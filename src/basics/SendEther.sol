// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title Different Ways to Send ETH
/// @author Ishan Lakhwani
/// @notice Shows three different methods to send ETH between contracts

/*
 * UNDERSTANDING ETH TRANSFERS 💸
 * 
 * Three ways to send ETH in Solidity:
 * 1. transfer(): Simple but limited
 * 2. send(): Low-level but returns bool
 * 3. call(): Most flexible and recommended
 * 
 * Visual Comparison:
 * +----------------+-------------+----------------+------------------+
 * |    Method      | Gas Limit   | Returns        | Recommended?     |
 * +----------------+-------------+----------------+------------------+
 * | transfer() 📮  | 2300 fixed  | throws error   | ❌ No (legacy)   |
 * | send()     📫  | 2300 fixed  | bool          | ❌ No (legacy)   |
 * | call()     📱  | adjustable  | bool & data   | ✅ Yes (modern)  |
 * +----------------+-------------+----------------+------------------+
 */
contract SendEther {
    /*
     * Method 1: transfer()
     * Like sending a letter with exact postage
     * 
     * Flow:
     * Contract A         Contract B
     * [Balance]    →    [Receives ETH]
     *           transfer()
     * 
     * Limitations:
     * - Fixed 2300 gas (might fail with complex receivers)
     * - Throws error on failure
     */
    function sendViaTransfer(address payable _to) public payable {
        // Simple but not recommended
        _to.transfer(msg.value);
    }

    /*
     * Method 2: send()
     * Like sending mail with delivery confirmation
     * 
     * Flow:
     * Contract A         Contract B
     * [Balance]    →    [Receives ETH]
     *             send()
     *             ↙
     *         bool (success)
     */
    function sendViaSend(address payable _to) public payable {
        // Returns bool for success/failure
        bool sent = _to.send(msg.value);
        require(sent, "Failed to send Ether");
    }

    /*
     * Method 3: call() (Recommended)
     * Like a modern digital transfer with confirmation
     * 
     * Flow:
     * Contract A         Contract B
     * [Balance]    →    [Receives ETH]
     *             call()
     *            ↙
     *    (success, return data)
     * 
     * Advantages:
     * - Adjustable gas
     * - Returns success bool and data
     * - Forward all available gas
     */
    function sendViaCall(address payable _to) public payable {
        // Modern recommended way
        (bool sent, bytes memory data) = _to.call{value: msg.value}("");
        require(sent, "Failed to send Ether");
    }
}

/*
 * BEST PRACTICES FOR SENDING ETH:
 * 
 * 1. Security First:
 *    - Always use call() for ETH transfers
 *    - Check return values
 *    - Consider reentrancy risks
 * 
 * 2. Gas Considerations:
 *    - transfer() and send() have 2300 gas limit
 *    - call() allows flexible gas limits
 *    - More complex receivers need more gas
 * 
 * Visual Gas Comparison:
 * 
 * transfer()/send()  [===========]  2300 gas fixed
 * call()            [==============================] flexible
 * 
 * Common Patterns:
 * - Check-Effects-Interactions
 * - Use reentrancy guards
 * - Always verify success
 */
