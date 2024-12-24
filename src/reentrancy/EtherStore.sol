// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title EtherStore - A vulnerable contract
/// @author Ishan Lakhwani
/// @notice This contract demonstrates a reentrancy vulnerability
/// @dev This contract is intentionally vulnerable for educational purposes

contract EtherStore {
    mapping(address => uint256) public balances;
    bool internal locked;

    event Deposit(address indexed user, uint256 amount);
    event Withdrawal(address indexed user, uint256 amount);

    modifier noReentrant() {
        require(!locked, "No re-entrancy");
        locked = true;
        _;
        locked = false;
    }

    function deposit() public payable {
        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw() public noReentrant {
        uint256 bal = balances[msg.sender];
        require(bal > 0);

        (bool sent,) = msg.sender.call{value: bal}("");
        require(sent, "Failed to send Ether");

        balances[msg.sender] = 0;
        emit Withdrawal(msg.sender, bal);
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
