#!/bin/bash

# SefTechHub SaaS Landing Page - Netlify Deployment Script
# Flexible deployment with environment handling and auth integration

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
PROJECT_NAME="seftechub-saas"
NETLIFY_SITE_NAME="api-seftechub"
BUILD_DIR="out"

echo -e "${BLUE}🚀 SefTechHub SaaS Landing Page - Netlify Deployment${NC}"
echo "=================================================="

# Check if Netlify CLI is installed
if ! command -v netlify &> /dev/null; then
    echo -e "${RED}❌ Netlify CLI not found. Installing...${NC}"
    npm install -g netlify-cli
fi

# Function to get environment variables
get_env_var() {
    local var_name=$1
    local default_value=$2
    local value=${!var_name:-$default_value}
    echo "$value"
}

# Environment detection
if [ -z "$ENVIRONMENT" ]; then
    echo -e "${YELLOW}⚠️  ENVIRONMENT not set. Defaulting to 'production'${NC}"
    ENVIRONMENT="production"
fi

echo -e "${BLUE}📦 Environment: $ENVIRONMENT${NC}"

# Set environment-specific variables
case $ENVIRONMENT in
    "production")
        SITE_URL="https://api.seftechub.com"
        API_URL="https://api.seftechub.com/api"
        SUPABASE_URL=$(get_env_var "NEXT_PUBLIC_SUPABASE_URL" "")
        SUPABASE_ANON_KEY=$(get_env_var "NEXT_PUBLIC_SUPABASE_ANON_KEY" "")
        ;;
    "staging")
        SITE_URL="https://staging-api-seftechub.netlify.app"
        API_URL="https://staging-api-seftechub.netlify.app/api"
        SUPABASE_URL=$(get_env_var "NEXT_PUBLIC_SUPABASE_URL_STAGING" "$NEXT_PUBLIC_SUPABASE_URL")
        SUPABASE_ANON_KEY=$(get_env_var "NEXT_PUBLIC_SUPABASE_ANON_KEY_STAGING" "$NEXT_PUBLIC_SUPABASE_ANON_KEY")
        ;;
    "preview")
        SITE_URL=""  # Will be set by Netlify
        API_URL=""   # Will be set by Netlify
        SUPABASE_URL=$(get_env_var "NEXT_PUBLIC_SUPABASE_URL_STAGING" "$NEXT_PUBLIC_SUPABASE_URL")
        SUPABASE_ANON_KEY=$(get_env_var "NEXT_PUBLIC_SUPABASE_ANON_KEY_STAGING" "$NEXT_PUBLIC_SUPABASE_ANON_KEY")
        ;;
esac

# Validate required environment variables
validate_env() {
    local required_vars=("SUPABASE_URL" "SUPABASE_ANON_KEY")
    local missing_vars=()
    
    for var in "${required_vars[@]}"; do
        if [ -z "${!var}" ]; then
            missing_vars+=("$var")
        fi
    done
    
    if [ ${#missing_vars[@]} -ne 0 ]; then
        echo -e "${RED}❌ Missing required environment variables:${NC}"
        printf '%s\n' "${missing_vars[@]}"
        echo -e "${YELLOW}💡 Please set these variables in your .env file or environment${NC}"
        exit 1
    fi
}

# Validate environment only for production
if [ "$ENVIRONMENT" = "production" ]; then
    validate_env
fi

echo -e "${BLUE}🔧 Installing dependencies...${NC}"
if command -v bun &> /dev/null; then
    bun install
else
    npm install
fi

echo -e "${BLUE}🏗️  Building application...${NC}"

# Set build environment variables
export NODE_ENV=production
export NEXT_TELEMETRY_DISABLED=1
export NEXT_PUBLIC_SITE_URL="$SITE_URL"
export NEXT_PUBLIC_API_URL="$API_URL"
export NEXT_PUBLIC_SUPABASE_URL="$SUPABASE_URL"
export NEXT_PUBLIC_SUPABASE_ANON_KEY="$SUPABASE_ANON_KEY"
export NEXT_PUBLIC_ENVIRONMENT="$ENVIRONMENT"

# Build the application
if command -v bun &> /dev/null; then
    bun run build
else
    npm run build
fi

# Export static files
if command -v bun &> /dev/null; then
    bun run export
else
    npm run export
fi

echo -e "${GREEN}✅ Build completed successfully${NC}"

# Check if build directory exists
if [ ! -d "$BUILD_DIR" ]; then
    echo -e "${RED}❌ Build directory '$BUILD_DIR' not found${NC}"
    exit 1
fi

# Deployment function
deploy_to_netlify() {
    local deploy_type=$1
    local site_id=$(get_env_var "NETLIFY_SITE_ID" "")
    
    if [ -z "$site_id" ]; then
        echo -e "${YELLOW}⚠️  NETLIFY_SITE_ID not found. Creating new site...${NC}"
        netlify sites:create --name "$NETLIFY_SITE_NAME"
        echo -e "${BLUE}💡 Please set NETLIFY_SITE_ID in your environment and run again${NC}"
        exit 1
    fi
    
    case $deploy_type in
        "production")
            echo -e "${BLUE}🚀 Deploying to production...${NC}"
            netlify deploy --prod --dir="$BUILD_DIR" --site="$site_id"
            ;;
        "preview")
            echo -e "${BLUE}🔍 Creating preview deployment...${NC}"
            netlify deploy --dir="$BUILD_DIR" --site="$site_id"
            ;;
        *)
            echo -e "${RED}❌ Invalid deployment type: $deploy_type${NC}"
            exit 1
            ;;
    esac
}

# Deploy based on environment
case $ENVIRONMENT in
    "production")
        deploy_to_netlify "production"
        echo -e "${GREEN}🎉 Production deployment completed!${NC}"
        echo -e "${BLUE}🌐 Site URL: https://api.seftechub.com${NC}"
        ;;
    "staging"|"preview")
        deploy_to_netlify "preview"
        echo -e "${GREEN}🎉 Preview deployment completed!${NC}"
        ;;
esac

# Post-deployment tasks
echo -e "${BLUE}🔧 Running post-deployment tasks...${NC}"

# Health check
if [ "$ENVIRONMENT" = "production" ]; then
    echo -e "${BLUE}🏥 Running health check...${NC}"
    sleep 10  # Wait for deployment to propagate
    
    if curl -f -s "https://api.seftechub.com" > /dev/null; then
        echo -e "${GREEN}✅ Health check passed${NC}"
    else
        echo -e "${YELLOW}⚠️  Health check failed - site may still be propagating${NC}"
    fi
fi

# Display useful links
echo -e "${GREEN}📋 Deployment Summary${NC}"
echo "===================="
echo -e "Environment: ${BLUE}$ENVIRONMENT${NC}"
echo -e "Build Directory: ${BLUE}$BUILD_DIR${NC}"
if [ "$ENVIRONMENT" = "production" ]; then
    echo -e "Site URL: ${BLUE}https://api.seftechub.com${NC}"
    echo -e "Admin Panel: ${BLUE}https://app.netlify.com/sites/$NETLIFY_SITE_NAME${NC}"
fi

echo -e "${GREEN}🎉 Deployment completed successfully!${NC}"

# Optional: Open site in browser
if [ "$1" = "--open" ] || [ "$1" = "-o" ]; then
    if command -v open &> /dev/null; then
        open "https://api.seftechub.com"
    elif command -v xdg-open &> /dev/null; then
        xdg-open "https://api.seftechub.com"
    fi
fi