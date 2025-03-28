SELECT
    da.artist_name,
    ds.song_name,
    COUNT(fs.session_id) AS total_purchases,
    SUM(CASE WHEN fs.liked = TRUE THEN 1 ELSE 0 END) AS liked_count,
    ROUND(SUM(CASE WHEN fs.liked = TRUE THEN 1 ELSE 0 END) * 100.0 / COUNT(fs.session_id), 2) AS like_percentage,
    AVG(fs.price) AS avg_price,
    du.country_code,
    date_part('month', fs.session_start_time) AS purchase_month,
    date_part('year', fs.session_start_time) AS purchase_year
FROM {{var("target_schema")}}.fact_session fs
JOIN {{var("target_schema")}}.dim_artists da
    ON fs.artist_id = da.artist_id
JOIN {{var("target_schema")}}.dim_songs ds
    ON fs.song_id = ds.song_id
JOIN {{var("target_schema")}}.dim_users du
    ON fs.user_id = du.user_id
GROUP BY 1, 2, 7, 8, 9
ORDER BY total_purchases DESC 