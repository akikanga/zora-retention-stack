INSERT INTO `zora-retention-stack.zora_prod.mint_events`
  (wallet_address, token_id, collection_address, mint_date, mint_price_eth, chain, mint_type)
VALUES
  ('0xAAA001', 'tok001', '0xCOLL01', TIMESTAMP '2024-01-15 10:00:00', 0.05, 'zora',     'creator_drop'),
  ('0xAAA001', 'tok002', '0xCOLL01', TIMESTAMP '2024-02-10 14:00:00', 0.05, 'zora',     'creator_drop'),
  ('0xAAA001', 'tok003', '0xCOLL01', TIMESTAMP '2024-03-05 09:00:00', 0.08, 'base',     'edition'),
  ('0xAAA002', 'tok004', '0xCOLL02', TIMESTAMP '2024-02-20 11:00:00', 0.03, 'zora',     'open_edition'),
  ('0xAAA002', 'tok005', '0xCOLL02', TIMESTAMP '2024-04-01 15:00:00', 0.03, 'zora',     'open_edition'),
  ('0xAAA003', 'tok006', '0xCOLL03', TIMESTAMP '2024-08-01 10:00:00', 0.10, 'ethereum', 'creator_drop'),
  ('0xAAA003', 'tok007', '0xCOLL03', TIMESTAMP '2024-09-01 12:00:00', 0.10, 'ethereum', 'creator_drop'),
  ('0xFFF001', 'tok008', '0xCOLL04', TIMESTAMP '2024-09-10 08:00:00', 0.02, 'base',     'edition'),
  ('0xFFF001', 'tok009', '0xCOLL04', TIMESTAMP '2024-09-20 16:00:00', 0.02, 'base',     'edition'),
  ('0xAAA004', 'tok010', '0xCOLL05', TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 5  DAY), 0.15, 'zora', 'creator_drop'),
  ('0xAAA004', 'tok011', '0xCOLL05', TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 10 DAY), 0.15, 'zora', 'creator_drop'),
  ('0xAAA004', 'tok012', '0xCOLL05', TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 15 DAY), 0.20, 'zora', 'edition'),
  ('0xAAA004', 'tok013', '0xCOLL05', TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 20 DAY), 0.20, 'zora', 'edition'),
  ('0xAAA005', 'tok014', '0xCOLL06', TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 3  DAY), 0.05, 'base', 'open_edition'),
  ('0xAAA005', 'tok015', '0xCOLL06', TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 7  DAY), 0.05, 'base', 'open_edition'),
  ('0xCCC001', 'tok016', '0xCOLL07', TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 8  DAY), 0.12, 'zora', 'creator_drop'),
  ('0xCCC001', 'tok017', '0xCOLL07', TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 12 DAY), 0.12, 'zora', 'creator_drop');
