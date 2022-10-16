{{
  config(
    materialized='view'
  )
}}

SELECT
    event_id
    , session_id
    , user_id
    , page_url
    , order_id
    , event_type
    , product_id
    , created_at
FROM {{ source('postgres', 'events') }}
