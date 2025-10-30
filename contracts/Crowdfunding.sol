// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Project {
    address public owner;
    uint256 public totalDonations;

    mapping(address => uint256) public donations;

    constructor() {
        owner = msg.sender;
    }

    // 1️⃣ Function to accept donations
    function donate() public payable {
        require(msg.value > 0, "Donation must be greater than 0");
        donations[msg.sender] += msg.value;
        totalDonations += msg.value;
    }

    // 2️⃣ Function to check total donations
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    // 3️⃣ Function for the owner to withdraw funds
    function withdraw(uint256 amount) public {
        require(msg.sender == owner, "Only owner can withdraw");
        require(amount <= address(this).balance, "Insufficient balance");
        payable(owner).transfer(amount);
    }
}
