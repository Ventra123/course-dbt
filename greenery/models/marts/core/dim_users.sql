with users as (
    select * from {{ ref('stg_users') }}
)

, orders as (
    select * from {{ ref('stg_orders') }}
)

, sessions as (
    select * from {{ ref('stg_events') }}
)

, addresses as (
    select * from {{ ref('stg_addresses') }}
)

, user_sessions as (
    select user_id
        , avg(sessions) as sessions_per_activity_date
        , min(activity_date) as first_activity_date
        , max(activity_date) as most_recent_activity_date
        , datediff(day,max(activity_date), current_date()) as days_since_last_active
    from (
        select user_id
            , date(created_at) as activity_date
            , count(*) as sessions
        from sessions
        group by 1,2
    ) as temp
    group by 1
)

, user_orders as (
    select user_id
        , date(min(created_at)) as first_purchase_date
        , date(max(created_at)) as most_recent_purchase_date
        , datediff(day,max(created_at), current_date()) as days_since_last_purchase
        , sum(order_cost) as lifetime_spend
        , count(distinct order_id) as lifetime_orders
    from orders
    group by 1
)

, final as (
select a.user_id
    , a.first_name
    , a.last_name
    , a.email
    , a.phone_number
    , d.address
    , d.zipcode
    , d.state
    , d.country
    , b.first_activity_date
    , b.most_recent_activity_date
    , b.days_since_last_active
    , b.sessions_per_activity_date
    , case when c.user_id is not null then 1 else 0 end as is_customer
    , c.first_purchase_date
    , c.most_recent_purchase_date
    , c.days_since_last_purchase
from users a
left join user_sessions b
    on a.user_id = b.user_id
left join user_orders c
    on a.user_id = c.user_id
join addresses d
    on a.address_id = d.address_id
)

select * from final









