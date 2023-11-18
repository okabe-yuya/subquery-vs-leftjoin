EXPLAIN ANALYZE SELECT
  up.user_id,
  SUM(CASE WHEN status = 0 THEN 1 ELSE 0 END) AS 下書きの総数,
  SUM(CASE WHEN status = 1 THEN 1 ELSE 0 END) AS 公開中の総数,
  SUM(CASE WHEN status = 2 THEN 1 ELSE 0 END) AS 非公開中の総数
FROM
  user_posts AS up
LEFT OUTER JOIN
  posts
ON
  up.post_id = posts.post_id
GROUP BY
  up.user_id
ORDER BY
  up.user_id
;

--                                                          QUERY PLAN                                                          
-- -----------------------------------------------------------------------------------------------------------------------------
--  Sort  (cost=26.12..26.37 rows=100 width=28) (actual time=0.413..0.421 rows=100 loops=1)
--    Sort Key: up.user_id
--    Sort Method: quicksort  Memory: 32kB
--    ->  HashAggregate  (cost=21.80..22.80 rows=100 width=28) (actual time=0.333..0.354 rows=100 loops=1)
--          Group Key: up.user_id
--          Batches: 1  Memory Usage: 32kB
--          ->  Hash Left Join  (cost=10.75..16.55 rows=300 width=6) (actual time=0.134..0.233 rows=300 loops=1)
--                Hash Cond: (up.post_id = posts.post_id)
--                ->  Seq Scan on user_posts up  (cost=0.00..5.00 rows=300 width=8) (actual time=0.014..0.042 rows=300 loops=1)
--                ->  Hash  (cost=7.00..7.00 rows=300 width=6) (actual time=0.112..0.113 rows=300 loops=1)
--                      Buckets: 1024  Batches: 1  Memory Usage: 20kB
--                      ->  Seq Scan on posts  (cost=0.00..7.00 rows=300 width=6) (actual time=0.006..0.056 rows=300 loops=1)
--  Planning Time: 0.606 ms
--  Execution Time: 0.478 ms
-- (14 rows)