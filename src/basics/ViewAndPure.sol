// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title View and Pure Functions Demo
/// @author Ishan Lakhwani
/// @notice Shows how view and pure functions work

/*
 * FUNCTION TYPES IN SOLIDITY:
 * 
 * 1. Regular Function: Can modify state
 * setNumber(5) => Changes state ✏️
 * 
 * 2. View Function: Can read but not modify
 * getNumber() => Just looks at state 👀
 * 
 * 3. Pure Function: Cannot read or modify
 * add(2,3) => Just computes something 🧮
 * 
 * Visual Example:
 * +-------------------+----------------+----------------+
 * |                   | Reads State?   | Changes State? |
 * +-------------------+----------------+----------------+
 * | Regular Function  |      ✅       |      ✅       |
 * | View Function     |      ✅       |      ❌       |
 * | Pure Function     |      ❌       |      ❌       |
 * +-------------------+----------------+----------------+
 */
contract ViewAndPure {
    // This is a state variable
    uint256 public x = 1;

    // View function: can look at state but not change it
    // Like checking your wallet balance
    function addToX(uint256 y) public view returns (uint256) {
        return x + y; // reads x but doesn't change it
    }

    // Pure function: just does computation
    // Like using a calculator
    function add(uint256 i, uint256 j) public pure returns (uint256) {
        return i + j; // doesn't touch any state
    }
}
