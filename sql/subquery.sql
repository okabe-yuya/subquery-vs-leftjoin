EXPLAIN ANALYZE SELECT
  up.user_id,
  (SELECT COUNT(post_id) FROM posts WHERE status = 0 AND post_id IN (SELECT post_id FROM user_posts WHERE user_id = up.user_id)) AS 下書きの総数,
  (SELECT COUNT(post_id) FROM posts WHERE status = 1 AND post_id IN (SELECT post_id FROM user_posts WHERE user_id = up.user_id)) AS 公開中の総数,
  (SELECT COUNT(post_id) FROM posts WHERE status = 2 AND post_id IN (SELECT post_id FROM user_posts WHERE user_id = up.user_id)) AS 非公開中の総数
FROM
  user_posts AS up
GROUP BY
  up.user_id
ORDER BY
  up.user_id
;


--                                                                   QUERY PLAN                                                                   
-- -----------------------------------------------------------------------------------------------------------------------------------------------
--  Group  (cost=0.15..4163.46 rows=100 width=28) (actual time=0.456..32.357 rows=100 loops=1)
--    Group Key: up.user_id
--    ->  Index Only Scan using user_posts_pkey on user_posts up  (cost=0.15..18.96 rows=300 width=4) (actual time=0.018..0.251 rows=300 loops=1)
--          Heap Fetches: 300
--    SubPlan 1
--      ->  Aggregate  (cost=13.81..13.82 rows=1 width=8) (actual time=0.110..0.110 rows=1 loops=100)
--            ->  Hash Join  (cost=5.79..13.81 rows=1 width=4) (actual time=0.078..0.105 rows=1 loops=100)
--                  Hash Cond: (posts.post_id = user_posts.post_id)
--                  ->  Seq Scan on posts  (cost=0.00..7.75 rows=103 width=4) (actual time=0.003..0.051 rows=103 loops=100)
--                        Filter: (status = 0)
--                        Rows Removed by Filter: 197
--                  ->  Hash  (cost=5.75..5.75 rows=3 width=4) (actual time=0.036..0.036 rows=3 loops=100)
--                        Buckets: 1024  Batches: 1  Memory Usage: 9kB
--                        ->  Seq Scan on user_posts  (cost=0.00..5.75 rows=3 width=4) (actual time=0.018..0.033 rows=3 loops=100)
--                              Filter: (user_id = up.user_id)
--                              Rows Removed by Filter: 297
--    SubPlan 2
--      ->  Aggregate  (cost=13.84..13.85 rows=1 width=8) (actual time=0.103..0.103 rows=1 loops=100)
--            ->  Hash Join  (cost=5.79..13.83 rows=1 width=4) (actual time=0.076..0.101 rows=1 loops=100)
--                  Hash Cond: (posts_1.post_id = user_posts_1.post_id)
--                  ->  Seq Scan on posts posts_1  (cost=0.00..7.75 rows=113 width=4) (actual time=0.002..0.050 rows=113 loops=100)
--                        Filter: (status = 1)
--                        Rows Removed by Filter: 187
--                  ->  Hash  (cost=5.75..5.75 rows=3 width=4) (actual time=0.035..0.035 rows=3 loops=100)
--                        Buckets: 1024  Batches: 1  Memory Usage: 9kB
--                        ->  Seq Scan on user_posts user_posts_1  (cost=0.00..5.75 rows=3 width=4) (actual time=0.018..0.033 rows=3 loops=100)
--                              Filter: (user_id = up.user_id)
--                              Rows Removed by Filter: 297
--    SubPlan 3
--      ->  Aggregate  (cost=13.76..13.77 rows=1 width=8) (actual time=0.102..0.102 rows=1 loops=100)
--            ->  Hash Join  (cost=5.79..13.76 rows=1 width=4) (actual time=0.081..0.099 rows=1 loops=100)
--                  Hash Cond: (posts_2.post_id = user_posts_2.post_id)
--                  ->  Seq Scan on posts posts_2  (cost=0.00..7.75 rows=84 width=4) (actual time=0.002..0.049 rows=84 loops=100)
--                        Filter: (status = 2)
--                        Rows Removed by Filter: 216
--                  ->  Hash  (cost=5.75..5.75 rows=3 width=4) (actual time=0.037..0.037 rows=3 loops=100)
--                        Buckets: 1024  Batches: 1  Memory Usage: 9kB
--                        ->  Seq Scan on user_posts user_posts_2  (cost=0.00..5.75 rows=3 width=4) (actual time=0.020..0.035 rows=3 loops=100)
--                              Filter: (user_id = up.user_id)
--                              Rows Removed by Filter: 297
--  Planning Time: 1.156 ms
--  Execution Time: 32.489 ms
-- (42 rows)