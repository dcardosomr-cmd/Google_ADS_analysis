-- First check the Month format
SELECT TOP 5 Month, Year FROM [dbo].[keywords_clean]

-- Convert all columns to correct data types
ALTER TABLE [dbo].[keywords_clean]
ALTER COLUMN Keyword NVARCHAR(255)

ALTER TABLE [dbo].[keywords_clean]
ALTER COLUMN Match_type NVARCHAR(50)

ALTER TABLE [dbo].[keywords_clean]
ALTER COLUMN Campaign NVARCHAR(100)

ALTER TABLE [dbo].[keywords_clean]
ALTER COLUMN Ad_group NVARCHAR(100)

ALTER TABLE [dbo].[keywords_clean]
ALTER COLUMN Year INT

ALTER TABLE [dbo].[keywords_clean]
ALTER COLUMN Quality_score FLOAT

ALTER TABLE [dbo].[keywords_clean]
ALTER COLUMN Cost FLOAT

ALTER TABLE [dbo].[keywords_clean]
ALTER COLUMN Impressions INT

ALTER TABLE [dbo].[keywords_clean]
ALTER COLUMN Clicks INT

ALTER TABLE [dbo].[keywords_clean]
ALTER COLUMN CTR FLOAT

ALTER TABLE [dbo].[keywords_clean]
ALTER COLUMN Conversions FLOAT

ALTER TABLE [dbo].[keywords_clean]
ALTER COLUMN All_conv_value FLOAT

ALTER TABLE [dbo].[keywords_clean]
ALTER COLUMN Value_per_conv FLOAT

ALTER TABLE [dbo].[keywords_clean]
ALTER COLUMN Search_impr_share FLOAT

ALTER TABLE [dbo].[Key_event_attribution_paths]
Drop column [Data_driven_path_attributed_key_events] 

ALTER TABLE [dbo].[Key_event_attribution_paths]
ALTER COLUMN Key_events INT

ALTER TABLE [dbo].[Key_event_attribution_paths]
ALTER COLUMN Purchase_revenue FLOAT

ALTER TABLE [dbo].[Key_event_attribution_paths]
ALTER COLUMN Days_to_key_event FLOAT

ALTER TABLE [dbo].[Key_event_attribution_paths]
ALTER COLUMN Touch_points_to_key_event INT


SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'keywords_clean'
ORDER BY ORDINAL_POSITION

SELECT 
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'campaigns_clean'
ORDER BY ORDINAL_POSITION

SELECT 
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'ad_groups_clean'
ORDER BY ORDINAL_POSITION


SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Conversion_attribution_analysis'
ORDER BY ORDINAL_POSITION


SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Key_event_attribution_paths'
ORDER BY ORDINAL_POSITION

SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Key_event_attribution_paths'
ORDER BY ORDINAL_POSITION


SELECT COLUMN_NAME, DATA_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME IN (
    'Key_event_attribution_paths',
    'Non-Google_campaign_Session_campaign', 
    'Traffic_acquisition_Session_primary_channel_group_(Default_channel_group)',
    'User_acquisition_First_user_primary_channel_group_(Default_channel_group)',
    'Conversion_attribution_analysis',
    'Month_final'
)
ORDER BY TABLE_NAME, ORDINAL_POSITION


-- ------------------------------------------------------------
-- section 1: overall account performance
-- ------------------------------------------------------------

-- q1: overall performance by year
select 
    year,
    round(sum(cost), 2) as total_spend,
    sum(clicks) as total_clicks,
    sum(impressions) as total_impressions,
    round(sum(conversions), 0) as total_conversions,
    round(sum(all_conv_value), 2) as total_revenue,
    round(sum(all_conv_value) / nullif(sum(cost), 0), 2) as roas,
    round(sum(cost) / nullif(sum(conversions), 0), 2) as cpa,
    round(sum(conversions) / nullif(sum(clicks), 0) * 100, 2) as conv_rate_pct
from [dbo].[campaigns_clean]
where year in (2023, 2024, 2025)
group by year
order by year


