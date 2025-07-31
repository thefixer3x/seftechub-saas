#!/bin/bash

# SefTechHub API Landing Page - Comprehensive Deployment Script
# Ready for manual Netlify/Vercel deployment

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Project configuration
PROJECT_NAME="seftechub-saas"
PROJECT_DESCRIPTION="SefTechHub SaaS Landing Page - Enterprise DeFi Infrastructure"

echo -e "${BLUE}🚀 SefTechHub SaaS Landing Page - Deployment Preparation${NC}"
echo "=================================================================="
echo -e "${PURPLE}Project: $PROJECT_NAME${NC}"
echo -e "${PURPLE}Description: $PROJECT_DESCRIPTION${NC}"
echo ""

# Check Node.js version
echo -e "${BLUE}📦 Checking Node.js version...${NC}"
node_version=$(node -v)
echo -e "${GREEN}✅ Node.js version: $node_version${NC}"

# Check if package manager is available
if command -v bun &> /dev/null; then
    PACKAGE_MANAGER="bun"
    echo -e "${GREEN}✅ Using Bun as package manager${NC}"
elif command -v npm &> /dev/null; then
    PACKAGE_MANAGER="npm"
    echo -e "${GREEN}✅ Using NPM as package manager${NC}"
else
    echo -e "${RED}❌ No package manager found${NC}"
    exit 1
fi

echo ""

# Install dependencies
echo -e "${BLUE}📦 Installing dependencies...${NC}"
if [ "$PACKAGE_MANAGER" = "bun" ]; then
    bun install
else
    npm install --legacy-peer-deps
fi
echo -e "${GREEN}✅ Dependencies installed successfully${NC}"
echo ""

# Run type checking
echo -e "${BLUE}🔍 Running TypeScript type checks...${NC}"
if [ "$PACKAGE_MANAGER" = "bun" ]; then
    bunx tsc --noEmit
else
    npx tsc --noEmit
fi
echo -e "${GREEN}✅ TypeScript type checks passed${NC}"
echo ""

# Run linting
echo -e "${BLUE}🧹 Running ESLint...${NC}"
if [ "$PACKAGE_MANAGER" = "bun" ]; then
    bun run lint
else
    npm run lint
fi
echo -e "${GREEN}✅ Linting completed${NC}"
echo ""

# Build the project
echo -e "${BLUE}🏗️  Building project for production...${NC}"
export NODE_ENV=production
export NEXT_TELEMETRY_DISABLED=1
export NEXT_PUBLIC_SITE_URL="https://api.seftechub.com"
export NEXT_PUBLIC_API_URL="https://api.seftechub.com/api"
export NEXT_PUBLIC_ENVIRONMENT="production"

if [ "$PACKAGE_MANAGER" = "bun" ]; then
    bun run build
else
    npm run build
fi
echo -e "${GREEN}✅ Build completed successfully${NC}"
echo ""

# Check build output
if [ -d "out" ]; then
    build_size=$(du -sh out | cut -f1)
    file_count=$(find out -type f | wc -l)
    echo -e "${GREEN}📊 Build statistics:${NC}"
    echo -e "   Build size: ${BLUE}$build_size${NC}"
    echo -e "   Files created: ${BLUE}$file_count${NC}"
    echo ""
else
    echo -e "${RED}❌ Build output directory 'out' not found${NC}"
    exit 1
fi

# Create deployment info file
echo -e "${BLUE}📋 Creating deployment information...${NC}"
cat > out/DEPLOYMENT_INFO.md << EOF
# SefTechHub SaaS Landing Page

## Deployment Information
- **Project**: $PROJECT_NAME
- **Build Date**: $(date)
- **Node Version**: $node_version
- **Package Manager**: $PACKAGE_MANAGER
- **Build Size**: $build_size
- **Files**: $file_count

