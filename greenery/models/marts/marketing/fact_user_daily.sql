with users as (
    select * from {{ ref('dim_users') }}
)

, user_sessions as (
    select * from {{ ref('int_user_sessions_daily') }}
)

, user_orders as (
    select * from {{ ref('int_user_orders_daily') }}
)

, user_dates as (
    select date_day as date_utc
        , user_id
    from int_calendar a, users b
)

, final as (
    select {{ dbt_utils.surrogate_key(['a.date_utc', 'a.user_id']) }} as sk
        , a.date_utc
        , a.user_id
        , case when b.user_id is not null then 1 else 0 end as is_active
        , coalesce(total_sessions,0) as total_sessions
        , coalesce(total_session_time_mins, 0) as total_session_duration_mins
        , coalesce(total_page_views, 0) as total_page_views
        , case when c.user_id is not null then 1 else 0 end as is_purchaser
        , coalesce(purchases,0) as total_purchases
        , coalesce(spend_usd, 0) as total_spend
        , coalesce(purchases_to_date, 0) as purchases_to_date
        , coalesce(spend_to_date, 0) as spend_to_date
    from user_dates a
    left join user_sessions b
        on a.user_id = b.user_id
        and a.date_utc = b.date_utc
    left join user_orders c
        on a.user_id = c.user_id
        and a.date_utc = c.date_utc
)

select * from final