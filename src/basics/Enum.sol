// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title Enum Example with Order Status
/// @author Ishan Lakhwani
/// @notice Shows how to use enums for status tracking

/*
 * ENUMS: Like a fixed set of options
 * 
 * Think of it like a shipping status:
 * 
 * Visual Example:
 * +------------+
 * | 📦 Order  |
 * +------------+
 *      ⬇️
 * [0] Pending (Default)
 *      ⬇️
 * [1] Shipped
 *      ⬇️
 * [2] Accepted
 *      ⬇️
 * [3] Rejected
 *      ⬇️
 * [4] Canceled
 * 
 * Each status has a number behind the scenes:
 * Pending   = 0 (default)
 * Shipped   = 1
 * Accepted  = 2
 * Rejected  = 3
 * Canceled  = 4
 */
contract Enum {
    // Define all possible status values
    enum Status {
        Pending, // 0
        Shipped, // 1
        Accepted, // 2
        Rejected, // 3
        Canceled // 4

    }

    // Current status (starts at Pending)
    Status public status;

    // Get current status
    function get() public view returns (Status) {
        return status;
    }

    // Update to a new status
    function set(Status _status) public {
        status = _status;
    }

    // Special function to mark as canceled
    function cancel() public {
        status = Status.Canceled;
    }

    // Reset back to Pending
    function reset() public {
        delete status; // same as status = Status.Pending
    }
}
