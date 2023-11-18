BEGIN;
  CREATE TABLE IF NOT EXISTS users (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(30) NOT NULL
  );
  CREATE TABLE IF NOT EXISTS posts (
    post_id SERIAL PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    body TEXT NOT NULL DEFAULT '',
    status SMALLSERIAL NOT NULL
  );
  CREATE INDEX posts_status ON posts (post_id, status);
  CREATE TABLE IF NOT EXISTS user_posts (
    user_id SERIAL,
    post_id SERIAL,
    PRIMARY KEY (user_id, post_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (post_id) REFERENCES posts(post_id)
  );
COMMIT;
