// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/ZkMask.sol";
import "../src/Interfaces/IZkMask.sol";

contract ZkMaskTest is Test, IZkMask {
    ZkMask public zkMask;

    function setUp() public {
        zkMask = new ZkMask();
    }

    function test_InitiateAuthentication() public {
        Transaction memory txDetails = Transaction(
            msg.sender,
            bytes4(keccak256("testInitiateAuthentication()")),
            new bytes32[](0),
            address(this),
            0,
            block.timestamp,
            block.number
        );
        uint256 txId = zkMask.initiateAuthentication(txDetails);
        Transaction memory storedTxDetails = zkMask.getTransaction(txId);
        assertEq(storedTxDetails.user, txDetails.user);
        assertEq(storedTxDetails.methodId, txDetails.methodId);
        assertEq(storedTxDetails.contractAddress, txDetails.contractAddress);
        assertEq(storedTxDetails.value, txDetails.value);
        assertEq(storedTxDetails.timestamp, txDetails.timestamp);
        assertEq(storedTxDetails.blockNumber, txDetails.blockNumber);
    }

    function test_CompleteAuthentication() public {
        Transaction memory txDetails = Transaction(
            msg.sender,
            bytes4(keccak256("testCompleteAuthentication()")),
            new bytes32[](0),
            address(this),
            0,
            block.timestamp,
            block.number
        );
        uint256 txId = zkMask.initiateAuthentication(txDetails);
        zkMask.completeAuthentication(true, txId);
        assertEq(zkMask.transactionVerified(txId), true);
    }

    function testFail_CompleteAuthentication() public {
        Transaction memory txDetails = Transaction(
            msg.sender,
            bytes4(keccak256("testCompleteAuthentication()")),
            new bytes32[](0),
            address(this),
            0,
            block.timestamp,
            block.number
        );
        uint256 txId = zkMask.initiateAuthentication(txDetails);
        zkMask.completeAuthentication(false, txId);
        assertEq(zkMask.transactionVerified(txId), true);
    }
}
