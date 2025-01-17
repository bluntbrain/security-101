// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title VulnerableVault - A vault contract with rounding error vulnerability
/// @author Ishan Lakhwani
/// @notice This contract demonstrates how rounding errors can be exploited
/// @dev The withdraw function contains a rounding error vulnerability in fee calculation

contract VulnerableVault {
    mapping(address => uint256) public balances;
    uint256 public totalDeposits;

    event Deposit(address indexed user, uint256 amount);
    event Withdraw(address indexed user, uint256 amount);

    function deposit() public payable {
        require(msg.value > 0, "Amount must be positive");
        balances[msg.sender] += msg.value;
        totalDeposits += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 _amount) public {
        require(_amount > 0, "Amount must be positive");
        require(balances[msg.sender] >= _amount, "Insufficient balance");

        // Vulnerable: Multiple rounding operations create cumulative errors
        uint256 feePercentage = 3; // 0.3%
        uint256 withdrawalFee = (_amount * feePercentage) / 1000;

        // Additional rounding error in fee calculation
        uint256 complexFee = (withdrawalFee * _amount) / totalDeposits;
        uint256 finalFee = (withdrawalFee + complexFee) / 2;

        uint256 amountAfterFee = _amount - finalFee;

        balances[msg.sender] -= _amount;
        totalDeposits -= _amount;

        (bool success,) = payable(msg.sender).call{value: amountAfterFee}("");
        require(success, "Transfer failed");

        emit Withdraw(msg.sender, _amount);
    }
}
