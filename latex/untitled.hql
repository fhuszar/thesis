-- find trending hashtags
SELECT
    *,
    (tbl.periodic+0.15)/(tbl.lastfourweeks+1) AS periodicity_index,
    (tbl.unique_periodic+0.15)/(tbl.unique_lastfourweeks+1) AS periodicity_index_unique,
    (tbl.unique_today+0.3) / (tbl.unique_lastfourweeks + 10) AS timeliness
FROM (
    SELECT
        hashtags.content_name AS content_name,
        SUM(CASE WHEN dayssince = 0 THEN 1 ELSE 0 END) AS today,
        SUM(CASE WHEN dayssince % 7 = 0 AND dayssince > 0 THEN 1.0 ELSE 0.0 END) / 4.0 AS periodic,
        SUM(CASE WHEN dayssince BETWEEN 1 AND 7 THEN 1.0 ELSE 0.0 END) / 7.0 AS lastweek,
        SUM(CASE WHEN dayssince BETWEEN 1 AND 28 THEN 1.0 ELSE 0.0 END) / 28.0 AS lastfourweeks,
        COUNT(DISTINCT CASE WHEN dayssince = 0 THEN twuser_id ELSE null END) AS unique_today,
        COUNT(DISTINCT CASE WHEN dayssince % 7 = 0 AND dayssince > 0 THEN twuser_id ELSE NULL END) AS unique_periodic,
        COUNT(DISTINCT CASE WHEN dayssince BETWEEN 1 AND 7 THEN twuser_id ELSE NULL END) AS unique_lastweek,
        COUNT(DISTINCT CASE WHEN dayssince BETWEEN 1 AND 28 THEN twuser_id ELSE NULL END) AS unique_lastfourweeks
    FROM (
        SELECT
            twuser_id,
            canonical_content_name AS content_name,
            '2013-05-31'::date - published_at::date AS dayssince
        FROM
            peerindex.user_content
        WHERE
            content_type = 'hashtag'
        ) hashtags
    GROUP BY
        content_name
    ) tbl
WHERE
    unique_today > 0
ORDER BY 
    timeliness DESC
LIMIT 10
;

-- relative to last 7 days
SELECT
    todaylastweek.canonical_content_name AS content_name,
    todaylastweek.today AS today,
    todaylastweek.lastweek AS lastweek,
    (today + 0.1) / (lastweek + 0.1) AS freshness_index
FROM (
    SELECT
        canonical_content_name AS canonical_content_name,
        SUM(
            CASE
                WHEN published_at >= dateadd(day,-1,to_date('2013-05-31', 'YYYY-MM-dd')) THEN 1
                ELSE 0
            END) AS today,
        SUM(
            CASE
                WHEN published_at >= dateadd(week,-1,to_date('2013-05-31', 'YYYY-MM-dd')) THEN 1
                ELSE 0
            END) AS lastweek
        SUM(
            CASE
                WHEN published_at BETWEEN dateadd(week,-1,to_date('2013-05-31', 'YYYY-MM-dd')) THEN 1
                ELSE 0
            END
            )
    FROM
        peerindex.user_content
    WHERE
        content_type = 'hashtag'
    GROUP BY
        canonical_content_name
) todaylastweek
WHERE
    today >= 10
ORDER BY
    freshness_index DESC
LIMIT
    40
;