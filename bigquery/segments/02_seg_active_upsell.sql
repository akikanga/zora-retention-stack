-- ============================================================
-- SEGMENT 2: Active Users Upsell (Power Creators + Collectors)
-- Priority: 2 of 5
-- NOTE: Threshold set to ≥2 for seed data validation.
--       In production with real Zora data, raise to ≥3 or
--       use PERCENT_RANK() top 10% approach.
-- ============================================================

WITH

active_creators AS (
  SELECT
    wallet_address,
    COUNT(*)            AS mints_last_30d,
    SUM(mint_price_eth) AS earnings_eth_30d
  FROM `zora-retention-stack.zora_prod.mint_events`
  WHERE mint_date >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 30 DAY)
  GROUP BY wallet_address
  HAVING COUNT(*) >= 2        -- production: raise to ≥3
),

active_collectors AS (
  SELECT
    wallet_address,
    COUNT(*)                AS collects_last_30d,
    SUM(collect_price_eth)  AS spend_eth_30d
  FROM `zora-retention-stack.zora_prod.collect_events`
  WHERE collect_date >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 30 DAY)
  GROUP BY wallet_address
  HAVING COUNT(*) >= 2        -- production: raise to ≥3
),

creators_tagged AS (
  SELECT
    w.wallet_address,
    w.email,
    w.identity_type,
    ac.mints_last_30d,
    ac.earnings_eth_30d,
    0    AS collects_last_30d,
    0.0  AS spend_eth_30d,
    'power_creator' AS power_user_type
  FROM active_creators ac
  INNER JOIN `zora-retention-stack.zora_prod.wallet_registry` w
    ON ac.wallet_address = w.wallet_address
  WHERE w.email IS NOT NULL
    AND w.email_subscribed = TRUE
),

collectors_tagged AS (
  SELECT
    w.wallet_address,
    w.email,
    w.identity_type,
    0    AS mints_last_30d,
    0.0  AS earnings_eth_30d,
    col.collects_last_30d,
    col.spend_eth_30d,
    'power_collector' AS power_user_type
  FROM active_collectors col
  INNER JOIN `zora-retention-stack.zora_prod.wallet_registry` w
    ON col.wallet_address = w.wallet_address
  WHERE w.email IS NOT NULL
    AND w.email_subscribed = TRUE
)

SELECT * FROM creators_tagged
UNION ALL
SELECT * FROM collectors_tagged
ORDER BY earnings_eth_30d DESC, spend_eth_30d DESC;
