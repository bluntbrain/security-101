// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title Function Visibility Demo
/// @author Ishan Lakhwani
/// @notice Shows different types of function visibility in Solidity

/*
 * UNDERSTANDING FUNCTION VISIBILITY 🔒
 * 
 * Think of visibility like different levels of access in a building:
 * 
 * 1. private   🔒 : Only accessible within this room
 * 2. internal  🏠 : Accessible within this building and connected buildings
 * 3. public    🌍 : Anyone can access from anywhere
 * 4. external  🚪 : Only accessible from outside the building
 * 
 * Visual Example:
 * +----------------+-------------------+--------------------+------------------+
 * |                | Same Contract    | Child Contract     | Other Contracts  |
 * +----------------+-------------------+--------------------+------------------+
 * | private   🔒   |      ✅         |        ❌         |       ❌        |
 * | internal  🏠   |      ✅         |        ✅         |       ❌        |
 * | public    🌍   |      ✅         |        ✅         |       ✅        |
 * | external  🚪   |      ❌         |        ❌         |       ✅        |
 * +----------------+-------------------+--------------------+------------------+
 */
contract Base {
    /*
     * PRIVATE FUNCTION 🔒
     * - Like your personal diary
     * - Only this contract can read it
     * - Most restrictive access
     */
    function privateFunc() private pure returns (string memory) {
        return "private function called";
    }

    // Function to test private access
    function testPrivateFunc() public pure returns (string memory) {
        // We can call privateFunc() here because we're in the same contract
        return privateFunc();
    }

    /*
     * INTERNAL FUNCTION 🏠
     * - Like a family secret
     * - This contract and child contracts can use it
     * - Good for shared functionality
     */
    function internalFunc() internal pure returns (string memory) {
        return "internal function called";
    }

    function testInternalFunc() public pure virtual returns (string memory) {
        return internalFunc();
    }

    /*
     * PUBLIC FUNCTION 🌍
     * - Like a public park
     * - Anyone can use it
     * - Most open access
     */
    function publicFunc() public pure returns (string memory) {
        return "public function called";
    }

    /*
     * EXTERNAL FUNCTION 🚪
     * - Like a store's entrance
     * - Only accessible from outside
     * - Cannot be called from inside this contract
     */
    function externalFunc() external pure returns (string memory) {
        return "external function called";
    }

    /*
     * VARIABLE VISIBILITY
     * Variables can also have visibility:
     */
    string private privateVar = "my private variable"; // Like a personal item
    string internal internalVar = "my internal variable"; // Like family property
    string public publicVar = "my public variable"; // Like a public notice
        // Note: Variables cannot be external
}

/*
 * CHILD CONTRACT EXAMPLE
 * Shows how inheritance affects visibility
 */
contract Child is Base {
    // Child contract can use internal functions
    // Like a child knowing family secrets
    function testInternalFunc() public pure override returns (string memory) {
        return internalFunc();
    }

    // Note: Child cannot access private functions
    // This would not work:
    // function testPrivateFunc() public pure returns (string memory) {
    //     return privateFunc(); // ❌ Error!
    // }
}

/*
 * VISIBILITY BEST PRACTICES:
 * 
 * 1. Start with most restrictive (private)
 * 2. Only make functions public/external if needed
 * 3. Use internal for shared contract logic
 * 4. Use external for interface functions
 * 
 * Think of it like security clearance:
 * - Give minimum access needed
 * - Be explicit about who can access what
 * - Document why certain visibility is chosen
 */
