"use client"

import { useState } from "react"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Textarea } from "@/components/ui/textarea"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { Checkbox } from "@/components/ui/checkbox"
import { Badge } from "@/components/ui/badge"
import { AlertCircle, CheckCircle2, Loader2, Key, Shield, Zap } from "lucide-react"
import { Alert, AlertDescription } from "@/components/ui/alert"

interface FormData {
  name: string
  email: string
  company: string
  useCase: string
  planType: 'free' | 'basic' | 'pro' | 'enterprise'
  estimatedVolume: string
  integrationType: string[]
  agreedToTerms: boolean
}

const integrationTypes = [
  { id: 'defi-protocols', label: 'DeFi Protocols Integration' },
  { id: 'trade-finance', label: 'Trade Finance APIs' },
  { id: 'b2b-marketplace', label: 'B2B Marketplace' },
  { id: 'compliance-engine', label: 'Global Compliance Engine' },
  { id: 'smart-contracts', label: 'Smart Contract Templates' },
  { id: 'multi-chain', label: 'Multi-Chain Infrastructure' },
  { id: 'analytics', label: 'Real-Time Analytics' },
  { id: 'credit-service', label: 'Credit-as-a-Service' },
]

const planFeatures = {
  free: {
    name: 'Free Tier',
    requests: '1,000/month',
    rateLimit: '100/hour',
    features: ['Basic API access', 'Community support', 'Standard rate limits'],
    price: 'Free'
  },
  basic: {
    name: 'Basic Plan',
    requests: '10,000/month',
    rateLimit: '500/hour',
    features: ['All Free features', 'Email support', 'Higher rate limits', 'Basic analytics'],
    price: '$99/month'
  },
  pro: {
    name: 'Pro Plan', 
    requests: '100,000/month',
    rateLimit: '2,000/hour',
    features: ['All Basic features', 'Priority support', 'Advanced analytics', 'Webhooks'],
    price: '$499/month'
  },
  enterprise: {
    name: 'Enterprise',
    requests: 'Unlimited',
    rateLimit: 'Custom',
    features: ['All Pro features', 'Dedicated support', 'Custom integrations', 'SLA guarantee'],
    price: 'Custom pricing'
  }
}

