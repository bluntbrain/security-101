// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title Transient Storage Demo
/// @author Ishan Lakhwani
/// @notice Shows how to use transient storage (new in Solidity)

/*
 * UNDERSTANDING TRANSIENT STORAGE
 * 
 * What is Transient Storage? 🔄
 * - Like a temporary notepad that gets erased after each transaction
 * - Cheaper than regular storage
 * - Only lasts during the current transaction
 * - Useful for temporary calculations
 * 
 * Visual Comparison:
 * +-------------------+-------------------------+------------------------+
 * |     Storage       |      Regular Storage    |    Transient Storage  |
 * |     Type         |          💾             |           🔄          |
 * +-------------------+-------------------------+------------------------+
 * | Lasts Until      | Forever (until changed) | End of transaction    |
 * | Gas Cost         | Expensive               | Cheaper               |
 * | Persists Between | Yes                     | No                    |
 * | Transactions     |                         |                       |
 * +-------------------+-------------------------+------------------------+
 * 
 * Real World Analogy:
 * - Regular Storage = Writing in a permanent ledger
 * - Transient Storage = Using a sticky note that you throw away after
 */
contract TestTransientStorage {
    // Define a constant slot for transient storage
    // Think of this like choosing which sticky note to use
    bytes32 constant SLOT = 0;

    /*
     * @notice Test function to demonstrate transient storage
     * @dev Uses assembly to access transient storage
     * 
     * Flow:
     * 1. Write value to transient storage
     * 2. Make external call
     * 3. Value is gone after call returns
     */
    function test() public {
        // Using inline assembly to access transient storage
        assembly {
            // Store value 321 in transient storage
            // Like writing "321" on our sticky note
            tstore(SLOT, 321)
        }

        // Create empty bytes array for the call
        bytes memory b = "";

        // Make an external call
        // This will clear our transient storage
        // Like crumpling up our sticky note
        msg.sender.call(b);
    }

    /*
     * @notice Read the current value from transient storage
     * @return v The value in transient storage (0 if cleared)
     * @dev Uses assembly to read transient storage
     */
    function val() public view returns (uint256 v) {
        // Read from transient storage
        // Like checking what's written on our sticky note
        assembly {
            v := tload(SLOT)
        }
    }
}

/*
 * IMPORTANT NOTES:
 * 
 * 1. Transient storage is cleared:
 *    - After external calls
 *    - At the end of transaction
 *    Like throwing away a sticky note
 * 
 * 2. Use cases:
 *    - Temporary calculations
 *    - Passing values between functions
 *    - Gas optimization
 * 
 * 3. Advantages:
 *    - Cheaper than regular storage
 *    - Useful for temporary data
 *    - Good for gas optimization
 * 
 * 4. Limitations:
 *    - Only lasts during transaction
 *    - Cleared after external calls
 *    - Requires assembly code
 */
