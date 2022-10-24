--How are our users moving through the product funnel?

--Which steps in the funnel have largest drop off points?

with events as (
    select * from {{ ref('stg_events') }}
)

, products as (
    select * from {{ ref('stg_products') }}
)

, int_sessions as (
    select * from {{ ref('int_user_sessions') }}
)

, final as (
select {{ dbt_utils.surrogate_key(['a.session_id', 'a.created_at', 'a.page_url']) }} as sk
    , date(created_at) as date_utc
    , a.user_id
    , a.session_id
    , c.session_duration_mins
    , a.page_url
    , a.created_at as session_ts
    , a.event_type
    , row_number() over (partition by a.session_id order by created_at) as session_activity_rank
    , case when session_end = session_ts then 1 else 0 end as is_final_session_activity
    , c.is_purchase_session
    , b.product_name
    , b.price
    , a.order_id as order_id
from events a
left join products b
    on a.product_id = b.product_id
join int_sessions c
    on a.session_id = c.session_id
)

select * from final




