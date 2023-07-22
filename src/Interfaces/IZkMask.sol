// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface IZkMask {
    error TransactionAlreadyExists();

    struct Transaction {
        address user;
        bytes4 methodId;
        bytes32[] params;
        address contractAddress;
        uint256 value;
        uint256 timestamp;
        uint256 blockNumber;
    }

    event InitiateAuthentication(
        uint256 indexed txId,
        address indexed userAddress,
        bytes4 indexed methodId,
        uint256 transactionTimestamp,
        uint256 transactionBlockNumber
    );
    event AuthenticationCompleted(
        bool success,
        address indexed userAddress,
        uint256 indexed transactionId,
        address contractAddress,
        uint256 value,
        bytes4 methodId,
        uint256 transactionTimestamp,
        uint256 transactionBlockNumber
    );
}
