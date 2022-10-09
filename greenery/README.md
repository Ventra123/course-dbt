Welcome to Sarvari's new dbt project!

### Week 1 Project Answers


# How many users do we have?
130
```
select count(distinct user_id) as users
from DEV_DB.DBT_SARVARIVENTRAPRAGADA.STG_users
```
# On average, how many orders do we receive per hour?
Average of 7.52 orders
```
select average(orders)
from (
select date(created_at) as date
, hour(created_at) as hr
, count(distinct order_id) as orders
from DEV_DB.DBT_SARVARIVENTRAPRAGADA.STG_orders
group by 1,2
) as temp
```
# On average, how long does an order take from being placed to being delivered?
Average of 3.89 days
```
select avg(timestampdiff('days',created_at, delivered_at)) 
from DEV_DB.DBT_SARVARIVENTRAPRAGADA.STG_orders
```
# How many users have only made one purchase? Two purchases? Three+ purchases?
Note: you should consider a purchase to be a single order. In other words, if a user places one order for 3 products, they are considered to have made 1 purchase.
One purchase - 25
Two purchases - 28
Three+ purchases - 71
```
select case when purchases = 1 then 'One'
when purchases = 2 then 'Two'
else 'Three+' end as purchase_group
, count(*)
from (
select user_id
, count(distinct order_id) as purchases
from DEV_DB.DBT_SARVARIVENTRAPRAGADA.STG_orders
group by 1
) as temp
group by 1
```
# On average, how many unique sessions do we have per hour?
16.32  sessions
```
select avg(sessions)
from (
select date(created_at) as date
, hour(created_at) as hr
, count(distinct session_id) as sessions
from DEV_DB.DBT_SARVARIVENTRAPRAGADA.STG_events
group by 1,2
) as temp
```