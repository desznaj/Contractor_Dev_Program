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

    event JobCreated(uint256 JobId, string Description, string Link, uint256 TotalPayout);

    struct Job{
        string Description;
        string Link;
        uint256 TotalPayout;
        address Contractor;
        bool Accepted;
        bool Completed;
        uint256 LastUpdate;
    }

    function CreateJob(string memory description, string memory link, uint256 payout) public onlyOwner{
        require(bytes(description).length > 0 && bytes(description).length < 200, "Description is either empty or too long.");
        require(bytes(link).length < 200, "Link is too long.");

        uint256 JobId = ContractorJobsCount;
        Jobs[JobId] = Job(description, link, payout, address(0), false, false);
        ContractorJobsCount++;
    }


}