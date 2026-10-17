// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Project {
    address payable public immutable owner;
    uint256 public immutable fundingGoal;
    uint256 public immutable deadline;

    // Gross amount donated over the campaign's lifetime.
    uint256 public totalDonations;

    // Total amount withdrawn by the owner.
    uint256 public totalWithdrawn;

    // Total amount refunded to donors.
    uint256 public totalRefunded;

    // A donor's refundable contribution balance.
    mapping(address => uint256) public donations;

    uint256 private _reentrancyStatus = 1;

    event DonationReceived(address indexed donor, uint256 amount);
    event FundsWithdrawn(address indexed owner, uint256 amount);
    event RefundClaimed(address indexed donor, uint256 amount);

    modifier nonReentrant() {
        require(_reentrancyStatus == 1, "Reentrant call");
        _reentrancyStatus = 2;
        _;
        _reentrancyStatus = 1;
    }

    // fundingGoal is in wei. durationInSeconds starts when the contract is deployed.
    constructor(uint256 fundingGoal_, uint256 durationInSeconds) {
        require(fundingGoal_ > 0, "Goal must be greater than 0");
        require(durationInSeconds > 0, "Duration must be greater than 0");

        owner = payable(msg.sender);
        fundingGoal = fundingGoal_;
        deadline = block.timestamp + durationInSeconds;
    }

    // Donate by calling donate() with ETH.
    function donate() external payable {
        _donate();
    }

    // Also accept a plain ETH transfer to the contract address.
    receive() external payable {
        _donate();
    }

    function _donate() internal {
        require(block.timestamp < deadline, "Campaign has ended");
        require(msg.value > 0, "Donation must be greater than 0");

        donations[msg.sender] += msg.value;
        totalDonations += msg.value;

        emit DonationReceived(msg.sender, msg.value);
    }

    // The owner can withdraw after the deadline, but only if the goal was reached.
    function withdraw(uint256 amount) external nonReentrant {
        require(msg.sender == owner, "Only owner can withdraw");
        require(block.timestamp >= deadline, "Campaign is still active");
        require(totalDonations >= fundingGoal, "Funding goal was not reached");
        require(amount > 0, "Amount must be greater than 0");
        require(amount <= address(this).balance, "Insufficient balance");

        totalWithdrawn += amount;

        (bool success, ) = owner.call{value: amount}("");
        require(success, "Withdrawal failed");

        emit FundsWithdrawn(owner, amount);
    }

    // Donors can reclaim their contributions after the deadline if the goal was missed.
    function claimRefund() external nonReentrant {
        require(block.timestamp >= deadline, "Campaign is still active");
        require(totalDonations < fundingGoal, "Funding goal was reached");

        uint256 refundAmount = donations[msg.sender];
        require(refundAmount > 0, "No refund available");

        donations[msg.sender] = 0;
        totalRefunded += refundAmount;

        (bool success, ) = payable(msg.sender).call{value: refundAmount}("");
        require(success, "Refund transfer failed");

        emit RefundClaimed(msg.sender, refundAmount);
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
