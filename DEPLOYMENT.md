# Cocktail API - Railway Deployment Guide

## Overview
This document describes the deployment process for the Cocktail REST API on Railway.app.

**Application**: Cocktail REST API (Adonis.js + PostgreSQL)
**Platform**: Railway.app
**Repository**: https://github.com/cerealmichael/backend-cocktail-api

---

## Prerequisites
- Railway account (https://railway.app)
- Forked repository connected to GitHub
- Railway CLI (optional, for local management)

---

## Deployment Steps

### 1. Create Railway Project

1. Go to https://railway.app/new
2. Click "Deploy from GitHub repo"
3. Select your forked repository: `cerealmichael/backend-cocktail-api`
4. Railway will automatically detect the Node.js application

### 2. Add PostgreSQL Database

1. In your Railway project, click "New Service"
2. Select "Database" > "PostgreSQL"
3. Railway will create a PostgreSQL instance and inject environment variables

### 3. Configure Environment Variables

Go to your web service settings and add these variables:

**Required Variables:**
```bash
# Node.js Configuration
NODE_ENV=production
PORT=3333
HOST=0.0.0.0
TZ=UTC
LOG_LEVEL=info

# Application Key (generate with: node ace generate:key)
APP_KEY=your-generated-app-key-here

# Database (Railway auto-provides these, but you may need to map them)
DB_HOST=${{Postgres.PGHOST}}
DB_PORT=${{Postgres.PGPORT}}
DB_USER=${{Postgres.PGUSER}}
DB_PASSWORD=${{Postgres.PGPASSWORD}}
DB_DATABASE=${{Postgres.PGDATABASE}}

# Storage
DRIVE_DISK=fs

# Domain (auto-set by Railway)
APP_DOMAIN=${{RAILWAY_PUBLIC_DOMAIN}}
```

**How to generate APP_KEY:**
```bash
# Locally with the repository
npm install
node ace generate:key
```

### 4. Deploy Application

1. Railway will automatically deploy on git push
2. Monitor deployment in Railway dashboard
3. Check deployment logs for any errors

### 5. Run Database Migrations

After successful deployment, run migrations via Railway CLI or dashboard:

**Option A: Using Railway CLI**
```bash
# Install Railway CLI
npm install -g @railway/cli

# Login
railway login

# Link to your project
railway link

# Run migrations
railway run node ace migration:run --force
```

**Option B: Using Railway Dashboard**
1. Go to your service > Settings
2. Under "Deploy Triggers" add a deploy command
3. Or use the terminal in Railway dashboard

### 6. Sync Cocktail Data

Run the scraping commands to populate the database:

```bash
# Via Railway CLI
railway run node ace scrape:ingredients
railway run node ace scrape:cocktails

# This will populate your database with cocktails and ingredients
```

### 7. Verify Deployment

1. Get your Railway public URL from the dashboard
2. Test the API endpoints:
   - `GET https://your-app.railway.app/` - Health check
   - `GET https://your-app.railway.app/api/cocktails` - List cocktails
   - Check Swagger docs at `/docs` (if enabled)

---

## Configuration Files Added

### `railway.json`
Railway-specific configuration for build and deployment settings.

### `nixpacks.toml`
Nixpacks configuration for Railway's builder to properly detect and build the Adonis.js application.

### `.env.production`
Template for production environment variables with Railway variable references.

---

## Nice-to-Have Features Implemented

### 1. Automatic Deployment
Railway automatically deploys on every push to the main branch.

**How it works:**
- Push to GitHub → Railway detects changes → Builds → Deploys

### 2. Horizontal Scaling
Railway supports horizontal scaling through replicas.

**To enable:**
1. Go to Service Settings
2. Navigate to "Scaling"
3. Adjust number of replicas

**Note:** Requires Railway Pro plan for multiple replicas.

### 3. Persistent Volume for Images
Railway supports persistent volumes for the images folder.

**To configure:**
1. Service Settings > Volumes
2. Add volume mount: `/app/public/images`
3. Volume size: 1GB (adjustable)

### 4. Cron Jobs for Synchronization
Railway supports cron jobs for periodic cocktail synchronization.

**Option A: Railway Cron Jobs**
1. Create new service > Cron Job
2. Use same repository
3. Set schedule: `0 0 * * *` (daily at midnight)
4. Command: `node ace scrape:cocktails && node ace scrape:ingredients`

**Option B: Internal Scheduler (Future Enhancement)**
- Implement using Adonis.js Task Scheduler
- Add cron job in `start/scheduler.ts`

### 5. Caching (Future Enhancement)
Add Redis for caching frequently accessed cocktails.

**Steps:**
1. Add Redis service in Railway
2. Install Redis client: `npm install ioredis`
3. Configure cache in Adonis.js
4. Cache cocktail queries

---

## Future DevOps Improvements

1. **CI/CD Pipeline Enhancement**
   - Add GitHub Actions for automated testing before deployment
   - Implement staging environment
   - Add code quality checks (linting, type checking)

2. **Monitoring & Logging**
   - Integrate application monitoring (Sentry, LogRocket)
   - Set up uptime monitoring
   - Configure alerts for errors

3. **Performance Optimization**
   - Implement CDN for static assets (Cloudflare)
   - Add database query optimization
   - Enable gzip compression
   - Implement API response caching

4. **Security Hardening**
   - Rate limiting for API endpoints
   - API key authentication
   - CORS configuration optimization
   - Regular dependency updates

5. **Database Management**
   - Automated database backups
   - Database connection pooling optimization
   - Read replicas for scaling

6. **Load Balancing**
   - Configure Railway load balancer for multiple replicas
   - Implement health check endpoints
   - Session management for scaled instances

7. **Documentation**
   - API versioning strategy
   - OpenAPI/Swagger documentation
   - Postman collection

8. **Container Optimization**
   - Reduce Docker image size
   - Multi-stage build optimization
   - Layer caching optimization

---

## Troubleshooting

### Build Fails
- Check build logs in Railway dashboard
- Verify all dependencies in `package.json`
- Ensure Node.js version compatibility (v22)

### Database Connection Issues
- Verify PostgreSQL service is running
- Check environment variables are correctly mapped
- Ensure database credentials are correct

### Migration Errors
- Run migrations with `--force` flag in production
- Check database permissions
- Verify migration files are up to date

### Application Not Starting
- Check PORT is set to Railway's provided port
- Verify HOST is set to `0.0.0.0`
- Check application logs for startup errors

---

## Cost Estimate

**Railway Free Tier:**
- $5 free credit per month
- Suitable for development and small projects

**Railway Pro Plan:**
- $20/month base
- Pay for usage beyond free credits
- Required for production apps with scaling

**Estimated Monthly Cost:**
- Web Service: ~$5-10
- PostgreSQL: ~$5
- Total: ~$10-15/month for small scale

---

## Support & Resources

- Railway Documentation: https://docs.railway.app
- Adonis.js Documentation: https://docs.adonisjs.com
- Project Repository: https://github.com/cerealmichael/backend-cocktail-api
- Original API: https://github.com/Solvro/backend-cocktail-api

---

## Deployment Checklist

- [ ] Fork repository
- [ ] Create Railway project
- [ ] Add PostgreSQL database
- [ ] Configure environment variables
- [ ] Generate and set APP_KEY
- [ ] Deploy application
- [ ] Run database migrations
- [ ] Sync cocktail data
- [ ] Test API endpoints
- [ ] Configure custom domain (if available)
- [ ] Set up automatic deployments
- [ ] Configure persistent volume for images
- [ ] Set up cron jobs for data sync
- [ ] Monitor application performance

---

## Conclusion

This deployment uses Railway.app for simplicity and speed. The platform provides:
- Automatic builds and deployments
- Managed PostgreSQL database
- Easy scaling options
- Built-in monitoring
- Free tier for development

For production use, consider implementing the "Nice-to-Have" features and "Future Improvements" mentioned above.
