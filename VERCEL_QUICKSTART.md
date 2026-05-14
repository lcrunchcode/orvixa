# Deploy to Vercel — Quick Start

## 5-Minute Deployment

### Step 1 — Download deployment files

From Claude outputs, download:
- `vercel.json`
- `package.json`
- `.gitignore`
- `DEPLOY_VERCEL.md` (full guide with troubleshooting)
- `public_index.html` (rename to `public/index.html`)

### Step 2 — Folder structure

```
orvixa/
├── vercel.json                    ✅ 
├── package.json                   ✅
├── .gitignore                     ✅
├── README.md                      ✅ (copy from outputs)
├── public/
│   ├── index.html                 ✅ (rename public_index.html)
│   ├── orvixa_advertiser_web3.html    ✅
│   └── orvixa_publisher_web3.html     ✅
```

### Step 3 — Push to GitHub

```bash
cd orvixa
git init
git add .
git commit -m "Initial commit: Orvixa deployment"
git remote add origin https://github.com/YOUR_USERNAME/orvixa.git
git branch -M main
git push -u origin main
```

### Step 4 — Deploy to Vercel

**Option A: Via Vercel Dashboard (easiest)**

1. Go to https://vercel.com/new
2. Click "Import Git Repository"
3. Paste your GitHub repo URL
4. Click "Import"
5. Click "Deploy"
6. Wait 30 seconds — done! ✅

**Option B: Via Vercel CLI**

```bash
npm install -g vercel
vercel login
vercel --prod
```

---

## You Get

```
✅ Live URL: https://orvixa-XXXXX.vercel.app
✅ Auto-HTTPS
✅ Global CDN
✅ Auto-redeploy on git push
```

---

## Test It

```
Publisher: https://orvixa-XXXXX.vercel.app/orvixa_publisher_web3.html
Advertiser: https://orvixa-XXXXX.vercel.app/orvixa_advertiser_web3.html
Home: https://orvixa-XXXXX.vercel.app/
```

---

## Use This URL for HackQuest

You can submit the Vercel URL to judges:

```
Live Demo: https://orvixa-XXXXX.vercel.app/orvixa_publisher_web3.html
GitHub: https://github.com/YOUR_USERNAME/orvixa
```

Judges can test it live without running locally.

---

## Troubleshooting

**MetaMask doesn't inject?**
- Make sure you're on HTTPS (Vercel auto-enables)
- Reload the page

**Can't connect to 0G Chain?**
- Check you're on mainnet (Chain 16661)
- Make sure you have OG tokens for gas

**localStorage not working?**
- Try opening the two tabs in the same browser window
- Clear browser cache if stuck

For more help, see `DEPLOY_VERCEL.md` (full guide).
