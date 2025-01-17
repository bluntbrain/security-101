// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title Gas Demonstration Contract
/// @author Ishan Lakhwani
/// @notice Demonstrates how gas works in Ethereum
/// @dev Shows an example of an infinite loop that will consume all gas

/*
 * UNDERSTANDING GAS IN ETHEREUM
 * 
 * What is Gas?
 * - Gas is like fuel for transactions on Ethereum
 * - Every operation (computation) costs some amount of gas
 * - Gas is paid in ETH (Ethereum's native currency)
 * 
 * Why do we need Gas?
 * - Prevents infinite loops and spam on the network
 * - Compensates miners/validators for processing transactions
 * - Ensures efficient use of network resources
 * 
 * Gas Costs:
 * - Simple operations (like addition) cost less gas
 * - Storage operations cost more gas
 * - Each transaction has a gas limit to prevent infinite execution
 */
contract Gas {
    // State variable that will be incremented
    uint256 public i = 0;

    /*
     * WARNING: This function is designed to fail!
     * 
     * @notice This function creates an infinite loop that will use up all gas
     * @dev When all gas is used:
     * - The transaction will fail
     * - All changes will be reverted
     * - The user will lose their gas fee
     * 
     * Common Gas Terms:
     * - Gas Limit: Maximum gas you're willing to use
     * - Gas Price: How much ETH you're willing to pay per unit of gas
     * - Total Fee = Gas Used × Gas Price
     */
    function forever() public {
        // This loop will run until:
        // 1. All gas is consumed
        // 2. The transaction hits the gas limit
        // 3. The transaction reverts
        while (true) {
            i += 1;
        }
    }
}
