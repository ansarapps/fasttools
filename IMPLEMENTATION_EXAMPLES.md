# 🛠️ Implementation Examples - प्रैक्टिकल कोड उदाहरण

## 📋 Table of Contents
1. [बेसिक टूल Implementation](#basic-tool-implementation)
2. [File Upload System](#file-upload-system)
3. [State Management](#state-management)
4. [API Integration](#api-integration)
5. [Error Handling](#error-handling)
6. [Performance Optimization](#performance-optimization)

---

## 🔧 Basic Tool Implementation

### 📄 PDF Merger Tool Example

**src/app/tools/pdf-merger/page.tsx:**
```typescript
'use client'

import { useState, useCallback } from 'react'
import { Button } from '@/components/ui/button'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { FileUpload } from '@/components/ui/file-upload'
import { Progress } from '@/components/ui/progress'
import { Alert, AlertDescription } from '@/components/ui/alert'
import { Download, FileText, X, ArrowUp, ArrowDown } from 'lucide-react'
import { downloadFile } from '@/lib/utils'

interface UploadedFile {
  id: string
  file: File
  preview: string
}

export default function PDFMergerPage() {
  const [files, setFiles] = useState<UploadedFile[]>([])
  const [isProcessing, setIsProcessing] = useState(false)
  const [progress, setProgress] = useState(0)
  const [error, setError] = useState<string | null>(null)
  const [mergedFileUrl, setMergedFileUrl] = useState<string | null>(null)

  const handleFileUpload = useCallback((uploadedFiles: File[]) => {
    const newFiles: UploadedFile[] = uploadedFiles.map(file => ({
      id: Math.random().toString(36).substr(2, 9),
      file,
      preview: URL.createObjectURL(file)
    }))
    setFiles(prev => [...prev, ...newFiles])
    setError(null)
  }, [])

  const removeFile = useCallback((id: string) => {
    setFiles(prev => {
      const file = prev.find(f => f.id === id)
      if (file) {
        URL.revokeObjectURL(file.preview)
      }
      return prev.filter(f => f.id !== id)
    })
  }, [])

  const moveFile = useCallback((id: string, direction: 'up' | 'down') => {
    setFiles(prev => {
      const index = prev.findIndex(f => f.id === id)
      if (index === -1) return prev
      
      const newIndex = direction === 'up' ? index - 1 : index + 1
      if (newIndex < 0 || newIndex >= prev.length) return prev
      
      const newFiles = [...prev]
      ;[newFiles[index], newFiles[newIndex]] = [newFiles[newIndex], newFiles[index]]
      return newFiles
    })
  }, [])

  const mergePDFs = async () => {
    if (files.length < 2) {
      setError('कम से कम 2 PDF फाइलें चुनें')
      return
    }

    setIsProcessing(true)
    setProgress(0)
    setError(null)

    try {
      const formData = new FormData()
      files.forEach((fileItem, index) => {
        formData.append(`pdf_${index}`, fileItem.file)
      })

      // Simulate progress
      const progressInterval = setInterval(() => {
        setProgress(prev => {
          if (prev >= 90) {
            clearInterval(progressInterval)
            return 90
          }
          return prev + 10
        })
      }, 200)

      const response = await fetch('/api/tools/pdf-merger', {
        method: 'POST',
        body: formData
      })

      clearInterval(progressInterval)
      setProgress(100)

      if (!response.ok) {
        throw new Error('PDF merge करने में त्रुटि हुई')
      }

      const blob = await response.blob()
      const url = URL.createObjectURL(blob)
      setMergedFileUrl(url)
      
    } catch (err) {
      setError(err instanceof Error ? err.message : 'कुछ गलत हुआ')
    } finally {
      setIsProcessing(false)
    }
  }

  const downloadMergedPDF = () => {
    if (mergedFileUrl) {
      downloadFile(mergedFileUrl, 'merged-document.pdf')
    }
  }

  const resetTool = () => {
    files.forEach(file => URL.revokeObjectURL(file.preview))
    setFiles([])
    setProgress(0)
    setError(null)
    if (mergedFileUrl) {
      URL.revokeObjectURL(mergedFileUrl)
      setMergedFileUrl(null)
    }
  }

  return (
    <div className="container mx-auto max-w-4xl py-8 px-4">
      <div className="text-center mb-8">
        <h1 className="text-3xl font-bold text-gray-900 dark:text-white mb-2">
          PDF Merger
        </h1>
        <p className="text-gray-600 dark:text-gray-300">
          कई PDF फाइलों को एक में मिलाएं
        </p>
      </div>

      <div className="grid gap-6">
        {/* File Upload Section */}
        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <FileText className="w-5 h-5" />
              PDF फाइलें चुनें
            </CardTitle>
          </CardHeader>
          <CardContent>
            <FileUpload
              accept=".pdf"
              multiple
              onFileUpload={handleFileUpload}
              disabled={isProcessing}
            />
          </CardContent>
        </Card>

        {/* File List */}
        {files.length > 0 && (
          <Card>
            <CardHeader>
              <CardTitle>अपलोड की गई फाइलें ({files.length})</CardTitle>
            </CardHeader>
            <CardContent>
              <div className="space-y-2">
                {files.map((fileItem, index) => (
                  <div
                    key={fileItem.id}
                    className="flex items-center justify-between p-3 border border-gray-200 dark:border-gray-700 rounded-lg"
                  >
                    <div className="flex items-center gap-3">
                      <FileText className="w-5 h-5 text-red-600" />
                      <span className="font-medium">{fileItem.file.name}</span>
                      <span className="text-sm text-gray-500">
                        ({(fileItem.file.size / 1024 / 1024).toFixed(2)} MB)
                      </span>
                    </div>
                    
                    <div className="flex items-center gap-2">
                      <Button
                        variant="ghost"
                        size="sm"
                        onClick={() => moveFile(fileItem.id, 'up')}
                        disabled={index === 0 || isProcessing}
                      >
                        <ArrowUp className="w-4 h-4" />
                      </Button>
                      <Button
                        variant="ghost"
                        size="sm"
                        onClick={() => moveFile(fileItem.id, 'down')}
                        disabled={index === files.length - 1 || isProcessing}
                      >
                        <ArrowDown className="w-4 h-4" />
                      </Button>
                      <Button
                        variant="ghost"
                        size="sm"
                        onClick={() => removeFile(fileItem.id)}
                        disabled={isProcessing}
                      >
                        <X className="w-4 h-4" />
                      </Button>
                    </div>
                  </div>
                ))}
              </div>
            </CardContent>
          </Card>
        )}

        {/* Error Display */}
        {error && (
          <Alert variant="destructive">
            <AlertDescription>{error}</AlertDescription>
          </Alert>
        )}

        {/* Progress */}
        {isProcessing && (
          <Card>
            <CardContent className="pt-6">
              <div className="space-y-2">
                <div className="flex justify-between text-sm">
                  <span>Processing...</span>
                  <span>{progress}%</span>
                </div>
                <Progress value={progress} className="w-full" />
              </div>
            </CardContent>
          </Card>
        )}

        {/* Action Buttons */}
        <div className="flex gap-4 justify-center">
          <Button
            onClick={mergePDFs}
            disabled={files.length < 2 || isProcessing}
            size="lg"
          >
            {isProcessing ? 'Processing...' : 'Merge PDFs'}
          </Button>
          
          {mergedFileUrl && (
            <Button
              onClick={downloadMergedPDF}
              variant="outline"
              size="lg"
              className="flex items-center gap-2"
            >
              <Download className="w-4 h-4" />
              Download
            </Button>
          )}
          
          <Button
            onClick={resetTool}
            variant="ghost"
            size="lg"
            disabled={isProcessing}
          >
            Reset
          </Button>
        </div>
      </div>
    </div>
  )
}
```

---

## 📁 File Upload System

### 🔄 Reusable File Upload Component

**src/components/ui/file-upload.tsx:**
```typescript
'use client'

import { useCallback, useState } from 'react'
import { useDropzone } from 'react-dropzone'
import { Button } from './button'
import { cn } from '@/lib/utils'
import { Upload, File, X } from 'lucide-react'

interface FileUploadProps {
  accept?: string
  multiple?: boolean
  maxSize?: number // in bytes
  onFileUpload: (files: File[]) => void
  disabled?: boolean
  className?: string
}

export function FileUpload({
  accept,
  multiple = false,
  maxSize = 10 * 1024 * 1024, // 10MB default
  onFileUpload,
  disabled = false,
  className
}: FileUploadProps) {
  const [dragActive, setDragActive] = useState(false)
  const [error, setError] = useState<string | null>(null)

  const onDrop = useCallback((acceptedFiles: File[], rejectedFiles: any[]) => {
    setError(null)
    
    if (rejectedFiles.length > 0) {
      const rejection = rejectedFiles[0]
      if (rejection.errors[0]?.code === 'file-too-large') {
        setError(`File size should be less than ${maxSize / 1024 / 1024}MB`)
      } else if (rejection.errors[0]?.code === 'file-invalid-type') {
        setError('Invalid file type')
      } else {
        setError('File upload failed')
      }
      return
    }

    if (acceptedFiles.length > 0) {
      onFileUpload(acceptedFiles)
    }
  }, [maxSize, onFileUpload])

  const { getRootProps, getInputProps, isDragActive } = useDropzone({
    onDrop,
    accept: accept ? { [accept]: [] } : undefined,
    multiple,
    maxSize,
    disabled,
    onDragEnter: () => setDragActive(true),
    onDragLeave: () => setDragActive(false)
  })

  return (
    <div className={cn('w-full', className)}>
      <div
        {...getRootProps()}
        className={cn(
          'border-2 border-dashed rounded-lg p-8 text-center cursor-pointer transition-colors',
          {
            'border-primary-400 bg-primary-50 dark:bg-primary-950': isDragActive || dragActive,
            'border-gray-300 dark:border-gray-600 hover:border-gray-400 dark:hover:border-gray-500': !isDragActive && !disabled,
            'border-gray-200 dark:border-gray-700 cursor-not-allowed opacity-50': disabled
          }
        )}
      >
        <input {...getInputProps()} />
        
        <div className="flex flex-col items-center gap-4">
          <div className={cn(
            'w-12 h-12 rounded-full flex items-center justify-center',
            isDragActive || dragActive 
              ? 'bg-primary-100 dark:bg-primary-900' 
              : 'bg-gray-100 dark:bg-gray-800'
          )}>
            <Upload className={cn(
              'w-6 h-6',
              isDragActive || dragActive 
                ? 'text-primary-600 dark:text-primary-400' 
                : 'text-gray-600 dark:text-gray-400'
            )} />
          </div>
          
          <div>
            <p className="text-lg font-medium text-gray-900 dark:text-white mb-1">
              {isDragActive ? 'Drop files here' : 'Choose files or drag & drop'}
            </p>
            <p className="text-sm text-gray-600 dark:text-gray-400">
              {accept && `Supported formats: ${accept}`}
              {maxSize && ` • Max size: ${maxSize / 1024 / 1024}MB`}
            </p>
          </div>
          
          <Button type="button" variant="outline" disabled={disabled}>
            <File className="w-4 h-4 mr-2" />
            Browse Files
          </Button>
        </div>
      </div>
      
      {error && (
        <div className="mt-2 p-3 bg-red-50 dark:bg-red-950 border border-red-200 dark:border-red-800 rounded-md">
          <div className="flex items-center justify-between">
            <p className="text-sm text-red-600 dark:text-red-400">{error}</p>
            <Button
              variant="ghost"
              size="sm"
              onClick={() => setError(null)}
            >
              <X className="w-4 h-4" />
            </Button>
          </div>
        </div>
      )}
    </div>
  )
}
```

---

## 🗃️ State Management

### 🔄 Zustand Store Example

**src/store/tool-store.ts:**
```typescript
import { create } from 'zustand'
import { devtools, persist } from 'zustand/middleware'

interface ToolUsage {
  toolId: string
  timestamp: Date
  fileSize?: number
}

interface ToolState {
  // Usage tracking
  usageHistory: ToolUsage[]
  totalUsage: number
  
  // User preferences
  preferences: {
    autoDownload: boolean
    deleteAfterDownload: boolean
    compressionLevel: 'low' | 'medium' | 'high'
  }
  
  // Actions
  trackUsage: (toolId: string, fileSize?: number) => void
  updatePreferences: (preferences: Partial<ToolState['preferences']>) => void
  clearHistory: () => void
}

export const useToolStore = create<ToolState>()()
  devtools(
    persist(
      (set, get) => ({
        usageHistory: [],
        totalUsage: 0,
        preferences: {
          autoDownload: false,
          deleteAfterDownload: true,
          compressionLevel: 'medium'
        },
        
        trackUsage: (toolId: string, fileSize?: number) => {
          const usage: ToolUsage = {
            toolId,
            timestamp: new Date(),
            fileSize
          }
          
          set((state) => ({
            usageHistory: [usage, ...state.usageHistory.slice(0, 99)], // Keep last 100
            totalUsage: state.totalUsage + 1
          }))
        },
        
        updatePreferences: (newPreferences) => {
          set((state) => ({
            preferences: { ...state.preferences, ...newPreferences }
          }))
        },
        
        clearHistory: () => {
          set({ usageHistory: [], totalUsage: 0 })
        }
      }),
      {
        name: 'tool-storage',
        partialize: (state) => ({ 
          preferences: state.preferences,
          totalUsage: state.totalUsage 
        })
      }
    ),
    { name: 'tool-store' }
  )
)
```

---

## 🌐 API Integration

### 📡 API Route Example

**src/app/api/tools/pdf-merger/route.ts:**
```typescript
import { NextRequest, NextResponse } from 'next/server'
import { PDFDocument } from 'pdf-lib'

export async function POST(request: NextRequest) {
  try {
    const formData = await request.formData()
    const files: File[] = []
    
    // Extract PDF files from form data
    for (const [key, value] of formData.entries()) {
      if (key.startsWith('pdf_') && value instanceof File) {
        files.push(value)
      }
    }
    
    if (files.length < 2) {
      return NextResponse.json(
        { error: 'At least 2 PDF files are required' },
        { status: 400 }
      )
    }
    
    // Create a new PDF document
    const mergedPdf = await PDFDocument.create()
    
    // Process each PDF file
    for (const file of files) {
      const arrayBuffer = await file.arrayBuffer()
      const pdf = await PDFDocument.load(arrayBuffer)
      const pages = await mergedPdf.copyPages(pdf, pdf.getPageIndices())
      
      pages.forEach((page) => {
        mergedPdf.addPage(page)
      })
    }
    
    // Generate the merged PDF
    const pdfBytes = await mergedPdf.save()
    
    // Return the merged PDF
    return new NextResponse(pdfBytes, {
      status: 200,
      headers: {
        'Content-Type': 'application/pdf',
        'Content-Disposition': 'attachment; filename="merged-document.pdf"',
        'Content-Length': pdfBytes.length.toString()
      }
    })
    
  } catch (error) {
    console.error('PDF merge error:', error)
    return NextResponse.json(
      { error: 'Failed to merge PDF files' },
      { status: 500 }
    )
  }
}

// Add rate limiting
export async function middleware(request: NextRequest) {
  // Implement rate limiting logic here
  // Example: Check user IP, implement token bucket algorithm
  return NextResponse.next()
}
```

### 🔄 API Client Hook

**src/hooks/use-api.ts:**
```typescript
import { useState, useCallback } from 'react'
import axios, { AxiosError } from 'axios'

interface ApiState<T> {
  data: T | null
  loading: boolean
  error: string | null
}

interface UseApiOptions {
  onSuccess?: (data: any) => void
  onError?: (error: string) => void
}

export function useApi<T = any>(options: UseApiOptions = {}) {
  const [state, setState] = useState<ApiState<T>>({
    data: null,
    loading: false,
    error: null
  })

  const execute = useCallback(async (
    url: string,
    config: any = {},
    method: 'GET' | 'POST' | 'PUT' | 'DELETE' = 'GET'
  ) => {
    setState(prev => ({ ...prev, loading: true, error: null }))

    try {
      const response = await axios({
        url,
        method,
        ...config
      })

      setState({
        data: response.data,
        loading: false,
        error: null
      })

      options.onSuccess?.(response.data)
      return response.data

    } catch (error) {
      const errorMessage = error instanceof AxiosError 
        ? error.response?.data?.error || error.message
        : 'An unexpected error occurred'

      setState({
        data: null,
        loading: false,
        error: errorMessage
      })

      options.onError?.(errorMessage)
      throw error
    }
  }, [options])

  const reset = useCallback(() => {
    setState({ data: null, loading: false, error: null })
  }, [])

  return {
    ...state,
    execute,
    reset
  }
}
```

---

## ⚠️ Error Handling

### 🛡️ Global Error Boundary

**src/components/error-boundary.tsx:**
```typescript
'use client'

import React from 'react'
import { Button } from '@/components/ui/button'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { AlertTriangle, RefreshCw } from 'lucide-react'

interface ErrorBoundaryState {
  hasError: boolean
  error?: Error
}

class ErrorBoundary extends React.Component<
  React.PropsWithChildren<{}>,
  ErrorBoundaryState
> {
  constructor(props: React.PropsWithChildren<{}>) {
    super(props)
    this.state = { hasError: false }
  }

  static getDerivedStateFromError(error: Error): ErrorBoundaryState {
    return { hasError: true, error }
  }

  componentDidCatch(error: Error, errorInfo: React.ErrorInfo) {
    console.error('Error caught by boundary:', error, errorInfo)
    
    // Log to error reporting service
    // Example: Sentry.captureException(error)
  }

  render() {
    if (this.state.hasError) {
      return (
        <div className="min-h-screen flex items-center justify-center p-4">
          <Card className="max-w-md w-full">
            <CardHeader className="text-center">
              <div className="mx-auto w-12 h-12 bg-red-100 dark:bg-red-900 rounded-full flex items-center justify-center mb-4">
                <AlertTriangle className="w-6 h-6 text-red-600 dark:text-red-400" />
              </div>
              <CardTitle className="text-xl">Something went wrong</CardTitle>
            </CardHeader>
            <CardContent className="text-center space-y-4">
              <p className="text-gray-600 dark:text-gray-300">
                We're sorry, but something unexpected happened. Please try refreshing the page.
              </p>
              
              {process.env.NODE_ENV === 'development' && (
                <details className="text-left">
                  <summary className="cursor-pointer text-sm font-medium mb-2">
                    Error Details
                  </summary>
                  <pre className="text-xs bg-gray-100 dark:bg-gray-800 p-2 rounded overflow-auto">
                    {this.state.error?.stack}
                  </pre>
                </details>
              )}
              
              <div className="flex gap-2 justify-center">
                <Button
                  onClick={() => window.location.reload()}
                  className="flex items-center gap-2"
                >
                  <RefreshCw className="w-4 h-4" />
                  Refresh Page
                </Button>
                <Button
                  variant="outline"
                  onClick={() => window.location.href = '/'}
                >
                  Go Home
                </Button>
              </div>
            </CardContent>
          </Card>
        </div>
      )
    }

    return this.props.children
  }
}

export default ErrorBoundary
```

### 🔄 Error Toast System

**src/hooks/use-toast.ts:**
```typescript
import { useState, useCallback } from 'react'

interface Toast {
  id: string
  title?: string
  description: string
  type: 'success' | 'error' | 'warning' | 'info'
  duration?: number
}

interface ToastState {
  toasts: Toast[]
}

export function useToast() {
  const [state, setState] = useState<ToastState>({ toasts: [] })

  const addToast = useCallback((toast: Omit<Toast, 'id'>) => {
    const id = Math.random().toString(36).substr(2, 9)
    const newToast: Toast = {
      id,
      duration: 5000,
      ...toast
    }

    setState(prev => ({
      toasts: [...prev.toasts, newToast]
    }))

    // Auto remove after duration
    if (newToast.duration && newToast.duration > 0) {
      setTimeout(() => {
        removeToast(id)
      }, newToast.duration)
    }

    return id
  }, [])

  const removeToast = useCallback((id: string) => {
    setState(prev => ({
      toasts: prev.toasts.filter(toast => toast.id !== id)
    }))
  }, [])

  const success = useCallback((description: string, title?: string) => {
    return addToast({ type: 'success', description, title })
  }, [addToast])

  const error = useCallback((description: string, title?: string) => {
    return addToast({ type: 'error', description, title })
  }, [addToast])

  const warning = useCallback((description: string, title?: string) => {
    return addToast({ type: 'warning', description, title })
  }, [addToast])

  const info = useCallback((description: string, title?: string) => {
    return addToast({ type: 'info', description, title })
  }, [addToast])

  return {
    toasts: state.toasts,
    addToast,
    removeToast,
    success,
    error,
    warning,
    info
  }
}
```

---

## ⚡ Performance Optimization

### 🔄 Lazy Loading Components

**src/components/lazy-tool.tsx:**
```typescript
import { lazy, Suspense } from 'react'
import { Card, CardContent } from '@/components/ui/card'
import { Loader2 } from 'lucide-react'

// Lazy load tool components
const PDFMerger = lazy(() => import('@/app/tools/pdf-merger/page'))
const ImageCompressor = lazy(() => import('@/app/tools/image-compressor/page'))
const TextConverter = lazy(() => import('@/app/tools/text-converter/page'))

const toolComponents = {
  'pdf-merger': PDFMerger,
  'image-compressor': ImageCompressor,
  'text-converter': TextConverter
}

interface LazyToolProps {
  toolId: keyof typeof toolComponents
}

function ToolLoadingFallback() {
  return (
    <Card className="min-h-[400px]">
      <CardContent className="flex items-center justify-center h-full">
        <div className="flex flex-col items-center gap-4">
          <Loader2 className="w-8 h-8 animate-spin text-primary-600" />
          <p className="text-gray-600 dark:text-gray-300">Loading tool...</p>
        </div>
      </CardContent>
    </Card>
  )
}

export function LazyTool({ toolId }: LazyToolProps) {
  const ToolComponent = toolComponents[toolId]

  if (!ToolComponent) {
    return (
      <Card>
        <CardContent className="text-center py-8">
          <p className="text-red-600">Tool not found</p>
        </CardContent>
      </Card>
    )
  }

  return (
    <Suspense fallback={<ToolLoadingFallback />}>
      <ToolComponent />
    </Suspense>
  )
}
```

### 🗂️ Image Optimization

**src/components/optimized-image.tsx:**
```typescript
import Image from 'next/image'
import { useState } from 'react'
import { cn } from '@/lib/utils'

interface OptimizedImageProps {
  src: string
  alt: string
  width?: number
  height?: number
  className?: string
  priority?: boolean
  placeholder?: 'blur' | 'empty'
  blurDataURL?: string
}

export function OptimizedImage({
  src,
  alt,
  width,
  height,
  className,
  priority = false,
  placeholder = 'empty',
  blurDataURL
}: OptimizedImageProps) {
  const [isLoading, setIsLoading] = useState(true)
  const [hasError, setHasError] = useState(false)

  if (hasError) {
    return (
      <div className={cn(
        'bg-gray-200 dark:bg-gray-800 flex items-center justify-center',
        className
      )}>
        <span className="text-gray-500 text-sm">Failed to load image</span>
      </div>
    )
  }

  return (
    <div className={cn('relative overflow-hidden', className)}>
      <Image
        src={src}
        alt={alt}
        width={width}
        height={height}
        priority={priority}
        placeholder={placeholder}
        blurDataURL={blurDataURL}
        className={cn(
          'transition-opacity duration-300',
          isLoading ? 'opacity-0' : 'opacity-100'
        )}
        onLoad={() => setIsLoading(false)}
        onError={() => {
          setIsLoading(false)
          setHasError(true)
        }}
        sizes="(max-width: 768px) 100vw, (max-width: 1200px) 50vw, 33vw"
      />
      
      {isLoading && (
        <div className="absolute inset-0 bg-gray-200 dark:bg-gray-800 animate-pulse" />
      )}
    </div>
  )
}
```

### 📊 Performance Monitoring

**src/lib/performance.ts:**
```typescript
// Performance monitoring utilities
export class PerformanceMonitor {
  private static instance: PerformanceMonitor
  private metrics: Map<string, number> = new Map()

  static getInstance(): PerformanceMonitor {
    if (!PerformanceMonitor.instance) {
      PerformanceMonitor.instance = new PerformanceMonitor()
    }
    return PerformanceMonitor.instance
  }

  startTiming(label: string): void {
    this.metrics.set(label, performance.now())
  }

  endTiming(label: string): number {
    const startTime = this.metrics.get(label)
    if (!startTime) {
      console.warn(`No start time found for ${label}`)
      return 0
    }

    const duration = performance.now() - startTime
    this.metrics.delete(label)
    
    // Log performance metrics
    if (process.env.NODE_ENV === 'development') {
      console.log(`⏱️ ${label}: ${duration.toFixed(2)}ms`)
    }

    // Send to analytics in production
    if (process.env.NODE_ENV === 'production') {
      this.sendMetric(label, duration)
    }

    return duration
  }

  private sendMetric(label: string, duration: number): void {
    // Send to your analytics service
    // Example: Google Analytics, Mixpanel, etc.
    if (typeof window !== 'undefined' && 'gtag' in window) {
      (window as any).gtag('event', 'timing_complete', {
        name: label,
        value: Math.round(duration)
      })
    }
  }

  measureFileProcessing<T>(
    label: string,
    fn: () => Promise<T>
  ): Promise<T> {
    return new Promise(async (resolve, reject) => {
      this.startTiming(label)
      try {
        const result = await fn()
        this.endTiming(label)
        resolve(result)
      } catch (error) {
        this.endTiming(label)
        reject(error)
      }
    })
  }
}

// Usage example
export const performanceMonitor = PerformanceMonitor.getInstance()

// Hook for component performance
export function usePerformanceMonitor() {
  return {
    measureAsync: performanceMonitor.measureFileProcessing.bind(performanceMonitor),
    startTiming: performanceMonitor.startTiming.bind(performanceMonitor),
    endTiming: performanceMonitor.endTiming.bind(performanceMonitor)
  }
}
```

---

## 🎯 Usage Examples

### 📝 Tool में Performance Monitoring का उपयोग

```typescript
// PDF Merger में performance monitoring
const { measureAsync } = usePerformanceMonitor()

const mergePDFs = async () => {
  try {
    const result = await measureAsync('pdf-merge-operation', async () => {
      const formData = new FormData()
      files.forEach((file, index) => {
        formData.append(`pdf_${index}`, file.file)
      })
      
      const response = await fetch('/api/tools/pdf-merger', {
        method: 'POST',
        body: formData
      })
      
      return response.blob()
    })
    
    // Handle success
  } catch (error) {
    // Handle error
  }
}
```

### 🔄 Error Boundary का उपयोग

```typescript
// app/layout.tsx में
import ErrorBoundary from '@/components/error-boundary'

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <body>
        <ErrorBoundary>
          <ThemeProvider>
            <Header />
            <main>{children}</main>
          </ThemeProvider>
        </ErrorBoundary>
      </body>
    </html>
  )
}
```

---

## 🎉 निष्कर्ष

ये implementation examples आपको निम्नलिखित में मदद करेंगे:

1. **Robust File Handling**: सुरक्षित और efficient file upload/processing
2. **Error Management**: Graceful error handling और user feedback
3. **Performance**: Optimized loading और monitoring
4. **State Management**: Scalable state management patterns
5. **API Integration**: RESTful API design और client-side integration

**अगले कदम**: इन examples को अपने प्रोजेक्ट में implement करें और अपनी जरूरतों के अनुसार customize करें।