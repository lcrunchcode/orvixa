// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract VexaSettlement is Ownable, ReentrancyGuard {
    
    enum Status { Open, Released, Refunded }

    struct EscrowRecord {
        bytes32 agentId;
        address payable agentAddr;
        address payable publisherAddr;
        uint256 amount;
        Status status;
        uint256 createdAt;
    }

    mapping(bytes32 => EscrowRecord) public escrows;
    
    // BLUE BUTTON: Stores the most recent Escrow ID for easy copying
    bytes32 public lastEscrowId;

    event EscrowLocked(bytes32 indexed escrowId, bytes32 indexed agentId, uint256 amount);
    event PaymentReleased(bytes32 indexed escrowId, address to, uint256 amount);
    event EscrowCancelled(bytes32 indexed escrowId, address to, uint256 amount);

    constructor() Ownable(msg.sender) {}

    // 1. Lock the money
    function lockEscrow(bytes32 agentId, address payable publisherAddr, bytes32 inventoryId) external payable nonReentrant {
        require(msg.value > 0, "Must send tokens");
        require(publisherAddr != address(0), "Invalid publisher address");

        bytes32 escrowId = keccak256(abi.encodePacked(agentId, inventoryId, block.timestamp));
        require(escrows[escrowId].amount == 0, "Escrow already exists");

        escrows[escrowId] = EscrowRecord({
            agentId: agentId,
            agentAddr: payable(msg.sender),
            publisherAddr: publisherAddr,
            amount: msg.value,
            status: Status.Open,
            createdAt: block.timestamp
        });

        // Updates the blue button for easy copy-paste
        lastEscrowId = escrowId;

        emit EscrowLocked(escrowId, agentId, msg.value);
    }

    // 2. Release payment (Only the Payer/Agent can release)
    function releasePayment(bytes32 escrowId) external nonReentrant {
        EscrowRecord storage escrow = escrows[escrowId];
        
        require(msg.sender == escrow.agentAddr, "Only the agent can release funds");
        require(escrow.status == Status.Open, "Escrow is not in Open state");

        escrow.status = Status.Released;
        uint256 amount = escrow.amount;

        (bool success, ) = escrow.publisherAddr.call{value: amount}("");
        require(success, "Transfer failed");

        emit PaymentReleased(escrowId, escrow.publisherAddr, amount);
    }

    // 3. Refund/Cancel (Only the Payer/Agent can cancel)
    function cancelEscrow(bytes32 escrowId) external nonReentrant {
        EscrowRecord storage escrow = escrows[escrowId];
        
        require(msg.sender == escrow.agentAddr, "Only the agent can cancel");
        require(escrow.status == Status.Open, "Cannot cancel: already settled");

        escrow.status = Status.Refunded;
        uint256 amount = escrow.amount;

        (bool success, ) = escrow.agentAddr.call{value: amount}("");
        require(success, "Refund failed");

        emit EscrowCancelled(escrowId, escrow.agentAddr, amount);
    }

    // 4. BLUE BUTTON: Check the Vault Balance
    function getContractBalance() external view returns (uint256) {
        return address(this).balance;
    }
}