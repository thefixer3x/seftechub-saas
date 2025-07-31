export default function StructuredData() {
  const structuredData = {
    "@context": "https://schema.org",
    "@type": "SoftwareApplication",
    name: "SefTechHub API - Enterprise DeFi Platform",
    applicationCategory: "FinanceApplication",
    operatingSystem: "Web",
    offers: {
      "@type": "Offer",
      price: "0",
      priceCurrency: "USD",
      availability: "https://schema.org/InStock",
      priceValidUntil: new Date(new Date().setFullYear(new Date().getFullYear() + 1)).toISOString().split("T")[0],
    },
    description:
      "Leading enterprise DeFi access platform with AI-powered trade finance, B2B marketplace integration, global compliance, and institutional-grade API infrastructure.",
    aggregateRating: {
      "@type": "AggregateRating",
      ratingValue: "4.8",
      ratingCount: "150",
    },
    featureList: [
      "AI-Powered DeFi Access",
      "Trade Finance APIs",
      "B2B Marketplace Integration",
      "Global Compliance Engine",
      "Smart Contract Templates",
      "Multi-Chain Infrastructure",
      "Institutional Security",
      "Real-Time Analytics",
      "Credit-as-a-Service Integration",
    ],
    provider: {
      "@type": "Organization",
      name: "SefTechHub",
      url: "https://seftechub.com",
    },
  }

  return <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(structuredData) }} />
}
