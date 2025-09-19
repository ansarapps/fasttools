# 🚀 Getting Started Guide - ऑनलाइन टूल्स वेबसाइट

## 📋 प्री-रिक्विजिट्स

### 💻 सिस्टम रिक्वायरमेंट्स
```bash
✅ Node.js 18+ (LTS recommended)
✅ npm या yarn पैकेज मैनेजर
✅ Git version control
✅ VS Code (recommended IDE)
✅ PostgreSQL 14+ (डेटाबेस)
```

### 🛠️ रिक्वायर्ड टूल्स इंस्टॉलेशन
```bash
# Node.js और npm चेक करें
node --version
npm --version

# Git चेक करें
git --version

# PostgreSQL इंस्टॉल करें (Windows)
# https://www.postgresql.org/download/windows/
```

---

## 🏗️ प्रोजेक्ट सेटअप - चरण 1

### 1️⃣ Next.js प्रोजेक्ट इनिशियलाइजेशन

```bash
# प्रोजेक्ट डायरेक्टरी में जाएं
cd e:\Devlopement\Tools\onlinetools

# Next.js प्रोजेक्ट बनाएं
npx create-next-app@latest frontend --typescript --tailwind --eslint --app --src-dir --import-alias "@/*"

# प्रोजेक्ट डायरेक्टरी में जाएं
cd frontend

# डेवलपमेंट सर्वर स्टार्ट करें
npm run dev
```

### 2️⃣ अतिरिक्त Dependencies इंस्टॉल करें

```bash
# UI Components और Utilities
npm install @headlessui/react @heroicons/react
npm install framer-motion
npm install zustand
npm install react-hook-form @hookform/resolvers zod
npm install axios swr
npm install next-themes
npm install @radix-ui/react-dropdown-menu @radix-ui/react-dialog
npm install lucide-react
npm install clsx tailwind-merge

# Development Dependencies
npm install -D @types/node
npm install -D prettier prettier-plugin-tailwindcss
npm install -D eslint-config-prettier
```

### 3️⃣ Tailwind CSS कॉन्फ़िगरेशन

**tailwind.config.js अपडेट करें:**
```javascript
/** @type {import('tailwindcss').Config} */
module.exports = {
  darkMode: ['class'],
  content: [
    './src/pages/**/*.{js,ts,jsx,tsx,mdx}',
    './src/components/**/*.{js,ts,jsx,tsx,mdx}',
    './src/app/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      colors: {
        primary: {
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
        gray: {
          50: '#f8fafc',
          100: '#f1f5f9',
          200: '#e2e8f0',
          300: '#cbd5e1',
          400: '#94a3b8',
          500: '#64748b',
          600: '#475569',
          700: '#334155',
          800: '#1e293b',
          900: '#0f172a',
        },
      },
      fontFamily: {
        sans: ['Inter', 'system-ui', 'sans-serif'],
      },
      animation: {
        'fade-in': 'fadeIn 0.5s ease-in-out',
        'slide-up': 'slideUp 0.3s ease-out',
      },
      keyframes: {
        fadeIn: {
          '0%': { opacity: '0' },
          '100%': { opacity: '1' },
        },
        slideUp: {
          '0%': { transform: 'translateY(10px)', opacity: '0' },
          '100%': { transform: 'translateY(0)', opacity: '1' },
        },
      },
    },
  },
  plugins: [],
}
```

---

## 📁 प्रोजेक्ट स्ट्रक्चर सेटअप

### 4️⃣ फोल्डर स्ट्रक्चर बनाएं

```bash
# Frontend structure
mkdir -p src/components/ui
mkdir -p src/components/tools
mkdir -p src/components/layout
mkdir -p src/lib
mkdir -p src/hooks
mkdir -p src/store
mkdir -p src/types
mkdir -p src/utils
mkdir -p public/icons

# Backend structure (अलग फोल्डर में)
cd ..
mkdir backend
cd backend
npm init -y
```

### 5️⃣ बेसिक कॉन्फ़िगरेशन फाइल्स

