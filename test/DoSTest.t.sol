//  SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/denial-of-service/VulnerableAuction.sol";
import "../src/denial-of-service/MaliciousBidder.sol";

contract DoSTest is Test {
    VulnerableAuction public auction;
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
        auction = new VulnerableAuction();
        attacker = new MaliciousBidder(auction);

        console.log("\n[DoS-Test] Setting up auction demonstration");
        console.log("----------------------------------------");
        _logAuctionState("Initial State");
    }

    function testDoSAttack() public {
        // Alice places first bid
        vm.prank(alice);
        auction.placeBid{value: 1 ether}();
        console.log("[DoS-Test] Alice placed bid of 1 ether");
        _logAuctionState("After Alice's bid");

        // Bob places higher bid
        vm.prank(bob);
        auction.placeBid{value: 2 ether}();
        console.log("[DoS-Test] Bob placed bid of 2 ether");
        console.log("[DoS-Test] Alice received refund of 1 ether");
        _logAuctionState("After Bob's bid");

        // Attacker places malicious bid
        vm.deal(address(attacker), 3 ether);
        attacker.attack{value: 3 ether}();
        console.log("[DoS-Test] Attacker placed bid of 3 ether");
        console.log("[DoS-Test] Bob should receive refund of 2 ether");
        console.log("[DoS-Test] Attack successful - Bob's refund was rejected");
        _logAuctionState("After Attacker's bid");

        // Carol tries to place a bid but fails
        vm.prank(carol);
        vm.expectRevert("Failed to refund previous bidder");
        auction.placeBid{value: 4 ether}();
        console.log("[DoS-Test] Carol's bid of 4 ether failed as expected");
        console.log("[DoS-Test] Auction is now permanently stuck!");
        _logAuctionState("Final State");
    }

    function _logAuctionState(string memory state) internal view {
        (address currentBidder, uint256 currentBid) = auction.getAuctionState();
        console.log("\n=== Auction State: %s ===", state);
        console.log("Highest Bidder: %s", currentBidder);
        console.log("Highest Bid: %s wei", currentBid);
        console.log("================================\n");
    }
}
