// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title AgentRegistry
 * @notice On-chain identity system for advertiser and publisher agents
 */
contract AgentRegistry is Ownable {
    
    struct Agent {
        address ownerAddress;
        string metadataCid;
        uint256 reputation;
        bool verified;
        uint256 createdAt;
    }

    mapping(bytes32 => Agent) public agents;
    mapping(address => bytes32) public addressToAgentId;
    
    uint256 public agentCount;
    bytes32[] public allAgentIds;
    
    event AgentRegistered(bytes32 indexed agentId, address indexed ownerAddress, uint256 timestamp);
    event ReputationUpdated(bytes32 indexed agentId, uint256 newReputation);
    event AgentVerified(bytes32 indexed agentId);

    function registerAgent(string memory metadataCid) external returns (bytes32) {
        bytes32 agentId = keccak256(abi.encodePacked(msg.sender, block.timestamp));
        
        Agent memory newAgent = Agent({
            ownerAddress: msg.sender,
            metadataCid: metadataCid,
            reputation: 50,
            verified: false,
            createdAt: block.timestamp
        });
        
        agents[agentId] = newAgent;
        addressToAgentId[msg.sender] = agentId;
        agentCount++;
        allAgentIds.push(agentId);
        
        emit AgentRegistered(agentId, msg.sender, block.timestamp);
        return agentId;
    }

    function updateReputation(bytes32 agentId, uint256 newReputation) external onlyOwner {
        require(agents[agentId].ownerAddress != address(0), "Agent does not exist");
        require(newReputation <= 100, "Reputation must be 0-100");
        
        agents[agentId].reputation = newReputation;
        emit ReputationUpdated(agentId, newReputation);
    }

    function verifyAgent(bytes32 agentId) external onlyOwner {
        require(agents[agentId].ownerAddress != address(0), "Agent does not exist");
        agents[agentId].verified = true;
        emit AgentVerified(agentId);
    }

    function getAgent(bytes32 agentId) external view returns (Agent memory) {
        require(agents[agentId].ownerAddress != address(0), "Agent does not exist");
        return agents[agentId];
    }
}