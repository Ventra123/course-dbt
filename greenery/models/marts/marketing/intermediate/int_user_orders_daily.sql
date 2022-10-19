with  orders as (
    select * from {{ ref('fact_orders')}}
)

, final as (
    select date_utc
        , user_id
        , count(*) as purchases
        , sum(order_cost) as spend_usd
        , sum(purchases) over (partition by user_id order by date_utc) as purchases_to_date
        , sum(spend_usd) over (partition by user_id order by date_utc) as spend_to_date
    from orders
    group by 1,2
)

select * from final
