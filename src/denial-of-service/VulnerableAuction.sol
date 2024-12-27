// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title Vulnerable Auction Contract
/// @author Ishan Lakhwani
/// @notice This contract demonstrates a vulnerable auction system prone to DoS attacks
/// @dev This contract is for demonstration purposes only - DO NOT USE IN PRODUCTION

contract VulnerableAuction {
    // Events
    event NewHighestBid(address indexed bidder, uint256 amount);
    event BidRefunded(address indexed bidder, uint256 amount);

    // State variables
    address public highestBidder;
    uint256 public highestBid;

    function placeBid() external payable {
        require(msg.value > highestBid, "Bid not high enough");

        address previousBidder = highestBidder;
        uint256 previousBid = highestBid;

        // Update auction state
        highestBid = msg.value;
        highestBidder = msg.sender;

        emit NewHighestBid(msg.sender, msg.value);

        // Refund the previous bidder
        if (previousBidder != address(0)) {
            (bool sent,) = previousBidder.call{value: previousBid}("");
            require(sent, "Failed to refund previous bidder");
            emit BidRefunded(previousBidder, previousBid);
        }
    }

    function getAuctionState() public view returns (address, uint256) {
        return (highestBidder, highestBid);
    }
}
