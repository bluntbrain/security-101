// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title Ether Units Demonstration
/// @author Ishan Lakhwani
/// @notice Shows different denominations of Ether
/// @dev Demonstrates wei, gwei, and ether conversions

/*
 * UNDERSTANDING ETHER UNITS
 * 
 * Ether (ETH) can be expressed in different denominations:
 * - wei: smallest unit of ether
 * - gwei: giga-wei, commonly used for gas prices
 * - ether: main unit used for trading
 * 
 * Conversion Chart:
 * 1 ether = 1,000,000,000 gwei (10^9)
 * 1 ether = 1,000,000,000,000,000,000 wei (10^18)
 * 1 gwei = 1,000,000,000 wei (10^9)
 */
contract EtherUnits {
    // Wei is the base unit
    uint256 public oneWei = 1 wei;
    // Verify that 1 wei is indeed 1
    bool public isOneWei = (oneWei == 1);

    // Gwei (giga-wei) is commonly used for gas prices
    uint256 public oneGwei = 1 gwei; // 1,000,000,000 wei
    // Verify that 1 gwei equals 10^9 wei
    bool public isOneGwei = (oneGwei == 1e9);

    // Ether is the main unit we typically work with
    uint256 public oneEther = 1 ether; // 1,000,000,000,000,000,000 wei
    // Verify that 1 ether equals 10^18 wei
    bool public isOneEther = (oneEther == 1e18);
}
