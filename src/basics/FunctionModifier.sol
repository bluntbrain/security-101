// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title Function Modifier Examples
/// @author Ishan Lakhwani
/// @notice Shows how to use modifiers to control function access and behavior

/*
 * UNDERSTANDING FUNCTION MODIFIERS 🛡️
 * 
 * Think of modifiers like security checks before entering a room:
 * 
 * Visual Example:
 * 
 *    Function Call
 *         ⬇️
 * +----------------+
 * |   Modifier    |  <- Security Check
 * |    Check      |
 * +----------------+
 *         ⬇️
 * +----------------+
 * |   Function    |  <- Only if check passes
 * |    Code       |
 * +----------------+
 * 
 * Real World Examples:
 * - onlyOwner: Like an ID check at a VIP room
 * - validAddress: Like verifying a real address exists
 * - noReentrancy: Like a "one person at a time" rule
 */
contract FunctionModifier {
    // Contract owner's address
    address public owner;
    // Example state variable
    uint256 public x = 10;
    // Lock flag for reentrancy guard
    bool public locked;

    /*
     * Constructor: Sets up the contract
     * Like setting up a new store and making yourself the owner
     */
    constructor() {
        // The person deploying the contract becomes the owner
        owner = msg.sender;
    }

    /*
     * MODIFIER 1: onlyOwner 👑
     * Checks if caller is the owner
     * Like a VIP check at an exclusive club
     */
    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        // The underscore is where the function code gets inserted
        _;
    }

    /*
     * MODIFIER 2: validAddress ✅
     * Checks if an address is valid
     * Like verifying a delivery address isn't empty
     */
    modifier validAddress(address _addr) {
        require(_addr != address(0), "Not valid address");
        _;
    }

    /*
     * Function that uses multiple modifiers
     * Will check both owner status AND address validity
     */
    function changeOwner(address _newOwner)
        public
        onlyOwner // First checks if current owner
        validAddress(_newOwner) // Then validates new address
    {
        owner = _newOwner;
    }

    /*
     * MODIFIER 3: noReentrancy 🔒
     * Prevents function from being called again while running
     * Like a "Do Not Disturb" sign while cleaning a room
     */
    modifier noReentrancy() {
        // Check if already locked
        require(!locked, "No reentrancy");
        // Lock the door
        locked = true;
        // Run the function
        _;
        // Unlock after function completes
        locked = false;
    }

    /*
     * Example of reentrancy protection
     * 
     * Without protection, this could be dangerous:
     * decrement(3) would call:
     * → decrement(2)
     * → → decrement(1)
     * 
     * With protection: Only one call at a time allowed
     */
    function decrement(uint256 i) public noReentrancy {
        x -= i;
        if (i > 1) {
            // Try to call itself again
            decrement(i - 1);
        }
    }
}

/*
 * MODIFIER BEST PRACTICES:
 * 
 * 1. Keep modifiers simple
 * 2. Use them for common checks
 * 3. Don't modify state in modifiers (except reentrancy locks)
 * 4. Document what each modifier does
 * 
 * Common Use Cases:
 * - Access control (onlyOwner, onlyAdmin)
 * - Input validation (validAddress, positiveAmount)
 * - State checks (notPaused, onlyOpen)
 * - Reentrancy protection
 */
