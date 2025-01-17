// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title DelegateCall Example
/// @author Ishan Lakhwani
/// @notice Shows how delegatecall works and its differences from regular calls

/*
 * UNDERSTANDING DELEGATECALL 📚
 * 
 * delegatecall is like borrowing code but using your own storage:
 * - Uses logic from target contract
 * - But executes in caller's context
 * - Storage layout must match!
 * 
 * Visual Storage Comparison:
 * 
 * Regular call:
 * Contract A         Contract B
 * +--------+        +--------+
 * |num: 0  |  call  |num: 5  |  // Each contract uses its own storage
 * |sender:A|   →    |sender:A|
 * +--------+        +--------+
 * 
 * delegatecall:
 * Contract A         Contract B
 * +--------+        +--------+
 * |num: 5  | delegate|num: 0  |  // A's storage is modified using B's code
 * |sender:A|   →    |sender:B|
 * +--------+        +--------+
 */

/*
 * Target Contract (Logic Contract)
 * Like a library of functions that others can borrow
 */
contract B {
    // Storage layout MUST match Contract A
    uint256 public num; // slot 0
    address public sender; // slot 1
    uint256 public value; // slot 2

    /*
     * Function that modifies state
     * Will modify caller's state when used with delegatecall
     */
    function setVars(uint256 _num) public payable {
        num = _num; // Changes storage slot 0
        sender = msg.sender; // Changes storage slot 1
        value = msg.value; // Changes storage slot 2
    }
}

/*
 * Caller Contract (Storage Contract)
 * Uses delegatecall to borrow logic from Contract B
 */
contract A {
    // Storage layout MUST match Contract B
    uint256 public num; // slot 0
    address public sender; // slot 1
    uint256 public value; // slot 2

    /*
     * Using delegatecall
     * Borrows logic but uses our storage
     * 
     * Flow:
     * 1. A's storage is used
     * 2. B's code is executed
     * 3. msg.sender remains original caller
     */
    function setVarsDelegateCall(address _contract, uint256 _num) public payable {
        // Make delegatecall to B's setVars function
        (bool success, bytes memory data) = _contract.delegatecall(abi.encodeWithSignature("setVars(uint256)", _num));
    }

    /*
     * Using regular call (for comparison)
     * Executes in target contract's context
     * 
     * Flow:
     * 1. B's storage is used
     * 2. B's code is executed
     * 3. msg.sender becomes contract A
     */
    function setVarsCall(address _contract, uint256 _num) public payable {
        (bool success, bytes memory data) =
            _contract.call{value: msg.value}(abi.encodeWithSignature("setVars(uint256)", _num));
    }
}

/*
 * DELEGATECALL BEST PRACTICES:
 * 
 * 1. Storage Layout:
 *    - Must match exactly between contracts
 *    - Include all variables in same order
 *    - Consider using proxies pattern
 * 
 * 2. Security:
 *    - Be careful with trusted contracts
 *    - Validate target contract
 *    - Check return values
 * 
 * 3. Common Use Cases:
 *    - Proxy patterns
 *    - Upgradeable contracts
 *    - Logic libraries
 * 
 * Visual Context Comparison:
 * 
 * msg.sender in regular call:
 * User → Contract A → Contract B
 *        msg.sender   msg.sender
 * 
 * msg.sender in delegatecall:
 * User → Contract A ⟲ Contract B
 *        msg.sender   (same msg.sender)
 */
