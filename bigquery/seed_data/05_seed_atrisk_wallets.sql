-- Add at-risk wallets with activity in the 45–89 day window
INSERT INTO `zora-retention-stack.zora_prod.wallet_registry`
  (wallet_address, email, signup_date, wallet_provider, referral_source, identity_type, email_subscribed)
VALUES
  ('0xGGG001', 'atrisk_creator1@gmail.com',   DATE_SUB(CURRENT_DATE, INTERVAL 100 DAY), 'metamask', NULL, 'creator',   TRUE),
  ('0xGGG002', 'atrisk_creator2@gmail.com',   DATE_SUB(CURRENT_DATE, INTERVAL 110 DAY), 'rainbow',  NULL, 'creator',   TRUE),
  ('0xGGG003', 'atrisk_collector1@gmail.com', DATE_SUB(CURRENT_DATE, INTERVAL 105 DAY), 'metamask', NULL, 'collector', TRUE),
  ('0xGGG004', 'atrisk_collector2@gmail.com', DATE_SUB(CURRENT_DATE, INTERVAL 108 DAY), 'rainbow',  NULL, 'collector', TRUE);

  -- At-risk creator mints: 50–75 days ago
INSERT INTO `zora-retention-stack.zora_prod.mint_events`
  (wallet_address, token_id, collection_address, mint_date, mint_price_eth, chain, mint_type)
VALUES
  ('0xGGG001', 'tok018', '0xCOLL08',
    TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 50 DAY), 0.05, 'zora', 'creator_drop'),
  ('0xGGG001', 'tok019', '0xCOLL08',
    TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 60 DAY), 0.05, 'zora', 'creator_drop'),
  ('0xGGG002', 'tok020', '0xCOLL09',
    TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 55 DAY), 0.08, 'base', 'edition'),
  ('0xGGG002', 'tok021', '0xCOLL09',
    TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 75 DAY), 0.08, 'base', 'edition');

    -- At-risk collector collects: 50–75 days ago
INSERT INTO `zora-retention-stack.zora_prod.collect_events`
  (wallet_address, creator_wallet, token_id, collect_date, collect_price_eth, chain)
VALUES
  ('0xGGG003', '0xAAA001', 'tok001',
    TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 52 DAY), 0.05, 'zora'),
  ('0xGGG003', '0xAAA002', 'tok004',
    TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 65 DAY), 0.03, 'zora'),
  ('0xGGG004', '0xAAA003', 'tok006',
    TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 58 DAY), 0.10, 'ethereum'),
  ('0xGGG004', '0xAAA001', 'tok002',
    TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 70 DAY), 0.05, 'zora');
