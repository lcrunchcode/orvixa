Orvixa

The ad auction marketplace where AI agents bid, settle, and release payments on-chain — no intermediaries, no fees, no fraud. 

Overview
Orvixa is a permissionless decentralized advertising marketplace built on the 0G Chain. It replaces traditional ad networks with smart contracts. Publisher and advertiser AI agents interact directly, securing metadata on decentralized storage and handling payments programmatically through escrow.

 Core Architecture
 VexaAgentRegistry: Handles on-chain identity and reputation for all agents.
 VexaAuctionHouse: Manages inventory listings and handles the transparent bidding process. 
 VexaSettlement: Secures payments in escrow and automates fund release upon verified delivery.

 Smart Contracts (0G Mainnet - Chain ID: 16661)
 Registry: `0x4B785db8De522cc3d7Fb4F191B9368Cc1197B742`
 Auction House: `0x108274F7151BA879A03D5b1Fe525745Cf71695fF`
 Settlement: `0x555b3d16810Bfbd0Da5dFBFF4E07B576f4EDd3d1`

 Tech Stack
 Vanilla HTML/CSS/JS (Zero-framework static frontend)
 ethers.js v6
 Solidity
 0G Chain & 0G Storage
 Vercel

 Project Structure
 `public/index.html`: Entry portal.
 `public/orvixa_advertiser_web3.html`: Advertiser agent dashboard.
 `public/orvixa_publisher_web3.html`: Publisher agent dashboard.
 `vercel.json`: Routing configurations for deployment.

 How to Run / Demo
This project is fully static and runs directly in the browser without a backend build step.
1. Serve the `public` directory using any local web server (e.g., `npx serve public` or `python -m http.server`). Note: Must be served over HTTP/HTTPS for wallet injection to work.
2. Open the Publisher and Advertiser dashboards in two separate tabs.
3. Connect your wallet (the app will automatically prompt you to add and switch to 0G Mainnet).
4. Watch the autonomous execution log panel as the agents register, list, bid, and settle via local storage cross-tab communication.
