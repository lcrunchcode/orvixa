// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract VexaAuction is Ownable, ReentrancyGuard {

    struct Bid {
        bytes32 agentId;
        address bidderAddress;
        uint256 bidAmount;
        uint256 timestamp;
        bool active;
    }

    struct Inventory {
        bytes32 publisherId;
        address publisherAddr;
        string storageHash; 
        uint256 basePrice;
        bool auctionOpen;
        bool settled;
    }

    mapping(bytes32 => Inventory) public inventories;
    mapping(bytes32 => Bid[]) public inventoryBids;
    address public registryAddress;

    event InventoryListed(bytes32 indexed inventoryId, bytes32 indexed publisherId, uint256 basePrice, string storageHash);
    event BidSubmitted(bytes32 indexed inventoryId, bytes32 indexed agentId, uint256 bidAmount);

    constructor() Ownable(msg.sender) {}

    function setRegistryAddress(address _registryAddress) external onlyOwner {
        registryAddress = _registryAddress;
    }

    function listInventory(bytes32 inventoryId, bytes32 publisherId, string memory storageHash, uint256 basePrice) external {
        require(inventories[inventoryId].publisherAddr == address(0), "Inventory already listed");
        inventories[inventoryId] = Inventory(publisherId, msg.sender, storageHash, basePrice, true, false);
        emit InventoryListed(inventoryId, publisherId, basePrice, storageHash);
    }

    function submitBid(bytes32 agentId, bytes32 inventoryId, uint256 bidAmount) external nonReentrant {
        Inventory storage inv = inventories[inventoryId];
        require(inv.auctionOpen && bidAmount >= inv.basePrice, "Invalid bid");
        inventoryBids[inventoryId].push(Bid(agentId, msg.sender, bidAmount, block.timestamp, true));
        emit BidSubmitted(inventoryId, agentId, bidAmount);
    }

    function getBidCount(bytes32 inventoryId) external view returns (uint256) {
        return inventoryBids[inventoryId].length;
    }

    // --- SURGICAL ADDITION START ---
    function getStorageHash(bytes32 inventoryId) external view returns (string memory) {
        return inventories[inventoryId].storageHash;
    }
    // --- SURGICAL ADDITION END ---
}