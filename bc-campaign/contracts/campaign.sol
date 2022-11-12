// SPDX-License-Identifier: MIT
pragma solidity ^0.4.26;

contract CampaignFactory {
    address[] public deployedCampaigns;

    function createCampaign(uint256 minimum) public {
        address newCampaign = new Campaign(minimum, msg.sender);
        deployedCampaigns.push(newCampaign);
    }

    function getDeployedCampaigns() public view returns (address[]) {
        return deployedCampaigns;
    }
}

contract Campaign {
    struct Request {
        string description;
        uint256 value;
        address recipient;
        bool complete;
        uint256 appprovalCount;
        mapping(address => bool) approvals;
    }

    // Storage (holds data between function calls)
    // As in a computer's hard drive
    Request[] public requests;
    address public manager;
    uint256 public minimumContribution;
    mapping(address => bool) public approvers;
    uint256 public approversCount;

    modifier restricted() {
        require(msg.sender == manager);
        _;
    }

    constructor(uint256 minimum, address creator) public {
        manager = creator;
        minimumContribution = minimum;
    }

    function contribute() public payable {
        require(msg.value > minimumContribution);

        approvers[msg.sender] = true;
        approversCount++;
    }

    function createRequest(
        string description,
        uint256 value,
        address recipient
    ) public restricted {
        // Memory (temporary place to store data)
        // As in a computer's RAM
        Request memory newRequest = Request({
            description: description,
            value: value,
            recipient: recipient,
            complete: false,
            appprovalCount: 0
        });

        requests.push(newRequest);
    }

    function approveRequest(uint256 index) public {
        Request storage thisRequest = requests[index];

        // require(approvers[msg.sender]);
        require(!thisRequest.approvals[msg.sender]);

        thisRequest.approvals[msg.sender] = true;
        thisRequest.appprovalCount++;
    }

    function finalizeRequest(uint256 index) public restricted {
        Request storage thisRequest = requests[index];

        require(thisRequest.appprovalCount > (approversCount / 2));
        require(!thisRequest.complete);

        thisRequest.recipient.transfer(thisRequest.value);
        thisRequest.complete = true;
    }
}
