#!/bin/bash

# SefTechHub SaaS Landing Page - Vercel Deployment Script
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
VERCEL_PROJECT_NAME="seftechub-saas"

echo -e "${BLUE}🚀 SefTechHub SaaS Landing Page - Vercel Deployment${NC}"
echo "=================================================="

# Check if Vercel CLI is installed
if ! command -v vercel &> /dev/null; then
    echo -e "${RED}❌ Vercel CLI not found. Installing...${NC}"
    npm install -g vercel
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
        VERCEL_ENV="production"
        ;;
    "staging")
        SITE_URL="https://staging-api-seftechub.vercel.app"
        API_URL="https://staging-api-seftechub.vercel.app/api"
        VERCEL_ENV="preview"
        ;;
    "preview")
        SITE_URL=""  # Will be set by Vercel
        API_URL=""   # Will be set by Vercel
        VERCEL_ENV="preview"
        ;;
esac

# Get Supabase credentials
SUPABASE_URL=$(get_env_var "NEXT_PUBLIC_SUPABASE_URL" "")
SUPABASE_ANON_KEY=$(get_env_var "NEXT_PUBLIC_SUPABASE_ANON_KEY" "")
SUPABASE_SERVICE_ROLE_KEY=$(get_env_var "SUPABASE_SERVICE_ROLE_KEY" "")

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

# Set environment variables for Vercel
set_vercel_env() {
    local env_name=$1
    local env_value=$2
    local env_target=$3
    
    if [ -n "$env_value" ]; then
        echo -e "${BLUE}🔧 Setting $env_name for $env_target...${NC}"
        vercel env add "$env_name" "$env_target" <<< "$env_value" > /dev/null 2>&1 || echo -e "${YELLOW}⚠️  Environment variable $env_name might already exist${NC}"
    fi
}

# Configure Vercel environment variables
configure_vercel_env() {
    local target=$1
    
    echo -e "${BLUE}🔧 Configuring Vercel environment variables for $target...${NC}"
    
    # Core environment variables
    set_vercel_env "NODE_ENV" "production" "$target"
    set_vercel_env "NEXT_TELEMETRY_DISABLED" "1" "$target"
    set_vercel_env "NEXT_PUBLIC_ENVIRONMENT" "$ENVIRONMENT" "$target"
    
    # Site URLs
    if [ -n "$SITE_URL" ]; then
        set_vercel_env "NEXT_PUBLIC_SITE_URL" "$SITE_URL" "$target"
        set_vercel_env "NEXT_PUBLIC_API_URL" "$API_URL" "$target"
    fi
    
    # Supabase configuration
    set_vercel_env "NEXT_PUBLIC_SUPABASE_URL" "$SUPABASE_URL" "$target"
    set_vercel_env "NEXT_PUBLIC_SUPABASE_ANON_KEY" "$SUPABASE_ANON_KEY" "$target"
    set_vercel_env "SUPABASE_SERVICE_ROLE_KEY" "$SUPABASE_SERVICE_ROLE_KEY" "$target"
    
    # API Keys and Services
    local openai_key=$(get_env_var "OPENAI_API_KEY" "")
    local anthropic_key=$(get_env_var "ANTHROPIC_API_KEY" "")
    local stripe_key=$(get_env_var "STRIPE_SECRET_KEY" "")
    
    set_vercel_env "OPENAI_API_KEY" "$openai_key" "$target"
    set_vercel_env "ANTHROPIC_API_KEY" "$anthropic_key" "$target"
    set_vercel_env "STRIPE_SECRET_KEY" "$stripe_key" "$target"
}

# Login to Vercel if not already logged in
if ! vercel whoami &> /dev/null; then
    echo -e "${BLUE}🔑 Logging into Vercel...${NC}"
    vercel login
fi

# Link project if not already linked
if [ ! -f ".vercel/project.json" ]; then
    echo -e "${BLUE}🔗 Linking Vercel project...${NC}"
    vercel link --yes
fi

