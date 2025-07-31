# SefTechHub SaaS Landing Page

A comprehensive SaaS landing page for api.seftechub.com showcasing enterprise DeFi infrastructure with integrated developer account management and API key provisioning.

## 🌟 Overview

This landing page serves as the gateway to SefTechHub's enterprise DeFi API platform, featuring:
- **Enterprise DeFi Leadership** messaging and positioning
- **Developer Access Form** with integrated API key management
- **Credit-as-a-Service Integration** showcasing platform capabilities
- **Flexible Deployment** scripts for Netlify and Vercel
- **Authenticated API Management** leveraging SefTechHub's existing infrastructure

## 🏗️ Architecture

### Frontend
- **Next.js 15** with TypeScript and React 19
- **Tailwind CSS** with shadcn/ui components
- **Framer Motion** for animations
- **Static Export** capability for edge deployment

### Backend Integration
- **Supabase** authentication and database
- **API Key Management** integrated with existing SefTechHub infrastructure
- **Row-Level Security** for multi-tenant access control
- **Auto-approval** for free tier API access

### Authentication System
Leverages the existing SefTechHub authentication infrastructure:
- `api_keys` table for API key management
- `usage_tracking` for billing and analytics
- `customer_plans` for tiered access control
- `api_access_requests` for developer onboarding

## 🚀 Features

### 🔑 Developer Access Management
- **Self-service registration** with instant free tier approval
- **Tiered pricing plans** (Free, Basic, Pro, Enterprise)
- **Automatic API key generation** for approved requests
- **Integration type selection** for customized onboarding
- **Admin dashboard** for request management

### 🛡️ Security & Compliance
- **Row-Level Security** (RLS) policies
- **JWT-based authentication** 
- **Rate limiting** per plan tier
- **Audit logging** for all API access
- **SOC 2 Type II** compliance ready

### 📊 Analytics & Monitoring
- **Real-time usage tracking**
- **Billing integration**
- **Developer analytics dashboard**
- **API health monitoring**

## 🛠️ Development Setup

### Prerequisites
- Node.js 20+ or Bun
- Supabase account and project
- Environment variables configured

### Installation
```bash
# Clone the repository
git clone <repository-url>
cd ai-saas-landing-onasis_gateway

# Install dependencies
npm install
# or
bun install

# Copy environment template
cp .env.example .env

# Configure environment variables
# See Environment Configuration section below
```

### Environment Configuration
Create a `.env.local` file with the following variables:

```bash
# Supabase Configuration
NEXT_PUBLIC_SUPABASE_URL=your-supabase-project-url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-supabase-anon-key
SUPABASE_SERVICE_ROLE_KEY=your-supabase-service-role-key

# Site Configuration
NEXT_PUBLIC_SITE_URL=https://api.seftechub.com
NEXT_PUBLIC_API_URL=https://api.seftechub.com/api
NEXT_PUBLIC_ENVIRONMENT=development

# Optional: External Service Keys
OPENAI_API_KEY=your-openai-key
ANTHROPIC_API_KEY=your-anthropic-key
STRIPE_SECRET_KEY=your-stripe-key
```

### Database Setup
Run the migration to set up the API access requests table:

```bash
# Apply the migration to your Supabase project
psql -h your-db-host -U postgres -d postgres -f supabase/migrations/001_api_access_requests.sql
```

Or use the Supabase CLI:
```bash
supabase db push
```

### Development Server
```bash
npm run dev
# or
bun run dev
```

Visit http://localhost:3000 to see the landing page.

## 🚢 Deployment

### Flexible Deployment Scripts
The project includes comprehensive deployment scripts for both Netlify and Vercel with environment-specific configurations.

#### Netlify Deployment

**Quick Deploy:**
```bash
# Production deployment
npm run deploy:netlify

# Staging deployment
npm run deploy:netlify:staging

# Preview deployment
npm run deploy:netlify:preview
```

**Manual Deploy:**
```bash
# Set environment (optional, defaults to production)
export ENVIRONMENT=production

# Run deployment script
./deploy-netlify.sh

# Optional: Open site after deployment
./deploy-netlify.sh --open

# Optional: Run health checks
./deploy-netlify.sh --test
```

**Environment Variables for Netlify:**
```bash
# Required
NETLIFY_SITE_ID=your-netlify-site-id
NEXT_PUBLIC_SUPABASE_URL=your-supabase-url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-supabase-anon-key

# Optional
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key
OPENAI_API_KEY=your-openai-key
STRIPE_SECRET_KEY=your-stripe-key
```

#### Vercel Deployment

**Quick Deploy:**
```bash
# Production deployment
npm run deploy:vercel

# Staging deployment
npm run deploy:vercel:staging

# Preview deployment
npm run deploy:vercel:preview
```