-- q2: performance by campaign type and year
select 
    year,
    campaign_type,
    round(sum(cost), 2) as total_spend,
    sum(clicks) as total_clicks,
    round(sum(conversions), 0) as total_conversions,
    round(sum(all_conv_value), 2) as total_revenue,
    round(sum(all_conv_value) / nullif(sum(cost), 0), 2) as roas,
    round(sum(cost) / nullif(sum(conversions), 0), 2) as cpa
from [dbo].[campaigns_clean]
where year in (2023, 2024, 2025)
group by year, campaign_type
order by year, roas desc


-- q3: quarterly performance by year
select 
    year,
    datepart(quarter, cast(month as date)) as quarter,
    round(sum(cost), 2) as total_spend,
    sum(clicks) as total_clicks,
    sum(impressions) as total_impressions,
    round(sum(conversions), 0) as total_conversions,
    round(sum(all_conv_value), 2) as total_revenue,
    round(sum(all_conv_value) / nullif(sum(cost), 0), 2) as roas,
    round(sum(cost) / nullif(sum(conversions), 0), 2) as cpa,
    round(sum(conversions) / nullif(sum(clicks), 0) * 100, 2) as conv_rate_pct
from [dbo].[campaigns_clean]
where year in (2023, 2024, 2025)
group by year, datepart(quarter, cast(month as date))
order by year, quarter


-- q4: monthly trend for 2025
select
    month,
    round(sum(cost), 2) as total_spend,
    round(sum(all_conv_value), 2) as total_revenue,
    round(sum(all_conv_value) / nullif(sum(cost), 0), 2) as roas,
    round(sum(conversions), 0) as total_conversions
from [dbo].[campaigns_clean]
where year = 2025
group by month
order by cast(month as date)


-- ------------------------------------------------------------
-- section 2: campaign performance
-- ------------------------------------------------------------

-- q5: top search campaigns by roas
select 
    year,
    campaign,
    round(sum(cost), 2) as total_spend,
    round(sum(all_conv_value), 2) as total_revenue,
    round(sum(all_conv_value) / nullif(sum(cost), 0), 2) as roas,
    round(sum(cost) / nullif(sum(conversions), 0), 2) as cpa,
    round(sum(conversions) / nullif(sum(clicks), 0) * 100, 2) as conv_rate_pct
from [dbo].[campaigns_clean]
where year in (2023, 2024, 2025)
    and campaign_type = 'Search'
group by year, campaign
having sum(cost) > 100
    and sum(all_conv_value) > 0
order by roas desc


-- q6: budget waste identification - high spend low return campaigns
select 
    campaign,
    campaign_type,
    round(sum(cost), 2) as total_spend,
    round(sum(all_conv_value), 2) as total_revenue,
    round(sum(all_conv_value) / nullif(sum(cost), 0), 3) as roas,
    round(sum(conversions), 0) as total_conversions
from [dbo].[campaigns_clean]
where year in (2023, 2024, 2025)
group by campaign, campaign_type
having sum(cost) > 200
    and sum(all_conv_value) / nullif(sum(cost), 0) < 0.1
order by total_spend desc


-- q7: funnel breakdown by campaign type
select
    campaign_type,
    sum(impressions) as total_impressions,
    sum(clicks) as total_clicks,
    round(sum(conversions), 0) as total_conversions,
    round(sum(clicks) * 100.0 / nullif(sum(impressions), 0), 2) as ctr_pct,
    round(sum(conversions) * 100.0 / nullif(sum(clicks), 0), 2) as click_to_conv_pct,
    round(sum(conversions) * 100.0 / nullif(sum(impressions), 0), 4) as impression_to_conv_pct,
    round(sum(all_conv_value), 2) as total_revenue,
    round(sum(cost), 2) as total_spend
from [dbo].[campaigns_clean]
where year in (2023, 2024, 2025)
group by campaign_type
order by total_revenue desc


-- q8: april and may 2025 campaign breakdown - collapse diagnosis
select
    month,
    campaign,
    campaign_type,
    round(sum(cost), 2) as total_spend,
    round(sum(all_conv_value), 2) as total_revenue,
    round(sum(all_conv_value) / nullif(sum(cost), 0), 2) as roas,
    round(sum(conversions), 2) as total_conversions
