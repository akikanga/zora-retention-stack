INSERT INTO `zora-retention-stack.zora_prod.collect_events`
  (wallet_address, creator_wallet, token_id, collect_date, collect_price_eth, chain)
VALUES
  -- collector1: dormant (last collect > 90 days ago)
  ('0xBBB001', '0xAAA001', 'tok001', TIMESTAMP '2024-01-20 11:00:00', 0.05, 'zora'),
  ('0xBBB001', '0xAAA002', 'tok004', TIMESTAMP '2024-03-10 14:00:00', 0.03, 'zora'),
  ('0xBBB001', '0xAAA001', 'tok003', TIMESTAMP '2024-04-01 09:00:00', 0.08, 'base'),
  -- collector2: dormant
  ('0xBBB002', '0xAAA002', 'tok005', TIMESTAMP '2024-02-28 10:00:00', 0.03, 'zora'),
  ('0xBBB002', '0xAAA003', 'tok006', TIMESTAMP '2024-05-15 15:00:00', 0.10, 'ethereum'),
  -- collector3: at risk (last collect ~50 days ago)
  ('0xBBB003', '0xAAA001', 'tok002', TIMESTAMP '2024-08-15 12:00:00', 0.05, 'zora'),
  ('0xFFF002', '0xAAA003', 'tok007', TIMESTAMP '2024-09-05 10:00:00', 0.10, 'ethereum'),
  ('0xFFF002', '0xAAA001', 'tok001', TIMESTAMP '2024-09-15 14:00:00', 0.05, 'zora'),
  -- collector4: active power collector
  ('0xBBB004', '0xAAA004', 'tok010', TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 4  DAY), 0.15, 'zora'),
  ('0xBBB004', '0xAAA004', 'tok011', TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 9  DAY), 0.15, 'zora'),
  ('0xBBB004', '0xAAA005', 'tok014', TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 14 DAY), 0.05, 'base'),
  ('0xBBB004', '0xAAA004', 'tok012', TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 18 DAY), 0.20, 'zora'),
  ('0xBBB004', '0xAAA005', 'tok015', TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 22 DAY), 0.05, 'base'),
  -- collector5: active
  ('0xBBB005', '0xAAA004', 'tok013', TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 6  DAY), 0.20, 'zora'),
  ('0xBBB005', '0xAAA005', 'tok014', TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 11 DAY), 0.05, 'base'),
  -- both1: collector side active
  ('0xCCC001', '0xAAA004', 'tok010', TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 7  DAY), 0.15, 'zora'),
  ('0xCCC002', '0xAAA005', 'tok015', TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 9  DAY), 0.05, 'base');
