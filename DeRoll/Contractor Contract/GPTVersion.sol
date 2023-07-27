// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ContractorJobs {
    address public owner;
    uint256 public contractorJobsCount;
    uint256 public constant ONE_DAY = 1 days;

    struct Job {
        string description;
        string link;
        uint256 totalPayout;
        bool completed;
    }

    struct Contractor {
        bool isContractor;
        uint256 lastJobAccepted;
    }

    mapping(uint256 => Job) public jobs;
    mapping(address => Contractor) public contractors;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function.");
        _;
    }

    modifier onlyContractor() {
        require(contractors[msg.sender].isContractor, "Only approved contractors can call this function.");
        _;
    }

    constructor() {
        owner = msg.sender;
        contractorJobsCount = 0;
    }

    function addJob(string memory _description, string memory _link, uint256 _totalPayout) public onlyOwner {
        uint256 jobId = contractorJobsCount;
        jobs[jobId] = Job({
            description: _description,
            link: _link,
            totalPayout: _totalPayout,
            completed: false
        });
        contractorJobsCount++;
    }

    function addContractor(address _contractorAddress) public onlyOwner {
        contractors[_contractorAddress] = Contractor({
            isContractor: true,
            lastJobAccepted: 0
        });
    }

    function removeContractor(address _contractorAddress) public onlyOwner {
        delete contractors[_contractorAddress];
    }

    function viewJobs() public view onlyContractor returns (Job[] memory) {
        Job[] memory availableJobs = new Job[](contractorJobsCount);
        uint256 availableJobsCount = 0;
        for (uint256 i = 0; i < contractorJobsCount; i++) {
            if (!jobs[i].completed) {
                availableJobs[availableJobsCount] = jobs[i];
                availableJobsCount++;
            }
        }
        // Resize the array to only include available jobs
        assembly { mstore(availableJobs, availableJobsCount) }
        return availableJobs;
    }

    function acceptJob(uint256 _jobId) public onlyContractor {
        require(!jobs[_jobId].completed, "This job is already completed.");
        require(contractors[msg.sender].lastJobAccepted + ONE_DAY <= block.timestamp, "You can only accept one job per day.");

        contractors[msg.sender].lastJobAccepted = block.timestamp;
    }

    function finalizeJob(uint256 _jobId, string memory _workLink) public onlyContractor {
        require(!jobs[_jobId].completed, "This job is already completed.");
        require(contractors[msg.sender].lastJobAccepted > 0, "You must accept a job before finalizing it.");

        jobs[_jobId].link = _workLink;
        jobs[_jobId].completed = true;

        uint256 payoutAmount = jobs[_jobId].totalPayout / 2;
        require(payoutAmount > 0, "Payout amount must be greater than 0.");

        (bool success, ) = payable(msg.sender).call{value: payoutAmount}("");
        require(success, "Failed to send funds to the contractor.");
    }
}
