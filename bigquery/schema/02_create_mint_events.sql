CREATE TABLE IF NOT EXISTS `zora-retention-stack.zora_prod.mint_events`
(
  wallet_address      STRING     NOT NULL,
  token_id            STRING,
  collection_address  STRING,
  mint_date           TIMESTAMP,
  mint_price_eth      FLOAT64,
  chain               STRING,
  mint_type           STRING
)
OPTIONS (
  description = "One row per on-chain mint. Sourced from Zora protocol."
);
