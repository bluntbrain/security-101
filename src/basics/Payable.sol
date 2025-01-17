// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title Payable Functions and Ether Handling
/// @author Ishan Lakhwani
/// @notice Shows how to handle ETH transfers in smart contracts

/*
 * UNDERSTANDING PAYABLE 💰
 * 
 * Think of payable like a digital wallet:
 * - Regular functions: Can't receive money
 * - Payable functions: Can receive ETH
 * 
 * Visual Flow of ETH:
 * 
 *    User/Contract        Smart Contract
 *    [1 ETH] 💰     →    📦 [Balance]
 *                   payable
 * 
 * Function Types:
 * +------------------+-------------------+
 * |     Payable      |    Non-Payable   |
 * +------------------+-------------------+
 * | Can receive ETH  | Can't receive ETH |
 * | 💰 Enabled      | 🚫 Disabled      |
 * +------------------+-------------------+
 */
contract Payable {
    // Owner can receive ETH (payable address)
    address payable public owner;

    /*
     * Payable Constructor
     * Like opening a new bank account that can receive initial deposit
     * 
     * Flow on Deploy:
     * Deployer → Contract
     * [ETH]   →  [Balance]
     */
    constructor() payable {
        owner = payable(msg.sender);
    }

    /*
     * Deposit Function
     * Like a bank deposit slot
     * 
     * Visual:
     * User         Contract
     * [ETH] → deposit() → [Balance]
     */
    function deposit() public payable {}

    /*
     * Non-Payable Function
     * Like a regular mailbox - can't accept money
     * 
     * Visual:
     * User         Contract
     * [ETH] → ❌ notPayable() 
     */
    function notPayable() public {}

    /*
     * Withdraw Function
     * Sends all contract balance to owner
     * 
     * Flow:
     * Contract        Owner
     * [Balance] → withdraw() → [Owner Balance]
     */
    function withdraw() public {
        // Get contract's entire balance
        uint256 amount = address(this).balance;

        // Send ETH to owner
        (bool success,) = owner.call{value: amount}("");
        require(success, "Failed to send Ether");
    }

    /*
     * Transfer Function
     * Send specific amount to any address
     * 
     * Flow:
     * Contract          Recipient
     * [Balance] → transfer() → [Recipient Balance]
     *    ↓ -amount            ↑ +amount
     */
    function transfer(address payable _to, uint256 _amount) public {
        // Send specified amount
        (bool success,) = _to.call{value: _amount}("");
        require(success, "Failed to send Ether");
    }
}

/*
 * PAYABLE BEST PRACTICES:
 * 
 * 1. Security:
 *    - Always check for successful transfers
 *    - Use require() after ETH transfers
 *    - Consider reentrancy attacks
 * 
 * 2. Design:
 *    - Mark functions payable only if needed
 *    - Keep track of deposits/withdrawals
 *    - Consider using events for transfers
 * 
 * 3. Gas Efficiency:
 *    - Use .call() for transfers (recommended)
 *    - Avoid .transfer() and .send() (legacy)
 * 
 * Common Patterns:
 * - Deposit/Withdraw pattern
 * - Pull over Push payments
 * - Emergency withdrawal
 */
