BEGIN;
  INSERT INTO users (name)
  SELECT substring(md5(random()::text) from 1 for 10)
  FROM generate_series(1, 100);

  INSERT INTO posts (title, body, status)
  SELECT
    substring(md5(random()::text) from 1 for 50),
    md5(random()::text),
    floor(random() * 3)::int
  FROM generate_series(1, 300);

  INSERT INTO user_posts (user_id, post_id)
  SELECT
    user_id,
    post_id
  FROM
    users
  JOIN LATERAL (
    SELECT post_id
    FROM posts
    WHERE post_id BETWEEN (user_id - 1) * 3 + 1 AND user_id * 3
  ) p ON true;
COMMIT;
