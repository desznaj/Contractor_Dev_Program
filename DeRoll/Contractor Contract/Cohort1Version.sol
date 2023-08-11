// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Cohort1Version is Ownable {
    uint256 private jobIdCounter;

    mapping(address => bool) private Contractors;
    mapping(uint256 => Job) private Jobs;

    enum JobStatus { AVAILABLE, ACCEPTED, COMPLETED }

    struct Job {
        uint256 JobId;
        string Title;
        string Description;
        string Link;
        uint256 RemainingPayout;
        address Contractor;
        JobStatus Status;
    }

    // Events

    event JobCreated(uint256 indexed JobId, string Title, string Description, string Link, uint256 Payout);

    event JobFinalized(uint256 indexed JobId);
    
    event ContractorsAdded(address[] Contractors);
    
    event ContractorsRemoved(address[] Contractors);

    // Contractor Functions



    // Owner Only Functions

    function CreateJob(string memory _title, string memory _description, string memory _link, uint256 _payout) external onlyOwner {
        jobIdCounter++;

        Jobs[jobIdCounter] = Job(
            jobIdCounter, 
            _title, 
            _description,
            _link, 
            _payout, 
            address(0), 
            JobStatus.AVAILABLE
        );

        emit JobCreated(jobIdCounter, _title, _description, _link, _payout);
    }

    function FinalizeJob(uint256 _jobId) public onlyOwner {
        require(_jobId <= jobIdCounter, "Job ID not valid");
        require(Jobs[_jobId].Status == JobStatus.ACCEPTED, "Job must be ongoing");
    
        Jobs[_jobId].Status = JobStatus.COMPLETED;
    
        uint256 finalPayout = Jobs[_jobId].RemainingPayout;
        address payable contractor = payable(Jobs[_jobId].JobsContractor);

        Jobs[_jobId].RemainingPayout = 0;

        (bool success, ) = contractor.call{value: finalPayout}("");
        require(success, "Failed to send funds to the contractor");

        emit JobFinalized(_jobId);
    }

    function AddContractors(address[] memory _contractors) external onlyOwner {
        for (uint256 i = 0; i < _contractors.length; i++) {
          Contractors[_contractors[i]] = true;
        }
        emit ContractorsAdded(_contractors);
    }

    function RemoveContractors(address[] memory _contractors) external onlyOwner {
        for (uint256 i = 0; i < _contractors.length; i++) {
            Contractors[_contractors[i]] = false;
        }
        emit ContractorsRemoved(_contractors);
    }
}
