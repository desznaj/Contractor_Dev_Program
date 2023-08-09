// SPDX-License-Identifier: UNLICENSE

pragma solidity 0.8.19;

contract ContractorJobs{
    //Variable Declarations
    address public Owner;
    uint256 internal LatestShuffleNumber;

    //Other Declarations
    mapping(address => bool) public Contractors;

    uint256[] public AvailableJobs;
    Job[] public Jobs;
    mapping(uint256 => uint256) internal FisherYatesShuffle;

    modifier onlyOwner(){
        require(msg.sender == Owner, "Only the owner can call this function.");
        _;
    }
    modifier onlyContractor(){
        require(Contractors[msg.sender], "Only approved contractors can call this function.");
        _;
    }

    event JobCreated(uint256 JobId, string Description, string Link, uint256 TotalPayout);
    event JobAccepted(uint256 JobId, address Contractor);
    event ContractorsAddedOrRemoved(address[] Contractors, bool AddRemove);

    struct Job{
        string Description;
        string Link;
        uint256 TotalPayout;
        address Contractor;
        bool Accepted;
        bool Completed;
    }

    function CreateJob(string memory description, string memory link, uint256 payout) public onlyOwner{
        require(bytes(description).length > 0 && bytes(description).length < 200, "Description is either empty or too long.");
        require(bytes(link).length < 200, "Link is too long.");

        Jobs.push(Job(description, link, payout, address(0), false, false));
        AvailableJobs.push(Jobs.length - 1);
        FisherYatesShuffle[(Jobs.length - 1)] = (AvailableJobs.length - 1);

        emit JobCreated((Jobs.length - 1), description, link, payout);
    }

    function AcceptJob(uint256 JobID) public{
        require(Contractors[msg.sender] == true, "You are not a SoteriaSC contractor");

        Jobs[JobID].Contractor = msg.sender;
        Jobs[JobID].Accepted = true;
        
        AvailableJobs[FisherYatesShuffle[JobID]] = AvailableJobs[AvailableJobs.length - 1];
        AvailableJobs.pop();

        payable(msg.sender).transfer(Jobs[JobID].TotalPayout / 2);
        
        emit JobAccepted(JobID, msg.sender);
    }

    //I want this function to be called by the contractor who accepted the job, but it does not payout to the contractor until the owner confirms the job is complete.
    function CompleteJob(uint256 JobID) public onlyContractor{
        require(Jobs[JobID].Accepted == true, "This job has not been accepted yet.");
        require(Jobs[JobID].Completed == false, "This job has already been completed.");

        Jobs[JobID].Completed = true;
    }

    function ConfirmCompleteJob(uint256 JobID) public onlyOwner{
        require(Jobs[JobID].Completed == true, "This job has not been completed yet.");

        payable(Jobs[JobID].Contractor).transfer(Jobs[JobID].TotalPayout - (Jobs[JobID].TotalPayout / 2));
    }

    function AddOrRemoveContractors(address[] memory contractors, bool addremove) public onlyOwner{
        for(uint256 i = 0; i < contractors.length; i++){
            Contractors[contractors[i]] = addremove;
        }
        emit ContractorsAddedOrRemoved(contractors, addremove);
    }

}