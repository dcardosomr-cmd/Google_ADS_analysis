# Inspira Hotels — Google Ads & GA4 Performance Analysis (2023–2025)

## Project Overview

This project analyses Google Ads and GA4 performance data for Inspira Hotels, a boutique hotel group in Lisbon with two properties: Inspira Liberdade and Inspira Santos. The analysis covers January 2023 to March 2026 and is based on data extracted via an automated Python pipeline connecting the Google Ads API and GA4 API to SQL Server, visualised in Power BI.

The goal was to identify what is working, what is not, where budget should be reallocated, and what strategic changes are needed to improve ROAS and drive new customer acquisition.

**Tech Stack:** Python · Google Ads API · GA4 API · SQL Server · Power BI

---

## Dashboards

- [Overview](#overview)
- [Campaign Performance](#campaign-performance)
- [Market & Seasonality](#market--seasonality)
- [Keywords](#keywords)
- [GA4 Attribution](#ga4-attribution)

---

## Overview

![Overview Dashboard](overview.png)

**Total Spend:** €46.78K | **Total Revenue:** €142.73K | **ROAS:** 3.05 | **Conversions:** 517 | **CPA:** €90.47 | **CTR:** 3.32%

The overall picture is positive — for every €1 invested, €3.05 was returned. However the trend is concerning. 2023 was the strongest year by far in terms of revenue and ROAS efficiency. In 2024 performance dropped aggressively, signalling a strategic shift that did not pay off. In 2025 a new company was hired, investment grew and revenue followed, but 2025 was the highest spending year without being the highest revenue year — meaning the 2023 strategy was more efficient with less budget.

2026 has very little data (3 months) so no conclusions can be drawn yet, though Performance Max investment is already at the same level as all of 2025 in just 3 months, which warrants close monitoring.

**Key observations:**
- There is no relationship between clicks and ROAS. 2024 had more clicks than 2023 but significantly lower revenue, confirming that volume of traffic does not translate to revenue
- Search campaigns account for 62% of revenue, making them the core of the strategy
- ROAS has declined year on year — the strategy needs to return to what worked in 2023
- The CPA of €90.47 should be contextualised against the average hotel booking value, as a single booking likely covers multiple CPAs — the issue is not the CPA itself but whether the conversions being tracked represent actual bookings

---

## Campaign Performance

![Campaign Performance Dashboard](campaign-overview.png)

The campaign-level data reveals a clear hierarchy: all top revenue-generating campaigns are Search campaigns targeting specific markets.

| Campaign | Type | ROAS |
|----------|------|------|
| Sales_PT | Search | 19.81 |
| Sales_ESP | Search | 18.74 |
| Sales_USA_CA | Search | 11.49 |
| Sales_FR_BE_CH | Search | 8.97 |
| Sales_UK_IE | Search | 4.36 |

**Key observations:**

**Search campaigns are the clear winner.** The top 5 revenue generators are all Search campaigns. Sales_PT has a ROAS of 19.81 and Sales_ESP 18.74 — these are exceptional returns and directly point to where budget should be concentrated.

**Demand Gen campaigns have been discontinued.** Demand Gen was present in 2023 but is no longer active in 2026. This was the right decision — despite generating the highest volume of impressions and clicks, Demand Gen consistently delivered ROAS below 1, meaning money was being lost. The budget has since been reallocated.

**Display campaigns have also been cut** for the same reason — impressions without conversions.

**Performance Max campaigns are a mixed picture.** PMax_Hotel1_UK has a ROAS of 2.06, making it the only Performance Max campaign with a positive return. All other Performance Max campaigns in other markets have ROAS below 1. The investment in these campaigns is growing aggressively in 2026 — already matching the full year of 2025 in just 3 months. Given that only one market is producing a positive return, the creative strategy and budget allocation for all other Performance Max markets needs urgent review. The campaigns appear to be growing follower counts but not driving bookings, suggesting audience mismatch or creative that builds awareness without converting.

---

## Market & Seasonality

![Market & Seasonality Dashboard](market-seasonality.png)

The market analysis reveals a significant misalignment between where budget is being invested and where the best returns are coming from.

**ROAS by Market:**

| Market | Overall ROAS |
|--------|-------------|
| Portugal | 11.98 |
| Spain | 10.07 |
| France/Belgium | 3.62 |
| UK/Ireland | 2.38 |
| USA/Canada | 2.29 |
| Other/Mixed | 0.88 |
| Brazil | 0.21 |

**Portugal and Spain are significantly underinvested.** Portugal has a ROAS of 11.98 and Spain 10.07 — by far the two strongest markets — yet both receive less investment than USA/Canada, UK/Ireland and France/Belgium. Portugal is the number one revenue source despite lower investment than several weaker-performing markets. Spain has the second best ROAS with very few campaigns, representing an almost entirely unexplored opportunity. Budget must be reallocated towards these two markets.

**Brazil must be stopped.** With a ROAS of 0.21, Brazil is consistently losing money. There is no quarter where Brazil has returned a positive ratio. The budget currently allocated to Brazil should be reallocated directly to Portugal and Spain where returns are proven.

**USA/Canada and UK/Ireland need creative and strategy review.** These are traditionally the strongest inbound tourism markets for Lisbon, yet their ROAS (2.29 and 2.38) is far below what Portugal and Spain achieve. Either the market behaviour has shifted, the creatives are not resonating, or the landing page experience is not converting international traffic. This requires a dedicated review of ad copy, landing pages and audience targeting for these markets.

**Seasonality patterns by market:**
- **Portugal & UK/Ireland:** Peak investment window is May through August, with a dip in August and recovery in September
- **Spain:** Only tested in January and February so far, with declining performance in February. Needs to be tested across the same window as Portugal (May–August) and in January to establish true seasonality
- **USA/Canada:** Best performance between January and March, and again between June and August. Investment should pause between March and June

The Portugal Q3 ROAS of 36.46 is the single strongest data point in the entire analysis — in the July to September window, the Portuguese market returns €36 for every €1 spent. This window must be fully capitalised on.

---

## Keywords

![Keywords Dashboard](keywords.png)

The keyword analysis reveals a heavy dependency on branded traffic, which raises questions about whether paid investment is actually driving incremental revenue or simply capturing bookings that would have happened organically.

**Key observations:**

**Branded keywords dominate revenue.** The top performing keywords by revenue and ROAS are all branded — variations of Inspira Liberdade, Inspira Boutique Hotel, Inspira Santa Marta. This means most conversions are coming from people who already know the hotel, not new customers being acquired through paid search.

**Inspira Liberdade Boutique Hotel receives the highest investment** among all keywords, yet customers searching for this term already know the brand. The incremental value of paid investment on pure brand terms is questionable — these bookings may occur regardless of paid presence.

**Non-branded keywords generate the most clicks but the least revenue.** This suggests a conversion funnel issue: people are discovering the hotel through non-branded terms but not completing bookings. This could indicate a landing page experience problem, pricing mismatch, or that the non-branded keyword selection is attracting the wrong intent. The strategy needs to shift towards non-branded keywords to acquire new customers, but the funnel needs to be fixed first.

**Exact match is the primary revenue driver.** The majority of revenue comes from exact match keywords, which confirms that high-intent, specific searches convert best. The strategy should be optimised around exact match, with cautious and lower-budget exploration of broad match to identify new keyword opportunities without overspending on low-intent traffic.

**Recommendation:** Invest in non-branded keyword strategies to drive new customer acquisition, leverage branded keywords to capture existing demand more efficiently, and audit the non-branded conversion funnel to understand why clicks are not converting to revenue.

---

## GA4 Attribution

![GA4 Attribution Dashboard](ga4-attribution.png)

The GA4 data provides a different perspective — it shows how users actually arrive at the website and which channels drive revenue, independent of Google Ads tracking.

**Channel performance by revenue:**
1. Organic Search — highest revenue by far
2. Unassigned — second highest revenue
3. Direct — third highest
4. Referral
5. Paid Search

**Key observations:**

**Organic Search is the strongest revenue channel overall.** This confirms that brand recognition and SEO are doing significant work. Customers who find the hotel organically convert at high rates, supporting the keyword analysis finding that branded terms perform best.

**The Unassigned channel is the second largest revenue source and requires immediate investigation.** Unassigned traffic in GA4 typically means sessions that cannot be attributed to a known source — this could be dark social, direct app traffic, email clients that strip UTM parameters, or booking engines that do not pass referral data correctly. Understanding what this channel actually represents is critical because it is generating more revenue than Referral, Paid Social and Paid Search combined. Once identified, this channel could be further optimised.

**Direct bookings are strong**, confirming that a significant portion of customers already know the brand and book without any paid influence.

**Paid Search is only the 5th best channel** despite being the primary advertising investment. This is consistent with the Google Ads data — paid search is contributing positively but it is not the dominant driver of revenue. The organic and direct channels are doing more work.

**Brand Awareness campaigns did not increase website sessions.** The data shows that in months with higher Brand Awareness spend, the number of sessions did not increase correspondingly. Brand Awareness investment ran from April 2023 to June 2025 when it was stopped — a correct decision supported by the data.

**The Client Journey chart shows that Direct and Organic Search are predominantly Single Touch conversions** — customers find the hotel and book immediately without needing multiple touchpoints. This reinforces the finding that brand recognition is already strong among converters, and that the priority should be top-of-funnel acquisition of customers who do not yet know the brand.

---

## Strategic Recommendations Summary

| Priority | Action |
|----------|--------|
| Immediate | Stop Brazil campaigns and reallocate budget to Portugal and Spain |
| Immediate | Investigate the Unassigned GA4 channel to identify and optimise this revenue source |
| Short-term | Review Performance Max creative and targeting for all markets except UK — ROAS is below 1 in every other market |
| Short-term | Test Spain campaigns across May–August window to establish true seasonality |
| Short-term | Audit non-branded keyword conversion funnel — clicks are not converting to revenue |
| Medium-term | Increase investment in Portugal Q3 (July–September) where ROAS reaches 36x |
| Medium-term | Review USA/Canada and UK/Ireland creative strategy — these markets underperform relative to their tourism significance |
| Ongoing | Monitor 2026 Performance Max spend — already matching full 2025 in 3 months with mixed results |

---

## Data & Methodology

- **Data source:** Google Ads API and GA4 Data API
- **Period:** January 2023 – March 2026
- **Pipeline:** Automated Python extraction → SQL Server → Power BI
- **Revenue note:** Conversion tracking was unreliable before January 2023. All analysis is scoped to 2023 onwards where data has been validated against Google Ads UI totals
- **Attribution model:** Google Ads last-click attribution for campaign data; GA4 data-driven attribution for channel analysis

