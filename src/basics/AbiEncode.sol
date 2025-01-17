// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title ABI Encoding Examples
/// @author Ishan Lakhwani
/// @notice Shows different ways to encode function calls

/*
 * UNDERSTANDING ABI ENCODING 📝
 * 
 * ABI (Application Binary Interface) encoding converts function calls and parameters 
 * into bytes that can be sent to contracts.
 * 
 * Three main encoding methods:
 * 1. encodeWithSignature: Uses string signature
 * 2. encodeWithSelector: Uses function selector
 * 3. encodeCall: Type-safe encoding (recommended)
 * 
 * Visual Example:
 * 
 * Function Call          →     Encoded Bytes
 * transfer(0x123.., 100) →     0xa9059cbb...
 *                              [selector][params]
 */

// Interface defines the function we want to call
interface IERC20 {
    function transfer(address, uint256) external;
}

// Mock token contract for example
contract Token {
    function transfer(address, uint256) external {}
}

contract AbiEncode {
    /*
     * Generic function to execute encoded calls
     * Like a universal remote that can send any command
     * 
     * Flow:
     * 1. Receive encoded data
     * 2. Send to target contract
     * 3. Check if call succeeded
     */
    function test(address _contract, bytes calldata data) external {
        (bool ok,) = _contract.call(data);
        require(ok, "call failed");
    }

    /*
     * Method 1: encodeWithSignature
     * Uses string function signature
     * 
     * Risks:
     * - Typos won't be caught at compile time
     * - "transfer(address,uint256)" must be exact
     * 
     * Visual:
     * "transfer(address,uint256)" → 0xa9059cbb (selector)
     */
    function encodeWithSignature(address to, uint256 amount) external pure returns (bytes memory) {
        // Manually specify function signature
        return abi.encodeWithSignature("transfer(address,uint256)", to, amount);
    }

    /*
     * Method 2: encodeWithSelector
     * Uses function selector directly
     * 
     * Better than signature because:
     * - No string manipulation
     * - Selector is computed at compile time
     * 
     * Visual:
     * IERC20.transfer.selector → 0xa9059cbb
     */
    function encodeWithSelector(address to, uint256 amount) external pure returns (bytes memory) {
        // Use interface to get selector
        return abi.encodeWithSelector(IERC20.transfer.selector, to, amount);
    }

    /*
     * Method 3: encodeCall (Recommended)
     * Type-safe encoding using interface
     * 
     * Advantages:
     * - Compile-time type checking
     * - No manual signature/selector needed
     * - Safest option
     * 
     * Visual:
     * IERC20.transfer → Type-checked → Encoded bytes
     */
    function encodeCall(address to, uint256 amount) external pure returns (bytes memory) {
        // Most safe: compiler checks types
        return abi.encodeCall(IERC20.transfer, (to, amount));
    }
}

/*
 * ABI ENCODING BEST PRACTICES:
 * 
 * 1. Safety:
 *    - Use encodeCall when possible (type-safe)
 *    - Verify encoded data carefully
 *    - Test with actual contracts
 * 
 * 2. Common Use Cases:
 *    - Contract interaction
 *    - Proxy contracts
 *    - Batch transactions
 * 
 * 3. Method Selection:
 *    encodeCall         → Known interface, type safety needed
 *    encodeWithSelector → Known selector, no interface
 *    encodeWithSignature → Dynamic/unknown functions
 * 
 * Visual Encoding Process:
 * 
 * Function + Args → ABI Encode → Selector + Params → Contract
 * transfer(addr, 100) → 0xa9059cbb + params → Target
 */
