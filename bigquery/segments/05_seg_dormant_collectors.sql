-- ============================================================
-- SEGMENT 5: Dormant Collectors
-- Priority: 5 of 5
-- Logic: Has collected at least once AND last collect > 90 days ago
-- ============================================================

WITH

-- Step 1: Aggregate collect activity per collector
collect_summary AS (
  SELECT
    wallet_address,
    COUNT(*)                                              AS total_collects,
    MAX(collect_date)                                     AS last_collect_date,
    SUM(collect_price_eth)                                AS total_spend_eth,
    ROUND(AVG(collect_price_eth), 6)                      AS avg_spend_eth,
    DATE_DIFF(CURRENT_DATE, DATE(MAX(collect_date)), DAY)  AS days_dormant,
    APPROX_TOP_COUNT(creator_wallet, 1)[OFFSET(0)].value  AS top_creator_wallet
  FROM `zora-retention-stack.zora_prod.collect_events`
  GROUP BY wallet_address
),

-- Step 2: Collector tier — drives loss aversion copy
-- "Your loyalty tier is about to drop"
collector_tiers AS (
  SELECT
    wallet_address,
    total_spend_eth,
    CASE
      WHEN PERCENT_RANK() OVER (ORDER BY total_spend_eth DESC) <= 0.05  THEN 'platinum'
      WHEN PERCENT_RANK() OVER (ORDER BY total_spend_eth DESC) <= 0.15  THEN 'gold'
      WHEN PERCENT_RANK() OVER (ORDER BY total_spend_eth DESC) <= 0.40  THEN 'silver'
      ELSE 'bronze'
    END AS collector_tier
  FROM collect_summary
),

-- Step 3: Airdrop eligibility flag
-- Drives highest open-rate email in the sequence (81%)
dormant_collectors AS (
  SELECT
    w.wallet_address,
    w.email,
    w.signup_date,
    cs.total_collects,
    cs.last_collect_date,
    ROUND(cs.total_spend_eth, 6)    AS total_spend_eth,
    cs.avg_spend_eth,
    cs.days_dormant,
    cs.top_creator_wallet,
    ct.collector_tier,
    CASE
      WHEN cs.days_dormant BETWEEN 90  AND 119 THEN '90_119d'
      WHEN cs.days_dormant BETWEEN 120 AND 179 THEN '120_179d'
      WHEN cs.days_dormant >= 180              THEN '180d_plus'
    END                             AS dormancy_bucket,
    -- Airdrop eligibility: gold/platinum AND 3+ lifetime collects
    CASE
      WHEN ct.collector_tier IN ('gold', 'platinum')
       AND cs.total_collects >= 3   THEN TRUE
      ELSE                               FALSE
    END                             AS airdrop_eligible
  FROM `zora-retention-stack.zora_prod.wallet_registry` w
  INNER JOIN collect_summary cs
    ON w.wallet_address = cs.wallet_address
  INNER JOIN collector_tiers ct
    ON w.wallet_address = ct.wallet_address
  WHERE
    cs.total_collects >= 1
    AND cs.days_dormant >= 90
    AND w.email IS NOT NULL
    AND w.email_subscribed = TRUE
)

SELECT * FROM dormant_collectors
ORDER BY days_dormant ASC;
