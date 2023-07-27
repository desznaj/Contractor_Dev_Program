// SPDX-License-Identifier: UNLICENSE

pragma solidity 0.8.19;

contract ContractorJobs{
    address public Owner;
    uint256 public ContractorJobsCount;

    mapping(address => bool) public Contractors;
    mapping(uint256 => Job) public Jobs;

    struct Job{
        string Description;
        string Link;
        uint256 TotalPayout;
        bool Completed;
    }

    func


}