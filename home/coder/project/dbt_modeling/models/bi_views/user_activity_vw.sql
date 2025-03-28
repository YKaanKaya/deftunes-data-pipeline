SELECT
    du.user_id,
    du.user_name,
    du.user_lastname,
    du.country_code,
    COUNT(fs.session_id) AS total_sessions,
    COUNT(DISTINCT date_trunc('day', fs.session_start_time)) AS active_days,
    SUM(fs.price) AS total_spent,
    AVG(fs.price) AS avg_purchase_value,
    MAX(fs.session_start_time) AS last_activity_date,
    COUNT(CASE WHEN fs.liked = TRUE THEN 1 END) AS liked_songs_count
FROM {{var("target_schema")}}.dim_users du
LEFT JOIN {{var("target_schema")}}.fact_session fs
    ON du.user_id = fs.user_id
GROUP BY 1, 2, 3, 4
ORDER BY total_spent DESC 