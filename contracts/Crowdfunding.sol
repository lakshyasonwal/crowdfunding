// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DecentralizedDonationSystem {
    address public owner;
    mapping(address => uint256) public donations;
    uint256 public totalDonations;

    event Donated(address indexed donor, uint256 amount);
    event Withdrawn(address indexed owner, uint256 amount);

    constructor() {
        owner = msg.sender;
    }

    // Function 1: Donate ETH
    function donate() external payable {
        require(msg.value > 0, "Donation must be greater than zero");
        donations[msg.sender] += msg.value;
        totalDonations += msg.value;
        emit Donated(msg.sender, msg.value);
    }

    // Function 2: Check Donation by User
    function checkDonation(address donor) external view returns (uint256) {
        return donations[donor];
    }

    // Function 3: Withdraw All Donations (only owner)
    function withdraw() external {
        require(msg.sender == owner, "Only owner can withdraw");
        uint256 amount = address(this).balance;
        payable(owner).transfer(amount);
        emit Withdrawn(owner, amount);
    }
}

