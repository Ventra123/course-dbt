{% snapshot snapshot_orders %}

  {{
    config(
        target_database= target.database,
        target_schema= target.schema,
        unique_key='order_id',

        strategy='check',
        check_cols=['status']
    )
  }}

  SELECT * FROM {{ source('postgres', 'orders') }}

{% endsnapshot %}