# Configure environment variables based on deployment type
case $ENVIRONMENT in
    "production")
        configure_vercel_env "production"
        echo -e "${BLUE}🚀 Deploying to production...${NC}"
        vercel --prod --yes
        ;;
    "staging")
        configure_vercel_env "preview"
        echo -e "${BLUE}🔍 Creating staging deployment...${NC}"
        vercel --yes
        ;;
    "preview")
        configure_vercel_env "preview"
        echo -e "${BLUE}🔍 Creating preview deployment...${NC}"
        vercel --yes
        ;;
esac

# Get deployment URL
DEPLOYMENT_URL=$(vercel ls --scope=$(vercel whoami) | grep "$VERCEL_PROJECT_NAME" | head -1 | awk '{print $2}')

echo -e "${GREEN}✅ Deployment completed successfully${NC}"

# Post-deployment tasks
echo -e "${BLUE}🔧 Running post-deployment tasks...${NC}"

# Health check for production
if [ "$ENVIRONMENT" = "production" ] && [ -n "$SITE_URL" ]; then
    echo -e "${BLUE}🏥 Running health check...${NC}"
    sleep 15  # Wait for deployment to propagate
    
    if curl -f -s "$SITE_URL" > /dev/null; then
        echo -e "${GREEN}✅ Health check passed${NC}"
    else
        echo -e "${YELLOW}⚠️  Health check failed - site may still be propagating${NC}"
    fi
fi

# Configure custom domain for production
if [ "$ENVIRONMENT" = "production" ]; then
    echo -e "${BLUE}🌐 Configuring custom domain...${NC}"
    vercel domains add api.seftechub.com --yes 2>/dev/null || echo -e "${YELLOW}⚠️  Domain may already be configured${NC}"
fi

# Display deployment information
echo -e "${GREEN}📋 Deployment Summary${NC}"
echo "===================="
echo -e "Environment: ${BLUE}$ENVIRONMENT${NC}"
echo -e "Project: ${BLUE}$VERCEL_PROJECT_NAME${NC}"

if [ "$ENVIRONMENT" = "production" ]; then
    echo -e "Production URL: ${BLUE}https://api.seftechub.com${NC}"
    echo -e "Vercel Dashboard: ${BLUE}https://vercel.com/dashboard${NC}"
elif [ -n "$DEPLOYMENT_URL" ]; then
    echo -e "Preview URL: ${BLUE}https://$DEPLOYMENT_URL${NC}"
fi

# Display useful commands
echo -e "${BLUE}📝 Useful Commands:${NC}"
echo "  vercel logs         - View deployment logs"
echo "  vercel env ls       - List environment variables"
echo "  vercel domains ls   - List configured domains"
echo "  vercel --help       - View all commands"

echo -e "${GREEN}🎉 Deployment completed successfully!${NC}"

# Optional: Open site in browser
if [ "$1" = "--open" ] || [ "$1" = "-o" ]; then
    local url_to_open
    if [ "$ENVIRONMENT" = "production" ]; then
        url_to_open="https://api.seftechub.com"
    elif [ -n "$DEPLOYMENT_URL" ]; then
        url_to_open="https://$DEPLOYMENT_URL"
    fi
    
    if [ -n "$url_to_open" ]; then
        if command -v open &> /dev/null; then
            open "$url_to_open"
        elif command -v xdg-open &> /dev/null; then
            xdg-open "$url_to_open"
        fi
    fi
fi

# Optional: Run smoke tests
if [ "$1" = "--test" ] || [ "$2" = "--test" ]; then
    echo -e "${BLUE}🧪 Running smoke tests...${NC}"
    
    local test_url
    if [ "$ENVIRONMENT" = "production" ]; then
        test_url="https://api.seftechub.com"
    elif [ -n "$DEPLOYMENT_URL" ]; then
        test_url="https://$DEPLOYMENT_URL"
    fi
    
    if [ -n "$test_url" ]; then
        # Test main page
        if curl -f -s "$test_url" > /dev/null; then
            echo -e "${GREEN}✅ Main page test passed${NC}"
        else
            echo -e "${RED}❌ Main page test failed${NC}"
        fi
        
        # Test API health endpoint
        if curl -f -s "$test_url/api/health" > /dev/null 2>&1; then
            echo -e "${GREEN}✅ API health test passed${NC}"
        else
            echo -e "${YELLOW}⚠️  API health test failed (endpoint may not exist yet)${NC}"
        fi
    fi
fi