**src/lib/utils.ts बनाएं:**
```typescript
import { type ClassValue, clsx } from "clsx"
import { twMerge } from "tailwind-merge"

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs))
}

export function formatFileSize(bytes: number): string {
  if (bytes === 0) return '0 Bytes'
  const k = 1024
  const sizes = ['Bytes', 'KB', 'MB', 'GB']
  const i = Math.floor(Math.log(bytes) / Math.log(k))
  return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i]
}

export function downloadFile(blob: Blob, filename: string) {
  const url = URL.createObjectURL(blob)
  const a = document.createElement('a')
  a.href = url
  a.download = filename
  document.body.appendChild(a)
  a.click()
  document.body.removeChild(a)
  URL.revokeObjectURL(url)
}
```

**src/types/index.ts बनाएं:**
```typescript
export interface Tool {
  id: string
  name: string
  description: string
  category: ToolCategory
  icon: string
  path: string
  isPremium?: boolean
  isNew?: boolean
}

export type ToolCategory = 
  | 'pdf'
  | 'text'
  | 'image'
  | 'seo'
  | 'developer'
  | 'converter'
  | 'generator'

export interface User {
  id: string
  email: string
  name: string
  avatar?: string
  plan: 'free' | 'pro' | 'enterprise'
  createdAt: Date
}

export interface ToolUsage {
  toolId: string
  userId?: string
  timestamp: Date
  fileSize?: number
  processingTime?: number
}
```

---

## 🎨 UI Components सेटअप

### 6️⃣ बेसिक UI Components बनाएं

**src/components/ui/button.tsx:**
```typescript
import * as React from "react"
import { cn } from "@/lib/utils"

interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: 'default' | 'destructive' | 'outline' | 'secondary' | 'ghost'
  size?: 'default' | 'sm' | 'lg'
}

const Button = React.forwardRef<HTMLButtonElement, ButtonProps>(
  ({ className, variant = "default", size = "default", ...props }, ref) => {
    return (
      <button
        className={cn(
          "inline-flex items-center justify-center rounded-md text-sm font-medium transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:opacity-50 disabled:pointer-events-none ring-offset-background",
          {
            "bg-primary-600 text-white hover:bg-primary-700": variant === "default",
            "bg-red-600 text-white hover:bg-red-700": variant === "destructive",
            "border border-gray-300 bg-white hover:bg-gray-50": variant === "outline",
            "bg-gray-100 text-gray-900 hover:bg-gray-200": variant === "secondary",
            "hover:bg-gray-100": variant === "ghost",
          },
          {
            "h-10 py-2 px-4": size === "default",
            "h-9 px-3 rounded-md": size === "sm",
            "h-11 px-8 rounded-md": size === "lg",
          },
          className
        )}
        ref={ref}
        {...props}
      />
    )
  }
)
Button.displayName = "Button"

export { Button }
```

**src/components/ui/card.tsx:**
```typescript
import * as React from "react"
import { cn } from "@/lib/utils"

const Card = React.forwardRef<
  HTMLDivElement,
  React.HTMLAttributes<HTMLDivElement>
>(({ className, ...props }, ref) => (
  <div
    ref={ref}
    className={cn(
      "rounded-lg border border-gray-200 bg-white shadow-sm dark:border-gray-800 dark:bg-gray-950",
      className
    )}
    {...props}
  />
))
Card.displayName = "Card"

const CardHeader = React.forwardRef<
  HTMLDivElement,
  React.HTMLAttributes<HTMLDivElement>
>(({ className, ...props }, ref) => (
  <div
    ref={ref}
    className={cn("flex flex-col space-y-1.5 p-6", className)}
    {...props}
  />
))
CardHeader.displayName = "CardHeader"

const CardTitle = React.forwardRef<
  HTMLParagraphElement,
  React.HTMLAttributes<HTMLHeadingElement>
>(({ className, ...props }, ref) => (
  <h3
    ref={ref}
    className={cn(
      "text-2xl font-semibold leading-none tracking-tight",
      className
    )}
    {...props}
  />
))
CardTitle.displayName = "CardTitle"

const CardContent = React.forwardRef<
  HTMLDivElement,
  React.HTMLAttributes<HTMLDivElement>
>(({ className, ...props }, ref) => (
  <div ref={ref} className={cn("p-6 pt-0", className)} {...props} />
))
CardContent.displayName = "CardContent"

export { Card, CardHeader, CardTitle, CardContent }
```

---

## 🏠 होम पेज सेटअप

### 7️⃣ मुख्य लेआउट बनाएं

