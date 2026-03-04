-- ============================================================
-- SEGMENT 1: New Signup Onboarding
-- Priority: 1 of 5
-- Table: wallet_registry + mint_events + collect_events
-- Logic: Signed up in last 14 days AND no mint AND no collect
-- ============================================================

WITH

-- Step 1: Get wallets that signed up in the last 14 days
recent_signups AS (
  SELECT
    wallet_address,
    email,
    signup_date,
    wallet_provider,
    referral_source,
    DATE_DIFF(CURRENT_DATE, signup_date, DAY) AS days_since_signup
  FROM `zora-retention-stack.zora_prod.wallet_registry`
  WHERE
    signup_date >= DATE_SUB(CURRENT_DATE, INTERVAL 14 DAY)
    AND email IS NOT NULL
    AND email_subscribed = TRUE
),

-- Step 2: Find wallets that have already minted (to exclude them)
has_minted AS (
  SELECT DISTINCT wallet_address
  FROM `zora-retention-stack.zora_prod.mint_events`
),

-- Step 3: Find wallets that have already collected (to exclude them)
has_collected AS (
  SELECT DISTINCT wallet_address
  FROM `zora-retention-stack.zora_prod.collect_events`
)

-- Step 4: Return only wallets with NO mint AND NO collect
SELECT
  rs.wallet_address,
  rs.email,
  rs.signup_date,
  rs.wallet_provider,
  rs.referral_source,
  rs.days_since_signup,
  -- This field tells Customer.io which email to send
  CASE
    WHEN rs.days_since_signup = 0           THEN 'day_0'
    WHEN rs.days_since_signup BETWEEN 1 AND 2  THEN 'day_1_2'
    WHEN rs.days_since_signup BETWEEN 3 AND 5  THEN 'day_3_5'
    WHEN rs.days_since_signup BETWEEN 6 AND 9  THEN 'day_6_9'
    WHEN rs.days_since_signup BETWEEN 10 AND 14 THEN 'day_10_14'
  END AS onboarding_stage
FROM recent_signups rs
LEFT JOIN has_minted hm
  ON rs.wallet_address = hm.wallet_address
LEFT JOIN has_collected hc
  ON rs.wallet_address = hc.wallet_address
WHERE
  hm.wallet_address IS NULL   -- exclude anyone who has minted
  AND hc.wallet_address IS NULL  -- exclude anyone who has collected
ORDER BY rs.days_since_signup ASC;
