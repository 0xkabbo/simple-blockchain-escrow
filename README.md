# Simple Blockchain Escrow

A secure and transparent escrow solution for Web3 commerce. This repository implements a "Buyer-Seller-Arbiter" model, protecting both parties in a transaction by holding funds in a smart contract until the terms of the agreement are fulfilled.

## Features
* **Safe Deposit:** Funds are locked in the contract at the start of the transaction.
* **Arbitration Logic:** Includes a designated Arbiter role to resolve disputes and release funds to the rightful party.
* **Non-Reentrant:** Protected against common withdrawal exploits.

## Getting Started
1. Deploy `Escrow.sol` with the Seller's address and the Arbiter's address.
2. The Buyer sends the required payment to the contract.
3. Once the service/good is received, the Buyer calls `confirmDelivery`.
4. In case of dispute, the Arbiter calls `resolveDispute`.

## License
MIT
