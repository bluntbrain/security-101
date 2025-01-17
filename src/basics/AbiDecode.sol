// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title ABI Decode Examples
/// @author Ishan Lakhwani
/// @notice Shows how to encode and decode complex data structures

/*
 * UNDERSTANDING ABI DECODE 📦
 * 
 * ABI decoding converts encoded bytes back into Solidity types:
 * - Reverses the encoding process
 * - Must know the exact types to decode
 * - Works with complex data structures
 * 
 * Visual Process:
 * 
 * Encode:   Data Types → [📦 Encoded Bytes]
 * Decode:   [📦 Encoded Bytes] → Original Data
 * 
 * Example Flow:
 * uint(123), address(0x...) → 0x000...7b... → uint(123), address(0x...)
 */
contract AbiDecode {
    /*
     * Complex data structure example
     * Shows nested data that needs encoding/decoding
     * 
     * Layout:
     * MyStruct {
     *   string name;        // Dynamic type
     *   uint256[2] nums;    // Fixed array
     * }
     */
    struct MyStruct {
        string name;
        uint256[2] nums;
    }

    /*
     * Encode multiple parameters including complex types
     * 
     * Parameters:
     * - x: Simple uint256
     * - addr: Ethereum address
     * - arr: Dynamic uint256 array
     * - myStruct: Custom struct
     * 
     * Visual Encoding:
     * [x][addr][arr_length][arr_data][struct_data] → bytes
     */
    function encode(uint256 x, address addr, uint256[] calldata arr, MyStruct calldata myStruct)
        external
        pure
        returns (bytes memory)
    {
        // Pack all parameters into a single bytes array
        return abi.encode(x, addr, arr, myStruct);
    }

    /*
     * Decode bytes back into original types
     * 
     * Flow:
     * 1. Take encoded bytes
     * 2. Specify expected types
     * 3. Get original values
     * 
     * Visual Decoding:
     * bytes → [Decoder] → Original Types
     *         Must match ↑ encoding order
     */
    function decode(bytes calldata data)
        external
        pure
        returns (uint256 x, address addr, uint256[] memory arr, MyStruct memory myStruct)
    {
        // Decode bytes into original types
        // Order and types must match encoding exactly
        (x, addr, arr, myStruct) = abi.decode(data, (uint256, address, uint256[], MyStruct));
    }
}

/*
 * ABI DECODE BEST PRACTICES:
 * 
 * 1. Type Safety:
 *    - Match types exactly
 *    - Order matters
 *    - Handle dynamic types carefully
 * 
 * 2. Common Use Cases:
 *    - Cross-contract communication
 *    - Batch processing
 *    - Data verification
 * 
 * 3. Error Handling:
 *    - Validate decoded data
 *    - Handle malformed input
 *    - Check array lengths
 * 
 * Visual Type Matching:
 * 
 * Encode:   (uint256, address, uint[]) → bytes
 * Decode:   bytes → (uint256, address, uint[]) ✅
 * Wrong:    bytes → (address, uint256, uint[]) ❌
 */
