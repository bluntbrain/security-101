// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title Solidity Primitive Data Types Demo
/// @author Ishan Lakhwani
/// @notice This contract demonstrates the basic primitive data types in Solidity
/// @dev A simple contract to showcase various data types and their usage

contract Primitives {
    // Boolean type - can only be true or false
    bool public boo = true;

    /*
     * Unsigned Integers (uint)
     * uint8   -> ranges from 0 to 2^8-1 (0 to 255)
     * uint256 -> ranges from 0 to 2^256-1
     */
    uint8 public u8 = 1;
    uint256 public u256 = 456;
    uint256 public u = 123; // uint is an alias for uint256

    /*
     * Signed Integers (int)
     * int8   -> ranges from -2^7 to 2^7-1 (-128 to 127)
     * int256 -> ranges from -2^255 to 2^255-1
     */
    int8 public i8 = -1;
    int256 public i256 = 456;
    int256 public i = -123; // int is an alias for int256

    // We can get the minimum and maximum values of int256
    int256 public minInt = type(int256).min;
    int256 public maxInt = type(int256).max;

    /*
     * Address type
     * Holds a 20-byte value (size of an Ethereum address)
     * Can be used to store Ethereum addresses and send Ether
     */
    address public addr = 0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c;

    /*
     * Bytes type
     * Fixed-size byte arrays
     * bytes1 = 1 byte = 8 bits
     * bytes2 = 2 bytes = 16 bits
     * ... up to bytes32
     */
    bytes1 a = 0xb5; // Single byte (8 bits) stored as hex
    bytes1 b = 0x56; // Another single byte

    /*
     * Default Values
     * Every data type has a default value when not explicitly assigned
     * Understanding default values is important for smart contract security
     */
    bool public defaultBoo; // false
    uint256 public defaultUint; // 0
    int256 public defaultInt; // 0
    address public defaultAddr; // 0x0000000000000000000000000000000000000000 (zero address)
}
