# Technology Stack

## Core Framework
- **Next.js 15** with App Router
- **React 19** with TypeScript
- **Static Export** configured for edge deployment

## Styling & UI
- **Tailwind CSS** with custom configuration
- **shadcn/ui** component library (Radix UI primitives)
- **Framer Motion** for animations
- **Lucide React** for icons
- **next-themes** for dark/light mode

## Backend Integration
- **Supabase** for authentication and database
- **Row-Level Security** (RLS) policies
- **API routes** in Next.js for developer access management

## Development Tools
- **TypeScript** with strict mode
- **ESLint** with Next.js configuration
- **Prettier** for code formatting
- **Geist** font family

## Build Configuration
- **Static export** (`output: 'export'`)
- **Image optimization disabled** for static hosting
- **Trailing slash** configuration
- **Environment-specific builds**

## Common Commands

### Development
```bash
npm run dev          # Start development server
npm run build        # Production build
npm run lint         # Run ESLint
npm run lint:fix     # Fix ESLint issues
npm run type-check   # TypeScript type checking
```

### Deployment
```bash
npm run deploy              # General deployment
npm run deploy:netlify      # Netlify production
npm run deploy:vercel       # Vercel production
npm run deploy:netlify:staging  # Netlify staging
```

### Maintenance
```bash
npm run clean        # Clean build artifacts
npm run format       # Format code with Prettier
npm run format:check # Check code formatting
```

## Package Managers
- Primary: **npm** (with legacy peer deps)
- Alternative: **bun** (faster alternative)
- Lock file: **pnpm-lock.yaml** present

## Environment Variables
- `NEXT_PUBLIC_SITE_URL` - Site URL (https://api.seftechub.com)
- `NEXT_PUBLIC_API_URL` - API endpoint URL
- `NEXT_PUBLIC_ENVIRONMENT` - Environment (production/staging/development)
- Supabase keys for database integration