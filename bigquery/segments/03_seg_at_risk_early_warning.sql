WITH

creator_activity AS (
  SELECT
    wallet_address,
    MAX(mint_date)  AS last_mint_date,
    COUNT(*)        AS total_mints,
    DATE_DIFF(
      CURRENT_DATE,
      DATE(MAX(mint_date)),
      DAY
    )               AS days_since_mint
  FROM `zora-retention-stack.zora_prod.mint_events`
  GROUP BY wallet_address
),

collector_activity AS (
  SELECT
    wallet_address,
    MAX(collect_date)  AS last_collect_date,
    COUNT(*)           AS total_collects,
    DATE_DIFF(
      CURRENT_DATE,
      DATE(MAX(collect_date)),
      DAY
    )                  AS days_since_collect
  FROM `zora-retention-stack.zora_prod.collect_events`
  GROUP BY wallet_address
),

at_risk_creators AS (
  SELECT
    w.wallet_address,
    w.email,
    'creator'               AS identity_type,
    ca.days_since_mint      AS days_since_activity,
    ca.total_mints          AS total_actions,
    ca.last_mint_date       AS last_activity_date
  FROM creator_activity ca
  INNER JOIN `zora-retention-stack.zora_prod.wallet_registry` w
    ON ca.wallet_address = w.wallet_address
  WHERE
    ca.days_since_mint BETWEEN 45 AND 89
    AND w.email IS NOT NULL
    AND w.email_subscribed = TRUE
),

at_risk_collectors AS (
  SELECT
    w.wallet_address,
    w.email,
    'collector'                  AS identity_type,
    cola.days_since_collect      AS days_since_activity,
    cola.total_collects          AS total_actions,
    cola.last_collect_date       AS last_activity_date
  FROM collector_activity cola
  INNER JOIN `zora-retention-stack.zora_prod.wallet_registry` w
    ON cola.wallet_address = w.wallet_address
  WHERE
    cola.days_since_collect BETWEEN 45 AND 89
    AND w.email IS NOT NULL
    AND w.email_subscribed = TRUE
)

SELECT * FROM at_risk_creators
UNION ALL
SELECT * FROM at_risk_collectors
ORDER BY days_since_activity DESC;
