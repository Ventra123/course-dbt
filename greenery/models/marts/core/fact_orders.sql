

with orders as (
    select * from {{ ref('stg_orders') }}
)

, order_items as (
    select * from {{ ref('stg_order_items') }}
)

, promos as (
    select * from {{ ref('stg_promos') }}
)

, addresses as (
    select * from {{ ref('stg_addresses') }}
)


, order_item_count as (
    select order_id
    , count(*) as total_items
    from order_items
    group by 1
)


, final as (
    select date(a.created_at) as date_utc
    , a.created_at
    , a.order_id
    , a.user_id
    , b.discount
    , d.total_items
    , a.order_cost
    , a.shipping_cost
    , a.order_total
    , c.address as shipping_address
    , c.zipcode as shipping_zipcode
    , c.state as shipping_state
    , c.country as shipping_country
    , a.tracking_id
    , a.shipping_service
    , a.estimated_delivery_at
    , a.delivered_at
    , a.order_status
    from orders a
    left join promos b
        on a.promo_id = b.promo_id
    left join addresses c
        on a.address_id = c.address_id
    join order_item_count d
        on a.order_id = d.order_id
)

select * from final





