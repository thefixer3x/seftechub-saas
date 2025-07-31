-- API Access Requests Table for SefTechHub API Landing Page
-- This extends the existing API key management system

-- Create API access requests table
CREATE TABLE IF NOT EXISTS api_access_requests (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    email TEXT NOT NULL,
    company TEXT NOT NULL,
    use_case TEXT NOT NULL,
    plan_type TEXT NOT NULL CHECK (plan_type IN ('free', 'basic', 'pro', 'enterprise')),
    estimated_volume TEXT,
    integration_type TEXT[] DEFAULT '{}',
    status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected', 'cancelled')),
    user_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    approved_at TIMESTAMP WITH TIME ZONE,
    rejected_at TIMESTAMP WITH TIME ZONE,
    approved_by UUID REFERENCES auth.users(id) ON DELETE SET NULL,
    rejection_reason TEXT,
    metadata JSONB DEFAULT '{}'::jsonb
);

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_api_access_requests_email ON api_access_requests(email);
CREATE INDEX IF NOT EXISTS idx_api_access_requests_status ON api_access_requests(status);
CREATE INDEX IF NOT EXISTS idx_api_access_requests_plan_type ON api_access_requests(plan_type);
CREATE INDEX IF NOT EXISTS idx_api_access_requests_created_at ON api_access_requests(created_at);
CREATE INDEX IF NOT EXISTS idx_api_access_requests_user_id ON api_access_requests(user_id);

-- Enable RLS
ALTER TABLE api_access_requests ENABLE ROW LEVEL SECURITY;

-- RLS Policies
-- Users can only see their own requests
CREATE POLICY "Users can view own requests" ON api_access_requests
    FOR SELECT USING (
        auth.uid() = user_id OR
        email = auth.jwt()->>'email'
    );

-- Users can insert their own requests
CREATE POLICY "Users can create requests" ON api_access_requests
    FOR INSERT WITH CHECK (
        email = auth.jwt()->>'email' OR
        auth.uid() IS NULL  -- Allow anonymous requests
    );

-- Admins can view and modify all requests
CREATE POLICY "Admins can manage all requests" ON api_access_requests
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM auth.users 
            WHERE auth.users.id = auth.uid() 
            AND auth.users.raw_user_meta_data->>'role' = 'admin'
        )
    );

-- Update timestamp function and trigger
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_api_access_requests_updated_at 
    BEFORE UPDATE ON api_access_requests
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

-- Insert sample data for testing (optional)
INSERT INTO api_access_requests (
    name, 
    email, 
    company, 
    use_case, 
    plan_type, 
    estimated_volume,
    integration_type,
    status,
    metadata
) VALUES 
(
    'John Developer',
    'john@example.com',
    'Example Corp',
    'Building a DeFi trading bot that needs access to real-time price feeds and liquidity data across multiple protocols.',
    'basic',
    '5,000 requests/month',
    ARRAY['defi-protocols', 'analytics'],
    'pending',
    '{"source": "sample_data", "created_by": "migration"}'::jsonb
),
(
    'Sarah Finance',
    'sarah@fintech.com',
    'FinTech Solutions Ltd',
    'Enterprise treasury management system requiring multi-chain DeFi integration for yield optimization.',
    'enterprise',
    '100,000 requests/month',
    ARRAY['defi-protocols', 'multi-chain', 'compliance-engine'],
    'approved',
    '{"source": "sample_data", "created_by": "migration"}'::jsonb
);

-- Create view for admin dashboard
CREATE OR REPLACE VIEW api_access_requests_admin AS
SELECT 
    r.*,
    u.email as user_email,
    u.created_at as user_created_at,
    COUNT(ak.id) as api_keys_count,
    SUM(CASE WHEN ak.is_active THEN 1 ELSE 0 END) as active_api_keys_count
FROM api_access_requests r
LEFT JOIN auth.users u ON r.user_id = u.id
LEFT JOIN api_keys ak ON r.user_id = ak.user_id
GROUP BY r.id, u.email, u.created_at
ORDER BY r.created_at DESC;

