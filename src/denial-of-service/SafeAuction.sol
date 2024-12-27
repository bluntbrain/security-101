// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title Safe Auction Contract
/// @author Ishan Lakhwani
/// @notice This contract demonstrates a DoS-resistant auction system using pull pattern
/// @dev This is a safer implementation using pull over push pattern

contract SafeAuction {
    // Events
    event NewHighestBid(address indexed bidder, uint256 amount);
    event RefundClaimed(address indexed bidder, uint256 amount);

    // State variables
    address public highestBidder;
    uint256 public highestBid;

    // Mapping to track refunds
    mapping(address => uint256) public pendingReturns;

    /// @notice Place a new bid
    /// @dev Uses pull pattern - stores refunds for later withdrawal
    function placeBid() external payable {
        require(msg.value > highestBid, "Bid not high enough");

        // Add previous highest bid to pending returns
        if (highestBidder != address(0)) {
            pendingReturns[highestBidder] += highestBid;
        }

        // Update auction state
        highestBid = msg.value;
        highestBidder = msg.sender;

        emit NewHighestBid(msg.sender, msg.value);
    }

    /// @notice Withdraw pending refunds
    /// @dev Allows users to pull their refunds
    /// @return success Whether the withdrawal was successful
    function withdrawRefund() external returns (bool success) {
        uint256 amount = pendingReturns[msg.sender];
        if (amount > 0) {
            // Reset pending return before sending to prevent re-entrancy
            pendingReturns[msg.sender] = 0;

            // Send refund
            (bool sent,) = msg.sender.call{value: amount}("");
            if (!sent) {
                // Restore the amount if send fails
                pendingReturns[msg.sender] = amount;
                return false;
            }
            emit RefundClaimed(msg.sender, amount);
            return true;
        }
        return false;
    }

    /// @notice Get the current auction state
    /// @return _highestBidder The address of the current highest bidder
    /// @return _highestBid The current highest bid amount
    function getAuctionState() external view returns (address _highestBidder, uint256 _highestBid) {
        return (highestBidder, highestBid);
    }

    /// @notice Get pending refund amount for an address
    /// @param bidder The address to check
    /// @return amount The amount of pending refund
    function getPendingRefund(address bidder) external view returns (uint256) {
        return pendingReturns[bidder];
    }
}