export default function DeveloperAccessForm() {
  const [formData, setFormData] = useState<FormData>({
    name: '',
    email: '',
    company: '',
    useCase: '',
    planType: 'free',
    estimatedVolume: '',
    integrationType: [],
    agreedToTerms: false
  })

  const [isSubmitting, setIsSubmitting] = useState(false)
  const [submitStatus, setSubmitStatus] = useState<{
    type: 'success' | 'error' | null
    message: string
    requestId?: string
  }>({ type: null, message: '' })

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    setIsSubmitting(true)
    setSubmitStatus({ type: null, message: '' })

    try {
      // For demo deployment, show success message
      await new Promise(resolve => setTimeout(resolve, 1000)) // Simulate API call
      
      setSubmitStatus({
        type: 'success',
        message: 'Demo submission successful! In production, this would integrate with SefTechHub\'s API system.',
        requestId: 'demo-' + Date.now()
      })
      
      // Reset form on success
      setFormData({
        name: '',
        email: '',
        company: '',
        useCase: '',
        planType: 'free',
        estimatedVolume: '',
        integrationType: [],
        agreedToTerms: false
      })
    } catch (error) {
      setSubmitStatus({
        type: 'error',
        message: 'Demo error. In production, this would be handled by the API system.'
      })
    } finally {
      setIsSubmitting(false)
    }
  }

  const handleIntegrationTypeChange = (typeId: string, checked: boolean) => {
    setFormData(prev => ({
      ...prev,
      integrationType: checked
        ? [...prev.integrationType, typeId]
        : prev.integrationType.filter(id => id !== typeId)
    }))
  }

  const selectedPlan = planFeatures[formData.planType]

  return (
    <div className="w-full max-w-4xl mx-auto space-y-8">
      {/* Header */}
      <div className="text-center space-y-4">
        <div className="inline-flex items-center gap-2 bg-primary/10 px-4 py-2 rounded-full">
          <Key className="h-4 w-4 text-primary" />
          <span className="text-sm font-medium text-primary">Developer Access</span>
        </div>
        <h2 className="text-3xl font-bold">Get API Access</h2>
        <p className="text-muted-foreground max-w-2xl mx-auto">
          Join thousands of developers building with SefTechHub's enterprise DeFi infrastructure. 
          Get started in minutes with our comprehensive API platform.
        </p>
      </div>

      {/* Status Alert */}
      {submitStatus.type && (
        <Alert className={submitStatus.type === 'success' ? 'border-green-200 bg-green-50' : 'border-red-200 bg-red-50'}>
          {submitStatus.type === 'success' ? (
            <CheckCircle2 className="h-4 w-4 text-green-600" />
          ) : (
            <AlertCircle className="h-4 w-4 text-red-600" />
          )}
          <AlertDescription className={submitStatus.type === 'success' ? 'text-green-800' : 'text-red-800'}>
            {submitStatus.message}
            {submitStatus.requestId && (
              <div className="mt-2 text-sm">
                Request ID: <code className="bg-white px-2 py-1 rounded">{submitStatus.requestId}</code>
              </div>
            )}
          </AlertDescription>
        </Alert>
      )}

      <div className="grid lg:grid-cols-2 gap-8">
        {/* Form */}
        <Card>
          <CardHeader>
            <CardTitle>Request API Access</CardTitle>
            <CardDescription>
              Fill out the form below to get access to SefTechHub's DeFi APIs
            </CardDescription>
          </CardHeader>
          <CardContent>
            <form onSubmit={handleSubmit} className="space-y-6">
              {/* Basic Information */}
              <div className="space-y-4">
                <div className="grid grid-cols-2 gap-4">
                  <div className="space-y-2">
                    <Label htmlFor="name">Full Name *</Label>
                    <Input
                      id="name"
                      value={formData.name}
                      onChange={(e) => setFormData(prev => ({ ...prev, name: e.target.value }))}
                      required
                    />
                  </div>
                  <div className="space-y-2">
                    <Label htmlFor="email">Email Address *</Label>
                    <Input
                      id="email"
                      type="email"
                      value={formData.email}
                      onChange={(e) => setFormData(prev => ({ ...prev, email: e.target.value }))}
                      required
                    />
                  </div>
                </div>

                <div className="space-y-2">
                  <Label htmlFor="company">Company/Organization *</Label>
                  <Input
                    id="company"
                    value={formData.company}
                    onChange={(e) => setFormData(prev => ({ ...prev, company: e.target.value }))}
                    required
                  />
                </div>

                <div className="space-y-2">
                  <Label htmlFor="useCase">Use Case Description *</Label>
                  <Textarea
                    id="useCase"
                    placeholder="Describe how you plan to use SefTechHub APIs (minimum 10 characters)"
                    value={formData.useCase}
                    onChange={(e) => setFormData(prev => ({ ...prev, useCase: e.target.value }))}
                    required
                    minLength={10}
                    rows={4}
                  />
                </div>
              </div>

              {/* Plan Selection */}
              <div className="space-y-2">
                <Label>Select Plan</Label>
                <Select value={formData.planType} onValueChange={(value: any) => setFormData(prev => ({ ...prev, planType: value }))}>
                  <SelectTrigger>
                    <SelectValue />
                  </SelectTrigger>
                  <SelectContent>
                    {Object.entries(planFeatures).map(([key, plan]) => (
                      <SelectItem key={key} value={key}>
                        <div className="flex items-center gap-2">
                          <span>{plan.name}</span>
                          <Badge variant="outline">{plan.price}</Badge>
                        </div>
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>

              {/* Estimated Volume */}
              <div className="space-y-2">
                <Label htmlFor="estimatedVolume">Estimated Monthly Volume</Label>
                <Input
                  id="estimatedVolume"
                  placeholder="e.g., 10,000 requests/month"
                  value={formData.estimatedVolume}
                  onChange={(e) => setFormData(prev => ({ ...prev, estimatedVolume: e.target.value }))}
                />
              </div>

              {/* Integration Types */}
              <div className="space-y-3">
                <Label>Integration Types (select all that apply)</Label>
                <div className="grid grid-cols-2 gap-3">
                  {integrationTypes.map((type) => (
                    <div key={type.id} className="flex items-center space-x-2">
                      <Checkbox
                        id={type.id}
                        checked={formData.integrationType.includes(type.id)}
                        onCheckedChange={(checked) => handleIntegrationTypeChange(type.id, checked as boolean)}
                      />
                      <Label htmlFor={type.id} className="text-sm">
                        {type.label}
                      </Label>
                    </div>
                  ))}
                </div>
              </div>

              {/* Terms Agreement */}
              <div className="flex items-center space-x-2">
                <Checkbox
                  id="terms"
                  checked={formData.agreedToTerms}
                  onCheckedChange={(checked) => setFormData(prev => ({ ...prev, agreedToTerms: checked as boolean }))}
                  required
                />
                <Label htmlFor="terms" className="text-sm">
                  I agree to the{' '}
                  <a href="/terms" className="text-primary hover:underline">
                    Terms of Service
                  </a>{' '}
                  and{' '}
                  <a href="/privacy" className="text-primary hover:underline">
                    Privacy Policy
                  </a>
                </Label>
              </div>

              {/* Submit Button */}
              <Button type="submit" className="w-full" disabled={isSubmitting || !formData.agreedToTerms}>
                {isSubmitting ? (
                  <>
                    <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                    Submitting Request...
                  </>
                ) : (
                  <>
                    <Zap className="mr-2 h-4 w-4" />
                    Request API Access
                  </>
                )}
              </Button>
            </form>
          </CardContent>
        </Card>

        {/* Plan Details */}
        <div className="space-y-6">
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <Shield className="h-5 w-5 text-primary" />
                {selectedPlan.name}
              </CardTitle>
              <CardDescription>
                <span className="text-2xl font-bold text-foreground">{selectedPlan.price}</span>
              </CardDescription>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="space-y-2">
                <div className="flex justify-between">
                  <span className="text-sm text-muted-foreground">Monthly Requests</span>
                  <span className="font-medium">{selectedPlan.requests}</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-sm text-muted-foreground">Rate Limit</span>
                  <span className="font-medium">{selectedPlan.rateLimit}</span>
                </div>
              </div>
              
              <div className="space-y-2">
                <h4 className="font-medium">Included Features</h4>
                <ul className="space-y-1">
                  {selectedPlan.features.map((feature, index) => (
                    <li key={index} className="flex items-center gap-2 text-sm">
                      <CheckCircle2 className="h-4 w-4 text-green-600 flex-shrink-0" />
                      {feature}
                    </li>
                  ))}
                </ul>
              </div>
            </CardContent>
          </Card>

          {/* Quick Facts */}
          <Card>
            <CardHeader>
              <CardTitle className="text-lg">Quick Facts</CardTitle>
            </CardHeader>
            <CardContent className="space-y-3">
              <div className="flex items-center gap-3">
                <CheckCircle2 className="h-5 w-5 text-green-600" />
                <span className="text-sm">Free tier auto-approved instantly</span>
              </div>
              <div className="flex items-center gap-3">
                <CheckCircle2 className="h-5 w-5 text-green-600" />
                <span className="text-sm">Paid plans reviewed within 24 hours</span>
              </div>
              <div className="flex items-center gap-3">
                <CheckCircle2 className="h-5 w-5 text-green-600" />
                <span className="text-sm">Comprehensive API documentation</span>
              </div>
              <div className="flex items-center gap-3">
                <CheckCircle2 className="h-5 w-5 text-green-600" />
                <span className="text-sm">24/7 monitoring and uptime SLA</span>
              </div>
            </CardContent>
          </Card>
        </div>
      </div>
    </div>
  )
}