from [dbo].[campaigns_clean]
where year = 2025
    and month in ('2025-04-01', '2025-05-01')
group by month, campaign, campaign_type
order by month, total_spend desc


-- q9: q3 performance by campaign - checks if weakness is universal
select
    campaign,
    round(sum(cost), 2) as total_spend,
    round(sum(all_conv_value), 2) as total_revenue,
    round(sum(all_conv_value) / nullif(sum(cost), 0), 2) as roas,
    round(sum(conversions), 2) as total_conversions
from [dbo].[campaigns_clean]
where year in (2023, 2024, 2025)
    and month in ('2023-07-01', '2023-08-01', '2023-09-01',
                  '2024-07-01', '2024-08-01', '2024-09-01',
                  '2025-07-01', '2025-08-01', '2025-09-01')
    and campaign_type = 'Search'
group by campaign
having sum(cost) > 100
order by roas desc


-- ------------------------------------------------------------
-- section 3: market and seasonality
-- ------------------------------------------------------------

-- q10: performance by market across all years
select
    campaign,
    case 
        when campaign like '%ESP%' then 'Spain'
        when campaign like '%FR%' or campaign like '%BE%' then 'France/Belgium'
        when campaign like '%UK%' or campaign like '%IE%' then 'UK/Ireland'
        when campaign like '%USA%' or campaign like '%CA%' then 'USA/Canada'
        when campaign like '%PT%' then 'Portugal'
        when campaign like '%BR%' then 'Brazil'
        when campaign like '%DE%' or campaign like '%NL%' then 'Germany/Netherlands'
        when campaign like '%Scandinavia%' then 'Scandinavia'
        else 'Other/Mixed'
    end as market,
    round(sum(cost), 2) as total_spend,
    sum(clicks) as total_clicks,
    round(sum(conversions), 2) as total_conversions,
    round(sum(all_conv_value), 2) as total_revenue,
    round(sum(all_conv_value) / nullif(sum(cost), 0), 2) as roas,
    round(sum(cost) / nullif(sum(conversions), 0), 2) as cpa
from [dbo].[campaigns_clean]
where year in (2023, 2024, 2025)
group by campaign,
    case 
        when campaign like '%ESP%' then 'Spain'
        when campaign like '%FR%' or campaign like '%BE%' then 'France/Belgium'
        when campaign like '%UK%' or campaign like '%IE%' then 'UK/Ireland'
        when campaign like '%USA%' or campaign like '%CA%' then 'USA/Canada'
        when campaign like '%PT%' then 'Portugal'
        when campaign like '%BR%' then 'Brazil'
        when campaign like '%DE%' or campaign like '%NL%' then 'Germany/Netherlands'
        when campaign like '%Scandinavia%' then 'Scandinavia'
        else 'Other/Mixed'
    end
order by market, roas desc


-- q11: seasonality by market and quarter
select
    case 
        when campaign like '%ESP%' then 'Spain'
        when campaign like '%FR%' or campaign like '%BE%' then 'France/Belgium'
        when campaign like '%UK%' or campaign like '%IE%' then 'UK/Ireland'
        when campaign like '%USA%' or campaign like '%CA%' then 'USA/Canada'
        when campaign like '%PT%' then 'Portugal'
        when campaign like '%BR%' then 'Brazil'
        when campaign like '%DE%' or campaign like '%NL%' then 'Germany/Netherlands'
        else 'Other/Mixed'
    end as market,
    datepart(quarter, month) as quarter,
    round(sum(cost), 2) as total_spend,
    round(sum(all_conv_value), 2) as total_revenue,
    round(sum(all_conv_value) / nullif(sum(cost), 0), 2) as roas,
    round(sum(conversions), 2) as total_conversions
