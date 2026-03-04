-- ============================================================
-- SEGMENT 2: Active Users Upsell (Power Creators + Collectors)
-- Priority: 2 of 5
-- Logic: Top creators (≥3 mints in 30 days) OR
--        Top collectors (≥3 collects in 30 days)
-- ============================================================

WITH

-- Step 1: Count mints per creator in last 30 days
active_creators AS (
  SELECT
    wallet_address,
    COUNT(*)              AS mints_last_30d,
    SUM(mint_price_eth)   AS earnings_eth_30d
  FROM `zora-retention-stack.zora_prod.mint_events`
  WHERE mint_date >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 30 DAY)
  GROUP BY wallet_address
  HAVING COUNT(*) >= 3
),

-- Step 2: Count collects per collector in last 30 days
active_collectors AS (
  SELECT
    wallet_address,
    COUNT(*)                AS collects_last_30d,
    SUM(collect_price_eth)  AS spend_eth_30d
  FROM `zora-retention-stack.zora_prod.collect_events`
  WHERE collect_date >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 30 DAY)
  GROUP BY wallet_address
  HAVING COUNT(*) >= 3
)

-- Step 3: Join to wallet registry, label identity type
SELECT
  w.wallet_address,
  w.email,
  w.identity_type,
  COALESCE(ac.mints_last_30d, 0)      AS mints_last_30d,
  COALESCE(ac.earnings_eth_30d, 0)    AS earnings_eth_30d,
  COALESCE(col.collects_last_30d, 0)  AS collects_last_30d,
  COALESCE(col.spend_eth_30d, 0)      AS spend_eth_30d,
  -- Label for Customer.io campaign branching
  CASE
    WHEN ac.wallet_address IS NOT NULL
     AND col.wallet_address IS NOT NULL THEN 'power_both'
    WHEN ac.wallet_address IS NOT NULL  THEN 'power_creator'
    ELSE                                     'power_collector'
  END AS power_user_type
FROM `zora-retention-stack.zora_prod.wallet_registry` w
INNER JOIN active_creators ac
  ON w.wallet_address = ac.wallet_address
FULL OUTER JOIN active_collectors col
  ON w.wallet_address = col.wallet_address
WHERE
  w.email IS NOT NULL
  AND w.email_subscribed = TRUE
ORDER BY earnings_eth_30d DESC, spend_eth_30d DESC;
