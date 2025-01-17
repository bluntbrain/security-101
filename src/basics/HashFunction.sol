// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title Hash Function Examples
/// @author Ishan Lakhwani
/// @notice Shows how to use keccak256 hash function and avoid collisions

/*
 * UNDERSTANDING HASH FUNCTIONS 🔐
 * 
 * Hash functions convert any input into a fixed-size output:
 * - One-way function (can't reverse)
 * - Same input = Same output
 * - Different input = Different output (usually)
 * 
 * Visual Example:
 * 
 * Input Data         Hash Function         Output (32 bytes)
 * "Hello" + 123  →   keccak256()    →   0x8b1a...3f4b
 *                    [📦 Black Box]
 * 
 * Properties:
 * +------------------+---------------------------+
 * | Property         | Description               |
 * +------------------+---------------------------+
 * | Deterministic    | Same input = Same hash    |
 * | One-way         | Can't reverse the hash    |
 * | Avalanche       | Small change = New hash   |
 * | Fixed size      | Always 32 bytes output    |
 * +------------------+---------------------------+
 */
contract HashFunction {
    /*
     * Hash multiple parameters
     * Combines different types into single hash
     * 
     * Flow:
     * 1. Pack parameters together (abi.encodePacked)
     * 2. Generate hash (keccak256)
     * 
     * Example:
     * "Hello" + 123 + 0x... → 0x8b1a...3f4b
     */
    function hash(string memory _text, uint256 _num, address _addr) public pure returns (bytes32) {
        // Combine and hash parameters
        return keccak256(abi.encodePacked(_text, _num, _addr));
    }

    /*
     * Demonstrate hash collision risk
     * Shows why careful parameter encoding is important
     * 
     * Problem Case:
     * text = "AA", anotherText = "BBB"
     * text = "AAB", anotherText = "BB"
     * Both produce same packed result: "AABBB"
     * 
     * Visual Example:
     * 
     * "AA" + "BBB"  →  "AABBB"  →  hash1
     * "AAB" + "BB"  →  "AABBB"  →  hash1 (Same!)
     * 
     * Solution: Use abi.encode instead of abi.encodePacked
     */
    function collision(string memory _text, string memory _anotherText) public pure returns (bytes32) {
        // Potentially dangerous with dynamic types
        return keccak256(abi.encodePacked(_text, _anotherText));
    }
}

/*
 * HASHING BEST PRACTICES:
 * 
 * 1. Encoding:
 *    - Use abi.encode for dynamic types
 *    - Use abi.encodePacked for fixed types
 *    - Be aware of collision risks
 * 
 * 2. Common Use Cases:
 *    - Digital signatures
 *    - Message verification
 *    - Unique identifiers
 *    - Commit-reveal schemes
 * 
 * 3. Security:
 *    - Don't use for passwords directly
 *    - Consider adding salt for sensitive data
 *    - Be careful with predictable inputs
 * 
 * Visual Encoding Comparison:
 * 
 * abi.encodePacked:
 * "AA" + "BB" → "AABB" (concatenated)
 * 
 * abi.encode:
 * "AA" + "BB" → 0x...00000AA...0000BB (padded)
 */
