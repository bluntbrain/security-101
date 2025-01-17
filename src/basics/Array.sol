// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title Array Examples
/// @author Ishan Lakhwani
/// @notice Shows different types of arrays and how to use them

/*
 * ARRAYS IN SOLIDITY
 * 
 * Think of arrays like a list of items:
 * 
 * Dynamic Array (can grow/shrink):
 * [1, 2, 3, 4, 5, ...]
 * 
 * Fixed Array (size can't change):
 * [_, _, _, _] (4 slots, fixed)
 * 
 * Visual Example:
 * +---+---+---+---+---+
 * | 1 | 2 | 3 | 4 | 5 | Dynamic: can add more →
 * +---+---+---+---+---+
 * 
 * +---+---+---+---+
 * | 1 | 2 | 3 | 4 | Fixed: size stays at 4
 * +---+---+---+---+
 */
contract Array {
    // Can grow or shrink
    uint256[] public arr;

    // Starts with values
    uint256[] public arr2 = [1, 2, 3];

    // Fixed size of 10
    uint256[10] public myFixedSizeArr;

    // Get one item
    function get(uint256 i) public view returns (uint256) {
        return arr[i];
    }

    // Get whole array
    function getArr() public view returns (uint256[] memory) {
        return arr; // Warning: expensive for big arrays!
    }

    // Add item to end
    function push(uint256 i) public {
        arr.push(i);
    }

    // Remove last item
    function pop() public {
        arr.pop();
    }

    // Get array size
    function getLength() public view returns (uint256) {
        return arr.length;
    }

    // Clear item at position
    function remove(uint256 index) public {
        // Just sets to 0, doesn't shrink array
        delete arr[index];
    }

    // Create array in memory
    function examples() external pure {
        // Fixed size of 5 in memory
        uint256[] memory a = new uint256[](5);
    }
}
