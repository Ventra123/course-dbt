with events as (
    select * from {{ ref('stg_events') }}
)


, final as (
select session_id
    , user_id
    , date(min(created_at)) as session_date_utc
    , min(created_at) as session_start
    , max(created_at) as session_end
    , timestampdiff(minute, min(created_at), max(created_at)) as session_duration_mins
    , sum(case when event_type = 'page_view' then 1 else 0 end) as total_page_views
    , sum(case when event_type = 'add_to_cart' then 1 else 0 end) as total_cart_views
    , max(case when event_type = 'checkout' then 1 else 0 end) as is_purchase_session
    , max(order_id) as order_id
from events
group by 1,2
)

select * from final

