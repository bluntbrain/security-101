// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title Data Locations in Solidity
/// @author Ishan Lakhwani
/// @notice Shows different ways data can be stored

/*
 * DATA LOCATIONS: Where variables live
 * 
 * 1. Storage (💾 Permanent)
 * - Like writing to a hard drive
 * - Persists between function calls
 * - Expensive (costs more gas)
 * - Example: Your bank account balance
 * 
 * 2. Memory (🎮 Temporary)
 * - Like computer RAM
 * - Only exists during function call
 * - Cheaper than storage
 * - Example: Calculator's temporary display
 * 
 * 3. Calldata (📨 Read-only)
 * - Like a sealed envelope
 * - Can't be modified
 * - Cheapest option
 * - Example: Email that you can read but can't edit
 * 
 * Visual Example:
 * +------------+-------------+------------+-------------+----------------+
 * |            | Persistent? | Modifiable | Gas Cost   | Real Example   |
 * +------------+-------------+------------+-------------+----------------+
 * | Storage 💾 |     ✅     |     ✅    | Expensive   | Hard Drive     |
 * | Memory  🎮 |     ❌     |     ✅    | Medium      | RAM           |
 * | Calldata📨 |     ❌     |     ❌    | Cheap       | CD-ROM        |
 * +------------+-------------+------------+-------------+----------------+
 * 
 * Think of it like a shop:
 * - Storage: Items in the warehouse (permanent)
 * - Memory: Shopping cart (temporary, can modify)
 * - Calldata: Shopping list (read-only)
 */
contract DataLocations {
    // These variables are always in storage
    uint256[] public arr; // Like items in warehouse
    mapping(uint256 => address) map; // Like a customer database

    // Custom data structure
    struct MyStruct {
        uint256 foo; // Like a product details form
    }

    // Mapping of structs in storage
    mapping(uint256 => MyStruct) myStructs; // Like a filing cabinet

    function f() public {
        // Example 1: Storage References
        // Like getting items from different warehouse sections
        _f(arr, map, myStructs[1]);

        // Example 2: Direct Storage Access
        // Like working directly with warehouse inventory
        MyStruct storage myStruct = myStructs[1];
        // Changes to myStruct will be permanent

        // Example 3: Memory Copy
        // Like making a temporary copy of product details
        MyStruct memory myMemStruct = MyStruct(0);
        // Changes to myMemStruct will be lost after function ends
    }

    // Storage References Example
    // Like giving someone access to specific warehouse sections
    function _f(
        uint256[] storage _arr, // Access to array shelf
        mapping(uint256 => address) storage _map, // Access to customer records
        MyStruct storage _myStruct // Access to one product file
    ) internal {
        // Any changes here affect the real storage data
        // Like making changes to actual warehouse inventory
    }

    // Memory Example
    // Like working with a temporary copy
    function g(uint256[] memory _arr) public pure returns (uint256[] memory) {
        // _arr is a temporary copy we can modify
        // Like working with a draft document
        return _arr;
    }

    // Calldata Example
    // Like receiving a sealed package
    function h(uint256[] calldata _arr) external {
        // Can read _arr but can't modify it
        // Like reading instructions on a sealed envelope
    }
}
