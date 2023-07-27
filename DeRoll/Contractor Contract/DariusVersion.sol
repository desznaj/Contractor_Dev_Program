// SPDX-License-Identifier: UNLICENSE

pragma solidity 0.8.19;

contract ContractorJobs{
    //
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
    event ContractorsAddedOrRemoved(address[] Contractors, bool AddRemove);

    struct Job{
        string Description;
        string Link;
        uint256 TotalPayout;
        address Contractor;
        bool Accepted;
        bool Completed;
        uint256 LastUpdate;
    }



    // Only Owner Functions

    function CreateJob(string memory description, string memory link, uint256 payout) public onlyOwner{
        require(bytes(description).length > 0 && bytes(description).length < 200, "Description is either empty or too long.");
        require(bytes(link).length < 200, "Link is too long.");

        uint256 JobId = ContractorJobsCount;
        Jobs[JobId] = Job(description, link, payout, address(0), false, false, block.timestamp);
        ContractorJobsCount++;

        emit JobCreated(JobId, description, link, payout);
    }

    function AddOrRemoveContractors(address[] memory contractors, bool addremove) public onlyOwner{
        for(uint256 i = 0; i < contractors.length; i++){
            Contractors[contractors[i]] = addremove;
        }
        emit ContractorsAddedOrRemoved(contractors, addremove);
    }


}