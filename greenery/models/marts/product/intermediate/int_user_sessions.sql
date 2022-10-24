


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
    , {{ agg_by_event_type('page_view') }} as total_page_views
    , {{ agg_by_event_type('add_to_cart')}} as total_cart_views
    , {{ agg_by_event_type('checkout') }} as is_purchase_session
    , {{ agg_by_event_type('package_shipped') }} as package_shipped
    , max(order_id) as order_id
from events
group by 1,2
)

select * from final

