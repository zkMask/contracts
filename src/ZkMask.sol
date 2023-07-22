// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./Interfaces/IZkMask.sol";

contract ZkMask is IZkMask {
    uint256 private transactionNonce;

    mapping(uint256 => Transaction) public transactionId;
    mapping(uint256 => bool) public transactionVerified;

    function initiateAuthentication(
        Transaction memory txDetails
    ) public returns (uint256) {
        address user = msg.sender;
        bytes4 functionSelector = txDetails.methodId;
        uint256 timestamp = txDetails.timestamp;
        uint256 blockNumber = txDetails.blockNumber;
        uint256 txId = uint256(
            keccak256(
                abi.encodePacked(
                    user,
                    functionSelector,
                    timestamp,
                    blockNumber,
                    transactionNonce
                )
            )
        );
        if (transactionId[txId].timestamp != 0) {
            revert TransactionAlreadyExists();
        }
        transactionId[txId] = txDetails;
        transactionNonce++;

        emit InitiateAuthentication(
            txId,
            user,
            functionSelector,
            timestamp,
            blockNumber
        );

        return txId;
    }

    function completeAuthentication(bool success, uint256 txId) public {
        Transaction memory txDetails = transactionId[txId];
        transactionVerified[txId] = success;
        address user = txDetails.user;
        address contractAddress = txDetails.contractAddress;
        uint256 value = txDetails.value;
        bytes4 methodId = txDetails.methodId;
        uint256 timestamp = txDetails.timestamp;
        uint256 blockNumber = txDetails.blockNumber;
        emit AuthenticationCompleted(
            success,
            user,
            txId,
            contractAddress,
            value,
            methodId,
            timestamp,
            blockNumber
        );
    }

    function getTransaction(
        uint256 txId
    ) public view returns (Transaction memory) {
        return transactionId[txId];
    }
}
