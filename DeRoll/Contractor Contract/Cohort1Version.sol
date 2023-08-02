// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./ICohort1Version.sol";

contract Cohort1Version is ICohort1Version, Ownable {
  using Counters for Counters.Counter;

  Counters.Counter private jobIdCounter;

  mapping(address => bool) private Contractors;
  mapping(uint256 => Job) private Jobs;

  // Contractor Functions



  // Owner Only Functions

  function createJob(string memory _title, string memory _description, string memory _link, uint256 _payout) external onlyOwner {
    jobIdCounter.increment();
    uint256 newJobId = jobIdCounter.current()

    Jobs[newJobId] = Job(
      newJobId, 
      _title, 
      _description,
      _link, 
      _payout, 
      address(0), 
      JobStatus.AVAILABLE
    );

    emit JobCreated(newJobId, _title, _description, _link, _payout);
  }

  function addContractors(address[] memory _contractors) external onlyOwner {
    for (uint256 i = 0; i < _contractors.length; i++) {
      Contractors[_contractors[i]] = true;
    }
    emit ContractorsAdded(_contractors);
  }

  function removeContractors(address[] memory _contractors) external onlyOwner {
    for (uint256 i = 0; i < _contractors.length; i++) {
      Contractors[_contractors[i]] = false;
    }
    emit ContractorsRemoved(_contractors);
  }
}
