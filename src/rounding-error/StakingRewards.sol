// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title StakingRewards - A vulnerable staking contract
/// @author Ishan Lakhwani
/// @notice This contract demonstrates rounding errors in Solidity
/// @dev This contract is intentionally vulnerable to rounding errors for educational purposes

contract StakingRewards {
    mapping(address => uint256) public stakedBalances;
    uint256 public totalStaked;
    uint256 public rewardsPerBlock;
    uint256 public lastBlockRewarded;

    constructor(uint256 _rewardsPerBlock) {
        rewardsPerBlock = _rewardsPerBlock;
        lastBlockRewarded = block.number;
    }

    function stake(uint256 _amount) public {
        require(_amount > 0, "Amount must be positive");
        stakedBalances[msg.sender] += _amount;
        totalStaked += _amount;
    }

    function getReward() public {
        uint256 blocksElapsed = block.number - lastBlockRewarded;
        if (blocksElapsed > 0 && totalStaked > 0) {
            uint256 totalRewards = rewardsPerBlock * blocksElapsed;

            // Vulnerable calculation - division happens for each user separately
            // causing rounding errors to accumulate
            uint256 share = stakedBalances[msg.sender] / totalStaked; // This division loses precision
            uint256 rewardAmount = totalRewards * share; // Multiplication after division amplifies the error

            stakedBalances[msg.sender] += rewardAmount;
            lastBlockRewarded = block.number;
        }
    }
}
