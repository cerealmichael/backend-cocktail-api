# Quick Start - Railway Deployment

## What I've Prepared for You

All configuration files are ready in your repository:
- `railway.json` - Railway deployment config
- `nixpacks.toml` - Build configuration
- `.env.production` - Environment variables template
- `DEPLOYMENT.md` - Full deployment documentation

**Repository**: https://github.com/cerealmichael/backend-cocktail-api

---

## Next Steps (Do These Manually)

### Step 1: Generate APP_KEY
```bash
cd ~/Desktop/backend-cocktail-api
npm install
node ace generate:key
# Copy the generated key - you'll need it for Railway
```

### Step 2: Deploy to Railway

1. Go to https://railway.app/new
2. Click "Deploy from GitHub repo"
3. Select: `cerealmichael/backend-cocktail-api`
4. Wait for initial deployment

### Step 3: Add PostgreSQL Database

1. In Railway project, click "New Service"
2. Select "Database" > "PostgreSQL"
3. Wait for database provisioning

### Step 4: Configure Environment Variables

In Railway service settings, add these variables:

```bash
NODE_ENV=production
PORT=3333
HOST=0.0.0.0
APP_KEY=<paste-your-generated-key>
DRIVE_DISK=fs

# Database (map from Railway PostgreSQL service)
DB_HOST=${{Postgres.PGHOST}}
DB_PORT=${{Postgres.PGPORT}}
DB_USER=${{Postgres.PGUSER}}
DB_PASSWORD=${{Postgres.PGPASSWORD}}
DB_DATABASE=${{Postgres.PGDATABASE}}
```

### Step 5: Redeploy & Run Migrations

After setting environment variables:

1. Redeploy the service (Railway will auto-redeploy)
2. Install Railway CLI:
   ```bash
   npm install -g @railway/cli
   railway login
   railway link
   ```
3. Run migrations:
   ```bash
   railway run node ace migration:run --force
   railway run node ace scrape:ingredients
   railway run node ace scrape:cocktails
   ```

### Step 6: Get Your URL

1. Railway will provide a public URL
2. Test: `https://your-app.railway.app/api/cocktails`

---

## For Your Study Group Documentation

Create a Google Doc with:

1. **What You Did**
   - Forked the cocktail API repository
   - Added Railway deployment configuration
   - Set up PostgreSQL database
   - Configured environment variables
   - Deployed to production
   - Ran migrations and data sync

2. **Technical Details**
   - Platform: Railway.app
   - Stack: Node.js 22 + Adonis.js + PostgreSQL
   - Deployment method: GitHub integration with automatic deploys
   - Database: Railway managed PostgreSQL

3. **Features Implemented**
   - Automatic deployment on git push
   - Production-ready configuration
   - Database migrations
   - Data synchronization scripts

4. **Nice-to-Have Features**
   - Documented horizontal scaling approach
   - Persistent volume configuration for images
   - Cron job strategy for data sync
   - Caching implementation plan

5. **Future Improvements**
   - CI/CD pipeline with automated testing
   - Monitoring and logging integration
   - CDN for static assets
   - Rate limiting and security hardening
   - Database backups automation

6. **Final URL**
   - Your Railway deployment URL

7. **Repository**
   - https://github.com/cerealmichael/backend-cocktail-api

---

## Contact Solvro For

- Custom subdomain at `rekrutacja.solvro.pl` (if you want one instead of Railway's URL)
- Any questions about the requirements

---

## Troubleshooting

If build fails:
- Check Railway logs
- Verify NODE_ENV is set to "production"
- Ensure APP_KEY is set

If database connection fails:
- Verify PostgreSQL service is running
- Check variable mapping is correct
- Ensure variables use Railway's reference syntax: `${{Postgres.VARIABLE}}`

---

## Time Estimate

- Railway setup: 5-10 minutes
- Environment configuration: 5 minutes
- Database setup and migrations: 5 minutes
- Testing: 5 minutes
- **Total: ~20-30 minutes**

Good luck with your application!
