// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title Event Examples in Solidity
/// @author Ishan Lakhwani
/// @notice Shows how to use events for logging and tracking

/*
 * UNDERSTANDING EVENTS 📢
 * 
 * Events are like announcements or notifications in blockchain:
 * - They're like a newspaper's announcements section
 * - Data is stored in transaction logs
 * - Cannot be read by smart contracts
 * - Useful for front-end applications
 * 
 * Visual Example of Event Flow:
 * 
 * Contract        Transaction Log        Frontend/Dapp
 *   📝     →     📜 Event Data    →      🖥️ UI
 * (emits)        (stores logs)         (displays info)
 * 
 * Indexed vs Non-Indexed Parameters:
 * +----------------+-------------------------+------------------------+
 * |                | Indexed (max 3)        | Non-Indexed           |
 * +----------------+-------------------------+------------------------+
 * | Search         | ✅ Can search for     | ❌ Cannot search      |
 * | Gas Cost      | 💰 More expensive      | 💰 Cheaper            |
 * | Use Case      | 🔍 Filtering events    | 📝 Storing data       |
 * +----------------+-------------------------+------------------------+
 */
contract Event {
    /*
     * Event Declaration:
     * - 'sender' is indexed (searchable)
     * - 'message' is not indexed (just stored)
     * 
     * Like a newspaper with:
     * - Indexed: Section number (easy to find)
     * - Non-indexed: Article content (just for reading)
     */
    event Log( // Like the author's signature (searchable)
        // Like the message content
    address indexed sender, string message);

    // Simple event with no parameters
    event AnotherLog();

    /*
     * Function that emits events
     * Like publishing multiple announcements
     */
    function test() public {
        // First announcement
        emit Log(msg.sender, "Hello World!");

        // Second announcement
        emit Log(msg.sender, "Hello EVM!");

        // Simple notification
        emit AnotherLog();
    }
}

/*
 * EVENT BEST PRACTICES:
 * 
 * 1. Use Events for:
 *    - Important state changes
 *    - Frontend notifications
 *    - Contract activity monitoring
 * 
 * 2. Indexing:
 *    - Index parameters you want to search for
 *    - Maximum 3 indexed parameters
 *    - Index addresses and IDs, not strings
 * 
 * 3. Naming:
 *    - Past tense (Transfer, Approval, Deposit)
 *    - Clear and descriptive
 * 
 * Example Use Cases:
 * - Token transfers: Transfer(from, to, amount)
 * - State changes: StatusChanged(oldStatus, newStatus)
 * - Access events: AdminAdded(newAdmin)
 */
