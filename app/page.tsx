import { Button } from "@/components/ui/button"
import { Database, Shield, TrendingUp, Zap } from "lucide-react"
import Testimonials from "@/components/testimonials"
import UseCases from "@/components/use-cases"
import Navbar from "@/components/navbar"
import Footer from "@/components/footer"
import TypingPromptInput from "@/components/typing-prompt-input"
import FramerSpotlight from "@/components/framer-spotlight"
import CssGridBackground from "@/components/css-grid-background"
import FeaturesSection from "@/components/features-section"
import StructuredData from "@/components/structured-data"
import DeveloperAccessForm from "@/components/developer-access-form"

export default function Home() {
  return (
    <>
      <StructuredData />
      <div className="flex min-h-screen flex-col">
        <Navbar />

        {/* Hero Section */}
        <section id="hero" className="relative min-h-screen flex items-center justify-center overflow-hidden">
          <CssGridBackground />
          <FramerSpotlight />
          <div className="container px-4 md:px-6 py-16 md:py-20">
            <div className="flex flex-col items-center text-center max-w-3xl mx-auto">
              <div className="inline-block rounded-lg bg-muted px-3 py-1 text-sm mb-6">Enterprise DeFi Leader</div>
              <h1 className="text-4xl md:text-5xl lg:text-6xl font-bold tracking-tighter mb-6">
                The Premier Enterprise DeFi Access Platform
              </h1>
              <p className="text-xl text-muted-foreground md:text-2xl/relaxed lg:text-base/relaxed xl:text-xl/relaxed max-w-2xl mb-12">
                Leading the enterprise DeFi revolution with AI-powered trade finance, global B2B marketplace integration, and institutional-grade API infrastructure.
              </p>

              <TypingPromptInput />

              <div className="flex flex-wrap justify-center gap-3 mt-16">
                <Button className="flex items-center gap-3 px-5 py-6 h-[60px] bg-[#1a1d21] hover:bg-[#2a2d31] text-white rounded-xl border-0 dark:bg-primary dark:hover:bg-primary/90 dark:shadow-[0_0_15px_rgba(36,101,237,0.5)] relative overflow-hidden group">
                  <div className="absolute inset-0 bg-gradient-to-r from-primary/0 via-primary/30 to-primary/0 dark:opacity-30 opacity-0 group-hover:opacity-100 transition-opacity duration-500 transform translate-x-[-100%] group-hover:translate-x-[100%]"></div>
                  <Zap className="h-5 w-5 text-white relative z-10" />
                  <div className="flex flex-col items-start relative z-10">
                    <span className="text-[15px] font-medium">Get API Access</span>
                    <span className="text-xs text-gray-400 dark:text-gray-300 -mt-0.5">v2.0.0</span>
                  </div>
                </Button>
                <Button className="px-5 py-6 h-[60px] rounded-xl border-2 border-gray-300 dark:border-gray-600 bg-transparent hover:bg-gray-100 dark:hover:bg-gray-800 text-[15px] font-medium text-foreground">
                  View Documentation
                </Button>
              </div>
            </div>
          </div>
        </section>

        {/* Features Section */}
        <FeaturesSection />

        {/* How It Works */}
        <section className="py-20" id="how-it-works" aria-labelledby="how-it-works-heading">
          <div className="container px-4 md:px-6">
            <div className="flex flex-col items-center justify-center space-y-4 text-center mb-12">
              <div className="space-y-2">
                <h2 id="how-it-works-heading" className="text-3xl font-bold tracking-tighter sm:text-4xl md:text-5xl">
                  How It Works
                </h2>
                <p className="mx-auto max-w-[700px] text-muted-foreground md:text-xl">
                  Connect your enterprise systems to SefTecHub's powerful DeFi and trade finance APIs.
                </p>
              </div>
            </div>
            <div className="grid gap-6 lg:grid-cols-3 lg:gap-12 items-start">
              <div className="flex flex-col items-center space-y-4 text-center">
                <div className="flex h-16 w-16 items-center justify-center rounded-full bg-primary text-primary-foreground">
                  <span className="text-2xl font-bold">1</span>
                </div>
                <h3 className="text-xl font-bold">API Authentication</h3>
                <p className="text-muted-foreground">
                  Secure API key generation with OAuth 2.0 and enterprise-grade authentication.
                </p>
              </div>
              <div className="flex flex-col items-center space-y-4 text-center">
                <div className="flex h-16 w-16 items-center justify-center rounded-full bg-primary text-primary-foreground">
                  <span className="text-2xl font-bold">2</span>
                </div>
                <h3 className="text-xl font-bold">Integrate Services</h3>
                <p className="text-muted-foreground">
                  Access DeFi protocols, trade finance, compliance monitoring, and AI analytics.
                </p>
              </div>
              <div className="flex flex-col items-center space-y-4 text-center">
                <div className="flex h-16 w-16 items-center justify-center rounded-full bg-primary text-primary-foreground">
                  <span className="text-2xl font-bold">3</span>
                </div>
                <h3 className="text-xl font-bold">Deploy & Monitor</h3>
                <p className="text-muted-foreground">
                  Real-time monitoring, analytics dashboard, and scalable infrastructure.
                </p>
              </div>
            </div>
          </div>
        </section>

        {/* Use Cases */}
        <UseCases />

        {/* Credit-as-a-Service Integration */}
        <section className="py-20 bg-gradient-to-b from-muted/50 to-background dark:from-muted/10 dark:to-background">
          <div className="container px-4 md:px-6">
            <div className="flex flex-col items-center justify-center space-y-4 text-center mb-12">
              <div className="space-y-2">
                <div className="inline-block rounded-lg bg-primary px-3 py-1 text-sm text-primary-foreground mb-2">
                  Platform Integration
                </div>
                <h2 className="text-3xl font-bold tracking-tighter sm:text-4xl md:text-5xl">
                  Powered by Credit-as-a-Service
                </h2>
                <p className="mx-auto max-w-[700px] text-muted-foreground md:text-xl">
                  Seamlessly integrated with our comprehensive credit aggregation platform featuring smart contracts, 
                  multi-provider risk assessment, and automated compliance.
                </p>
              </div>
            </div>
            
            <div className="grid gap-6 lg:grid-cols-3 lg:gap-12 items-start">
              <div className="flex flex-col items-center space-y-4 text-center">
                <div className="flex h-16 w-16 items-center justify-center rounded-full bg-primary text-primary-foreground">
                  <Database className="h-8 w-8" />
                </div>
                <h3 className="text-xl font-bold">Smart Contract Credit Aggregation</h3>
                <p className="text-muted-foreground">
                  Automated credit routing across traditional and DeFi protocols with real-time risk assessment and optimal rate matching.
                </p>
              </div>
              <div className="flex flex-col items-center space-y-4 text-center">
                <div className="flex h-16 w-16 items-center justify-center rounded-full bg-primary text-primary-foreground">
                  <Shield className="h-8 w-8" />
                </div>
                <h3 className="text-xl font-bold">Multi-Provider Risk Engine</h3>
                <p className="text-muted-foreground">
                  Advanced credit scoring with collateral management, liquidation protection, and institutional-grade security.
                </p>
              </div>
              <div className="flex flex-col items-center space-y-4 text-center">
                <div className="flex h-16 w-16 items-center justify-center rounded-full bg-primary text-primary-foreground">
                  <TrendingUp className="h-8 w-8" />
                </div>
                <h3 className="text-xl font-bold">Enterprise API Access</h3>
                <p className="text-muted-foreground">
                  Production-ready APIs with comprehensive testing, microservices architecture, and 24/7 monitoring.
                </p>
              </div>
            </div>

            <div className="mt-16 p-8 bg-muted/30 dark:bg-muted/10 rounded-2xl border">
              <div className="text-center space-y-4">
                <h3 className="text-2xl font-bold">Integration Highlights</h3>
                <div className="grid md:grid-cols-2 gap-6 text-left">
                  <div className="space-y-3">
                    <h4 className="font-semibold text-primary">Smart Contract Foundation</h4>
                    <ul className="space-y-2 text-sm text-muted-foreground">
                      <li>• CreditAggregator.sol for lifecycle management</li>
                      <li>• CollateralManager.sol with multi-token support</li>
                      <li>• CreditScoringOracle.sol with 0-1000 scale</li>
                      <li>• 96% test coverage with security audits</li>
                    </ul>
                  </div>
                  <div className="space-y-3">
                    <h4 className="font-semibold text-primary">Production Infrastructure</h4>
                    <ul className="space-y-2 text-sm text-muted-foreground">
                      <li>• TypeScript SDK with circuit breaker patterns</li>
                      <li>• Fastify API server with JWT authentication</li>
                      <li>• PostgreSQL with Drizzle ORM</li>
                      <li>• Complete CRUD operations for all entities</li>
                    </ul>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </section>

        {/* Testimonials */}
        <Testimonials />

        {/* Developer Access Section */}
        <section id="contact" className="py-20 bg-muted/50 dark:bg-muted/10" aria-labelledby="contact-heading">
          <div className="container px-4 md:px-6">
            <DeveloperAccessForm />
          </div>
        </section>

        <Footer />
      </div>
    </>
  )
}