**src/components/layout/header.tsx:**
```typescript
'use client'

import Link from 'next/link'
import { useState } from 'react'
import { Button } from '@/components/ui/button'
import { Menu, X, Sun, Moon } from 'lucide-react'
import { useTheme } from 'next-themes'

export function Header() {
  const [isMenuOpen, setIsMenuOpen] = useState(false)
  const { theme, setTheme } = useTheme()

  return (
    <header className="sticky top-0 z-50 w-full border-b border-gray-200 bg-white/95 backdrop-blur supports-[backdrop-filter]:bg-white/60 dark:border-gray-800 dark:bg-gray-950/95">
      <div className="container mx-auto flex h-16 items-center justify-between px-4">
        <Link href="/" className="flex items-center space-x-2">
          <div className="h-8 w-8 rounded-lg bg-primary-600 flex items-center justify-center">
            <span className="text-white font-bold text-lg">T</span>
          </div>
          <span className="text-xl font-bold text-gray-900 dark:text-white">
            ToolsHub
          </span>
        </Link>

        {/* Desktop Navigation */}
        <nav className="hidden md:flex items-center space-x-6">
          <Link href="/tools" className="text-gray-600 hover:text-gray-900 dark:text-gray-300 dark:hover:text-white">
            Tools
          </Link>
          <Link href="/categories" className="text-gray-600 hover:text-gray-900 dark:text-gray-300 dark:hover:text-white">
            Categories
          </Link>
          <Link href="/pricing" className="text-gray-600 hover:text-gray-900 dark:text-gray-300 dark:hover:text-white">
            Pricing
          </Link>
          <Link href="/blog" className="text-gray-600 hover:text-gray-900 dark:text-gray-300 dark:hover:text-white">
            Blog
          </Link>
        </nav>

        <div className="flex items-center space-x-4">
          <Button
            variant="ghost"
            size="sm"
            onClick={() => setTheme(theme === 'dark' ? 'light' : 'dark')}
          >
            {theme === 'dark' ? <Sun className="h-4 w-4" /> : <Moon className="h-4 w-4" />}
          </Button>
          
          <div className="hidden md:flex items-center space-x-2">
            <Button variant="ghost" size="sm">
              Login
            </Button>
            <Button size="sm">
              Sign Up
            </Button>
          </div>

          {/* Mobile menu button */}
          <Button
            variant="ghost"
            size="sm"
            className="md:hidden"
            onClick={() => setIsMenuOpen(!isMenuOpen)}
          >
            {isMenuOpen ? <X className="h-4 w-4" /> : <Menu className="h-4 w-4" />}
          </Button>
        </div>
      </div>

      {/* Mobile Navigation */}
      {isMenuOpen && (
        <div className="md:hidden border-t border-gray-200 dark:border-gray-800">
          <nav className="flex flex-col space-y-4 p-4">
            <Link href="/tools" className="text-gray-600 hover:text-gray-900 dark:text-gray-300 dark:hover:text-white">
              Tools
            </Link>
            <Link href="/categories" className="text-gray-600 hover:text-gray-900 dark:text-gray-300 dark:hover:text-white">
              Categories
            </Link>
            <Link href="/pricing" className="text-gray-600 hover:text-gray-900 dark:text-gray-300 dark:hover:text-white">
              Pricing
            </Link>
            <Link href="/blog" className="text-gray-600 hover:text-gray-900 dark:text-gray-300 dark:hover:text-white">
              Blog
            </Link>
            <div className="flex flex-col space-y-2 pt-4 border-t border-gray-200 dark:border-gray-800">
              <Button variant="ghost" size="sm">
                Login
              </Button>
              <Button size="sm">
                Sign Up
              </Button>
            </div>
          </nav>
        </div>
      )}
    </header>
  )
}
```

### 8️⃣ होम पेज अपडेट करें

