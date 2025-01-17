// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title Interface Examples in Solidity
/// @author Ishan Lakhwani
/// @notice Shows how interfaces work and how to use them

/*
 * UNDERSTANDING INTERFACES 🔌
 * 
 * An interface is a way to interact with external contracts without having their full code
 * Think of an interface like a universal remote control:
 * - It defines what buttons are available
 * - It doesn't know how the TV works internally
 * - It just knows how to communicate with it
 * 
 * Visual Example:
 * 
 *  Interface (ICounter)        Contract (Counter)
 *  +----------------+         +------------------+
 *  |  Blueprint 📋  |  -->   | Implementation 🏗️ |
 *  | count()        |         | count = 0        |
 *  | increment()    |         | increment()      |
 *  +----------------+         +------------------+
 *         ⬇️                          ⬆️
 *      MyContract                     |
 *  (Uses interface to           (Actual contract
 *   talk to Counter)            with real code)
 */

// The actual contract with implementation
contract Counter {
    // State variable to store count
    uint256 public count;

    // Function to increase count
    function increment() external {
        count += 1;
    }
}

/*
 * Interface Definition
 * Like a blueprint that defines:
 * - What functions exist
 * - What they return
 * - But NOT how they work
 */
interface ICounter {
    // Just declares what functions are available
    function count() external view returns (uint256);
    function increment() external;
}

/*
 * Contract that uses the interface
 * Like a universal remote that works with any TV
 * that follows the interface pattern
 */
contract MyContract {
    /*
     * Uses interface to call increment
     * 
     * Flow:
     * MyContract -> ICounter -> Counter
     * (Remote)     (Protocol)   (TV)
     */
    function incrementCounter(address _counter) external {
        // Convert address to ICounter interface
        ICounter(_counter).increment();
    }

    /*
     * Uses interface to read count
     * 
     * Like checking channel number through remote
     */
    function getCount(address _counter) external view returns (uint256) {
        return ICounter(_counter).count();
    }
}

/*
 * INTERFACE BEST PRACTICES:
 * 
 * 1. Naming:
 *    - Prefix with 'I' (ICounter, IERC20)
 *    - Clear and descriptive
 * 
 * 2. Functions:
 *    - Must be external
 *    - No implementation
 *    - No constructor
 *    - No state variables
 * 
 * 3. Use Cases:
 *    - Standardization (ERC20, ERC721)
 *    - Contract interaction
 *    - Code organization
 * 
 * Visual Contract Interaction:
 * 
 * Contract A        Interface        Contract B
 *    📱     ->     🔌 ICounter  ->    📺
 * (Remote)         (Protocol)      (Device)
 */
