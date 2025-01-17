// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title Solidity Variables Demo
/// @author Ishan Lakhwani
/// @notice Demonstrates the three types of variables in Solidity: State, Local, and Global
/// @dev Shows basic usage of different variable scopes and their characteristics

contract Variables {
    /*
     * State Variables
     * - Permanently stored in contract storage
     * - Expensive to use (costs gas)
     * - Accessible by all contract functions
     * - Persists between function calls
     * - Value is stored on the blockchain
     */
    string public text = "Hello";
    uint256 public num = 123;

    /*
     * This function demonstrates the usage of both local and global variables
     * The 'view' keyword means this function doesn't modify state
     */
    function doSomething() public view {
        /*
         * Local Variables
         * - Temporary variables that only exist during function execution
         * - Not stored on the blockchain
         * - Gas efficient as they only exist in memory
         * - Cannot be accessed outside this function
         */
        uint256 i = 456;

        /*
         * Global Variables
         * Special variables provided by Solidity
         * Give access to blockchain properties and transaction context
         * Some common global variables include:
         * - block.timestamp: Current block's timestamp
         * - msg.sender: Address of the account calling the function
         * - block.number: Current block number
         * - msg.value: Amount of ETH sent with the transaction
         * - block.difficulty: Current block's difficulty
         */
        uint256 timestamp = block.timestamp; // Unix timestamp of current block
        address sender = msg.sender; // Address of the account/contract calling this function

        // Note: These variables are declared but not used in this function
        // In a real contract, you would typically do something with these values
    }
}
