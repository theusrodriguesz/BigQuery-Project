WITH commits AS (
  SELECT
    author.email,
    EXTRACT(DAYOFWEEK
    FROM
      TIMESTAMP_SECONDS(author.date.seconds)) BETWEEN 2
    AND 6 is_weekday,
    LOWER(REGEXP_EXTRACT(diff.new_path, r'\.([^\./\(~_ \- #]*)$')) lang,
    diff.new_path AS path,
    TIMESTAMP_SECONDS(author.date.seconds) AS author_timestamp
  FROM
    `bigquery-public-data.github_repos.commits`,
    UNNEST(difference) diff
  WHERE
    EXTRACT(YEAR
    FROM
      TIMESTAMP_SECONDS(author.date.seconds))=2016)
SELECT
  lang,
  is_weekday,
  COUNT(path) AS numcommits
FROM
  commits
WHERE
  lang IS NOT NULL
GROUP BY
  lang,
  is_weekday
HAVING
  numcommits > 100
ORDER BY
  numcommits DESC