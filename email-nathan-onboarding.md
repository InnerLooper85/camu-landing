**To:** nathan.e.fuller@gmail.com
**Subject:** Welcome to CAMU — Getting Set Up

---

Hey Nathan,

Welcome to the team! Excited to have you on board. CAMU is a suite of manufacturing management tools, and we have three active projects you'll be working across:

- **EstradaBot** — Production scheduling app (Python/Flask). Live at estradabot.biz
- **GembaBot** — Gemba walk mobile app (React Native + Express + PostgreSQL). Live at gembabot.com
- **camu-landing** — Marketing landing page (HTML/CSS + nginx). Live at letscamu.com

I've attached the full onboarding guide which walks through everything in detail — setup steps, deployment, troubleshooting, the works. But here's the short version of what to do first:


**First thing — activate your Claude seat**

I've set you up with a company account (nathan@consultantbot.bar) on our Anthropic team (ConsultantBot). You should have an invite waiting — go ahead and activate that when you get a chance so you have Claude Code access ready to go.


**1. Accounts to set up**

- **GitHub** — I'll send you an org invite to our GitHub (InnerLooper85). Accept that and you'll have access to all three repos.
- **Anthropic / Claude** — Once you've activated your seat (see above), use your company account (nathan@consultantbot.bar) to log into Claude for Claude Code access — it's our recommended dev workflow.
- **Google Cloud** — Reach out to me and I'll get you added to the relevant GCP projects.


**2. Clone the repos**

Once you have GitHub access:

```
git clone https://github.com/InnerLooper85/EstradaBot.git
git clone https://github.com/InnerLooper85/GembaBot.git
git clone https://github.com/InnerLooper85/camu-landing.git
```


**3. Get each project running locally**

The onboarding doc has step-by-step instructions for each project. The quick version:

- **EstradaBot** — Set up a Python venv, install requirements, copy `.env.example` to `.env`, and run `python run_production.py`. You'll need to set a few env vars (details in the doc).
- **GembaBot** — This one needs a Cloud SQL proxy connection. Ask me for the database password. The doc walks through starting the proxy, backend, and mobile app.
- **camu-landing** — Easiest one. Just open `index.html` in your browser. Done.


**4. Claude Code (recommended)**

EstradaBot and GembaBot both have `CLAUDE.md` files that Claude reads automatically. You can use Claude Code via the web at claude.ai, on mobile, or through the CLI. The doc has more detail on this, but it's the fastest way to get productive.


**5. First-day checklist**

The end of the onboarding doc has a checklist to verify everything's working — run through that once you're set up and let me know if anything's off.

One important note: all changes go through pull requests. Never push directly to production branches (`master` for EstradaBot, `main` for GembaBot and camu-landing).

If you hit any snags, just reach out. Happy to hop on a call to work through anything.

Welcome aboard!
Sean
