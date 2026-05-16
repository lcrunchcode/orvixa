 Deploy Orvixa to Vercel

 Quick Start

 1. Folder Structure

```
orvixa/
├── vercel.json                    
├── package.json                   
├── .gitignore                     
├── README.md                      
├── SUBMISSION_CHECKLIST.md        
├── PROJECT_INTRO.md               
├── public/
│   ├── orvixa_advertiser_web3.html
│   ├── favicon.oco
│   ├── orvixa_publisher_web3.html     
│   └── index.html
│
│                    (optional: create below)
└── .git/                          (after git init)
```

 2. Create public/index.html (optional — redirects to publisher)

```html
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta http-equiv="refresh" content="0;url=./orvixa_publisher_web3.html">
  <title>Orvixa — Loading...</title>
</head>
<body>
  <p><a href="orvixa_publisher_web3.html">Click here if not redirected</a></p>
</body>
</html>
```

3. Deploy

 Option A: Via Vercel CLI (recommended)

```bash
npm install -g vercel
vercel login
vercel --prod
```

Option B: Via GitHub + Vercel Dashboard

1. Push to GitHub:
```bash
git init
git add .
git commit -m "feat: deploy to Vercel"
git remote add origin https://github.com/YOUR_USERNAME/orvixa.git
git branch -M main
git push -u origin main
```

2. Go to https://vercel.com/new
3. Import your GitHub repo
4. Click "Deploy" — Vercel auto-detects the setup

Option C: Drag & Drop (fastest, but no Git history)

1. Go to https://vercel.com/new
2. Drag the entire `orvixa/` folder to Vercel
3. Auto-deployed in 30 seconds

---

After Deployment

You'll Get

```
✅ Live URL: https://orvixa-XXXXX.vercel.app
✅ SSL/TLS: automatic
✅ CDN: global
✅ Live Deployments: https://vercel.com/dashboard
```

Test It

```bash
 Publisher
https://orvixa-XXXXX.vercel.app/orvixa_publisher_web3.html

 Advertiser
https://orvixa-XXXXX.vercel.app/orvixa_advertiser_web3.html

 Index (optional redirect)
https://orvixa-XXXXX.vercel.app/
```

---

 Important Notes

 What Works Out of the Box

- ethers.js loads from CDN — no bundling needed
- MetaMask inject works on Vercel — HTTPS required ✓ (Vercel auto-enables)
- localStorage works — browsers support it
- Both dashboards are pure client-side — no backend needed

 Common Issues

**Issue:** MetaMask doesn't inject
**Fix:** Vercel is HTTPS by default — this is required. If you're on `http://localhost:8080` (local testing), MetaMask won't inject. Use Vercel URL (HTTPS) or `vercel dev` for local testing with HTTPS.

**Issue:** Can't connect wallet
**Fix:** Make sure you're on an HTTPS URL. MetaMask blocks `http://` (except localhost).

**Issue:** CORS errors fetching from 0G RPC
**Fix:** The 0G RPC (`https://evmrpc.0g.ai`) allows CORS. If you see CORS errors, your browser is likely very old or you're behind a corporate proxy. Upgrade browser.

---

Environment Variables (if needed in future)

Create `.env.local` (not checked into Git):

```
# Vercel will ignore this automatically, but keep it for local dev
NEXT_PUBLIC_REGISTRY_ADDRESS=0x4B785db8De522cc3d7Fb4F191B9368Cc1197B742
NEXT_PUBLIC_AUCTION_ADDRESS=0x108274F7151BA879A03D5b1Fe525745Cf71695fF
NEXT_PUBLIC_SETTLEMENT_ADDRESS=0x555b3d16810Bfbd0Da5dFBFF4E07B576f4EDd3d1
```

Then reference in HTML via `window.location.hash` or expose via a simple `config.js`.

For now, addresses are hardcoded in the HTML files — fine for a hackathon.

---

Custom Domain (optional)

After deployment:

1. Go to Vercel Dashboard → Project Settings → Domains
2. Add your domain (e.g., `orvixa.xyz`)
3. Point DNS records to Vercel
4. Auto-HTTPS certificate issued in minutes

---

Git Deployment (Recommended for HackQuest)

```bash
# Initialize repo
git init
git add .
git commit -m "Initial commit: Orvixa on 0G Chain"
git remote add origin https://github.com/YOUR_USERNAME/orvixa.git
git branch -M main
git push -u origin main

# Connect Vercel to GitHub
# Go to https://vercel.com/new → import this repo
# Auto-redeploys on every git push
```

---

Vercel Dashboard Tips

- Deployments:See live/preview/production
- Analytics:Traffic, response times
- Functions:If you add serverless functions later
- Environment:Manage env vars
- Domains:Connect custom domains
- Settings:Build, deploy, security

---

Rollback (if needed)

On Vercel Dashboard:
1. Deployments tab
2. Click any previous deployment
3. Click "Promote to Production"
4. Instant rollback

---

 Final Checklist Before Submitting

- [ ] Vercel URL works: `https://orvixa-XXXXX.vercel.app/orvixa_publisher_web3.html`
- [ ] MetaMask injects (check console for no errors)
- [ ] Can click "Connect Wallet" — MetaMask pops up
- [ ] Can Register on 0G and see Agent ID in chain bar
- [ ] Both dashboards communicate via localStorage (Publisher writes, Advertiser reads)
- [ ] All TXs show on 0G Explorer (`chainscan.0g.ai`)
- [ ] GitHub repo is public
- [ ] README.md is in the root (judges see it)

---

If You Use Vercel URL for HackQuest

Instead of GitHub Pages, you can submit the live Vercel URL:

```
GitHub Repo: https://github.com/YOUR_USERNAME/orvixa
Live Demo: https://orvixa-XXXXX.vercel.app/orvixa_publisher_web3.html
```

Judges can test it live without running locally. 
