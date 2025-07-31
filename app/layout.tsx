import type React from "react"
import type { Metadata } from "next"
import { Inter } from "next/font/google"
import "./globals.css"
import { ThemeProvider } from "@/components/theme-provider"

const inter = Inter({ subsets: ["latin"] })

export const metadata: Metadata = {
  title: "SefTecHub API | Enterprise DeFi Access Platform",
  description:
    "Leading enterprise DeFi infrastructure with AI-powered trade finance, B2B marketplace integration, global compliance, and institutional-grade APIs.",
  keywords: "enterprise DeFi, trade finance API, B2B marketplace, blockchain integration, smart contracts, institutional DeFi, SefTecHub",
  openGraph: {
    type: "website",
    locale: "en_US",
    url: "https://api.seftechub.com",
    title: "SefTecHub API | Enterprise DeFi Access Platform",
    description:
      "The premier enterprise DeFi platform providing AI-powered trade finance, global compliance, and institutional-grade API infrastructure.",
    siteName: "SefTecHub API",
    images: [
      {
        url: "https://api.seftechub.com/og-image.jpg",
        width: 1200,
        height: 630,
        alt: "SefTecHub Enterprise DeFi Platform",
      },
    ],
  },
  twitter: {
    card: "summary_large_image",
    title: "SefTecHub API | Enterprise DeFi Access Platform",
    description: "Leading enterprise DeFi infrastructure with AI-powered solutions for global B2B trade and finance.",
    images: ["https://api.seftechub.com/twitter-image.jpg"],
  },
  robots: {
    index: true,
    follow: true,
  },
    generator: 'SefTecHub'
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en" suppressHydrationWarning>
      <body className={inter.className}>
        <ThemeProvider attribute="class" defaultTheme="system" enableSystem disableTransitionOnChange>
          {children}
        </ThemeProvider>
      </body>
    </html>
  )
}
