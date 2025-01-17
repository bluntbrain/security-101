// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title Constructor and Inheritance Examples
/// @author Ishan Lakhwani
/// @notice Shows different ways to use constructors with inheritance

/*
 * UNDERSTANDING CONSTRUCTORS AND INHERITANCE 🏗️
 * 
 * Think of it like building a house:
 * - Constructor is like the initial setup/building process
 * - Inheritance is like building on top of existing foundations
 * 
 * Visual Example of Inheritance:
 * 
 *        Base Contracts
 *     +--------+  +--------+
 *     |   X    |  |   Y    |  <- Parent contracts
 *     +--------+  +--------+
 *          ↓          ↓
 *          +----------+
 *          |    B     |     <- Child contract
 *          +----------+
 */

// Base Contract X (Parent)
contract X {
    string public name;

    // Constructor for X
    // Like setting up the foundation
    constructor(string memory _name) {
        name = _name;
    }
}

// Base Contract Y (Parent)
contract Y {
    string public text;

    // Constructor for Y
    // Like setting up another foundation piece
    constructor(string memory _text) {
        text = _text;
    }
}

/*
 * INHERITANCE METHOD 1: Fixed Values 🎯
 * 
 * Like building a house with pre-selected materials
 * Values are hardcoded when deploying
 */
contract B is X("Input to X"), Y("Input to Y") {
// B's constructor is empty
// Parent constructors are called with fixed values
// Like saying "always use brick for X and wood for Y"
}

/*
 * INHERITANCE METHOD 2: Flexible Values 🔄
 * 
 * Like building a house where you choose materials later
 * Values are passed when deploying
 */
contract C is X, Y {
    // Pass values to parent constructors
    constructor(
        string memory _name, // Value for X
        string memory _text // Value for Y
    ) X(_name) Y(_text) {}
}

/*
 * INHERITANCE METHOD 3: Fixed Order ⬇️
 * 
 * Order of constructor calls follows inheritance list
 * X is called first, then Y
 */
contract D is X, Y {
    constructor() X("X was called") Y("Y was called") {}
    // Execution order: X → Y
}

/*
 * IMPORTANT NOTE ON ORDER:
 * Even though Y is listed first in constructor,
 * X will still be called first because of inheritance order (is X, Y)
 */
contract E is X, Y {
    constructor() Y("Y was called") X("X was called") {}
    // Still executes: X → Y (order in constructor doesn't matter)
}

/*
 * CONSTRUCTOR BEST PRACTICES:
 * 
 * 1. Keep initialization logic simple
 * 2. Be clear about inheritance order
 * 3. Document parameter requirements
 * 4. Consider using flexible values when needed
 * 
 * Think of it like building instructions:
 * - Be clear about the order
 * - Document what materials (parameters) are needed
 * - Make it flexible when needed
 */
