// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title Simple Storage Contract Demo
/// @author Ishan Lakhwani
/// @notice A basic example of reading and writing state in a smart contract
/// @dev Demonstrates the fundamental concepts of state variables and functions

contract SimpleStorage {
    /*
     * State Variable Declaration
     * - uint256 is an unsigned integer that can store values from 0 to 2^256-1
     * - 'public' automatically creates a getter function
     * - This variable is stored permanently on the blockchain
     */
    uint256 public num;

    /*
     * Write Function
     * @param _num The number to store in the contract
     * @notice Updates the state variable 'num'
     * @dev This function:
     * - Requires a transaction (costs gas)
     * - Changes the blockchain state
     * - Can be called by any address
     */
    function set(uint256 _num) public {
        num = _num;
    }

    /*
     * Read Function
     * @notice Retrieves the stored number
     * @return The current value of 'num'
     * @dev This function:
     * - Is marked as 'view' (no state modification)
     * - Doesn't cost gas when called externally
     * - Can be called without sending a transaction
     */
    function get() public view returns (uint256) {
        return num;
    }
}
