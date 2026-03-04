CREATE SCHEMA IF NOT EXISTS `zora-retention-stack.hightouch_planner`;
GRANT `roles/bigquery.dataViewer`, `roles/bigquery.dataEditor`
ON SCHEMA `zora-retention-stack.hightouch_planner`
TO "serviceAccount:hightouch-bigquery-reader@zora-retention-stack.iam.gserviceaccount.com";