**Manual Deploy:**
```bash
# Set environment (optional, defaults to production)
export ENVIRONMENT=production

# Run deployment script
./deploy-vercel.sh

# Optional: Open site after deployment
./deploy-vercel.sh --open

# Optional: Run smoke tests
./deploy-vercel.sh --test
```

**Environment Variables for Vercel:**
The script automatically configures environment variables in Vercel. Ensure you have:
```bash
# Required
NEXT_PUBLIC_SUPABASE_URL=your-supabase-url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-supabase-anon-key

# Optional
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key
OPENAI_API_KEY=your-openai-key
STRIPE_SECRET_KEY=your-stripe-key
```

### Deployment Features

#### Environment-Specific Configurations
- **Production**: `api.seftechub.com` with production Supabase
- **Staging**: Staging URLs with staging database
- **Preview**: Branch-specific URLs for testing

#### Performance Optimizations
- **Static Export**: Pre-rendered HTML for edge deployment
- **Image Optimization**: Unoptimized images for static hosting
- **CDN Caching**: Optimized cache headers
- **Gzip Compression**: Automatic compression

#### Security Headers
Both deployment scripts configure security headers:
- `X-Frame-Options: DENY`
- `X-Content-Type-Options: nosniff`
- `X-XSS-Protection: 1; mode=block`
- `Referrer-Policy: strict-origin-when-cross-origin`

## 🔧 API Endpoints

### `/api/request-access`
Handles developer API access requests with automatic free tier approval.

**POST Request:**
```json
{
  "name": "Developer Name",
  "email": "developer@company.com",
  "company": "Company Name",
  "useCase": "Description of use case",
  "planType": "free|basic|pro|enterprise",
  "estimatedVolume": "10,000 requests/month",
  "integrationType": ["defi-protocols", "trade-finance"],
  "agreedToTerms": true
}
```

**Response:**
```json
{
  "success": true,
  "message": "Access request approved!",
  "status": "approved|pending",
  "requestId": "uuid"
}
```

**GET Request:**
Query request status by email or request ID:
```
GET /api/request-access?email=developer@company.com
GET /api/request-access?requestId=uuid
```

## 🎨 Customization

### Branding
Update branding elements in:
- `components/navbar.tsx` - Navigation and logo
- `components/footer.tsx` - Footer information
- `app/layout.tsx` - Metadata and SEO
- `components/structured-data.tsx` - Schema markup

### Content
Main content sections:
- `app/page.tsx` - Hero section and layout
- `components/features-section.tsx` - Feature highlights
- `components/use-cases.tsx` - Use case examples
- `components/typing-prompt-input.tsx` - Interactive prompts

### Styling
- `app/globals.css` - Global styles
- `tailwind.config.ts` - Tailwind configuration
- Component-level styling using Tailwind classes

## 📊 Analytics & Monitoring

### Built-in Analytics
- **API request tracking** via `usage_tracking` table
- **User behavior** via `api_access_requests` metadata
- **Performance monitoring** via deployment scripts
- **Health checks** for uptime monitoring

### Integration Points
- **PostHog** for user analytics
- **Sentry** for error tracking
- **Stripe** for billing analytics
- **Supabase** for database analytics

## 🔐 Security Considerations

### Data Protection
- **PII encryption** in database
- **API key hashing** with SHA-256
- **Rate limiting** per user/plan
- **CORS configuration** for API security

### Access Control
- **Row-Level Security** on all tables
- **JWT validation** for authenticated requests
- **Role-based permissions** for admin functions
- **IP whitelisting** support (optional)

### Compliance
- **GDPR/NDPR** data handling
- **SOC 2 Type II** infrastructure
- **Audit logging** for compliance
- **Data retention policies**

## 🤝 Contributing

### Development Workflow
1. Create feature branch
2. Make changes with tests
3. Update documentation
4. Submit pull request
5. Deploy to staging for review

### Code Standards
- **TypeScript** strict mode
- **ESLint** configuration
- **Prettier** formatting
- **Conventional commits**

## 📚 Documentation

### Additional Resources
- [SefTechHub Workspace](../seftechub-workspace/README.md) - Main ecosystem
- [Credit-as-a-Service](../credit-as-a-service-platform/README.md) - Backend platform
- [API Documentation](https://docs.seftechub.com) - API reference
- [Developer Portal](https://developers.seftechub.com) - Developer resources

### Support
- **Email**: api-support@seftechub.com
- **Documentation**: docs.seftechub.com
- **Status Page**: status.seftechub.com
- **Community**: discord.gg/seftechub

## 📄 License

This project is proprietary software owned by SefTechHub. All rights reserved.

---

**Built with ❤️ for the SefTechHub ecosystem**

*Empowering enterprise DeFi through comprehensive API infrastructure*