with events as (
    select * from {{ ref('stg_events') }}
)

, order_items as (
    select * from {{ ref('stg_order_items') }}
)

, products as (
    select * from {{ ref('stg_products') }}
)

, products_viewed_and_purchased as (
    select session_id
        , user_id
        , product_id
        , order_id
        , count(*) as total_page_views
        from (
            select session_id
                , user_id
                , product_id
                , event_type
                , max(order_id) over (partition by session_id) as order_id
            from stg_events
            where event_type in ('page_view','checkout')
        ) as temp
        where event_type = 'page_view'
        group by 1,2,3,4
)



, final as (
    select a.session_id
        , a.user_id
        , c.product_name
        , c.price
        , a.total_page_views
        , case when a.order_id is not null then 1 else 0 end as is_purchase_session
        , coalesce(b.quantity,0) as purchased_quantity
    from products_viewed_and_purchased a
    left join order_items b
        on a.order_id = b.order_id
        and a.product_id = b.product_id
    join products c
        on a.product_id = c.product_id
)


select * from final


















