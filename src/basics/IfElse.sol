// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title Control Flow with If-Else Statements
/// @author Ishan Lakhwani
/// @notice Demonstrates conditional statements in Solidity
/// @dev Shows both traditional if-else and ternary operator usage

/*
 * UNDERSTANDING CONTROL FLOW IN SOLIDITY
 * 
 * Control flow statements help us make decisions in our code
 * based on certain conditions. They are fundamental to writing
 * smart contracts that can handle different scenarios.
 */
contract IfElse {
    /*
     * @notice Traditional if-else demonstration
     * @param x The number to evaluate
     * @return uint256 Different values based on the condition:
     *         - Returns 0 if x < 10
     *         - Returns 1 if 10 <= x < 20
     *         - Returns 2 if x >= 20
     * 
     * @dev This function shows how multiple conditions can be chained
     * The conditions are evaluated from top to bottom
     */
    function foo(uint256 x) public pure returns (uint256) {
        // First condition: is x less than 10?
        if (x < 10) {
            return 0;
        }
        // Second condition: is x less than 20?
        // This only runs if first condition was false
        else if (x < 20) {
            return 1;
        }
        // If none of the above conditions were true
        // This is the default case
        else {
            return 2;
        }
    }

    /*
     * @notice Ternary operator demonstration
     * @param _x The number to evaluate
     * @return uint256 Either 1 or 2 based on the condition
     * 
     * @dev The ternary operator is a shorthand way to write simple if-else statements
     * Syntax: condition ? value_if_true : value_if_false
     * 
     * Gas Consideration:
     * - Ternary operators can be more gas efficient for simple conditions
     * - They make code more concise but should only be used for simple conditions
     */
    function ternary(uint256 _x) public pure returns (uint256) {
        // Same as:
        // if (_x < 10) {
        //     return 1;
        // } else {
        //     return 2;
        // }
        return _x < 10 ? 1 : 2;
    }
}
