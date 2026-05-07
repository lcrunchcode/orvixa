// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/access/Ownable.sol";

contract VexaAgentRegistry is Ownable {

    struct Agent {
        address ownerAddress;
        string metadataCid;     // 0G Storage hash
        uint256 reputation;     // 0-100 score
        bool verified;
        uint256 createdAt;
        bool exists;
    }

    mapping(bytes32 => Agent) public agents;
    mapping(address => bytes32) public addressToAgentId;
    bytes32[] public allAgentIds;
    uint256 public agentCount;

    event AgentRegistered(bytes32 indexed agentId, address indexed ownerAddress, string metadataCid, uint256 timestamp);

    // FIX: We added "Ownable(msg.sender)" here to tell the contract YOU are the owner
    constructor() Ownable(msg.sender) {}

    function registerAgent(string memory metadataCid) external returns (bytes32) {
        require(addressToAgentId[msg.sender] == bytes32(0), "Address already registered");
        require(bytes(metadataCid).length > 0, "Metadata CID required");

        bytes32 agentId = keccak256(abi.encodePacked(msg.sender, agentCount));

        agents[agentId] = Agent({
            ownerAddress: msg.sender,
            metadataCid: metadataCid,
            reputation: 50,
            verified: false,
            createdAt: block.timestamp,
            exists: true
        });

        addressToAgentId[msg.sender] = agentId;
        allAgentIds.push(agentId);
        agentCount++;

        emit AgentRegistered(agentId, msg.sender, metadataCid, block.timestamp);
        return agentId;
    }

    function getAgent(bytes32 agentId) external view returns (Agent memory) {
        require(agents[agentId].exists, "Agent does not exist");
        return agents[agentId];
    }
}