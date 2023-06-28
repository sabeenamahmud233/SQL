
DROP TABLE IF EXISTS netflix;

CREATE TABLE `netflix` (
  `id` VARCHAR(100),
  `title` VARCHAR(500),
  `type` VARCHAR(100),
  `description` VARCHAR(1000),
  `release_year` INT DEFAULT NULL,
  `age_certification` VARCHAR(100),
  `runtime` INT DEFAULT NULL,
  `genres` VARCHAR(100),
  `production_countries` VARCHAR(100),
  `seasons` VARCHAR(100),
  `imdb_id` VARCHAR(100),
  `imdb_score` VARCHAR(10) DEFAULT NULL,
  `imdb_votes` VARCHAR(10) DEFAULT NULL,
  `tmdb_popularity` VARCHAR(10) DEFAULT NULL,
  `tmdb_score` VARCHAR(10) DEFAULT NULL
);