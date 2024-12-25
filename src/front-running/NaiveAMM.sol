// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/**
 * @title NaiveAMM
 * @author Ishan Lakhwani
 * @notice A simplified constant-product AMM to demonstrate front-running.
 *         Not production-ready! For educational purposes only.
 */
contract NaiveAMM {
    uint256 public reserveToken;
    uint256 public reserveETH;

    // We simulate a "token" via a mapping for balances (not a real ERC20).
    mapping(address => uint256) public tokenBalance;

    /**
     * @dev Seed initial liquidity in the constructor if desired.
     * @param _initialTokenLiquidity How many tokens to seed as the initial token reserve.
     *                               The deployer also sends ETH in the constructor.
     */
    constructor(uint256 _initialTokenLiquidity) payable {
        require(msg.value > 0, "Must seed ETH liquidity");
        require(_initialTokenLiquidity > 0, "Must seed token liquidity");
        reserveETH = msg.value;
        reserveToken = _initialTokenLiquidity;
    }

    /**
     * @notice Add more liquidity (very naive approach).
     */
    function addLiquidity(uint256 tokenAmount) external payable {
        require(msg.value > 0 && tokenAmount > 0, "Invalid liquidity amounts");
        reserveETH += msg.value;
        reserveToken += tokenAmount;
    }

    /**
     * @notice Swap ETH -> Token
     * @param minTokensOut The minimum amount of tokens user expects (slippage protection).
     */
    function swapETHForToken(uint256 minTokensOut) external payable {
        require(msg.value > 0, "No ETH sent");

        // tokensOut = (reserveToken * ETH_in) / (reserveETH + ETH_in)
        uint256 tokensOut = (reserveToken * msg.value) / (reserveETH + msg.value);
        require(tokensOut >= minTokensOut, "Slippage too high / insufficient output");

        // Update reserves
        reserveETH += msg.value;
        reserveToken -= tokensOut; // tokens sent to user

        // Increase user's token balance
        tokenBalance[msg.sender] += tokensOut;
    }

    /**
     * @notice Swap Token -> ETH
     * @param tokenAmountIn The amount of tokens to swap.
     * @param minEthOut Minimum ETH expected out (slippage protection).
     */
    function swapTokenForETH(uint256 tokenAmountIn, uint256 minEthOut) external {
        require(tokenBalance[msg.sender] >= tokenAmountIn, "Not enough tokens");

        // ethOut = (reserveETH * tokenAmountIn) / (reserveToken + tokenAmountIn)
        uint256 ethOut = (reserveETH * tokenAmountIn) / (reserveToken + tokenAmountIn);
        require(ethOut >= minEthOut, "Slippage too high / insufficient output");

        // Update reserves
        reserveToken += tokenAmountIn;
        reserveETH -= ethOut;

        // Deduct tokens from user
        tokenBalance[msg.sender] -= tokenAmountIn;

        // Transfer ETH to user
        (bool success,) = msg.sender.call{value: ethOut}("");
        require(success, "ETH transfer failed");
    }
}
