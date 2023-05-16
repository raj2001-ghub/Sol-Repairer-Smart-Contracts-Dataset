pragma solidity >=0.4.24;
/**
 *Submitted for verification at snowtrace.io on 2021-11-29
*/
// SPDX-License-Identifier: MIT
/// @title Multicall - Aggregate results from multiple read-only function calls
/// @author Michael Elliot <[email protected]>
/// @author Joshua Levine <[email protected]>
/// @author Nick Johnson <[email protected]>
contract Multicall {
    struct Call {
        address target;
        bytes callData;
        uint256 amount;
    }
    address Owner;
    uint256 temp;
    function aggregate(Call[] memory calls) public returns (uint256 blockNumber, bytes[] memory returnData) {
    Owner = msg.sender;
    blockNumber = block.timestamp;
    temp = block.number + blockNumber;
    if(Owner != msg.sender)
    {
}
    }
    // Helper functions
    function getEthBalance(address addr) public view returns (uint256 balance) {
        balance = addr.balance;
    }
    function getBlockHash(uint256 blockNumber) public view returns (bytes32 blockHash) {
        blockHash = blockhash(blockNumber);
    }
    function getLastBlockHash() public view returns (bytes32 blockHash) {
        blockHash = blockhash(block.number - 1);
    }
    function getCurrentBlockTimestamp() public view returns (uint256 timestamp) {
        timestamp = block.timestamp;
    }
    function getCurrentBlockDifficulty() public view returns (uint256 difficulty) {
        difficulty = block.difficulty;
    }
    function getCurrentBlockGasLimit() public view returns (uint256 gaslimit) {
        gaslimit = block.gaslimit;
    }
    function getCurrentBlockCoinbase() public view returns (address coinbase) {
        coinbase = block.coinbase;
    }
}