// SPDX-License-Identifier: UNLICENSE

pragma solidity 0.8.19;

contract ContractorJobs{
    address public Owner;
    uint256 public ContractorJobsCount;
    uint256 public OldestUnclaimedJob;

    mapping(address => bool) public Contractors;
    mapping(uint256 => Job) public Jobs;

    modifier onlyOwner(){
        require(msg.sender == Owner, "Only the owner can call this function.");
        _;
    }
    modifier onlyContractor(){
        require(Contractors[msg.sender], "Only approved contractors can call this function.");
        _;
    }

    struct Job{
        string Description;
        string Link;
        uint256 TotalPayout;
        address Contractor;
        bool Accepted;
        bool Completed;
    }

    function CreateJob(string memory description, string memory link, uint256 Payout) public onlyOwner{
        uint256 JobId = ContractorJobsCount;
        Jobs[JobId] = Job(_description, )
        ContractorJobsCount++;
    }


}