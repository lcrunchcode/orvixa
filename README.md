<<<<<<< HEAD
 Orvixa — Autonomous Ad Marketplace on 0G Chain

> Permissionless, verifiable ad auctions where AI agents bid, settle, and release payments on-chain — no intermediaries, no fraud.

---

 What It Is

Orvixa is a decentralised advertising marketplace built on 0G Chain. Publishers list ad inventory as on-chain slots. Advertiser AI agents autonomously discover that inventory, bid in real-time sealed auctions, lock payment in escrow, and release it on delivery — all transparent and verifiable on the 0G Explorer.

Traditional ad networks (Google Ads, DSPs) extract 30–50% fees, hide auction mechanics, and have zero fraud accountability. Orvixa removes the intermediary entirely.

---

 0G Components Used

| Component | How It Is Used |
|---|---|
| 0G Chain (Chain ID 16661) | All core logic — agent registration, auction bids, escrow lock/release — executes on-chain via three deployed smart contracts |
| 0G Storage | Inventory slot metadata (dimensions, placement, category, base price) is hashed and committed to the on-chain auction contract via the `storageHash` field in `listInventory()` |
| Agent ID (via VexaAgentRegistry) | Every advertiser and publisher mints a unique `bytes32` Agent ID on-chain with on-chain reputation score tracked per agent |

 Smart Contracts (0G Mainnet — Chain 16661)

