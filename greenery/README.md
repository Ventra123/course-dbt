Welcome to Sarvari's new dbt project!

# Week 1 Project Answers


### How many users do we have?
130
```
select count(distinct user_id) as users
from DEV_DB.DBT_SARVARIVENTRAPRAGADA.STG_users
```
### On average, how many orders do we receive per hour?
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
### On average, how long does an order take from being placed to being delivered?
Average of 3.89 days
```
select avg(timestampdiff('days',created_at, delivered_at)) 
from DEV_DB.DBT_SARVARIVENTRAPRAGADA.STG_orders
```
### How many users have only made one purchase? Two purchases? Three+ purchases?
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
### On average, how many unique sessions do we have per hour?
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

# Week 2 Project Answers

## Part 1. Models

### What is our user repeat rate?
Repeat Rate is 79.83%
```
select sum(case when orders >= 2 then 1 else 0 end)/count(*) as repeat_rate
from (
    select user_id, count(*) as orders
    from stg_orders
    group by 1
) as temp
```
### What are good indicators of a user who will likely purchase again? What about indicators of users who are likely NOT to purchase again? If you had more data, what features would you want to look into to answer this question?

Some indicators of users who will likely purchase again
1. Order contents of first purchase could determine if there is likely a subsequent upsell or cross-sell purchase
2. Order size of the first order
3. High activity measured by average number of sessions per day could indicate continued interest

Indicators of users who are not likely to purchase again
1. If they have "churned", i.e. they have not had any activity in the last X days
2. If they made the first purchase using a promo code or redeemed a discount

Additional data that could inform the likelihood of repeat purchases
1. Demographic information of a user like gender and age
2. The marketing channel through which a user was first acquired

### Explain the marts models you added. Why did you organize the models in the way you did?

The models are intended to be usable for end business users
They are therefore denormalized and follow the big wide table approach of data modelling to reduce the number of joins that non-technical users have to do do(see )
However, they are not over-engineered to cover all the possible use cases for end users, with the intention that more pre-calculated measures, dimensions or aggregate tables could be added as needs arise upon usage
Most models are therefore not aggregated, to retain flexibility

## Part 2. Tests
Currently, my tests are set up to check for basic data quality assessment like ensuring primary keys show up as unique and non null values. I've also used the accepted values test in a couple of instances to check for assumptions that dimensions in the data are static. If this assumption is incorrect or the engineers instrument a new value in that particular dimension, this test will throw an error and rightfully draw our attention towards fixing the problem upstream

## Part 3. Snapshots
After running the snapshot update, the following orders changed from week 1 to week 2
8385cfcd-2b3f-443a-a676-9756f7eb5404
e24985f3-2fb3-456e-a1aa-aaf88f490d70
5741e351-3124-4de7-9dff-01a448e7dfd4
914b8929-e04a-40f8-86ee-357f2be3a2a2
05202733-0e17-4726-97c2-0520c024ab85
939767ac-357a-4bec-91f8-a7b25edd46c9


# Week 3 Project Answers

## Part 1. Create new models to answer the first two questions 

### What is our overall conversion rate?
62.4%
```
select sum(is_purchase_session)/count(*) as cvr
from (
    select session_id
        , max(is_purchase_session) as is_purchase_session
    from fact_session_conversions
    group by 1
)
```
### What is our conversion rate by product?
```
select product_name
    , count(*) as sessions
    , sum(case when purchased_quantity > 0 then 1 else 0 end)/count(*) as cvr
from fact_session_conversions
group by 1
order by 2 desc

```

## Part 2. Create a macro to simplify part of a model

## Part 3. Add a post hook to your project to apply grants to the role “reporting

## Part 4. Install a package (i.e. dbt-utils, dbt-expectations) and apply one or more of the macros to your project
I used dbt utils to add surrogate keys to all the tables which didn't already have a well defined primary key. I thenadded unique and not null tests to these newly generated surrogate keys to ensure that the model assumptions hold true and that the table grain is well defined.

## Part 5. dbt Snapshots
The following orders' status changed from preparing to shipped

5741e351-3124-4de7-9dff-01a448e7dfd4
, e24985f3-2fb3-456e-a1aa-aaf88f490d70
, 8385cfcd-2b3f-443a-a676-9756f7eb5404
, 914b8929-e04a-40f8-86ee-357f2be3a2a2
, 05202733-0e17-4726-97c2-0520c024ab85
, 939767ac-357a-4bec-91f8-a7b25edd46c9