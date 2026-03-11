# CAMU Developer Onboarding

Welcome to the team. CAMU is a suite of manufacturing management tools. We have three active projects:

| Project | What it is | Tech | Live URL |
|---------|-----------|------|----------|
| **EstradaBot** | Production scheduling app | Python/Flask + Bootstrap + GCS | [estradabot.biz](https://estradabot.biz) |
| **GembaBot** | Gemba walk mobile app | React Native + Express + PostgreSQL | [gembabot.com](https://gembabot.com) |
| **camu-landing** | Marketing landing page | HTML/CSS + nginx | [letscamu.com](https://letscamu.com) |

By the end of this guide, you'll be able to run, modify, and deploy all three.

---

## 1. Prerequisites

### Accounts You Need

| Account | What for | Who to ask |
|---------|----------|------------|
| **GitHub** | Code access — all three repos live under [InnerLooper85](https://github.com/InnerLooper85) | Ask Sean for an org invite |
| **Anthropic** | Claude Code access (Pro or Team plan) | Sign up at [claude.ai](https://claude.ai) |
| **Google Cloud** | Deployment and database access | Ask Sean — different GCP projects per app (see [Deployment](#8-deployment)) |

### Tools to Install

**If using Claude Code (recommended path):**

```bash
# Install Claude Code CLI
npm install -g @anthropic-ai/claude-code

# Authenticate
claude login
```

Claude Code also works in-browser at [claude.ai](https://claude.ai) and on mobile — just link your GitHub account. No local tooling required for that path.

**If using a traditional IDE (or both):**

| Tool | Needed for | Install |
|------|-----------|---------|
| Git | All projects | [git-scm.com](https://git-scm.com) |
| Node.js (LTS) | GembaBot backend + mobile | [nodejs.org](https://nodejs.org) |
| Python 3.11+ | EstradaBot | [python.org](https://www.python.org) |
| gcloud CLI | All deployments | [cloud.google.com/sdk](https://cloud.google.com/sdk/docs/install) |
| Cloud SQL Proxy | GembaBot local dev | [cloud.google.com/sql/docs/postgres/connect-auth-proxy](https://cloud.google.com/sql/docs/postgres/connect-auth-proxy) |
| Docker (optional) | camu-landing local testing | [docker.com](https://www.docker.com) |
| VS Code (recommended) | Code editing | [code.visualstudio.com](https://code.visualstudio.com) |

---

## 2. Repositories

Clone all three:

```bash
git clone https://github.com/InnerLooper85/EstradaBot.git
git clone https://github.com/InnerLooper85/GembaBot.git
git clone https://github.com/InnerLooper85/camu-landing.git
```

### Branch Conventions

| Project | Production | Development | Feature branches | PR target |
|---------|-----------|-------------|-----------------|-----------|
| **EstradaBot** | `master` | `dev` | `feat/<desc>`, `fix/<desc>` | `dev` |
| **GembaBot** | `main` | `dev` | `feat/<desc>`, `fix/<desc>`, `claude/<desc>` | `dev` |
| **camu-landing** | `main` | — | Work directly on feature branches | `main` |

All changes go through pull requests. Never push directly to production branches.

---

## 3. Project Setup — EstradaBot

**Tech:** Python/Flask, Bootstrap, Google Cloud Storage, Cloud Run

```bash
cd EstradaBot

# Create and activate virtual environment
python -m venv venv
source venv/bin/activate        # Linux/Mac
venv\Scripts\activate           # Windows

# Install dependencies
pip install -r requirements.txt

# Set up environment
cp .env.example .env
# Edit .env — set SECRET_KEY, ADMIN_USERNAME, ADMIN_PASSWORD
```

Key `.env` variables:

```
SECRET_KEY=any-random-string
ADMIN_USERNAME=admin
ADMIN_PASSWORD=your-local-password
USERS=TestUser:testpass:planner
```

The `USERS` format is `username:password:role` — comma-separated for multiple users. Valid roles: `admin`, `planner`, `mfgeng`, `customer_service`, `operator`, `guest`.

**Run it:**

```bash
python run_production.py
```

App runs at **http://localhost:5000**

**Verify:** Log in with the admin credentials you set. You should see the scheduler dashboard.

---

## 4. Project Setup — GembaBot

**Tech:** React Native (Expo) + Express + PostgreSQL (Cloud SQL) + Cloud Run

GembaBot requires a Cloud SQL proxy connection for local development.

### Backend

```bash
# Terminal 1 — Start Cloud SQL proxy
cloud-sql-proxy gembabot:us-central1:gembabot-db --port 15432

# Terminal 2 — Start the backend
cd GembaBot/backend
npm install
cp .env.example .env
# Edit .env — set DATABASE_URL and JWT_SECRET (see below)
npm run dev
```

Key `.env` variables:

```
PORT=3000
DATABASE_URL=postgresql://gembabot:<password>@127.0.0.1:15432/gembabot_dev
JWT_SECRET=any-throwaway-secret
JWT_EXPIRES_IN=7d
```

Ask Sean for the `gembabot` database password. The proxy connects to the **dev database** (`gembabot_dev`) — never put production credentials in `.env`.

Backend runs at **http://localhost:3000**

### Mobile

```bash
# Terminal 3 — Start Expo
cd GembaBot/mobile
npm install
npm start
```

Expo will open a dev server. Scan the QR code with Expo Go on your phone, or press `w` for web.

### Seed Data

```bash
cd GembaBot/backend
npm run seed
```

Creates a demo user: **demo@gembabot.com** / **password123**

### Tests

```bash
cd GembaBot/backend
npm test
```

Tests are fully mocked — no database connection needed.

**Verify:** Backend responds at localhost:3000, Expo loads the app, you can log in with the seed user.

---

## 5. Project Setup — camu-landing

**Tech:** Plain HTML + CSS, served by nginx in Docker on Cloud Run

This is the simplest project. No build step, no dependencies.

**Local development:**

```bash
cd camu-landing
# Just open index.html in your browser
```

That's it. Edit the HTML/CSS, refresh the browser.

**Optional — run with Docker (matches production):**

```bash
docker build -t camu-landing .
docker run -p 8080:8080 camu-landing
```

Then visit **http://localhost:8080**. The `/story` route maps to `story.html` via nginx config.

**Verify:** Both pages load (`/` and `/story`), styles render correctly.

---

## 6. Using Claude Code

Claude Code can be used via web browser, mobile app, or CLI. EstradaBot and GembaBot both have a `CLAUDE.md` file that Claude reads automatically on session start.

### Web / Mobile (fastest to get started)

1. Go to [claude.ai](https://claude.ai) and open Claude Code
2. Link your GitHub account when prompted
3. Select the repo you want to work on
4. Claude clones it and reads `CLAUDE.md` automatically

### CLI

```bash
cd EstradaBot   # or GembaBot, or camu-landing
claude
```

Claude detects `CLAUDE.md` and follows project conventions.

### Session Startup

Both EstradaBot and GembaBot have mandatory session startup checks. Claude runs these automatically and reports:

```
SESSION CHECK:
  Branch:          dev
  Local commit:    abc1234 Latest commit message
  Remote:          abc1234 Latest commit message
  Status:          UP TO DATE
  Ready to work:   YES
```

If the branch is behind remote, resolve that before starting new work.

### Common Claude Code Commands

| What you want | What to tell Claude |
|---------------|---------------------|
| Check repo status | *"Run session startup checks"* |
| Start a feature | *"Create a feature branch for [description]"* |
| Understand code | *"Explain how [feature] works"* |
| Make a change | *"Add [feature] to [file]"* |
| Commit and push | *"Commit and push these changes"* |
| Open a PR | *"Create a PR targeting dev"* |
| Review a PR | *"Review PR #[number]"* |

---

## 7. Common Workflows

### Making Changes (any project)

1. **Pull latest:** `git fetch origin && git checkout dev && git pull` (or `main` for camu-landing)
2. **Create a branch:** `git checkout -b feat/my-feature dev`
3. **Make changes** — locally or via Claude Code
4. **Test locally** — run the app, verify your changes work
5. **Commit and push:** `git add <files> && git commit -m "description" && git push -u origin feat/my-feature`
6. **Open a PR** targeting `dev` (or `main` for camu-landing)
7. **Wait for CI** — EstradaBot and GembaBot run tests automatically on PR

### Pull Request Guidelines

- One feature or fix per PR
- Short, descriptive title
- Explain the "why" in the description, not just the "what"
- Wait for CI to pass before requesting review

---

## 8. Deployment

### Overview

| Project | Dev deploy | Prod deploy | GCP Project |
|---------|-----------|-------------|-------------|
| **EstradaBot** | Push to `dev` → auto-deploys | Push to `master` → auto-deploys | `project-20e62326-f8a0-47bc-be6` |
| **GembaBot** | Push to `dev` → auto-deploys | Merge to `main` → auto-deploys | `gembabot` |
| **camu-landing** | N/A | Manual: `./deploy.sh` | `letscamu` |

**GCP accounts:** EstradaBot uses `sean.filipow@gmail.com`. GembaBot uses a separate GCP project (`gembabot`). Ask Sean for access to the appropriate projects.

### EstradaBot Deployment

CI/CD handles both dev and prod via GitHub Actions:
- Push to `dev` → tests run → auto-deploy to `estradabot-dev` Cloud Run service
- Merge to `master` → tests run → auto-deploy to `estradabot` Cloud Run service

**Before merging to master:** You must bump the version badge in `backend/templates/base.html`, update the Update Log in `backend/templates/update_log.html`, and update the version in `CLAUDE.md`. See the project's `CLAUDE.md` for the full versioning protocol.

### GembaBot Deployment

CI/CD handles both dev and prod via GitHub Actions:
- Push to `dev` → tests run → auto-deploy to `gembabot-dev` Cloud Run service
- Merge to `main` → tests run → auto-deploy to production

Only Sean merges to `main`.

### camu-landing Deployment

No CI/CD — deploy manually:

```bash
cd camu-landing
./deploy.sh
```

Requires `gcloud` CLI authenticated to the `letscamu` project.

---

## 9. Gotchas & Troubleshooting

### Windows / MSYS (Git Bash)

- **Port conflicts:** Check for processes blocking ports before starting dev servers. Kill with `taskkill //PID <pid> //F`
- **Bash mangles special characters:** MSYS auto-expands `$` and `/` in strings. When working with bcrypt hashes or JSON containing `$`, use Node.js scripts instead of bash commands
- **`sleep -s` doesn't work** — use `sleep <seconds>` without flags

### EstradaBot

- **USERS env var format:** `username:password:role` with colons — when deploying with `gcloud`, use `--env-vars-file env.yaml` instead of `--set-env-vars` to avoid parsing issues
- **Dev vs prod credentials:** `.env` is local dev only. Production uses `env.yaml` (never committed to git)

### GembaBot

- **Cloud SQL proxy port:** Use `15432` (not `5432`–`5434` which may conflict with local PostgreSQL)
- **Run migrations as `gembabot` user, not `postgres`** — otherwise the app user won't own the tables and you'll hit permission errors
- **`.env` is dev only:** Never put `INSTANCE_CONNECTION_NAME` in `.env` — production config lives in `env.yaml` on Cloud Run
- **DB password changes:** If the password changes, it must be updated in four places — GitHub Secrets, `backend/.env`, `backend/env.yaml`, and both Cloud Run services

### camu-landing

- **No CI/CD:** Changes to `main` don't auto-deploy. You must run `./deploy.sh` manually
- **Uncommitted changes:** Check `git status` before deploying — the deploy script builds from the working directory

---

## 10. Quick Reference

### Local Dev URLs

| Project | URL |
|---------|-----|
| EstradaBot | http://localhost:5000 |
| GembaBot backend | http://localhost:3000 |
| GembaBot mobile | Expo dev server (scan QR) |
| camu-landing | Open `index.html` or http://localhost:8080 (Docker) |

### Production URLs

| Project | URL |
|---------|-----|
| EstradaBot | https://estradabot.biz |
| GembaBot | https://gembabot.com |
| camu-landing | https://letscamu.com |

### Key Commands Cheat Sheet

```bash
# === EstradaBot ===
cd EstradaBot
source venv/bin/activate       # activate venv (Linux/Mac)
python run_production.py       # start dev server
pytest tests/ -v               # run tests

# === GembaBot ===
cloud-sql-proxy gembabot:us-central1:gembabot-db --port 15432  # proxy (separate terminal)
cd GembaBot/backend && npm run dev    # backend
cd GembaBot/mobile && npm start       # mobile (Expo)
cd GembaBot/backend && npm test       # tests
cd GembaBot/backend && npm run seed   # seed demo data

# === camu-landing ===
cd camu-landing
open index.html                       # local dev (or just open in browser)
./deploy.sh                           # deploy to Cloud Run
```

---

## 11. First-Day Checklist

Use this to verify your setup is complete:

- [ ] GitHub: You can access all three repos under [InnerLooper85](https://github.com/InnerLooper85)
- [ ] **EstradaBot:** App runs locally, you can log in
- [ ] **GembaBot:** Cloud SQL proxy connects, backend starts, mobile loads in Expo
- [ ] **camu-landing:** Pages render locally
- [ ] **Git:** You can create a test branch, push it, and delete it in any repo
- [ ] **Claude Code:** (if using) Session startup checks pass on at least one project
- [ ] **GCP:** (if deploying) `gcloud` CLI is authenticated and you can access the relevant projects

Welcome aboard.
