SELECT 'wallet_registry' AS tbl, COUNT(*) AS `rows` FROM `zora-retention-stack.zora_prod.wallet_registry`
UNION ALL
SELECT 'mint_events',            COUNT(*) FROM `zora-retention-stack.zora_prod.mint_events`
UNION ALL
SELECT 'collect_events',         COUNT(*) FROM `zora-retention-stack.zora_prod.collect_events`
UNION ALL
SELECT 'follow_events',          COUNT(*) FROM `zora-retention-stack.zora_prod.follow_events`;
