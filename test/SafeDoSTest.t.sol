// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/denial-of-service/SafeAuction.sol";
import "../src/denial-of-service/MaliciousBidder.sol";

contract SafeDoSTest is Test {
    SafeAuction public auction;
    MaliciousBidder public attacker;

    address alice = makeAddr("alice");
    address bob = makeAddr("bob");
    address carol = makeAddr("carol");

    function setUp() public {
        // Setup initial balances
        vm.deal(alice, 5 ether);
        vm.deal(bob, 5 ether);
        vm.deal(carol, 5 ether);

        // Deploy contracts
        auction = new SafeAuction();

        console.log("\n[SafeDoS-Test] Setting up auction demonstration");
        console.log("----------------------------------------");
        _logAuctionState("Initial State");
    }

    function testSafeAuction() public {
        // Alice places first bid
        vm.prank(alice);
        auction.placeBid{value: 1 ether}();
        console.log("[SafeDoS-Test] Alice placed bid of 1 ether");
        _logAuctionState("After Alice's bid");

        // Bob places higher bid
        vm.prank(bob);
        auction.placeBid{value: 2 ether}();
        console.log("[SafeDoS-Test] Bob placed bid of 2 ether");
        _logPendingRefund(alice, "Alice's pending refund");

        // Alice withdraws her refund
        vm.prank(alice);
        bool aliceWithdrawSuccess = auction.withdrawRefund();
        assertTrue(aliceWithdrawSuccess, "Alice should be able to withdraw");
        console.log("[SafeDoS-Test] Alice successfully withdrew her refund");

        // Carol places even higher bid
        vm.prank(carol);
        auction.placeBid{value: 3 ether}();
        console.log("[SafeDoS-Test] Carol placed bid of 3 ether");
        _logPendingRefund(bob, "Bob's pending refund");

        // Bob withdraws his refund
        vm.prank(bob);
        bool bobWithdrawSuccess = auction.withdrawRefund();
        assertTrue(bobWithdrawSuccess, "Bob should be able to withdraw");
        console.log("[SafeDoS-Test] Bob successfully withdrew his refund");

        _logAuctionState("Final State");
    }

    function _logAuctionState(string memory state) internal view {
        (address currentBidder, uint256 currentBid) = auction.getAuctionState();
        console.log("\n=== Auction State: %s ===", state);
        console.log("Highest Bidder: %s", currentBidder);
        console.log("Highest Bid: %s wei", currentBid);
        console.log("================================\n");
    }

    function _logPendingRefund(address bidder, string memory label) internal view {
        uint256 pendingAmount = auction.getPendingRefund(bidder);
        console.log("\n=== %s ===", label);
        console.log("Amount: %s wei", pendingAmount);
        console.log("================================\n");
    }
}
