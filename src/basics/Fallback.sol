// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title Fallback and Receive Functions
/// @author Ishan Lakhwani
/// @notice Shows how fallback and receive functions handle incoming ETH

/*
 * UNDERSTANDING FALLBACK & RECEIVE 📨
 * 
 * How Contract Receives ETH:
 * 
 *                  Incoming Transaction
 *                         ⬇️
 *              Has ETH been sent?
 *            /                    \
 *          Yes                    No
 *          /                        \
 *    Is msg.data empty?         fallback()
 *    /              \
 * Yes              No
 * /                  \
 * receive()      fallback()
 * 
 * Visual Function Selection:
 * +------------------+------------------+------------------+
 * | Condition        | msg.data empty?  | Function Called  |
 * +------------------+------------------+------------------+
 * | Sending ETH      |       ✅        | receive()        |
 * | Sending ETH      |       ❌        | fallback()       |
 * | No ETH          |     Either       | fallback()       |
 * +------------------+------------------+------------------+
 */
contract Fallback {
    // Event to track which function was called and remaining gas
    event Log(string func, uint256 gas);

    /*
     * RECEIVE FUNCTION
     * Called when:
     * 1. ETH is sent to contract
     * 2. msg.data is empty
     * 
     * Example: Simple ETH transfer
     * User → Contract
     * 1 ETH   (no data)
     */
    receive() external payable {
        // Log function name and remaining gas
        emit Log("receive", gasleft());
    }

    /*
     * FALLBACK FUNCTION
     * Called when:
     * 1. No other function matches call
     * 2. ETH sent with data
     * 3. No receive() exists
     * 
     * Example: ETH transfer with data
     * User → Contract
     * 1 ETH   (with data)
     */
    fallback() external payable {
        // Log function name and remaining gas
        emit Log("fallback", gasleft());
    }

    /*
     * View contract's ETH balance
     * Useful for checking if ETH was received
     */
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}

/*
 * COMMON USE CASES:
 * 
 * receive():
 * - Accept ETH payments
 * - Simple ETH transfers
 * - No additional logic needed
 * 
 * fallback():
 * - Handle unknown function calls
 * - Accept ETH with data
 * - Custom function forwarding
 * 
 * Visual Example of Calls:
 * 
 * 1. Regular ETH Transfer:
 * send 1 ETH → receive()
 * 
 * 2. ETH + Data Transfer:
 * send 1 ETH + data → fallback()
 * 
 * 3. Unknown Function:
 * call unknownFunc() → fallback()
 * 
 * BEST PRACTICES:
 * 
 * 1. Keep these functions simple
 * 2. Use events for monitoring
 * 3. Consider gas limitations
 * 4. Handle errors appropriately
 * 5. Document expected behavior
 */
