import FeatureCard from "@/components/feature-card"
import {
  BotIcon,
  SparklesIcon,
  DatabaseIcon,
  ShieldIcon,
  FileTextIcon,
  ServerIcon,
  LockIcon,
  ZapIcon,
} from "@/components/feature-icons"

export default function FeaturesSection() {
  const features = [
    {
      icon: <BotIcon />,
      title: "AI-Powered DeFi Access",
      description:
        "Leverage advanced AI algorithms to optimize DeFi strategies, automate yield farming, and execute smart trades across multiple protocols.",
      accentColor: "rgba(36, 101, 237, 0.5)",
    },
    {
      icon: <SparklesIcon />,
      title: "Trade Finance APIs",
      description: "Complete suite of APIs for letters of credit, supply chain finance, invoice factoring, and cross-border payments.",
      accentColor: "rgba(236, 72, 153, 0.5)",
    },
    {
      icon: <DatabaseIcon />,
      title: "B2B Marketplace Integration",
      description: "Connect to global B2B networks with automated vendor onboarding, KYC/AML compliance, and smart contract execution.",
      accentColor: "rgba(34, 211, 238, 0.5)",
    },
    {
      icon: <ShieldIcon />,
      title: "Global Compliance Engine",
      description: "Real-time compliance monitoring across 150+ jurisdictions with automated reporting and risk assessment.",
      accentColor: "rgba(132, 204, 22, 0.5)",
    },
    {
      icon: <FileTextIcon />,
      title: "Smart Contract Templates",
      description: "Pre-audited DeFi smart contract templates for lending, staking, liquidity provision, and yield optimization.",
      accentColor: "rgba(249, 115, 22, 0.5)",
    },
    {
      icon: <ServerIcon />,
      title: "Multi-Chain Infrastructure",
      description: "Seamless integration with Ethereum, BSC, Polygon, Arbitrum, and 20+ blockchain networks.",
      accentColor: "rgba(168, 85, 247, 0.5)",
    },
    {
      icon: <LockIcon />,
      title: "Institutional Security",
      description:
        "Military-grade encryption, multi-sig wallets, hardware security modules (HSM), and SOC 2 Type II compliance.",
      accentColor: "rgba(251, 191, 36, 0.5)",
    },
    {
      icon: <ZapIcon />,
      title: "Real-Time Analytics",
      description: "Live dashboards for DeFi positions, trade finance metrics, cashflow forecasting, and risk exposure analysis.",
      accentColor: "rgba(16, 185, 129, 0.5)",
    },
  ]

  return (
    <section className="py-20 bg-muted/50 dark:bg-muted/10" id="features" aria-labelledby="features-heading">
      <div className="container px-4 md:px-6">
        <div className="flex flex-col items-center justify-center space-y-4 text-center mb-12">
          <div className="space-y-2">
            <div className="inline-block rounded-lg bg-primary px-3 py-1 text-sm text-primary-foreground mb-2">
              DeFi Leadership
            </div>
            <h2 id="features-heading" className="text-3xl font-bold tracking-tighter sm:text-4xl md:text-5xl">
              Enterprise DeFi Infrastructure
            </h2>
            <p className="mx-auto max-w-[700px] text-muted-foreground md:text-xl">
              The most comprehensive enterprise DeFi platform with institutional-grade APIs and global compliance.
            </p>
          </div>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
          {features.map((feature, index) => (
            <FeatureCard
              key={index}
              icon={feature.icon}
              title={feature.title}
              description={feature.description}
              accentColor={feature.accentColor}
            />
          ))}
        </div>
      </div>
    </section>
  )
}
