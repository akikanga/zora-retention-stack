INSERT INTO `zora-retention-stack.zora_prod.wallet_registry`
  (wallet_address, email, signup_date, wallet_provider, referral_source, identity_type, email_subscribed)
VALUES
  ('0xAAA001', 'creator1@gmail.com',   DATE '2023-06-15', 'metamask',        NULL,        'creator',   TRUE),
  ('0xAAA002', 'creator2@gmail.com',   DATE '2023-08-20', 'rainbow',         '0xAAA001',  'creator',   TRUE),
  ('0xAAA003', 'creator3@gmail.com',   DATE '2024-01-10', 'coinbase_wallet', NULL,        'creator',   TRUE),
  ('0xAAA004', 'creator4@gmail.com',   DATE '2024-03-05', 'metamask',        '0xAAA001',  'creator',   TRUE),
  ('0xAAA005', 'creator5@gmail.com',   DATE '2024-07-01', 'rainbow',         NULL,        'creator',   TRUE),
  ('0xBBB001', 'collector1@gmail.com', DATE '2023-09-10', 'metamask',        NULL,        'collector', TRUE),
  ('0xBBB002', 'collector2@gmail.com', DATE '2023-11-22', 'rainbow',         '0xBBB001',  'collector', TRUE),
  ('0xBBB003', 'collector3@gmail.com', DATE '2024-02-14', 'coinbase_wallet', NULL,        'collector', TRUE),
  ('0xBBB004', 'collector4@gmail.com', DATE '2024-04-30', 'metamask',        '0xAAA002',  'collector', TRUE),
  ('0xBBB005', 'collector5@gmail.com', DATE '2024-06-18', 'rainbow',         NULL,        'collector', TRUE),
  ('0xCCC001', 'both1@gmail.com',      DATE '2023-07-04', 'metamask',        NULL,        'both',      TRUE),
  ('0xCCC002', 'both2@gmail.com',      DATE '2024-05-11', 'rainbow',         '0xCCC001',  'both',      TRUE),
  ('0xDDD001', 'newuser1@gmail.com',   CURRENT_DATE - 2,  'metamask',        NULL,        'unknown',   TRUE),
  ('0xDDD002', 'newuser2@gmail.com',   CURRENT_DATE - 5,  'rainbow',         '0xAAA003',  'unknown',   TRUE),
  ('0xDDD003', 'newuser3@gmail.com',   CURRENT_DATE - 8,  'coinbase_wallet', NULL,        'unknown',   TRUE),
  ('0xDDD004', 'newuser4@gmail.com',   CURRENT_DATE - 11, 'metamask',        NULL,        'unknown',   TRUE),
  ('0xEEE001', 'nosub1@gmail.com',     DATE '2023-10-01', 'metamask',        NULL,        'creator',   FALSE),
  ('0xEEE002', NULL,                   DATE '2024-01-20', 'rainbow',         NULL,        'collector', TRUE),
  ('0xFFF001', 'atrisk1@gmail.com',    DATE '2023-12-01', 'metamask',        NULL,        'creator',   TRUE),
  ('0xFFF002', 'atrisk2@gmail.com',    DATE '2024-02-28', 'rainbow',         NULL,        'collector', TRUE);
