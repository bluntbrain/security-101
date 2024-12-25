// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import "../src/front-running/NaiveAMM.sol";
import "../src/front-running/Attacker.sol";

/**
 * @title FrontRunTest
 * @author Ishan Lakhwani
 * @notice Foundry test illustrating front-running on a naive constant-product AMM.
 *         This version prints ETH values in a more human-friendly way.
 */
contract FrontRunTest is Test {
    NaiveAMM public amm;
    Attacker public attacker;

    // Test actors
    address public owner = address(0xABCD);
    address public victim = address(0xBEEF);
    address public attackerEOA = address(0xDEAD);

    function setUp() public {
        /**
         * 1. Deploy AMM with initial liquidity:
         *    - 10,000 tokens
         *    - 10 ETH (the deployer sends 10 ETH in the constructor)
         */
        vm.deal(owner, 10 ether); // Give "owner" 10 ETH
        vm.startPrank(owner);
        amm = new NaiveAMM{value: 10 ether}(10_000 /* tokens */ );
        vm.stopPrank();

        /**
         * 2. Deploy the Attacker contract from attackerEOA
         */
        vm.deal(attackerEOA, 5 ether); // Attacker has 5 ETH
        vm.startPrank(attackerEOA);
        attacker = new Attacker(address(amm));
        vm.stopPrank();

        /**
         * 3. Give the victim some ETH (e.g. 20 ETH) to do a large swap
         */
        vm.deal(victim, 20 ether);

        // 4. Label addresses for easier debugging
        vm.label(owner, "Owner");
        vm.label(victim, "Victim");
        vm.label(attackerEOA, "AttackerEOA");
        vm.label(address(amm), "NaiveAMM");
        vm.label(address(attacker), "AttackerContract");
    }

    /**
     * @notice Demonstrate a front-running scenario:
     *         - Victim swaps 5 ETH -> tokens
     *         - Attacker front-runs with 2 ETH first.
     *         - Victim gets fewer tokens than expected.
     */
    function testFrontRunningAttack() public {
        // --- Step 1: Log initial AMM reserves in an easy-to-read format ---
        console.log("=== Initial AMM Reserves ===");
        console.log("Token Reserve:", amm.reserveToken(), "tokens");
        console.log("ETH Reserve:  ", amm.reserveETH() / 1e18, "ETH"); // Convert wei to ETH

        // Victim wants to swap 5 ETH
        uint256 victimSwapETH = 5 ether;

        // If no one else traded, victim would get this many tokens:
        uint256 tokensOutIfNoFrontRun = (amm.reserveToken() * victimSwapETH) / (amm.reserveETH() + victimSwapETH);

        console.log("\nVictim would get ~", tokensOutIfNoFrontRun, "tokens (no front-run).");

        // We'll let the victim allow 30% slippage (just for demonstration),
        // so the trade doesn't revert when front-run occurs.
        // That means victimMinTokensOut = 70% of the no-front-run amount.
        uint256 victimMinTokensOut = (tokensOutIfNoFrontRun * 70) / 100;

        // --- Step 2: Attacker front-runs with 2 ETH ---
        console.log("\n[Attacker front-runs with 2 ETH]");
        vm.startPrank(attackerEOA);
        attacker.frontRunBuyTokens{value: 2 ether}(1);
        vm.stopPrank();

        // Log new AMM reserves after attacker
        console.log("AMM Reserves After Attacker:");
        console.log("Token Reserve:", amm.reserveToken(), "tokens");
        console.log("ETH Reserve:  ", amm.reserveETH() / 1e18, "ETH");

        // --- Step 3: Victim now swaps 5 ETH ---
        console.log("\n[Victim swaps 5 ETH -> tokens]");
        vm.startPrank(victim);
        amm.swapETHForToken{value: victimSwapETH}(victimMinTokensOut);
        vm.stopPrank();

        // --- Step 4: Final AMM reserves & final balances ---
        console.log("\n=== Final AMM Reserves ===");
        console.log("Token Reserve:", amm.reserveToken(), "tokens");
        console.log("ETH Reserve:  ", amm.reserveETH() / 1e18, "ETH");

        uint256 attackerTokens = amm.tokenBalance(address(attacker));
        uint256 victimTokens = amm.tokenBalance(victim);

        console.log("\nAttacker's Final Token Balance:", attackerTokens, "tokens");
        console.log("Victim's Final Token Balance:  ", victimTokens, "tokens");

        // --- Step 5: Check victim got fewer tokens than if no front-run occurred ---
        require(victimTokens < tokensOutIfNoFrontRun, "Victim unexpectedly got >= tokensOutIfNoFrontRun!");
    }
}
