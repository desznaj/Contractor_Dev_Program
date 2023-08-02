// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

interface ICohort1Version {
  enum JobStatus { Open, Accepted, Completed }

  struct Job {
    uint256 JobId;
    string Title;
    string Description;
    string Link;
    uint256 Payout;
    address Contractor;
    JobStatus Status;
  }

  event JobCreated(uint256 JobId, string Title, string Description, string Link, uint256 Payout);

  event ContractorAdded(address[] Contractors, bool AddRemove);

  // Contractor Only Functions

  function getJobsList() external view returns (Job[] memory);

  function acceptJob(uint256 _jobId) external;

  function finalizeJob(uint256 _jobId) external;

  // Owner Only Functions

  function createJob(string memory _title, string memory _description, string memory _link, uint256 _payout) external;

  function addContractors(address[] memory _contractors) external;

  function removeContractors(address[] memory _contractors) external;
}
