with user_sessions as (
    select * from {{ ref('int_user_sessions')}}
)


, final as (
    select {{ dbt_utils.surrogate_key(['session_date_utc', 'user_id']) }} as sk
        , session_date_utc as date_utc
        , user_id
        , count(*) as total_sessions
        , sum(session_duration_mins) as total_session_time_mins
        , sum(total_page_views) as total_page_views
    from user_sessions
    group by 1,2,3
)

select * from final
