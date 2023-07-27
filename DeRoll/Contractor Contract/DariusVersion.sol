// SPDX-License-Identifier: UNLICENSE

pragma solidity 0.8.19;

contract ContractorJobs{
    address public Owner;

    mapping(address => bool) public Contractors;
    mapping(uint256 => Job) public Jobs;

    struct Job{
        
    }
}