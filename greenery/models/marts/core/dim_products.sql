with products as (
    select * from {{ ref('stg_products') }}
)

, orders as (
    select * from {{ ref('stg_orders') }}
)

, order_items as (
    select * from {{ ref('stg_order_items') }}
)

, product_purchases as (
    select b.product_id
        , sum(b.quantity) as total_purchases
        , min(date(created_at)) as first_purchase_date
        , max(date(created_at)) as most_recent_purchase_date
    from  orders a
    join  order_items b
    group by 1
)

, final as (
select a.product_id
    , a.product_name
    , a.price
    , a.inventory
    , coalesce(b.total_purchases, 0) as total_purchases
    , b.first_purchase_date
    , b.most_recent_purchase_date
from products a
left join product_purchases b
    on a.product_id = b.product_id
)

select * from final





