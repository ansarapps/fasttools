# 📦 Project Templates - प्रोजेक्ट टेम्प्लेट्स

## 📋 Table of Contents
1. [Frontend Package.json](#frontend-packagejson)
2. [Backend Package.json](#backend-packagejson)
3. [Configuration Files](#configuration-files)
4. [Environment Templates](#environment-templates)
5. [Docker Configuration](#docker-configuration)
6. [Database Schema](#database-schema)

---

## 🎨 Frontend Package.json

**frontend/package.json:**
```json
{
  "name": "online-tools-frontend",
  "version": "1.0.0",
  "description": "Comprehensive online tools website - Frontend",
  "private": true,
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "next lint",
    "lint:fix": "next lint --fix",
    "type-check": "tsc --noEmit",
    "test": "jest",
    "test:watch": "jest --watch",
    "test:coverage": "jest --coverage",
    "analyze": "ANALYZE=true npm run build",
    "storybook": "storybook dev -p 6006",
    "build-storybook": "storybook build"
  },
  "dependencies": {
    "next": "^14.0.0",
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "typescript": "^5.2.0",
    "tailwindcss": "^3.3.0",
    "@tailwindcss/forms": "^0.5.6",
    "@tailwindcss/typography": "^0.5.10",
    "@headlessui/react": "^1.7.17",
    "@heroicons/react": "^2.0.18",
    "framer-motion": "^10.16.4",
    "next-auth": "^4.24.5",
    "@next-auth/prisma-adapter": "^1.0.7",
    "prisma": "^5.6.0",
    "@prisma/client": "^5.6.0",
    "zustand": "^4.4.6",
    "react-hook-form": "^7.47.0",
    "@hookform/resolvers": "^3.3.2",
    "zod": "^3.22.4",
    "react-query": "^3.39.3",
    "axios": "^1.6.0",
    "react-hot-toast": "^2.4.1",
    "react-dropzone": "^14.2.3",
    "pdf-lib": "^1.17.1",
    "jspdf": "^2.5.1",
    "html2canvas": "^1.4.1",
    "sharp": "^0.32.6",
    "next-themes": "^0.2.1",
    "next-seo": "^6.4.0",
    "@vercel/analytics": "^1.1.1",
    "@sentry/nextjs": "^7.77.0",
    "stripe": "^14.5.0",
    "@stripe/stripe-js": "^2.1.11",
    "lucide-react": "^0.292.0",
    "clsx": "^2.0.0",
    "class-variance-authority": "^0.7.0",
    "tailwind-merge": "^2.0.0"
  },
  "devDependencies": {
    "@types/node": "^20.8.7",
    "@types/react": "^18.2.31",
    "@types/react-dom": "^18.2.14",
    "@typescript-eslint/eslint-plugin": "^6.9.0",
    "@typescript-eslint/parser": "^6.9.0",
    "eslint": "^8.52.0",
    "eslint-config-next": "^14.0.0",
    "eslint-config-prettier": "^9.0.0",
    "eslint-plugin-prettier": "^5.0.1",
    "prettier": "^3.0.3",
    "prettier-plugin-tailwindcss": "^0.5.6",
    "autoprefixer": "^10.4.16",
    "postcss": "^8.4.31",
    "@next/bundle-analyzer": "^14.0.0",
    "jest": "^29.7.0",
    "jest-environment-jsdom": "^29.7.0",
    "@testing-library/react": "^13.4.0",
    "@testing-library/jest-dom": "^6.1.4",
    "@testing-library/user-event": "^14.5.1",
    "@storybook/addon-essentials": "^7.5.3",
    "@storybook/addon-interactions": "^7.5.3",
    "@storybook/addon-links": "^7.5.3",
    "@storybook/blocks": "^7.5.3",
    "@storybook/nextjs": "^7.5.3",
    "@storybook/react": "^7.5.3",
    "@storybook/testing-library": "^0.2.2",
    "storybook": "^7.5.3"
  },
  "engines": {
    "node": ">=18.0.0",
    "npm": ">=8.0.0"
  },
  "browserslist": {
    "production": [
      ">0.2%",
      "not dead",
      "not op_mini all"
    ],
    "development": [
      "last 1 chrome version",
      "last 1 firefox version",
      "last 1 safari version"
    ]
  }
}
```

---

## ⚙️ Backend Package.json

**backend/package.json:**
```json
{
  "name": "online-tools-backend",
  "version": "1.0.0",
  "description": "Comprehensive online tools website - Backend API",
  "main": "dist/server.js",
  "scripts": {
    "start": "node dist/server.js",
    "dev": "ts-node-dev --respawn --transpile-only src/server.ts",
    "build": "tsc && npm run copy-assets",
    "copy-assets": "cp -r src/assets dist/ || xcopy src\\assets dist\\assets /E /I",
    "test": "jest",
    "test:watch": "jest --watch",
    "test:coverage": "jest --coverage",
    "lint": "eslint src/**/*.ts",
    "lint:fix": "eslint src/**/*.ts --fix",
    "type-check": "tsc --noEmit",
    "migrate": "prisma migrate deploy",
    "migrate:dev": "prisma migrate dev",
    "generate": "prisma generate",
    "db:seed": "ts-node prisma/seed.ts",
    "db:studio": "prisma studio",
    "db:reset": "prisma migrate reset"
  },
  "dependencies": {
    "express": "^4.18.2",
    "cors": "^2.8.5",
    "helmet": "^7.1.0",
    "morgan": "^1.10.0",
    "compression": "^1.7.4",
    "express-rate-limit": "^7.1.5",
    "express-validator": "^7.0.1",
    "bcryptjs": "^2.4.3",
    "jsonwebtoken": "^9.0.2",
    "passport": "^0.6.0",
    "passport-jwt": "^4.0.1",
    "passport-google-oauth20": "^2.0.0",
    "passport-github2": "^0.1.12",
    "prisma": "^5.6.0",
    "@prisma/client": "^5.6.0",
    "ioredis": "^5.3.2",
    "multer": "^1.4.5-lts.1",
    "sharp": "^0.32.6",
    "pdf-lib": "^1.17.1",
    "pdf2pic": "^3.0.1",
    "node-html-pdf": "^0.3.0",
    "mammoth": "^1.6.0",
    "xlsx": "^0.18.5",
    "csv-parser": "^3.0.0",
    "aws-sdk": "^2.1489.0",
    "cloudinary": "^1.41.0",
    "nodemailer": "^6.9.7",
    "stripe": "^14.5.0",
    "winston": "^3.11.0",
    "winston-daily-rotate-file": "^4.7.1",
    "@sentry/node": "^7.77.0",
    "dotenv": "^16.3.1",
    "joi": "^17.11.0",
    "moment": "^2.29.4",
    "lodash": "^4.17.21",
    "uuid": "^9.0.1",
    "cron": "^3.1.6",
    "socket.io": "^4.7.4"
  },
  "devDependencies": {
    "@types/node": "^20.8.7",
    "@types/express": "^4.17.20",
    "@types/cors": "^2.8.15",
    "@types/morgan": "^1.9.7",
    "@types/compression": "^1.7.4",
    "@types/bcryptjs": "^2.4.5",
    "@types/jsonwebtoken": "^9.0.4",
    "@types/passport": "^1.0.14",
    "@types/passport-jwt": "^3.0.11",
    "@types/passport-google-oauth20": "^2.0.13",
    "@types/multer": "^1.4.9",
    "@types/node-html-pdf": "^0.2.3",
    "@types/nodemailer": "^6.4.13",
    "@types/lodash": "^4.14.200",
    "@types/uuid": "^9.0.6",
    "@types/cron": "^2.0.1",
    "typescript": "^5.2.2",
    "ts-node": "^10.9.1",
    "ts-node-dev": "^2.0.0",
    "@typescript-eslint/eslint-plugin": "^6.9.0",
    "@typescript-eslint/parser": "^6.9.0",
    "eslint": "^8.52.0",
    "eslint-config-prettier": "^9.0.0",
    "eslint-plugin-prettier": "^5.0.1",
    "prettier": "^3.0.3",
    "jest": "^29.7.0",
    "ts-jest": "^29.1.1",
    "@types/jest": "^29.5.6",
    "supertest": "^6.3.3",
    "@types/supertest": "^2.0.15",
    "nodemon": "^3.0.1"
  },
  "engines": {
    "node": ">=18.0.0",
    "npm": ">=8.0.0"
  }
}
```

---

## 📁 Configuration Files

### 1️⃣ TypeScript Configuration

**frontend/tsconfig.json:**
```json
{
  "compilerOptions": {
    "target": "es5",
    "lib": ["dom", "dom.iterable", "es6"],
    "allowJs": true,
    "skipLibCheck": true,
    "strict": true,
    "noEmit": true,
    "esModuleInterop": true,
    "module": "esnext",
    "moduleResolution": "bundler",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "preserve",
    "incremental": true,
    "plugins": [
      {
        "name": "next"
      }
    ],
    "baseUrl": ".",
    "paths": {
      "@/*": ["./src/*"],
      "@/components/*": ["./src/components/*"],
      "@/lib/*": ["./src/lib/*"],
      "@/hooks/*": ["./src/hooks/*"],
      "@/types/*": ["./src/types/*"],
      "@/utils/*": ["./src/utils/*"],
      "@/styles/*": ["./src/styles/*"]
    }
  },
  "include": [
    "next-env.d.ts",
    "**/*.ts",
    "**/*.tsx",
    ".next/types/**/*.ts"
  ],
  "exclude": ["node_modules"]
}
```

**backend/tsconfig.json:**
```json
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "commonjs",
    "lib": ["ES2020"],
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true,
    "declaration": true,
    "declarationMap": true,
    "sourceMap": true,
    "removeComments": true,
    "noImplicitAny": true,
    "noImplicitReturns": true,
    "noFallthroughCasesInSwitch": true,
    "noUncheckedIndexedAccess": true,
    "noImplicitOverride": true,
    "allowUnusedLabels": false,
    "allowUnreachableCode": false,
    "exactOptionalPropertyTypes": true,
    "baseUrl": ".",
    "paths": {
      "@/*": ["./src/*"],
      "@/controllers/*": ["./src/controllers/*"],
      "@/middleware/*": ["./src/middleware/*"],
      "@/models/*": ["./src/models/*"],
      "@/routes/*": ["./src/routes/*"],
      "@/services/*": ["./src/services/*"],
      "@/utils/*": ["./src/utils/*"],
      "@/types/*": ["./src/types/*"]
    }
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist", "**/*.test.ts"]
}
```

### 2️⃣ Tailwind Configuration

**frontend/tailwind.config.js:**
```javascript
/** @type {import('tailwindcss').Config} */
module.exports = {
  darkMode: ['class'],
  content: [
    './pages/**/*.{ts,tsx}',
    './components/**/*.{ts,tsx}',
    './app/**/*.{ts,tsx}',
    './src/**/*.{ts,tsx}',
  ],
  theme: {
    container: {
      center: true,
      padding: '2rem',
      screens: {
        '2xl': '1400px',
      },
    },
    extend: {
      colors: {
        border: 'hsl(var(--border))',
        input: 'hsl(var(--input))',
        ring: 'hsl(var(--ring))',
        background: 'hsl(var(--background))',
        foreground: 'hsl(var(--foreground))',
        primary: {
          DEFAULT: 'hsl(var(--primary))',
          foreground: 'hsl(var(--primary-foreground))',
          50: '#eff6ff',
          100: '#dbeafe',
          200: '#bfdbfe',
          300: '#93c5fd',
          400: '#60a5fa',
          500: '#3b82f6',
          600: '#2563eb',
          700: '#1d4ed8',
          800: '#1e40af',
          900: '#1e3a8a',
        },
        secondary: {
          DEFAULT: 'hsl(var(--secondary))',
          foreground: 'hsl(var(--secondary-foreground))',
        },
        destructive: {
          DEFAULT: 'hsl(var(--destructive))',
          foreground: 'hsl(var(--destructive-foreground))',
        },
        muted: {
          DEFAULT: 'hsl(var(--muted))',
          foreground: 'hsl(var(--muted-foreground))',
        },
        accent: {
          DEFAULT: 'hsl(var(--accent))',
          foreground: 'hsl(var(--accent-foreground))',
        },
        popover: {
          DEFAULT: 'hsl(var(--popover))',
          foreground: 'hsl(var(--popover-foreground))',
        },
        card: {
          DEFAULT: 'hsl(var(--card))',
          foreground: 'hsl(var(--card-foreground))',
        },
      },
      borderRadius: {
        lg: 'var(--radius)',
        md: 'calc(var(--radius) - 2px)',
        sm: 'calc(var(--radius) - 4px)',
      },
      keyframes: {
        'accordion-down': {
          from: { height: 0 },
          to: { height: 'var(--radix-accordion-content-height)' },
        },
        'accordion-up': {
          from: { height: 'var(--radix-accordion-content-height)' },
          to: { height: 0 },
        },
        'fade-in': {
          '0%': { opacity: '0' },
          '100%': { opacity: '1' },
        },
        'slide-in': {
          '0%': { transform: 'translateY(10px)', opacity: '0' },
          '100%': { transform: 'translateY(0)', opacity: '1' },
        },
      },
      animation: {
        'accordion-down': 'accordion-down 0.2s ease-out',
        'accordion-up': 'accordion-up 0.2s ease-out',
        'fade-in': 'fade-in 0.5s ease-out',
        'slide-in': 'slide-in 0.3s ease-out',
      },
      fontFamily: {
        sans: ['Inter', 'system-ui', 'sans-serif'],
        mono: ['JetBrains Mono', 'monospace'],
      },
      spacing: {
        '18': '4.5rem',
        '88': '22rem',
      },
    },
  },
  plugins: [
    require('tailwindcss-animate'),
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography'),
  ],
}
```

### 3️⃣ ESLint Configuration

**frontend/.eslintrc.json:**
```json
{
  "extends": [
    "next/core-web-vitals",
    "@typescript-eslint/recommended",
    "prettier"
  ],
  "parser": "@typescript-eslint/parser",
  "plugins": ["@typescript-eslint"],
  "rules": {
    "@typescript-eslint/no-unused-vars": "error",
    "@typescript-eslint/no-explicit-any": "warn",
    "@typescript-eslint/explicit-function-return-type": "off",
    "@typescript-eslint/explicit-module-boundary-types": "off",
    "@typescript-eslint/no-empty-function": "warn",
    "prefer-const": "error",
    "no-var": "error",
    "no-console": "warn",
    "no-debugger": "error"
  },
  "ignorePatterns": ["dist", "node_modules", ".next"]
}
```

### 4️⃣ Prettier Configuration

**.prettierrc:**
```json
{
  "semi": false,
  "trailingComma": "es5",
  "singleQuote": true,
  "tabWidth": 2,
  "useTabs": false,
  "printWidth": 80,
  "bracketSpacing": true,
  "arrowParens": "avoid",
  "endOfLine": "lf",
  "plugins": ["prettier-plugin-tailwindcss"]
}
```

### 5️⃣ Jest Configuration

**frontend/jest.config.js:**
```javascript
const nextJest = require('next/jest')

const createJestConfig = nextJest({
  // Provide the path to your Next.js app to load next.config.js and .env files
  dir: './',
})

// Add any custom config to be passed to Jest
const customJestConfig = {
  setupFilesAfterEnv: ['<rootDir>/jest.setup.js'],
  moduleNameMapping: {
    // Handle module aliases (this will be automatically configured for you based on your tsconfig.json paths)
    '^@/components/(.*)$': '<rootDir>/components/$1',
    '^@/pages/(.*)$': '<rootDir>/pages/$1',
    '^@/lib/(.*)$': '<rootDir>/lib/$1',
    '^@/hooks/(.*)$': '<rootDir>/hooks/$1',
    '^@/utils/(.*)$': '<rootDir>/utils/$1',
  },
  testEnvironment: 'jest-environment-jsdom',
  collectCoverageFrom: [
    'src/**/*.{js,jsx,ts,tsx}',
    '!src/**/*.d.ts',
    '!src/pages/_app.tsx',
    '!src/pages/_document.tsx',
  ],
  coverageThreshold: {
    global: {
      branches: 70,
      functions: 70,
      lines: 70,
      statements: 70,
    },
  },
}

// createJestConfig is exported this way to ensure that next/jest can load the Next.js config which is async
module.exports = createJestConfig(customJestConfig)
```

---

## 🌍 Environment Templates

### 1️⃣ Frontend Environment

**frontend/.env.local.example:**
```bash
# App Configuration
NEXT_PUBLIC_APP_NAME="Online Tools"
NEXT_PUBLIC_APP_URL=http://localhost:3000
NEXT_PUBLIC_API_URL=http://localhost:3001

# Authentication
NEXTAUTH_URL=http://localhost:3000
NEXTAUTH_SECRET=your-nextauth-secret-key-here

# OAuth Providers
GOOGLE_CLIENT_ID=your-google-client-id
GOOGLE_CLIENT_SECRET=your-google-client-secret
GITHUB_CLIENT_ID=your-github-client-id
GITHUB_CLIENT_SECRET=your-github-client-secret

# Database
DATABASE_URL="postgresql://username:password@localhost:5432/onlinetools?schema=public"

# Analytics
NEXT_PUBLIC_GA_ID=G-XXXXXXXXXX
NEXT_PUBLIC_HOTJAR_ID=your-hotjar-id

# File Storage
NEXT_PUBLIC_CLOUDINARY_CLOUD_NAME=your-cloud-name
CLOUDINARY_API_KEY=your-api-key
CLOUDINARY_API_SECRET=your-api-secret

# Payment
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=pk_test_...
STRIPE_SECRET_KEY=sk_test_...
STRIPE_WEBHOOK_SECRET=whsec_...

# Monitoring
SENTRY_DSN=your-sentry-dsn

# Feature Flags
NEXT_PUBLIC_ENABLE_ANALYTICS=true
NEXT_PUBLIC_ENABLE_PAYMENTS=true
NEXT_PUBLIC_ENABLE_CHAT=false
```

### 2️⃣ Backend Environment

**backend/.env.example:**
```bash
# Server Configuration
PORT=3001
NODE_ENV=development
CORS_ORIGIN=http://localhost:3000

# Database
DATABASE_URL="postgresql://username:password@localhost:5432/onlinetools?schema=public"
REDIS_URL=redis://localhost:6379

# JWT
JWT_SECRET=your-jwt-secret-key-here
JWT_EXPIRES_IN=7d
REFRESH_TOKEN_SECRET=your-refresh-token-secret
REFRESH_TOKEN_EXPIRES_IN=30d

# OAuth
GOOGLE_CLIENT_ID=your-google-client-id
GOOGLE_CLIENT_SECRET=your-google-client-secret
GITHUB_CLIENT_ID=your-github-client-id
GITHUB_CLIENT_SECRET=your-github-client-secret

# File Storage
AWS_ACCESS_KEY_ID=your-aws-access-key
AWS_SECRET_ACCESS_KEY=your-aws-secret-key
AWS_REGION=us-east-1
AWS_S3_BUCKET=your-s3-bucket-name

# Cloudinary (Alternative)
CLOUDINARY_CLOUD_NAME=your-cloud-name
CLOUDINARY_API_KEY=your-api-key
CLOUDINARY_API_SECRET=your-api-secret

# Email Service
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_SECURE=false
SMTP_USER=your-email@gmail.com
SMTP_PASS=your-app-password

# Payment Gateway
STRIPE_SECRET_KEY=sk_test_...
STRIPE_WEBHOOK_SECRET=whsec_...

# Rate Limiting
RATE_LIMIT_WINDOW_MS=900000
RATE_LIMIT_MAX_REQUESTS=100

# File Upload Limits
MAX_FILE_SIZE=10485760
MAX_FILES_PER_REQUEST=5
ALLOWED_FILE_TYPES=pdf,doc,docx,txt,jpg,jpeg,png,gif,webp

# Monitoring
SENTRY_DSN=your-sentry-dsn
LOG_LEVEL=info

# API Keys
OPENAI_API_KEY=your-openai-api-key
GOOGLE_TRANSLATE_API_KEY=your-google-translate-key

# Security
ENCRYPTION_KEY=your-32-character-encryption-key
HASH_SALT_ROUNDS=12

# Feature Flags
ENABLE_RATE_LIMITING=true
ENABLE_FILE_COMPRESSION=true
ENABLE_CACHING=true
ENABLE_LOGGING=true
```

---

## 🐳 Docker Configuration

### 1️⃣ Frontend Dockerfile

**frontend/Dockerfile:**
```dockerfile
# Multi-stage build for Next.js
FROM node:18-alpine AS base

# Install dependencies only when needed
FROM base AS deps
RUN apk add --no-cache libc6-compat
WORKDIR /app

# Install dependencies based on the preferred package manager
COPY package.json yarn.lock* package-lock.json* pnpm-lock.yaml* ./
RUN \
  if [ -f yarn.lock ]; then yarn --frozen-lockfile; \
  elif [ -f package-lock.json ]; then npm ci; \
  elif [ -f pnpm-lock.yaml ]; then yarn global add pnpm && pnpm i --frozen-lockfile; \
  else echo "Lockfile not found." && exit 1; \
  fi

# Rebuild the source code only when needed
FROM base AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .

# Environment variables for build
ARG NEXT_PUBLIC_APP_URL
ARG NEXT_PUBLIC_API_URL
ENV NEXT_PUBLIC_APP_URL=$NEXT_PUBLIC_APP_URL
ENV NEXT_PUBLIC_API_URL=$NEXT_PUBLIC_API_URL

# Build the application
RUN npm run build

# Production image, copy all the files and run next
FROM base AS runner
WORKDIR /app

ENV NODE_ENV production

# Create nextjs user
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

# Copy built application
COPY --from=builder /app/public ./public
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

USER nextjs

EXPOSE 3000

ENV PORT 3000
ENV HOSTNAME "0.0.0.0"

CMD ["node", "server.js"]
```

### 2️⃣ Backend Dockerfile

**backend/Dockerfile:**
```dockerfile
FROM node:18-alpine AS base

# Install dependencies
FROM base AS deps
RUN apk add --no-cache libc6-compat
WORKDIR /app

COPY package*.json ./
COPY prisma ./prisma/

RUN npm ci --only=production
RUN npx prisma generate

# Build the source code
FROM base AS builder
WORKDIR /app

COPY package*.json ./
COPY tsconfig.json ./
COPY prisma ./prisma/
COPY src ./src/

RUN npm ci
RUN npx prisma generate
RUN npm run build

# Production image
FROM base AS runner
WORKDIR /app

ENV NODE_ENV production

# Create app user
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nodejs

# Copy built application
COPY --from=deps /app/node_modules ./node_modules
COPY --from=deps /app/prisma ./prisma
COPY --from=builder /app/dist ./dist
COPY package*.json ./

# Change ownership
RUN chown -R nodejs:nodejs /app
USER nodejs

EXPOSE 3001

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:3001/health || exit 1

CMD ["npm", "start"]
```

### 3️⃣ Docker Compose

**docker-compose.yml:**
```yaml
version: '3.8'

services:
  # PostgreSQL Database
  postgres:
    image: postgres:15-alpine
    container_name: onlinetools_postgres
    environment:
      POSTGRES_DB: onlinetools
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: password123
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./database/init.sql:/docker-entrypoint-initdb.d/init.sql
    networks:
      - onlinetools_network

  # Redis Cache
  redis:
    image: redis:7-alpine
    container_name: onlinetools_redis
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data
    networks:
      - onlinetools_network

  # Backend API
  backend:
    build:
      context: ./backend
      dockerfile: Dockerfile
    container_name: onlinetools_backend
    environment:
      NODE_ENV: development
      PORT: 3001
      DATABASE_URL: postgresql://postgres:password123@postgres:5432/onlinetools
      REDIS_URL: redis://redis:6379
      JWT_SECRET: your-jwt-secret-key
      CORS_ORIGIN: http://localhost:3000
    ports:
      - "3001:3001"
    depends_on:
      - postgres
      - redis
    volumes:
      - ./backend:/app
      - /app/node_modules
    networks:
      - onlinetools_network
    command: npm run dev

  # Frontend
  frontend:
    build:
      context: ./frontend
      dockerfile: Dockerfile
      args:
        NEXT_PUBLIC_APP_URL: http://localhost:3000
        NEXT_PUBLIC_API_URL: http://localhost:3001
    container_name: onlinetools_frontend
    environment:
      NEXT_PUBLIC_APP_URL: http://localhost:3000
      NEXT_PUBLIC_API_URL: http://localhost:3001
      NEXTAUTH_URL: http://localhost:3000
      NEXTAUTH_SECRET: your-nextauth-secret
    ports:
      - "3000:3000"
    depends_on:
      - backend
    volumes:
      - ./frontend:/app
      - /app/node_modules
      - /app/.next
    networks:
      - onlinetools_network
    command: npm run dev

  # Nginx Reverse Proxy
  nginx:
    image: nginx:alpine
    container_name: onlinetools_nginx
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx/nginx.conf:/etc/nginx/nginx.conf
      - ./nginx/ssl:/etc/nginx/ssl
    depends_on:
      - frontend
      - backend
    networks:
      - onlinetools_network

volumes:
  postgres_data:
  redis_data:

networks:
  onlinetools_network:
    driver: bridge
```

---

## 🗄️ Database Schema

### 1️⃣ Prisma Schema

**prisma/schema.prisma:**
```prisma
// This is your Prisma schema file,
// learn more about it in the docs: https://pris.ly/d/prisma-schema

generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

// User Management
model User {
  id            String    @id @default(cuid())
  email         String    @unique
  name          String?
  avatar        String?
  emailVerified DateTime?
  plan          Plan      @default(FREE)
  isActive      Boolean   @default(true)
  lastLoginAt   DateTime?
  createdAt     DateTime  @default(now())
  updatedAt     DateTime  @updatedAt
  
  // Relations
  accounts      Account[]
  sessions      Session[]
  toolUsages    ToolUsage[]
  subscriptions Subscription[]
  apiKeys       ApiKey[]
  
  @@map("users")
}

// NextAuth Account
model Account {
  id                String  @id @default(cuid())
  userId            String
  type              String
  provider          String
  providerAccountId String
  refresh_token     String? @db.Text
  access_token      String? @db.Text
  expires_at        Int?
  token_type        String?
  scope             String?
  id_token          String? @db.Text
  session_state     String?
  
  user User @relation(fields: [userId], references: [id], onDelete: Cascade)
  
  @@unique([provider, providerAccountId])
  @@map("accounts")
}

// NextAuth Session
model Session {
  id           String   @id @default(cuid())
  sessionToken String   @unique
  userId       String
  expires      DateTime
  
  user User @relation(fields: [userId], references: [id], onDelete: Cascade)
  
  @@map("sessions")
}

// NextAuth Verification Token
model VerificationToken {
  identifier String
  token      String   @unique
  expires    DateTime
  
  @@unique([identifier, token])
  @@map("verification_tokens")
}

// Tools Management
model Tool {
  id          String   @id @default(cuid())
  name        String
  slug        String   @unique
  description String
  category    Category
  isPremium   Boolean  @default(false)
  isActive    Boolean  @default(true)
  icon        String?
  tags        String[]
  metadata    Json?
  createdAt   DateTime @default(now())
  updatedAt   DateTime @updatedAt
  
  // Relations
  usages ToolUsage[]
  
  @@map("tools")
}

// Tool Usage Analytics
model ToolUsage {
  id             String   @id @default(cuid())
  userId         String?
  toolId         String
  fileSize       Int?
  processingTime Int?
  ipAddress      String?
  userAgent      String?
  success        Boolean  @default(true)
  errorMessage   String?
  metadata       Json?
  createdAt      DateTime @default(now())
  
  // Relations
  user User? @relation(fields: [userId], references: [id])
  tool Tool  @relation(fields: [toolId], references: [id])
  
  @@map("tool_usages")
}

// Subscription Management
model Subscription {
  id                String             @id @default(cuid())
  userId            String
  stripeCustomerId  String?            @unique
  stripeSubscriptionId String?         @unique
  stripePriceId     String?
  status            SubscriptionStatus @default(INACTIVE)
  currentPeriodStart DateTime?
  currentPeriodEnd   DateTime?
  cancelAtPeriodEnd  Boolean           @default(false)
  createdAt         DateTime          @default(now())
  updatedAt         DateTime          @updatedAt
  
  // Relations
  user User @relation(fields: [userId], references: [id], onDelete: Cascade)
  
  @@map("subscriptions")
}

// API Key Management
model ApiKey {
  id        String   @id @default(cuid())
  userId    String
  name      String
  key       String   @unique
  isActive  Boolean  @default(true)
  lastUsed  DateTime?
  expiresAt DateTime?
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt
  
  // Relations
  user User @relation(fields: [userId], references: [id], onDelete: Cascade)
  
  @@map("api_keys")
}

// File Management
model File {
  id           String     @id @default(cuid())
  originalName String
  filename     String     @unique
  mimetype     String
  size         Int
  path         String
  url          String?
  userId       String?
  status       FileStatus @default(UPLOADED)
  expiresAt    DateTime?
  createdAt    DateTime   @default(now())
  updatedAt    DateTime   @updatedAt
  
  @@map("files")
}

// Blog/Content Management
model Post {
  id          String      @id @default(cuid())
  title       String
  slug        String      @unique
  content     String      @db.Text
  excerpt     String?
  coverImage  String?
  status      PostStatus  @default(DRAFT)
  publishedAt DateTime?
  createdAt   DateTime    @default(now())
  updatedAt   DateTime    @updatedAt
  
  // Relations
  tags        Tag[]
  
  @@map("posts")
}

// Tags for Posts
model Tag {
  id    String @id @default(cuid())
  name  String @unique
  slug  String @unique
  color String @default("#3b82f6")
  
  // Relations
  posts Post[]
  
  @@map("tags")
}

// Contact/Feedback
model Contact {
  id        String        @id @default(cuid())
  name      String
  email     String
  subject   String
  message   String        @db.Text
  status    ContactStatus @default(PENDING)
  createdAt DateTime      @default(now())
  updatedAt DateTime      @updatedAt
  
  @@map("contacts")
}

// Enums
enum Plan {
  FREE
  PRO
  ENTERPRISE
}

enum Category {
  PDF
  IMAGE
  TEXT
  SEO
  DEVELOPER
  CONVERTER
  UTILITY
  DESIGN
}

enum SubscriptionStatus {
  ACTIVE
  INACTIVE
  CANCELED
  PAST_DUE
  UNPAID
}

enum FileStatus {
  UPLOADED
  PROCESSING
  COMPLETED
  FAILED
  DELETED
}

enum PostStatus {
  DRAFT
  PUBLISHED
  ARCHIVED
}

enum ContactStatus {
  PENDING
  REPLIED
  RESOLVED
  SPAM
}
```

### 2️⃣ Database Seed

**prisma/seed.ts:**
```typescript
import { PrismaClient, Category, Plan } from '@prisma/client'
import bcrypt from 'bcryptjs'

const prisma = new PrismaClient()

async function main() {
  console.log('🌱 Starting database seed...')

  // Create admin user
  const adminPassword = await bcrypt.hash('admin123', 12)
  const admin = await prisma.user.upsert({
    where: { email: 'admin@onlinetools.com' },
    update: {},
    create: {
      email: 'admin@onlinetools.com',
      name: 'Admin User',
      plan: Plan.ENTERPRISE,
      emailVerified: new Date(),
    },
  })

  console.log('👤 Created admin user:', admin.email)

  // Create tools
  const tools = [
    {
      name: 'PDF Merger',
      slug: 'pdf-merger',
      description: 'Merge multiple PDF files into one document',
      category: Category.PDF,
      isPremium: false,
      icon: '📄',
      tags: ['pdf', 'merge', 'combine'],
    },
    {
      name: 'Image Compressor',
      slug: 'image-compressor',
      description: 'Compress images to reduce file size',
      category: Category.IMAGE,
      isPremium: false,
      icon: '🖼️',
      tags: ['image', 'compress', 'optimize'],
    },
    {
      name: 'Text Formatter',
      slug: 'text-formatter',
      description: 'Format and beautify text content',
      category: Category.TEXT,
      isPremium: false,
      icon: '📝',
      tags: ['text', 'format', 'beautify'],
    },
    {
      name: 'SEO Analyzer',
      slug: 'seo-analyzer',
      description: 'Analyze website SEO performance',
      category: Category.SEO,
      isPremium: true,
      icon: '📊',
      tags: ['seo', 'analyze', 'website'],
    },
    {
      name: 'JSON Validator',
      slug: 'json-validator',
      description: 'Validate and format JSON data',
      category: Category.DEVELOPER,
      isPremium: false,
      icon: '⚡',
      tags: ['json', 'validate', 'format'],
    },
    {
      name: 'Unit Converter',
      slug: 'unit-converter',
      description: 'Convert between different units',
      category: Category.CONVERTER,
      isPremium: false,
      icon: '🔄',
      tags: ['convert', 'units', 'measurement'],
    },
  ]

  for (const tool of tools) {
    await prisma.tool.upsert({
      where: { slug: tool.slug },
      update: {},
      create: tool,
    })
  }

  console.log('🛠️ Created tools:', tools.length)

  // Create blog tags
  const tags = [
    { name: 'Tutorial', slug: 'tutorial', color: '#3b82f6' },
    { name: 'Tips', slug: 'tips', color: '#10b981' },
    { name: 'News', slug: 'news', color: '#f59e0b' },
    { name: 'Updates', slug: 'updates', color: '#8b5cf6' },
  ]

  for (const tag of tags) {
    await prisma.tag.upsert({
      where: { slug: tag.slug },
      update: {},
      create: tag,
    })
  }

  console.log('🏷️ Created tags:', tags.length)

  // Create sample blog post
  await prisma.post.upsert({
    where: { slug: 'welcome-to-online-tools' },
    update: {},
    create: {
      title: 'Welcome to Online Tools',
      slug: 'welcome-to-online-tools',
      content: `
# Welcome to Online Tools

We're excited to launch our comprehensive online tools platform! Our mission is to provide you with the best tools for your daily tasks.

## What We Offer

- **PDF Tools**: Merge, split, compress PDF files
- **Image Tools**: Compress, resize, convert images
- **Text Tools**: Format, analyze, transform text
- **Developer Tools**: JSON validator, code formatter
- **SEO Tools**: Analyze and optimize your website

## Getting Started

1. Browse our tool categories
2. Select the tool you need
3. Upload your files or input your data
4. Download the results

It's that simple! No registration required for basic tools.

## Premium Features

Upgrade to our Pro plan for:
- Unlimited file uploads
- Batch processing
- Priority support
- Advanced tools

Thank you for choosing Online Tools!
      `,
      excerpt: 'Welcome to our comprehensive online tools platform. Discover powerful tools for PDF, images, text, and more!',
      status: 'PUBLISHED',
      publishedAt: new Date(),
      tags: {
        connect: [{ slug: 'news' }, { slug: 'updates' }],
      },
    },
  })

  console.log('📝 Created sample blog post')

  console.log('✅ Database seed completed!')
}

main()
  .catch((e) => {
    console.error('❌ Seed failed:', e)
    process.exit(1)
  })
  .finally(async () => {
    await prisma.$disconnect()
  })
```

---

## 🎯 Quick Start Commands

### 📦 Installation Commands

```bash
# Clone and setup project
git clone <repository-url> online-tools
cd online-tools

# Setup frontend
cd frontend
npm install
cp .env.local.example .env.local
# Edit .env.local with your values

# Setup backend
cd ../backend
npm install
cp .env.example .env
# Edit .env with your values

# Setup database
npx prisma migrate dev
npx prisma db seed

# Start development servers
# Terminal 1 - Backend
cd backend && npm run dev

# Terminal 2 - Frontend
cd frontend && npm run dev
```

### 🚀 Production Deployment

```bash
# Build and deploy
npm run build
npm run start

# Using Docker
docker-compose up -d

# Using PM2
npm install -g pm2
pm2 start ecosystem.config.js
```

---

## 🎉 Conclusion

ये सभी templates आपको एक professional और scalable online tools website बनाने में मदद करेंगे। हर file को अपनी जरूरतों के अनुसार customize करें और step-by-step implementation करें।

### 📚 Next Steps:
1. **Environment Setup**: सभी environment variables configure करें
2. **Database Setup**: PostgreSQL और Redis setup करें
3. **Authentication**: OAuth providers configure करें
4. **Payment Integration**: Stripe setup करें
5. **Deployment**: Production environment में deploy करें

**Happy Coding! 🚀**