**src/app/page.tsx:**
```typescript
import Link from 'next/link'
import { Button } from '@/components/ui/button'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { 
  FileText, 
  Image, 
  Search, 
  Code, 
  Zap, 
  Shield,
  Smartphone,
  Globe
} from 'lucide-react'

const features = [
  {
    icon: FileText,
    title: 'PDF Tools',
    description: 'Merge, split, compress, and convert PDF files with ease.'
  },
  {
    icon: Image,
    title: 'Image Editor',
    description: 'Resize, compress, and convert images in various formats.'
  },
  {
    icon: Search,
    title: 'SEO Tools',
    description: 'Optimize your website with our comprehensive SEO toolkit.'
  },
  {
    icon: Code,
    title: 'Developer Tools',
    description: 'Code formatters, generators, and other developer utilities.'
  },
  {
    icon: Zap,
    title: 'Fast Processing',
    description: 'Lightning-fast processing with optimized algorithms.'
  },
  {
    icon: Shield,
    title: 'Secure & Private',
    description: 'Your files are processed securely and deleted after use.'
  },
  {
    icon: Smartphone,
    title: 'Mobile Friendly',
    description: 'Works perfectly on all devices - desktop, tablet, and mobile.'
  },
  {
    icon: Globe,
    title: 'No Installation',
    description: 'Use all tools directly in your browser, no downloads required.'
  }
]

export default function HomePage() {
  return (
    <div className="min-h-screen">
      {/* Hero Section */}
      <section className="relative py-20 px-4 text-center bg-gradient-to-br from-primary-50 to-blue-100 dark:from-gray-900 dark:to-gray-800">
        <div className="container mx-auto max-w-4xl">
          <h1 className="text-4xl md:text-6xl font-bold text-gray-900 dark:text-white mb-6">
            All-in-One
            <span className="text-primary-600"> Online Tools </span>
            Platform
          </h1>
          <p className="text-xl text-gray-600 dark:text-gray-300 mb-8 max-w-2xl mx-auto">
            Transform, convert, and optimize your files with our comprehensive collection 
            of online tools. Fast, secure, and completely free to use.
          </p>
          <div className="flex flex-col sm:flex-row gap-4 justify-center">
            <Button size="lg" className="text-lg px-8 py-3">
              Explore Tools
            </Button>
            <Button variant="outline" size="lg" className="text-lg px-8 py-3">
              View Categories
            </Button>
          </div>
        </div>
      </section>

      {/* Features Grid */}
      <section className="py-20 px-4">
        <div className="container mx-auto max-w-6xl">
          <div className="text-center mb-16">
            <h2 className="text-3xl md:text-4xl font-bold text-gray-900 dark:text-white mb-4">
              Why Choose Our Platform?
            </h2>
            <p className="text-lg text-gray-600 dark:text-gray-300 max-w-2xl mx-auto">
              We provide the most comprehensive and user-friendly online tools 
              to help you accomplish your tasks efficiently.
            </p>
          </div>
          
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
            {features.map((feature, index) => {
              const Icon = feature.icon
              return (
                <Card key={index} className="text-center hover:shadow-lg transition-shadow">
                  <CardHeader>
                    <div className="mx-auto w-12 h-12 bg-primary-100 dark:bg-primary-900 rounded-lg flex items-center justify-center mb-4">
                      <Icon className="w-6 h-6 text-primary-600 dark:text-primary-400" />
                    </div>
                    <CardTitle className="text-lg">{feature.title}</CardTitle>
                  </CardHeader>
                  <CardContent>
                    <p className="text-gray-600 dark:text-gray-300 text-sm">
                      {feature.description}
                    </p>
                  </CardContent>
                </Card>
              )
            })}
          </div>
        </div>
      </section>

      {/* Popular Tools Section */}
      <section className="py-20 px-4 bg-gray-50 dark:bg-gray-900">
        <div className="container mx-auto max-w-6xl">
          <div className="text-center mb-16">
            <h2 className="text-3xl md:text-4xl font-bold text-gray-900 dark:text-white mb-4">
              Popular Tools
            </h2>
            <p className="text-lg text-gray-600 dark:text-gray-300">
              Most used tools by our community
            </p>
          </div>
          
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {/* Tool cards will be added here */}
            <Card className="hover:shadow-lg transition-shadow">
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <FileText className="w-5 h-5 text-primary-600" />
                  PDF Merger
                </CardTitle>
              </CardHeader>
              <CardContent>
                <p className="text-gray-600 dark:text-gray-300 mb-4">
                  Combine multiple PDF files into a single document.
                </p>
                <Button className="w-full">
                  Use Tool
                </Button>
              </CardContent>
            </Card>
            
            {/* Add more tool cards */}
          </div>
        </div>
      </section>

      {/* CTA Section */}
      <section className="py-20 px-4 text-center">
        <div className="container mx-auto max-w-4xl">
          <h2 className="text-3xl md:text-4xl font-bold text-gray-900 dark:text-white mb-4">
            Ready to Get Started?
          </h2>
          <p className="text-lg text-gray-600 dark:text-gray-300 mb-8">
            Join thousands of users who trust our platform for their daily tasks.
          </p>
          <Button size="lg" className="text-lg px-8 py-3">
            Start Using Tools
          </Button>
        </div>
      </section>
    </div>
  )
}
```