from [dbo].[campaigns_clean]
where year in (2023, 2024, 2025)
group by 
    case 
        when campaign like '%ESP%' then 'Spain'
        when campaign like '%FR%' or campaign like '%BE%' then 'France/Belgium'
        when campaign like '%UK%' or campaign like '%IE%' then 'UK/Ireland'
        when campaign like '%USA%' or campaign like '%CA%' then 'USA/Canada'
        when campaign like '%PT%' then 'Portugal'
        when campaign like '%BR%' then 'Brazil'
        when campaign like '%DE%' or campaign like '%NL%' then 'Germany/Netherlands'
        else 'Other/Mixed'
    end,
    datepart(quarter, month)
order by market, quarter


-- ------------------------------------------------------------
-- section 4: keyword analysis
-- ------------------------------------------------------------

-- q12: top 20 keywords by revenue
select top 20
    keyword,
    match_type,
    round(sum(cost), 2) as total_spend,
    sum(clicks) as total_clicks,
    round(sum(conversions), 2) as total_conversions,
    round(sum(all_conv_value), 2) as total_revenue,
    round(sum(all_conv_value) / nullif(sum(cost), 0), 2) as roas,
    round(sum(cost) / nullif(sum(conversions), 0), 2) as cpa
from [dbo].[keywords_clean]
where year in (2023, 2024, 2025)
    and all_conv_value > 0
group by keyword, match_type
order by total_revenue desc


-- q13: revenue concentration - keyword dependency risk
select
    keyword,
    round(sum(all_conv_value), 2) as total_revenue,
    round(sum(all_conv_value) * 100.0 / 
        (select sum(all_conv_value) from [dbo].[keywords_clean] 
         where year in (2023, 2024, 2025)), 2) as revenue_share_pct,
    round(sum(cost), 2) as total_spend,
    round(sum(conversions), 2) as total_conversions
from [dbo].[keywords_clean]
where year in (2023, 2024, 2025)
group by keyword
order by total_revenue desc


-- q14: branded vs non-branded revenue split
select
    case 
        when keyword like '%hotel_brand%' then 'Branded'
        else 'Non-Branded'
    end as keyword_type,
    count(distinct keyword) as unique_keywords,
    round(sum(cost), 2) as total_spend,
    sum(clicks) as total_clicks,
    round(sum(conversions), 2) as total_conversions,
    round(sum(all_conv_value), 2) as total_revenue,
    round(sum(all_conv_value) / nullif(sum(cost), 0), 2) as roas,
    round(sum(all_conv_value) * 100.0 / 
        (select sum(all_conv_value) from [dbo].[keywords_clean]
         where year in (2023, 2024, 2025)), 2) as revenue_share_pct
from [dbo].[keywords_clean]
where year in (2023, 2024, 2025)
group by 
    case 
        when keyword like '%hotel_brand%' then 'Branded'
        else 'Non-Branded'
    end
order by total_revenue desc


-- q15: performance by match type
select
    match_type,
    count(distinct keyword) as unique_keywords,
    round(sum(cost), 2) as total_spend,
    sum(clicks) as total_clicks,
    round(sum(conversions), 2) as total_conversions,
    round(sum(all_conv_value), 2) as total_revenue,
    round(sum(all_conv_value) / nullif(sum(cost), 0), 2) as roas,
    round(sum(cost) / nullif(sum(conversions), 0), 2) as cpa,
    round(sum(conversions) * 100.0 / nullif(sum(clicks), 0), 2) as conv_rate_pct
from [dbo].[keywords_clean]
where year in (2023, 2024, 2025)
group by match_type
order by roas desc


-- q16: keywords with high spend and zero conversions
select
    keyword,
    match_type,
    campaign,
    round(sum(cost), 2) as total_spend,
    sum(clicks) as total_clicks,
    round(sum(conversions), 2) as total_conversions,
    round(sum(all_conv_value), 2) as total_revenue
from [dbo].[keywords_clean]
where year in (2023, 2024, 2025)
group by keyword, match_type, campaign
having sum(cost) > 50
    and sum(conversions) = 0
order by total_spend desc


-- q17: branded search volume trend by year
select
    year,
    sum(impressions) as branded_impressions,
    sum(clicks) as branded_clicks,
    round(sum(cost), 2) as total_spend,
    round(sum(conversions), 2) as total_conversions
from [dbo].[keywords_clean]
where keyword like '%hotel_brand%'
    and year in (2023, 2024, 2025)
