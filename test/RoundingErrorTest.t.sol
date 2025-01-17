// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/rounding-error/StakingRewards.sol";

contract StakingRewardsTest is Test {
    StakingRewards public rewards;
    address payable user1 = payable(address(0x1));
    address payable user2 = payable(address(0x2));
    address payable attacker = payable(address(0x1337));

    function setUp() public {
        rewards = new StakingRewards(100); // 100 rewards per block
    }

    function testRoundingExploit() public {
        vm.prank(user1);
        rewards.stake(3);
        vm.prank(user2);
        rewards.stake(7);

        vm.roll(block.number + 10);

        vm.prank(user1);
        rewards.getReward();
        vm.prank(user2);
        rewards.getReward();

        uint256 user1BalanceAfterFirstReward = rewards.stakedBalances(user1);
        uint256 user2BalanceAfterFirstReward = rewards.stakedBalances(user2);

        vm.prank(attacker);
        rewards.stake(1);
        vm.roll(block.number + 10);
        vm.prank(attacker);
        rewards.getReward();

        console.log("Initial stakes - User1: 3, User2: 7, Attacker: 1");
        console.log("After rewards:");
        console.log("User1 balance:", user1BalanceAfterFirstReward);
        console.log("User2 balance:", user2BalanceAfterFirstReward);
        console.log("Attacker balance:", rewards.stakedBalances(attacker));

        // Due to rounding errors, attacker should get disproportionate rewards
        assertGt(rewards.stakedBalances(attacker), 1);
    }

    function testNoExploit() public {
        vm.prank(user1);
        rewards.stake(300);
        vm.prank(user2);
        rewards.stake(700);

        vm.roll(block.number + 10);

        vm.prank(user1);
        rewards.getReward();
        vm.prank(user2);
        rewards.getReward();

        uint256 user1BalanceAfterFirstReward = rewards.stakedBalances(user1);
        uint256 user2BalanceAfterFirstReward = rewards.stakedBalances(user2);

        console.log("Initial stakes - User1: 300, User2: 700");
        console.log("After rewards:");
        console.log("User1 balance:", user1BalanceAfterFirstReward);
        console.log("User2 balance:", user2BalanceAfterFirstReward);

        // With larger numbers, rounding errors still occur but are less significant
        assertGt(user1BalanceAfterFirstReward, 300);
        assertGt(user2BalanceAfterFirstReward, 700);
    }
}
