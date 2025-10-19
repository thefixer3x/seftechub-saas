# Project Structure

## Directory Organization

### Core Application
```
app/                    # Next.js App Router
├── globals.css        # Global styles and CSS variables
├── layout.tsx         # Root layout with metadata and theme provider
├── page.tsx           # Homepage with hero and main sections
├── privacy/           # Privacy policy page
├── robots.ts          # SEO robots configuration
└── sitemap.ts         # SEO sitemap generation
```

### Components Architecture
```
components/
├── ui/                # shadcn/ui components (Radix UI primitives)
│   ├── button.tsx     # Button variants with CVA
│   ├── card.tsx       # Card layouts
│   ├── form.tsx       # Form components with react-hook-form
│   └── ...            # Other UI primitives
├── contact-form.tsx   # Developer access form
├── features-section.tsx # Product features showcase
├── navbar.tsx         # Navigation with theme toggle
├── footer.tsx         # Site footer
└── ...                # Other business components
```

### Utilities & Configuration
```
lib/
└── utils.ts           # Utility functions (cn for className merging)

hooks/
├── use-mobile.tsx     # Mobile detection hook
└── use-toast.ts       # Toast notification hook
```

### Static Assets
```
public/
├── placeholder-logo.png
├── placeholder-logo.svg
└── ...                # Other static assets
```

### Configuration Files
```
├── components.json    # shadcn/ui configuration
├── tailwind.config.ts # Tailwind CSS configuration
├── next.config.mjs    # Next.js configuration
├── tsconfig.json      # TypeScript configuration
└── package.json       # Dependencies and scripts
```

## Naming Conventions

### Files & Directories
- **kebab-case** for component files (`contact-form.tsx`)
- **PascalCase** for component names (`ContactForm`)
- **camelCase** for utility functions and hooks
- **lowercase** for app router pages (`page.tsx`)

### Components
- UI components in `components/ui/` follow shadcn/ui patterns
- Business components in `components/` root
- Use `forwardRef` for UI components that need ref forwarding
- Export both component and variants (for buttons, etc.)

### Styling
- Use `cn()` utility for className merging
- Tailwind classes preferred over custom CSS
- CSS variables for theme colors in `globals.css`
- Component variants using `class-variance-authority` (CVA)

## Import Patterns
```typescript
// Absolute imports using @ alias
import { Button } from "@/components/ui/button"
import { cn } from "@/lib/utils"

// Type imports
import type { Metadata } from "next"
import type React from "react"
```

## Architecture Patterns

### Component Structure
- Functional components with TypeScript
- Props interfaces defined inline or exported
- Use `React.forwardRef` for UI components
- Consistent export patterns (`export { Component, componentVariants }`)

### State Management
- React hooks for local state
- Form state with `react-hook-form` and `zod` validation
- Theme state via `next-themes` provider

### API Integration
- API routes in `app/api/` (not present but expected pattern)
- Supabase client for database operations
- Environment-based configuration

## Development Guidelines

### File Organization
- Group related components in subdirectories when needed
- Keep UI components separate from business logic
- Use index files sparingly (prefer explicit imports)
- Place types close to their usage

### Code Style
- TypeScript strict mode enabled
- ESLint configuration follows Next.js standards
- Prettier for consistent formatting
- Use `const` for immutable values, `let` for mutable