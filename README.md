# CharityVault Crowdfunding

CharityVault is a single-campaign ETH crowdfunding contract. The Solidity contract is named **Project**.

## Project Description

Contributors can fund the campaign through its deadline. If the campaign reaches its funding goal by then, the owner can withdraw funds. If it misses the goal, donors can claim refunds.

## How It Works

1. Deploy the contract with a funding goal in wei and a duration in seconds.
2. Donate by calling `donate()` with ETH, or by sending ETH directly to the contract before the deadline.
3. Donations remain open until the deadline, even after the goal is reached. The campaign may raise more than its goal.
4. After the deadline, the owner can withdraw funds if the goal was reached. Otherwise, donors can claim refunds.

## Key Features

- Records each donor's contributions.
- Emits events for donations, withdrawals, and refunds.
- Accepts direct ETH transfers while the campaign is active.
- Allows owner withdrawals only after the deadline and only if the goal was reached.
- Allows donor refunds only after the deadline if the goal was missed.
- Uses a reentrancy guard on withdrawal and refund calls.

## Deployment Parameters

The constructor takes:

- `fundingGoal_`: target amount in wei.
- `durationInSeconds`: campaign duration in seconds.

For example, a goal of 1 ETH is 1000000000000000000 wei, and 30 days is 2592000 seconds.

## Public Getters

- `owner`: campaign owner.
- `fundingGoal`: target amount.
- `deadline`: campaign end timestamp.
- `donations(address)`: contribution recorded for a donor. It is set to zero after that donor claims a refund.
- `totalDonations`: gross contributions received; it does not decrease after withdrawals or refunds.
- `totalWithdrawn`: amount withdrawn by the owner.
- `totalRefunded`: amount returned to donors.
- `getBalance()`: ETH currently held by the contract.

## Future Scope

- Add a donor leaderboard.
- Support ERC-20 tokens.
- Enable multi-signature withdrawals.
- Develop a frontend DApp.

## Contract Source

See [contracts/Crowdfunding.sol](contracts/Crowdfunding.sol).

## Deployment Details

The address previously listed here is:

**0xA91E710811f203c42F598f4f536BbB70E5334181**

This address was listed for the earlier implementation. The current source requires a funding goal and duration at deployment. A source update does not change a deployed contract, so deploy this version and verify its source before listing its address as the current deployment. Add the network name and block-explorer link when verified.

The screenshot below documents the previously listed deployment. Replace it with details for the current version after deployment.

<img width="1918" height="1022" alt="Previous deployment screenshot" src="https://github.com/user-attachments/assets/becd2ce4-39dc-4e36-9bb6-0d635a0e8a80" />