| Contract | Address | Explorer |
|---|---|---|
| VexaAgentRegistry | `0x4B785db8De522cc3d7Fb4F191B9368Cc1197B742` | [View on 0G Chain](https://chainscan.0g.ai/address/0x4b785db8de522cc3d7fb4f191b9368cc1197b742?tab=transaction) |
| VexaAuctionHouse | `0x108274F7151BA879A03D5b1Fe525745Cf71695fF` | [View on 0G Chain](https://chainscan.0g.ai/address/0x108274f7151ba879a03d5b1fe525745cf71695ff) |
| VexaSettlement | `0x555b3d16810Bfbd0Da5dFBFF4E07B576f4EDd3d1` | [View on 0G Chain](https://chainscan.0g.ai/address/0x555b3d16810bfbd0da5dfbff4e07b576f4edd3d1) |

---

 System Architecture

```
┌──────────────────────────────┐      ┌──────────────────────────────┐
│  Advertiser Dashboard        │      │  Publisher Dashboard          │
│  orvixa_advertiser_web3.html │      │  orvixa_publisher_web3.html  │
│                              │      │                              │
│  Advertiser Agent Engine     │      │  Publisher Agent Engine      │
│  ─────────────────────────── │      │  ──────────────────────────  │
│  1. Register Agent ID        │      │  1. Register Agent ID        │
│  2. Read inventoryId from    │◄─────│  2. List inventory on-chain  │
│     localStorage             │  LS  │  3. Write inventoryId to     │
│  3. submitBid()              │      │     localStorage             │
│  4. lockEscrow() + OG value  │      │  4. Poll settlement contract │
└──────────────┬───────────────┘      └──────────────┬───────────────┘
               │ ethers.js v6 + MetaMask              │
               ▼                                      ▼
┌─────────────────────────────────────────────────────────────────────┐
│                      0G CHAIN  (Chain ID 16661)                     │
│                                                                     │
│  VexaAgentRegistry     VexaAuctionHouse        VexaSettlement       │
│  registerAgent()       listInventory()         lockEscrow()         │
│  addressToAgentId()    submitBid()             releasePayment()     │
│  agents[id].rep        getBidCount()           getContractBalance() │
└─────────────────────────────────────────────────────────────────────┘
                               │
                               ▼
                    ┌─────────────────────┐
                    │    0G Storage       │
                    │  storageHash field  │
                    │  committed per slot │
                    └─────────────────────┘
```

 Full Agentic Cycle

```
PUBLISHER TAB                          ADVERTISER TAB
─────────────                          ──────────────
Connect Wallet                         Connect Wallet
    │                                       │
Register Agent ID ─────────────────► Register Agent ID
    │                                       │
listInventory() on 0G Chain                 │ (polling localStorage)
    │                                       │
Write inventoryId → localStorage ────────► Read inventoryId
    │                                       │
Poll settlement every 8s            submitBid(agentId, inventoryId, 0.001OG)
    │                                       │
    │                               lockEscrow() { value: 0.001 OG }
    │
Detect EscrowLocked
    │
releasePayment() → OG to publisher wallet

All steps produce on-chain TXs visible at chainscan.0g.ai
```

---

 Running Locally

 Requirements
- MetaMask browser extension
- OG token for gas (0.01 OG covers the full demo cycle)

 Step 1 — Serve over HTTP (MetaMask blocks file://)

```bash
python3 -m http.server 8080
 then open:
 http://localhost:8080/orvixa_publisher_web3.html   ← open FIRST
 http://localhost:8080/orvixa_advertiser_web3.html  ← open SECOND
```

 Step 2 — Publisher first

1. Click Connect Wallet — MetaMask auto-prompts to add 0G Mainnet (Chain 16661)
2. The Publisher Agent Log panel appears bottom-left
3. Agent auto-runs: Register → List Inventory → Write to localStorage → Poll for escrow
4. Each TX shows a toast with a live Explorer link

 Step 3 — Advertiser second

1. Click Connect Wallet in the Advertiser tab
2. The Advertiser Agent Log panel appears
3. Agent auto-runs: Register → Wait for Publisher inventoryId → Bid → Lock Escrow
4. Publisher detects the locked escrow and auto-releases payment

 Step 4 — Verify on-chain

Every toast links directly to `chainscan.0g.ai/tx/...`. You can also browse:
- Registry transactions: https://chainscan.0g.ai/address/0x4b785db8de522cc3d7fb4f191b9368cc1197b742?tab=transaction
- Auction: https://chainscan.0g.ai/address/0x108274f7151ba879a03d5b1fe525745cf71695ff
- Settlement: https://chainscan.0g.ai/address/0x555b3d16810bfbd0da5dfbff4e07b576f4edd3d1

---

 Judge Testing Checklist

 Publisher Dashboard (`orvixa_publisher_web3.html`)

| Step | What to do | Expected result |
|---|---|---|
| 1 | Click Connect Wallet | MetaMask auto-adds 0G Mainnet |
| 2 | After connect | Chain bar shows Publisher ID, Reputation, Balance |
| 3 | Watch Agent Log | Register TX → List TX → "Waiting for Advertiser" |
| 4 | Manual: Click Register on 0G | Chain bar updates with Publisher ID immediately |
| 5 | Manual: Click  List on 0G Chain | Toast with TX hash appears |

 Advertiser Dashboard (`orvixa_advertiser_web3.html`)

| Step | What to do | Expected result |
|---|---|---|
| 1 | Click Connect Wallet | Same auto-network switch |
| 2 | After connect | Chain bar shows Agent ID, Reputation, Balance |
| 3 | Watch Agent Log | Register → Waiting → Bid TX → Escrow TX |
| 4 | Manual: Click Register on 0G | Chain bar updates to `0x1a3b…f4d2` |
| 5 | Manual: Click Deploy Agent | Shows Agent ID confirmation |

 Console output to show judges

```
Wallet connected: 0x... | Balance: 0.123 OG
Agent UI updated: 0x[bytes32 agentId]
[PUB AGENT] TX sent: 0x1f3a...
[PUB AGENT] Inventory confirmed block 4821033
[ADV AGENT] Got inventoryId: 0x8b2c...
[ADV AGENT] Bid confirmed block 4821041
[ADV AGENT] Escrow locked block 4821049
[PUB AGENT] Payment released! Block 4821057
```

---

 Common Issues

| Issue | Fix |
|---|---|
| MetaMask not found | Install from metamask.io |
| Opened via file:// | Run `python3 -m http.server 8080` |
| Balance shows `—` | 0G RPC can be slow — wait 5s then reload |
| Agent ID shows "Not registered" | Click Register on 0G — agent engine also does this automatically |
| Advertiser stuck on "Waiting for Publisher" | Open Publisher tab first and wait for it to finish Step 2 |
| TX fails: insufficient funds | Need OG token for gas — see docs.0g.ai for bridge |
| `user rejected` in log | Approve the MetaMask prompt |

---

 Track

Track 3: Agentic Economy & Autonomous Applications

Orvixa builds the financial and service layer for autonomous AI-to-AI commerce — specifically micropayment-based ad auction rails with on-chain escrow settlement. The two dashboards demonstrate a complete agentic pipeline where software agents transact with each other on 0G Chain with zero human approval at auction time, directly matching the track's Financial Rails and AI Commerce focus areas.

---

Built for the 0G APAC Hackathon 
=======
# vexa
# vexa
# vexa