group by year
order by year


-- ------------------------------------------------------------
-- section 5: ga4 attribution analysis
-- ------------------------------------------------------------

-- q18: channel revenue and roas comparison
select
    primary_channel_group_default_channel_group as channel,
    round(sum(total_revenue_by_int_time), 2) as total_revenue,
    round(sum(all_conversions), 2) as total_conversions,
    round(sum(ads_cost), 2) as total_ads_cost,
    round(sum(total_revenue_by_int_time) / nullif(sum(ads_cost), 0), 2) as roas
from [dbo].[conversion_attribution_analysis]
group by primary_channel_group_default_channel_group
order by total_revenue desc


-- q19: multi-touch vs single-touch contribution by channel
select
    primary_channel_group_default_channel_group as channel,
    round(sum(single_touch_point_credit_by_int_time), 2) as single_touch_conversions,
    round(sum(early_touch_point_credit_by_int_time), 2) as early_touch_conversions,
    round(sum(mid_touch_point_credit_by_int_time), 2) as mid_touch_conversions,
    round(sum(late_touch_point_credit_by_int_time), 2) as late_touch_conversions,
    round(sum(all_conversions), 2) as total_conversions,
    round(sum(early_touch_point_credit_by_int_time) + 
          sum(mid_touch_point_credit_by_int_time), 2) as assisted_conversions
from [dbo].[conversion_attribution_analysis]
group by primary_channel_group_default_channel_group
order by total_conversions desc


-- q20: top 20 conversion paths by revenue
select top 20
    primary_channel_group_path as conversion_path,
    key_events as total_conversions,
    round(purchase_revenue, 2) as total_revenue,
    round(days_to_key_event, 2) as avg_days_to_convert,
    touch_points_to_key_event as touchpoints
from [dbo].[key_event_attribution_paths]
order by purchase_revenue desc


-- q21: conversion complexity - single vs multi touch
select
    touch_points_to_key_event as touchpoints,
    count(*) as number_of_paths,
    sum(key_events) as total_conversions,
    round(sum(purchase_revenue), 2) as total_revenue,
    round(avg(days_to_key_event), 2) as avg_days_to_convert
from [dbo].[key_event_attribution_paths]
group by touch_points_to_key_event
order by touch_points_to_key_event


-- q22: traffic quality by channel
select
    [session_primary_channel_group_default_channel_group] as channel,
    sessions,
    engaged_sessions,
    round(engagement_rate * 100, 2) as engagement_rate_pct,
    round(total_revenue, 2) as total_revenue,
    key_events as conversions,
    round(session_key_event_rate * 100, 4) as conversion_rate_pct,
    round(total_revenue / nullif(key_events, 0), 2) as revenue_per_conversion
from [dbo].[traffic_acquisition_session_primary_channel_group_(default_channel_group)]
order by total_revenue desc


-- q23: non-google campaign performance
select top 20
    session_campaign as campaign,
    active_users,
    sessions,
    engaged_sessions,
    key_events as conversions,
    round(total_revenue, 2) as total_revenue,
    round(total_revenue / nullif(key_events, 0), 2) as revenue_per_conversion
from [dbo].[non-google_campaign_session_campaign]
where total_revenue > 0
order by total_revenue desc


-- q24: monthly ga4 traffic vs google ads spend by month-year

select
    t.year,
    t.month,
    t.sessions,
    t.key_events as conversions,
    round(t.total_revenue, 2) as ga4_revenue,
    round(t.engagement_rate * 100, 2) as engagement_rate_pct,
    round(c.brand_awareness_spend, 2) as brand_awareness_spend,
    round(c.total_paid_spend, 2) as total_paid_spend
from [dbo].[Month final] t
left join (
    select
        year,
        month,
        sum(case when campaign like '%Brand_Awareness%' 
            then cost else 0 end) as brand_awareness_spend,
        sum(cost) as total_paid_spend
    from [dbo].[campaigns_clean]
    group by year, month
) c on t.year = c.year and t.month = cast(month(cast(c.month as date)) as nvarchar)
where t.year in (2024, 2025)
order by t.year, cast(t.month as int)