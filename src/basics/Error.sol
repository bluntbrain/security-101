// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title Error Handling in Solidity
/// @author Ishan Lakhwani
/// @notice Shows different ways to handle errors and validate conditions

/*
 * UNDERSTANDING ERROR HANDLING 🚫
 * 
 * Three main ways to handle errors in Solidity:
 * 
 * 1. require(): Like a bouncer at a club
 *    - Checks condition at entrance
 *    - Returns gas if condition fails
 *    - Good for input validation
 * 
 * 2. revert(): Like an emergency stop button
 *    - Stops execution and returns gas
 *    - Can be used anywhere
 *    - Good for complex conditions
 * 
 * 3. assert(): Like a safety check
 *    - Checks for conditions that should NEVER be false
 *    - Uses all gas if fails
 *    - Good for invariants
 * 
 * Visual Comparison:
 * +------------+------------------+----------------+------------------+
 * |            | Gas Refund      | Use Case       | Error Message    |
 * +------------+------------------+----------------+------------------+
 * | require()  | ✅ Returns gas  | Input checking | Custom message   |
 * | revert()   | ✅ Returns gas  | Complex logic  | Custom message   |
 * | assert()   | ❌ Uses all gas | Invariants     | Default message  |
 * +------------+------------------+----------------+------------------+
 */
contract Error {
    /*
     * Example 1: require()
     * Like checking ID at a club entrance
     */
    function testRequire(uint256 _i) public pure {
        // Check if input meets our condition
        require(_i > 10, "Input must be greater than 10");
        // some code
        // If we get past require, _i is definitely > 10
    }

    /*
     * Example 2: revert()
     * Like hitting the emergency stop
     */
    function testRevert(uint256 _i) public pure {
        // More complex condition checking
        if (_i <= 10) {
            revert("Input must be greater than 10");
        }
        // If we get here, _i is definitely > 10
    }

    // State variable for assert example
    uint256 public num;

    /*
     * Example 3: assert()
     * Like a safety check that should never fail
     */
    function testAssert() public view {
        // This should ALWAYS be true
        // If it's false, we have a serious bug
        assert(num == 0);
    }

    /*
     * Example 4: Custom Errors
     * Like having specific error codes
     * More gas efficient than string messages
     */
    // Define custom error with parameters
    error InsufficientBalance(uint256 balance, uint256 withdrawAmount);

    function testCustomError(uint256 _withdrawAmount) public view {
        uint256 bal = address(this).balance;

        // If withdrawal amount is too high
        if (bal < _withdrawAmount) {
            // Revert with custom error and data
            revert InsufficientBalance({balance: bal, withdrawAmount: _withdrawAmount});
        }
        // If we get here, withdrawal amount is valid
    }
}

/*
 * ERROR HANDLING BEST PRACTICES:
 * 
 * 1. Use require() for:
 *    - Input validation
 *    - Condition checking at start of function
 *    - Access control
 * 
 * 2. Use revert() for:
 *    - Complex conditions
 *    - Multiple conditions
 *    - Custom errors
 * 
 * 3. Use assert() for:
 *    - Invariant checking
 *    - Conditions that should never be false
 *    - Internal errors
 * 
 * 4. Custom Errors:
 *    - More gas efficient than strings
 *    - Can include error data
 *    - Better for debugging
 */
