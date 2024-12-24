// test/ReentrancyTest.t.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "forge-std/Test.sol";
import "../src/reentrancy/EtherStore.sol";
import "../src/reentrancy/Attack.sol";

contract ReentrancyTest is Test {
    EtherStore public etherStore;
    Attack public attack;

    address public alice;
    address public bob;
    address public eve;

    function setUp() public {
        // Setup accounts
        alice = makeAddr("alice");
        bob = makeAddr("bob");
        eve = makeAddr("eve");

        // Deploy contracts
        etherStore = new EtherStore();
        attack = new Attack(address(etherStore));

        // Fund accounts
        vm.deal(alice, 1 ether);
        vm.deal(bob, 1 ether);
        vm.deal(eve, 1 ether);

        // Alice and Bob deposit 1 ether each
        vm.prank(alice);
        etherStore.deposit{value: 1 ether}();

        vm.prank(bob);
        etherStore.deposit{value: 1 ether}();
    }

    function testReentrancyAttack() public {
        // Initial state
        console.log("--- Initial State ---");
        console.log("EtherStore balance:", etherStore.getBalance() / 1e18, "ETH");
        console.log("Attacker balance:", attack.getBalance() / 1e18, "ETH");
        console.log("Eve balance:", eve.balance / 1e18, "ETH");

        // Eve performs the attack
        vm.prank(eve);
        attack.attack{value: 1 ether}();

        vm.prank(eve);
        attack.withdrawStolen();

        // Final state
        console.log("\n--- Final State ---");
        console.log("EtherStore balance:", etherStore.getBalance() / 1e18, "ETH");
        console.log("Attacker balance:", attack.getBalance() / 1e18, "ETH");
        console.log("Eve balance:", eve.balance / 1e18, "ETH");

        // Assertions
        assertEq(etherStore.getBalance(), 0, "EtherStore should be empty");
        assertGt(eve.balance, 2 ether, "Eve should have stolen the funds");
    }

    receive() external payable {}
}
