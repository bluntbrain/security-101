// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title Mapping Demo
/// @author Ishan Lakhwani
/// @notice Shows how mappings work in Solidity

/*
 * MAPPINGS: Think of them like a dictionary or lookup table
 * 
 * Simple Example:
 * Address => Balance
 * 0x123... => 100
 * 0x456... => 50
 * 0x789... => 75
 * 
 * Like a table:
 * +-----------+---------+
 * |  Address  | Balance |
 * +-----------+---------+
 * | 0x123...  |   100   |
 * | 0x456...  |    50   |
 * | 0x789...  |    75   |
 * +-----------+---------+
 */
contract Mapping {
    // Simple mapping: connects an address to a number
    mapping(address => uint256) public myMap;

    // Read a value
    function get(address _addr) public view returns (uint256) {
        // If address not found, returns 0
        return myMap[_addr];
    }

    // Save a value
    function set(address _addr, uint256 _i) public {
        myMap[_addr] = _i;
    }

    // Delete a value
    function remove(address _addr) public {
        delete myMap[_addr]; // Sets value back to 0
    }
}

/*
 * NESTED MAPPINGS: Like a spreadsheet with two keys
 * 
 * Example: User permissions for different token IDs
 * 
 * Visual:
 * +------------+-------------+----------+
 * |   User     | Token ID    | Allowed? |
 * +------------+-------------+----------+
 * | 0x123...   |     1      |   true   |
 * | 0x123...   |     2      |   false  |
 * | 0x456...   |     1      |   false  |
 * | 0x456...   |     2      |   true   |
 * +------------+-------------+----------+
 */
contract NestedMapping {
    // Nested mapping: like a spreadsheet lookup
    mapping(address => mapping(uint256 => bool)) public nested;

    // Read permission
    function get(address _addr1, uint256 _i) public view returns (bool) {
        return nested[_addr1][_i];
    }

    // Set permission
    function set(address _addr1, uint256 _i, bool _boo) public {
        nested[_addr1][_i] = _boo;
    }

    // Remove permission
    function remove(address _addr1, uint256 _i) public {
        delete nested[_addr1][_i]; // Sets back to false
    }
}
