CREATE TABLE IF NOT EXISTS `zora-retention-stack.zora_prod.wallet_registry`
(
  wallet_address    STRING    NOT NULL,
  email             STRING,
  signup_date       DATE,
  wallet_provider   STRING,
  referral_source   STRING,
  identity_type     STRING,
  email_subscribed  BOOL
)
OPTIONS (
  description = "Core wallet/user spine. One row per wallet address."
);
