// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

/**
 * @title Escrow
 * @dev Professional escrow implementation for secure P2P trades.
 */
contract Escrow is ReentrancyGuard {
    address public buyer;
    address payable public seller;
    address public arbiter;
    uint256 public amount;

    enum State { AWAITING_PAYMENT, AWAITING_DELIVERY, CLOSED, DISPUTED }
    State public currentState;

    modifier onlyBuyer() {
        require(msg.sender == buyer, "Only buyer can call this");
        _;
    }

    modifier onlyArbiter() {
        require(msg.sender == arbiter, "Only arbiter can call this");
        _;
    }

    constructor(address payable _seller, address _arbiter) {
        buyer = msg.sender;
        seller = _seller;
        arbiter = _arbiter;
        currentState = State.AWAITING_PAYMENT;
    }

    function deposit() external payable onlyBuyer {
        require(currentState == State.AWAITING_PAYMENT, "Already paid");
        require(msg.value > 0, "Must send funds");
        amount = msg.value;
        currentState = State.AWAITING_DELIVERY;
    }

    function confirmDelivery() external onlyBuyer nonReentrant {
        require(currentState == State.AWAITING_DELIVERY, "Not awaiting delivery");
        currentState = State.CLOSED;
        seller.transfer(address(this).balance);
    }

    function initiateDispute() external {
        require(msg.sender == buyer || msg.sender == seller, "Only parties can dispute");
        require(currentState == State.AWAITING_DELIVERY, "Cannot dispute now");
        currentState = State.DISPUTED;
    }

    function resolveDispute(bool releaseToSeller) external onlyArbiter nonReentrant {
        require(currentState == State.DISPUTED, "Not in dispute");
        currentState = State.CLOSED;
        if (releaseToSeller) {
            seller.transfer(address(this).balance);
        } else {
            payable(buyer).transfer(address(this).balance);
        }
    }
}
