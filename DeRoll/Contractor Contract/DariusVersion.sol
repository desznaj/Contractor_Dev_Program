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

    function CreateJob(string memory _description, string memory _link, uint256 _totalPayout) public onlyOwner{
        uint256 JobId = ContractorJobsCount;
        Jobs[JobId] = Job({
            Description: _description,
            Link: _link,
            TotalPayout: _totalPayout,
            Completed: false
        });
        ContractorJobsCount++;
    }


}