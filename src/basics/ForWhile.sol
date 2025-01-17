// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title Loop Control Structures in Solidity
/// @author Ishan Lakhwani
/// @notice Demonstrates different types of loops and control statements
/// @dev Shows for loops, while loops, continue, and break statements

contract Loop {
    /*
     * @notice Demonstrates different types of loops and control flow
     * @dev This is a pure function (doesn't modify or read state)
     * 
     * Gas Consideration:
     * - Loops can be expensive in terms of gas
     * - Always ensure loops have a finite bound
     * - Be careful with large loops as they might hit gas limits
     */
    function loop() public pure {
        /*
         * For Loop Structure:
         * - Initialization: uint256 i = 0
         * - Condition: i < 10
         * - Iteration: i++
         */
        for (uint256 i = 0; i < 10; i++) {
            if (i == 3) {
                // continue skips the rest of this iteration
                // and moves to the next one
                continue;
            }
            if (i == 5) {
                // break exits the loop completely
                break;
            }
        }

        /*
         * While Loop:
         * - Simpler structure but needs manual counter
         * - Runs as long as condition is true
         * - Must ensure the condition eventually becomes false
         */
        uint256 j;
        while (j < 10) {
            j++;
        }
    }
}
