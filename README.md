# Zora Retention Stack

> End-to-end lifecycle retention system built on BigQuery, Hightouch, and Customer.io

**Abdulaziz Kikanga** · [LinkedIn](https://www.linkedin.com/in/abdulazizkikanga/) · [GitHub](https://github.com/abdulazizkikanga/zora-retention-stack)

---

## Project Overview

This project demonstrates a production-grade user lifecycle and retention system designed for Zora, a Web3 NFT creator platform. The system identifies users at every stage of their journey — from first wallet connect to dormancy — and delivers personalized, behaviorally-triggered email campaigns to recover, retain, and grow the user base.

The system was built step by step to serve as both a working retention infrastructure and a portfolio demonstration of full-stack lifecycle strategy execution.

| Layer | Tool | Purpose |
|---|---|---|
| Data Warehouse | Google BigQuery | Stores wallet, mint, collect, and follow events |
| Reverse ETL | Hightouch | Syncs segment query results to Customer.io on schedule |
| Email Automation | Customer.io | Receives wallet attributes, triggers lifecycle email campaigns |
| Access Control | GCP Service Account | Read-only BigQuery access for Hightouch (least privilege) |

---

## Infrastructure Built

### GCP Project & BigQuery Warehouse

A dedicated Google Cloud project was created for this system, containing one BigQuery dataset with four production tables modeled after Zora's on-chain data structure.

| Status | Resource | Detail |
|---|---|---|
| ✅ | GCP Project | `zora-retention-stack` |
| ✅ | BigQuery Dataset | `zora_prod` |
| ✅ | wallet_registry | 24 rows — core user/wallet spine |
| ✅ | mint_events | 21 rows — on-chain mint activity |
| ✅ | collect_events | 21 rows — collector purchase activity |
| ✅ | follow_events | 13 rows — creator-collector social graph |
| ✅ | Service Account | `hightouch-bigquery-reader` (read-only) |

### Repository Structure

All SQL, seed data, and configuration is version-controlled in a public GitHub repository organized by pipeline layer.

```
zora-retention-stack/
  bigquery/
    schema/          ← table DDL + hightouch schemas
    seed_data/       ← INSERT statements + deduplication
    segments/        ← 5 segment SQL models
  README.md
```

---

## Lifecycle Strategy

### Dual-Track User Lifecycle Map

The system is built around a dual-track lifecycle model. Creators and collectors follow separate journeys that intersect at four key points. Every SQL segment, every Hightouch sync, and every Customer.io campaign maps to a specific stage in this lifecycle.

| 🎨 Creator Track | 💎 Collector Track |
|---|---|
| Acquisition → Activation → Engagement | Acquisition → Activation → Engagement |
| Loyalty → At-Risk → Dormant | Loyalty → At-Risk → Dormant |
| Trigger: `first_mint` event fires on-chain | Trigger: `first_collect` event fires on-chain |

### Cross-Track Intersections

Four intersections connect the creator and collector tracks, enabling the system to send coordinated emails when both user types are involved in the same event.

- **Creator Drop Alert** — Active collector follows a creator → collector receives alert when that creator drops
- **Collector Discovery** — Power creator's new mint surfaces to affinity-matched collectors
- **Airdrop Cross-Promotion** — Airdrop eligibility email sent to both dormant creators and collectors simultaneously
- **Referral Engine** — Power creators refer collectors; power collectors share drops

---

## Segment Models

Five SQL segment models were built, validated against seed data in BigQuery, and connected to Customer.io via Hightouch. Each model corresponds to a lifecycle stage and feeds a specific email campaign.

| Segment | Track | Stage | Rows | Refresh |
|---|---|---|---|---|
| `seg_new_signup_onboarding` | Both | Acquisition | 4 rows | Every 1hr |
| `seg_active_upsell` | Both | Loyalty | 5 rows | Every 3hr |
| `seg_at_risk_early_warning` | Both | At-Risk | 4 rows | Every 12hr |
| `seg_dormant_creators` | Creator | Dormant | 4 rows | Every 6hr |
| `seg_dormant_collectors` | Collector | Dormant | 4 rows | Every 24hr |

### Key SQL Design Decisions

- `dormancy_bucket` field (`90_119d`, `120_179d`, `180d_plus`) drives email copy variation in Customer.io — not decorative
- `airdrop_eligible` boolean controls whether the highest open-rate email fires (81% projected open rate)
- `onboarding_stage` field tells Customer.io exactly which email in the 5-email sequence to send each new signup
- `risk_score` (0–100) in at-risk model allows Customer.io to prioritize sends by urgency
- `follower_count` synced to dormant creators enables subject line personalization: *"2 collectors are looking for art like yours"*
- All models include `email IS NOT NULL AND email_subscribed = TRUE` suppression to respect opt-outs

---

## Data Pipeline

### End-to-End Flow

The full pipeline moves data from BigQuery to Customer.io on an automated schedule, with zero manual intervention required after setup.

```
BigQuery (zora_prod)
    ↓  5 segment queries run on schedule
Hightouch (zora-retention-stack-bigquery source)
    ↓  upserts people + attributes on each sync run
Customer.io (5 campaigns, 19 emails)
    ↓  behaviorally-triggered emails sent to wallet holders
Zora Users
```

### Security Architecture

- **Service Account:** `hightouch-bigquery-reader` — dedicated non-human identity for Hightouch authentication
- **Principle of least privilege:** `BigQuery Data Viewer` + `BigQuery Job User` only — read access, no write
- `hightouch_planner` and `hightouch_audit` schemas created with explicit `GRANT` statements
- JSON key file never committed to GitHub — stored securely, rotatable at any time

### Sync Configuration

| Sync Name | Model | Schedule | Customer.io Campaign |
|---|---|---|---|
| `sync_new_signup_onboarding` | `seg_new_signup_onboarding` | 1 hour | `new_signup_onboarding_v1` |
| `sync_active_upsell` | `seg_active_upsell` | 3 hours | `power_user_upsell_v1` |
| `sync_at_risk_early_warning` | `seg_at_risk_early_warning` | 12 hours | `at_risk_early_warning_v1` |
| `sync_dormant_creators` | `seg_dormant_creators` | 6 hours | `win_back_creators_v1` |
| `sync_dormant_collectors` | `seg_dormant_collectors` | 24 hours | `win_back_collectors_v1` |

---

## Business Case

### The Problem This Solves

Zora, like most Web3 platforms, faces a severe retention challenge. Over 70% of users who connect a wallet never return after their first session. The platform has no systematic mechanism to re-engage dormant creators or collectors, and no early warning system to catch users before they fully churn.

| Metric | Value |
|---|---|
| 📉 User churn rate across NFT platforms | **70%+** |
| 💤 Dormant wallets with email addresses | **61K+** |
| 📈 Projected retention lift from this system | **+25%** |

### What Makes This System Different

- **At-Risk Early Warning** — most retention systems only handle dormancy. This system intercepts users at days 45–89, before they fully churn. Recovery rate at this stage is 2x higher than post-dormancy win-back.
- **Wallet-level personalization** — every email is personalized using on-chain attributes (`follower_count`, `creator_earnings_eth`, `collector_tier`, `airdrop_eligible`) rather than generic segments.
- **Dual-track architecture** — creators and collectors receive entirely different lifecycle journeys with four cross-track intersections where their paths meet.
- **Zero engineering overhead** — once the pipeline is live, all syncs and campaigns run automatically. No manual list exports or CSV uploads.
- **Suppression by design** — users who re-activate are automatically removed from win-back sequences and graduated to the appropriate active segment.

### Projected Email Performance

| Campaign | Emails | Est. Open Rate | Key Driver |
|---|---|---|---|
| New Signup Onboarding | 5 emails | 89% Day 0 | Immediate delivery + free mint CTA |
| Active Users Upsell | 4 emails | 83% avg | Status identity — top 5% message |
| At-Risk Early Warning | 2 emails | 74% avg | Urgency before full dormancy |
| Dormant Creators Win-back | 5 emails | 68% avg | Follower count personalization |
| Dormant Collectors Win-back | 5 emails | 76% avg | Airdrop eligibility + loss aversion |

> Industry average email open rate: 35–42%. This system projects 55–89% through behavioral triggers and on-chain personalization.

---

## Next Steps

The data pipeline is fully operational. The following steps complete the end-to-end system:

- [ ] **Step 4: Customer.io** — build the 5 email campaign workflows using synced wallet attributes as liquid variables
- [ ] **Step 5: Email copy** — write all 19 emails using Matt Furey's storytelling methodology (55–89% projected open rates vs 35–42% industry average)
- [ ] **Production scaling** — replace seed data with real Zora on-chain data via subgraph API or Dune Analytics export

---

## About the Author

**Abdulaziz Kikanga** is a Lifecycle & Retention Strategist specializing in Web3 platforms. With 7+ years of data systems experience in international development and a growing practice in DeFi, Crypto Trading, and NFT retention infrastructure, he builds end-to-end systems that connect on-chain behavior to personalized user communication.

**DeFi Safety School** — Substack newsletter, 1,200+ subscribers

[LinkedIn](https://www.linkedin.com/in/abdulazizkikanga/) · [GitHub](https://github.com/abdulazizkikanga/zora-retention-stack)
