import Link from "next/link"

export default function Footer() {
  const currentYear = new Date().getFullYear()

  return (
    <footer className="border-t py-12 md:py-16">
      <div className="container px-4 md:px-6">
        <div className="grid grid-cols-1 md:grid-cols-4 gap-8">
          <div className="space-y-4">
            <h3 className="text-lg font-bold">SefTecHub API</h3>
            <p className="text-sm text-muted-foreground">
              Leading enterprise DeFi access platform for global B2B trade and finance with AI-powered solutions.
            </p>
          </div>
          <div className="space-y-4">
            <h3 className="text-sm font-bold">Products</h3>
            <nav aria-label="Product Navigation">
              <ul className="space-y-2 text-sm">
                <li>
                  <Link href="/defi-apis" className="text-muted-foreground hover:text-foreground">
                    DeFi APIs
                  </Link>
                </li>
                <li>
                  <Link href="/trade-finance" className="text-muted-foreground hover:text-foreground">
                    Trade Finance
                  </Link>
                </li>
                <li>
                  <Link href="/b2b-marketplace" className="text-muted-foreground hover:text-foreground">
                    B2B Marketplace
                  </Link>
                </li>
                <li>
                  <Link href="/compliance" className="text-muted-foreground hover:text-foreground">
                    Compliance Engine
                  </Link>
                </li>
              </ul>
            </nav>
          </div>
          <div className="space-y-4">
            <h3 className="text-sm font-bold">Developers</h3>
            <nav aria-label="Resources Navigation">
              <ul className="space-y-2 text-sm">
                <li>
                  <Link href="/api-docs" className="text-muted-foreground hover:text-foreground">
                    API Documentation
                  </Link>
                </li>
                <li>
                  <Link href="/sdks" className="text-muted-foreground hover:text-foreground">
                    SDKs & Libraries
                  </Link>
                </li>
                <li>
                  <Link href="/webhooks" className="text-muted-foreground hover:text-foreground">
                    Webhooks
                  </Link>
                </li>
                <li>
                  <Link href="/status" className="text-muted-foreground hover:text-foreground">
                    API Status
                  </Link>
                </li>
              </ul>
            </nav>
          </div>
          <div className="space-y-4">
            <h3 className="text-sm font-bold">SefTecHub</h3>
            <nav aria-label="Company Navigation">
              <ul className="space-y-2 text-sm">
                <li>
                  <Link href="https://seftechub.com/about" className="text-muted-foreground hover:text-foreground">
                    About Us
                  </Link>
                </li>
                <li>
                  <Link href="https://seftechub.com/careers" className="text-muted-foreground hover:text-foreground">
                    Careers
                  </Link>
                </li>
                <li>
                  <Link href="/partners" className="text-muted-foreground hover:text-foreground">
                    Partners
                  </Link>
                </li>
                <li>
                  <Link href="/privacy" className="text-muted-foreground hover:text-foreground">
                    Privacy & Terms
                  </Link>
                </li>
              </ul>
            </nav>
          </div>
        </div>
        <div className="mt-12 pt-8 border-t flex flex-col md:flex-row justify-between items-center gap-4">
          <p className="text-sm text-muted-foreground">© {currentYear} SefTecHub. All rights reserved.</p>
          <div className="flex gap-4">
            <Link
              href="https://linkedin.com"
              className="text-muted-foreground hover:text-foreground"
              aria-label="LinkedIn"
            >
              <svg
                xmlns="http://www.w3.org/2000/svg"
                width="24"
                height="24"
                viewBox="0 0 24 24"
                fill="none"
                stroke="currentColor"
                strokeWidth="2"
                strokeLinecap="round"
                strokeLinejoin="round"
                className="h-5 w-5"
              >
                <path d="M16 8a6 6 0 0 1 6 6v7h-4v-7a2 2 0 0 0-2-2 2 2 0 0 0-2 2v7h-4v-7a6 6 0 0 1 6-6z"></path>
                <rect width="4" height="12" x="2" y="9"></rect>
                <circle cx="4" cy="4" r="2"></circle>
              </svg>
            </Link>
            <Link
              href="https://twitter.com"
              className="text-muted-foreground hover:text-foreground"
              aria-label="Twitter"
            >
              <svg
                xmlns="http://www.w3.org/2000/svg"
                width="24"
                height="24"
                viewBox="0 0 24 24"
                fill="none"
                stroke="currentColor"
                strokeWidth="2"
                strokeLinecap="round"
                strokeLinejoin="round"
                className="h-5 w-5"
              >
                <path d="M22 4s-.7 2.1-2 3.4c1.6 10-9.4 17.3-18 11.6 2.2.1 4.4-.6 6-2C3 15.5.5 9.6 3 5c2.2 2.6 5.6 4.1 9 4-.9-4.2 4-6.6 7-3.8 1.1 0 3-1.2 3-1.2z"></path>
              </svg>
            </Link>
            <Link href="https://github.com" className="text-muted-foreground hover:text-foreground" aria-label="GitHub">
              <svg
                xmlns="http://www.w3.org/2000/svg"
                width="24"
                height="24"
                viewBox="0 0 24 24"
                fill="none"
                stroke="currentColor"
                strokeWidth="2"
                strokeLinecap="round"
                strokeLinejoin="round"
                className="h-5 w-5"
              >
                <path d="M15 22v-4a4.8 4.8 0 0 0-1-3.5c3 0 6-2 6-5.5.08-1.25-.27-2.48-1-3.5.28-1.15.28-2.35 0-3.5 0 0-1 0-3 1.5-2.64-.5-5.36-.5-8 0C6 2 5 2 5 2c-.3 1.15-.3 2.35 0 3.5A5.403 5.403 0 0 0 4 9c0 3.5 3 5.5 6 5.5-.39.49-.68 1.05-.85 1.65-.17.6-.22 1.23-.15 1.85v4"></path>
                <path d="M9 18c-4.51 2-5-2-7-2"></path>
              </svg>
            </Link>
          </div>
        </div>
      </div>
    </footer>
  )
}