---

## 🎨 Theme Provider सेटअप

### 9️⃣ Theme Provider कॉन्फ़िगरेशन

**src/components/theme-provider.tsx:**
```typescript
'use client'

import * as React from 'react'
import { ThemeProvider as NextThemesProvider } from 'next-themes'
import { type ThemeProviderProps } from 'next-themes/dist/types'

export function ThemeProvider({ children, ...props }: ThemeProviderProps) {
  return <NextThemesProvider {...props}>{children}</NextThemesProvider>
}
```

**src/app/layout.tsx अपडेट करें:**
```typescript
import type { Metadata } from 'next'
import { Inter } from 'next/font/google'
import './globals.css'
import { ThemeProvider } from '@/components/theme-provider'
import { Header } from '@/components/layout/header'

const inter = Inter({ subsets: ['latin'] })

export const metadata: Metadata = {
  title: 'ToolsHub - All-in-One Online Tools Platform',
  description: 'Transform, convert, and optimize your files with our comprehensive collection of online tools.',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en" suppressHydrationWarning>
      <body className={inter.className}>
        <ThemeProvider
          attribute="class"
          defaultTheme="system"
          enableSystem
          disableTransitionOnChange
        >
          <Header />
          <main>{children}</main>
        </ThemeProvider>
      </body>
    </html>
  )
}
```

---

## 🚀 डेवलपमेंट सर्वर चलाना

### 🔟 प्रोजेक्ट रन करें

```bash
# Frontend directory में जाएं
cd frontend

# Development server start करें
npm run dev

# Browser में खोलें: http://localhost:3000
```

---

## 📝 अगले कदम

### ✅ चेकलिस्ट - फेज 1 पूरा करने के लिए

- [ ] ✅ Next.js प्रोजेक्ट सेटअप
- [ ] ✅ Tailwind CSS कॉन्फ़िगरेशन
- [ ] ✅ बेसिक UI कंपोनेंट्स
- [ ] ✅ Header और Navigation
- [ ] ✅ होम पेज डिजाइन
- [ ] ✅ Theme Provider सेटअप
- [ ] 🔄 Footer कंपोनेंट बनाना
- [ ] 🔄 Tools लिस्टिंग पेज
- [ ] 🔄 पहला टूल (PDF Merger) बनाना
- [ ] 🔄 रेस्पॉन्सिव डिजाइन टेस्टिंग

### 🎯 अगला फोकस
1. **Footer Component** बनाएं
2. **Tools Listing Page** डेवलप करें
3. **पहला PDF Tool** इम्प्लीमेंट करें
4. **File Upload Component** बनाएं
5. **Progress Indicator** जोड़ें

### 🔧 उपयोगी कमांड्स

```bash
# नई कंपोनेंट बनाने के लिए
touch src/components/ui/[component-name].tsx

# नया पेज बनाने के लिए
mkdir src/app/[page-name]
touch src/app/[page-name]/page.tsx

# Build करने के लिए
npm run build

# Linting के लिए
npm run lint

# Type checking के लिए
npx tsc --noEmit
```

---

## 🎉 बधाई हो!

आपका बेसिक प्रोजेक्ट सेटअप तैयार है! अब आप:

1. **Modern UI** के साथ Next.js प्रोजेक्ट चला सकते हैं
2. **Dark/Light Mode** का उपयोग कर सकते हैं
3. **Responsive Design** देख सकते हैं
4. **Component-based Architecture** का फायदा उठा सकते हैं

**अगला कदम**: पहला टूल बनाना और बैकएंड API सेटअप करना।

---

*यह गाइड आपको प्रोजेक्ट की मजबूत नींव प्रदान करती है। किसी भी समस्या के लिए, कृपया डॉक्यूमेंटेशन देखें या सहायता मांगें।*