## Environment Variables Required
\`\`\`
NEXT_PUBLIC_SITE_URL=https://api.seftechub.com
NEXT_PUBLIC_API_URL=https://api.seftechub.com/api
NEXT_PUBLIC_ENVIRONMENT=production
\`\`\`

## Deployment Instructions

### Netlify
1. Drag and drop the 'out' folder to Netlify deploy
2. Or use Netlify CLI: \`netlify deploy --prod --dir=out\`
3. Configure custom domain: api.seftechub.com

### Vercel
1. Use Vercel CLI: \`vercel --prod\`
2. Or import from GitHub and deploy
3. Configure custom domain: api.seftechub.com

## Post-Deployment
- Test all functionality
- Verify custom domain DNS
- Set up monitoring and analytics
- Configure SSL certificates

Built with ❤️ for the SefTechHub ecosystem
EOF

echo -e "${GREEN}✅ Deployment info created${NC}"
echo ""

# Create .env.example
echo -e "${BLUE}⚙️  Creating environment template...${NC}"
cat > .env.example << EOF
# SefTechHub SaaS Landing Page Environment Variables

# Site Configuration
NEXT_PUBLIC_SITE_URL=https://api.seftechub.com
NEXT_PUBLIC_API_URL=https://api.seftechub.com/api
NEXT_PUBLIC_ENVIRONMENT=production

# Supabase Configuration (for full API functionality)
NEXT_PUBLIC_SUPABASE_URL=your-supabase-project-url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-supabase-anon-key
SUPABASE_SERVICE_ROLE_KEY=your-supabase-service-role-key

# Optional: External Service Keys
OPENAI_API_KEY=your-openai-key
ANTHROPIC_API_KEY=your-anthropic-key
STRIPE_SECRET_KEY=your-stripe-key
EOF

echo -e "${GREEN}✅ Environment template created${NC}"
echo ""

# Performance analysis
echo -e "${BLUE}📊 Analyzing build performance...${NC}"
echo -e "${GREEN}Bundle Analysis:${NC}"
if [ -f "out/_next/static/chunks/pages/_app.js" ]; then
    app_size=$(du -h out/_next/static/chunks/pages/_app.js 2>/dev/null | cut -f1 || echo "N/A")
    echo -e "   App bundle: ${BLUE}$app_size${NC}"
fi

# Count static assets
css_files=$(find out/_next/static -name "*.css" 2>/dev/null | wc -l || echo "0")
js_files=$(find out/_next/static -name "*.js" 2>/dev/null | wc -l || echo "0")
echo -e "   CSS files: ${BLUE}$css_files${NC}"
echo -e "   JS files: ${BLUE}$js_files${NC}"
echo ""

# Security check
echo -e "${BLUE}🔒 Running security checks...${NC}"
security_issues=0

# Check for sensitive files
if [ -f "out/.env" ] || [ -f "out/.env.local" ] || [ -f "out/.env.production" ]; then
    echo -e "${RED}⚠️  Environment files found in build output${NC}"
    security_issues=$((security_issues + 1))
fi

# Check for source maps in production
if find out -name "*.map" | grep -q .; then
    echo -e "${YELLOW}⚠️  Source maps found in production build${NC}"
fi

if [ $security_issues -eq 0 ]; then
    echo -e "${GREEN}✅ Security checks passed${NC}"
else
    echo -e "${YELLOW}⚠️  $security_issues security issues found${NC}"
fi
echo ""

# Create deployment checklist
echo -e "${BLUE}📝 Creating deployment checklist...${NC}"
cat > DEPLOYMENT_CHECKLIST.md << EOF
# SefTechHub SaaS Landing Page - Deployment Checklist

## Pre-Deployment ✅
- [x] Dependencies installed
- [x] TypeScript checks passed
- [x] Linting completed
- [x] Production build successful
- [x] Security checks completed

## Deployment Steps
### Option 1: Netlify
- [ ] Create new Netlify site
- [ ] Drag 'out' folder to deploy area
- [ ] Configure custom domain: api.seftechub.com
- [ ] Set up SSL certificate
- [ ] Configure redirects (if needed)

### Option 2: Vercel
- [ ] Import project to Vercel
- [ ] Configure build settings
- [ ] Set environment variables
- [ ] Configure custom domain: api.seftechub.com
- [ ] Deploy to production

## Post-Deployment
- [ ] Test website functionality
- [ ] Verify all pages load correctly
- [ ] Test developer access form
- [ ] Check mobile responsiveness
- [ ] Verify SSL certificate
- [ ] Test page load speed
- [ ] Set up monitoring/analytics

## Environment Variables (Production)
\`\`\`
NEXT_PUBLIC_SITE_URL=https://api.seftechub.com
NEXT_PUBLIC_API_URL=https://api.seftechub.com/api
NEXT_PUBLIC_ENVIRONMENT=production
\`\`\`

## Monitoring
- [ ] Set up Netlify/Vercel analytics
- [ ] Configure error tracking
- [ ] Set up uptime monitoring
- [ ] Monitor Core Web Vitals

## Notes
- Build output is in the 'out' directory
- All assets are optimized for production
- Static export is configured for edge deployment
EOF

echo -e "${GREEN}✅ Deployment checklist created${NC}"
echo ""

# Final summary
echo -e "${GREEN}🎉 DEPLOYMENT PREPARATION COMPLETE!${NC}"
echo "============================================="
echo -e "${BLUE}📁 Deploy Directory:${NC} out/"
echo -e "${BLUE}📊 Build Size:${NC} $build_size"
echo -e "${BLUE}📄 Files Created:${NC} $file_count"
echo ""
echo -e "${YELLOW}📋 Next Steps:${NC}"
echo "1. Review DEPLOYMENT_CHECKLIST.md"
echo "2. Deploy 'out' folder to Netlify or Vercel"
echo "3. Configure custom domain: api.seftechub.com"
echo "4. Set up environment variables if needed"
echo "5. Test deployment thoroughly"
echo ""
echo -e "${GREEN}Ready for manual deployment! 🚀${NC}"

# Optional: Open deployment checklist
if command -v open &> /dev/null; then
    echo -e "${BLUE}📖 Opening deployment checklist...${NC}"
    open DEPLOYMENT_CHECKLIST.md 2>/dev/null || true
fi