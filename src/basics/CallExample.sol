// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title Low-Level Call Examples
/// @author Ishan Lakhwani
/// @notice Shows how to make low-level calls between contracts

/*
 * UNDERSTANDING LOW-LEVEL CALLS 📞
 * 
 * Low-level calls allow contracts to interact dynamically:
 * - Can call functions that don't exist
 * - Can send ETH with the call
 * - More flexible but more dangerous
 * 
 * Visual Call Flow:
 *                  encode        call          decode
 * Caller → [function signature + data] → Receiver → [result]
 *          "foo(string,uint256)"
 */

/*
 * Receiver Contract
 * Like a phone that can receive calls
 */
contract Receiver {
    // Event to log incoming calls
    event Received( // Who called
        // How much ETH sent
        // What message
    address caller, uint256 amount, string message);

    /*
     * Fallback Function
     * Called when:
     * - Function doesn't exist
     * - Raw call data sent
     * 
     * Like an answering machine
     */
    fallback() external payable {
        emit Received(msg.sender, msg.value, "Fallback was called");
    }

    /*
     * Regular Function
     * Can be called normally or via low-level call
     * 
     * Like a specific phone extension
     */
    function foo(string memory _message, uint256 _x) public payable returns (uint256) {
        // Log the call details
        emit Received(msg.sender, msg.value, _message);
        // Return modified value
        return _x + 1;
    }
}

/*
 * Caller Contract
 * Like a phone making calls
 */
contract Caller {
    // Event to log call results
    event Response(bool success, bytes data);

    /*
     * Test calling existing function
     * 
     * Flow:
     * 1. Encode function signature and parameters
     * 2. Make the call with ETH and gas
     * 3. Get success/failure and return data
     * 
     * Visual:
     * Caller → encode("foo(string,uint256)") → Receiver
     *       ← success/data                   ←
     */
    function testCallFoo(address payable _addr) public payable {
        // Encode the function call
        // "foo(string,uint256)" + parameters
        (bool success, bytes memory data) = _addr.call{
            value: msg.value, // Send ETH
            gas: 5000 // Limit gas
        }(
            abi.encodeWithSignature(
                "foo(string,uint256)", // Function signature
                "call foo", // First parameter
                123 // Second parameter
            )
        );

        // Log the result
        emit Response(success, data);
    }

    /*
     * Test calling non-existent function
     * Will trigger the fallback function
     * 
     * Visual:
     * Caller → "doesNotExist()" → Receiver's fallback
     */
    function testCallDoesNotExist(address payable _addr) public payable {
        // Try to call non-existent function
        (bool success, bytes memory data) = _addr.call{value: msg.value}(abi.encodeWithSignature("doesNotExist()"));

        // Log the result
        emit Response(success, data);
    }
}

/*
 * LOW-LEVEL CALL BEST PRACTICES:
 * 
 * 1. Security:
 *    - Always check return values
 *    - Be careful with external calls
 *    - Consider reentrancy risks
 * 
 * 2. Gas:
 *    - Set gas limits when needed
 *    - Handle out-of-gas scenarios
 * 
 * 3. Error Handling:
 *    - Check success boolean
 *    - Handle return data carefully
 * 
 * 4. Documentation:
 *    - Document expected function signatures
 *    - Log important call data
 * 
 * Visual Call Process:
 * 
 * 1. Normal Call:
 * Caller → foo("hello", 123) → Receiver → Return Value
 * 
 * 2. Failed Call:
 * Caller → unknownFunction() → Fallback → Log Event
 */
