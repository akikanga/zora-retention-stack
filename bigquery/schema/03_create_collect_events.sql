CREATE TABLE IF NOT EXISTS `zora-retention-stack.zora_prod.collect_events`
(
  wallet_address      STRING     NOT NULL,
  creator_wallet      STRING,
  token_id            STRING,
  collect_date        TIMESTAMP,
  collect_price_eth   FLOAT64,
  chain               STRING
)
OPTIONS (
  description = "One row per collect action by a collector wallet."
);
