CREATE OR REPLACE TABLE `zora-retention-stack.zora_prod.mint_events` AS
SELECT DISTINCT *
FROM (
  SELECT
    wallet_address,
    token_id,
    collection_address,
    mint_price_eth,
    chain,
    mint_type,
    -- Keep only the earliest mint_date per token
    MIN(mint_date) OVER (
      PARTITION BY wallet_address, token_id
    ) AS mint_date
  FROM `zora-retention-stack.zora_prod.mint_events`
)
ORDER BY wallet_address, mint_date;
