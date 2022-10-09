{{
  config(
    materialized='view'
  )
}}

SELECT 
    product_id
    , name as product_name
    , price
    , inventory
FROM {{ source('postgres', 'products') }}