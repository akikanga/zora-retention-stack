-- ============================================================
-- SEGMENT 4: Dormant Creators
-- Priority: 4 of 5
-- Logic: Has minted at least once AND last mint > 90 days ago
-- ============================================================

WITH

-- Step 1: Aggregate mint activity per creator
mint_summary AS (
  SELECT
    wallet_address,
    COUNT(*)                                          AS total_mints,
    MAX(mint_date)                                    AS last_mint_date,
    SUM(mint_price_eth)                               AS creator_earnings_eth,
    DATE_DIFF(CURRENT_DATE, DATE(MAX(mint_date)), DAY) AS days_dormant,
    APPROX_TOP_COUNT(mint_type, 1)[OFFSET(0)].value   AS top_category
  FROM `zora-retention-stack.zora_prod.mint_events`
  GROUP BY wallet_address
),

-- Step 2: Follower counts for email personalization
-- drives copy: "X collectors are looking for art like yours"
follower_counts AS (
  SELECT
    creator_wallet,
    COUNTIF(is_active = TRUE) AS follower_count
  FROM `zora-retention-stack.zora_prod.follow_events`
  GROUP BY creator_wallet
),

-- Step 3: Dormancy bucket for email copy variation
-- 90–119 days gets softer tone than 180+ days
dormant_creators AS (
  SELECT
    w.wallet_address,
    w.email,
    w.signup_date,
    w.referral_source,
    ms.total_mints,
    ms.last_mint_date,
    ms.creator_earnings_eth,
    ms.days_dormant,
    ms.top_category,
    COALESCE(fc.follower_count, 0) AS follower_count,
    CASE
      WHEN ms.days_dormant BETWEEN 90  AND 119 THEN '90_119d'
      WHEN ms.days_dormant BETWEEN 120 AND 179 THEN '120_179d'
      WHEN ms.days_dormant >= 180              THEN '180d_plus'
    END AS dormancy_bucket
  FROM `zora-retention-stack.zora_prod.wallet_registry` w
  INNER JOIN mint_summary ms
    ON w.wallet_address = ms.wallet_address
  LEFT JOIN follower_counts fc
    ON w.wallet_address = fc.creator_wallet
  WHERE
    ms.total_mints >= 1
    AND ms.days_dormant >= 90
    AND w.email IS NOT NULL
    AND w.email_subscribed = TRUE
)

SELECT * FROM dormant_creators
ORDER BY days_dormant ASC;