-- Grant permissions for the view
GRANT SELECT ON api_access_requests_admin TO authenticated;

-- RLS policy for admin view
CREATE POLICY "Admins can view requests admin" ON api_access_requests_admin
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM auth.users 
            WHERE auth.users.id = auth.uid() 
            AND auth.users.raw_user_meta_data->>'role' = 'admin'
        )
    );

-- Create function for auto-approving free tier requests
CREATE OR REPLACE FUNCTION auto_approve_free_tier()
RETURNS TRIGGER AS $$
DECLARE
    new_user_id UUID;
    api_key_hash TEXT;
BEGIN
    -- Only auto-approve free tier requests
    IF NEW.plan_type = 'free' AND NEW.status = 'pending' THEN
        -- Create user account if it doesn't exist
        INSERT INTO auth.users (
            email,
            email_confirmed_at,
            raw_user_meta_data
        ) VALUES (
            NEW.email,
            NOW(),
            jsonb_build_object(
                'name', NEW.name,
                'company', NEW.company,
                'plan_type', 'free',
                'source', 'api_access_request'
            )
        ) 
        ON CONFLICT (email) DO UPDATE SET
            raw_user_meta_data = auth.users.raw_user_meta_data || jsonb_build_object(
                'name', NEW.name,
                'company', NEW.company,
                'plan_type', 'free'
            )
        RETURNING id INTO new_user_id;
        
        -- Get user ID if already existed
        IF new_user_id IS NULL THEN
            SELECT id INTO new_user_id FROM auth.users WHERE email = NEW.email;
        END IF;
        
        -- Generate API key hash (simplified for this example)
        api_key_hash := 'sk_' || gen_random_uuid()::text || gen_random_uuid()::text;
        
        -- Create API key
        INSERT INTO api_keys (
            user_id,
            key_hash,
            name,
            description,
            rate_limit_per_hour,
            metadata
        ) VALUES (
            new_user_id,
            api_key_hash,
            'Auto-generated Free Tier Key',
            'Automatically generated for free tier access',
            100,
            jsonb_build_object(
                'plan_type', 'free',
                'auto_generated', true,
                'request_id', NEW.id
            )
        );
        
        -- Update request status
        NEW.status := 'approved';
        NEW.approved_at := NOW();
        NEW.user_id := new_user_id;
        NEW.metadata := NEW.metadata || jsonb_build_object(
            'auto_approved', true,
            'api_key_generated', true
        );
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create trigger for auto-approval
CREATE TRIGGER auto_approve_free_tier_trigger
    BEFORE INSERT ON api_access_requests
    FOR EACH ROW
    EXECUTE FUNCTION auto_approve_free_tier();

-- Add comments for documentation
COMMENT ON TABLE api_access_requests IS 'Stores API access requests from the landing page';
COMMENT ON COLUMN api_access_requests.plan_type IS 'The requested plan type: free, basic, pro, or enterprise';
COMMENT ON COLUMN api_access_requests.integration_type IS 'Array of integration types the user is interested in';
COMMENT ON COLUMN api_access_requests.status IS 'Request status: pending, approved, rejected, or cancelled';
COMMENT ON COLUMN api_access_requests.metadata IS 'Additional data including source, user agent, IP address, etc.';

-- Create notification for admin when new requests are submitted
CREATE OR REPLACE FUNCTION notify_admin_new_request()
RETURNS TRIGGER AS $$
BEGIN
    -- Only notify for non-free tier requests (free tier is auto-approved)
    IF NEW.plan_type != 'free' THEN
        -- This would typically call a notification service
        -- For now, we'll just log it
        RAISE NOTICE 'New API access request submitted: % - % (% plan)', NEW.name, NEW.email, NEW.plan_type;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER notify_admin_new_request_trigger
    AFTER INSERT ON api_access_requests
    FOR EACH ROW
    EXECUTE FUNCTION notify_admin_new_request();