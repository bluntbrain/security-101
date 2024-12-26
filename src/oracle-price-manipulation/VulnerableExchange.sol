// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

/// @title VulnerableExchange
/// @author Ishan Lakhwani
/// @notice A simple exchange contract that uses an oracle for price feed
contract VulnerableExchange {
    AggregatorV3Interface public priceFeed;
    uint256 public reservesUSD;
    uint256 public reservesTOKEN;

    constructor(address _priceFeed, uint256 _initialReservesUSD, uint256 _initialReservesTOKEN) {
        priceFeed = AggregatorV3Interface(_priceFeed);
        reservesUSD = _initialReservesUSD * 10 ** 18; // Store with 18 decimals for precision
        reservesTOKEN = _initialReservesTOKEN * 10 ** 18;
    }

    function getPrice() public view returns (uint256) {
        (
            /*uint80 roundID*/
            ,
            int256 price,
            /*uint startedAt*/
            ,
            /*uint timeStamp*/
            ,
            /*uint80 answeredInRound*/
        ) = priceFeed.latestRoundData();
        require(price > 0, "Price feed returned invalid data");
        return uint256(price); // Price is in 8 decimals
    }

    function getTokenValueInUSD(uint256 _tokenAmount) public view returns (uint256) {
        uint256 price = getPrice();
        return (_tokenAmount * price) / 10 ** 8; // Adjust for decimals
    }

    function swapUSDForToken(uint256 _usdAmount) public returns (uint256 tokenReceived) {
        require(_usdAmount > 0, "Amount must be positive");

        // Calculate token amount based on current oracle price
        uint256 price = getPrice();
        // _usdAmount has 18 decimals, price has 8 decimals
        // We want tokenAmount to have 18 decimals
        uint256 tokenAmount = (_usdAmount * 1e18) / (price * 1e10);

        require(tokenAmount <= reservesTOKEN, "Not enough tokens in reserve");

        reservesUSD += _usdAmount;
        reservesTOKEN -= tokenAmount;

        emit Swap(msg.sender, _usdAmount, tokenAmount);
        return tokenAmount;
    }

    function swapTokenForUSD(uint256 _tokenAmount) public returns (uint256 usdReceived) {
        require(_tokenAmount > 0, "Amount must be positive");

        // Calculate USD amount based on current oracle price
        uint256 price = getPrice();
        // _tokenAmount has 18 decimals, price has 8 decimals
        // We want usdAmount to have 18 decimals
        uint256 usdAmount = (_tokenAmount * price * 1e10) / 1e18;

        require(usdAmount <= reservesUSD, "Not enough USD in reserve");

        reservesTOKEN += _tokenAmount;
        reservesUSD -= usdAmount;
        emit Swap(msg.sender, usdAmount, _tokenAmount);
        return usdAmount;
    }

    event Swap(address indexed user, uint256 usdAmount, uint256 tokenAmount);
}
