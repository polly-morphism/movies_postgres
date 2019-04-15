DROP TABLE IF EXISTS query1 CASCADE;
DROP TABLE IF EXISTS query2 CASCADE;
DROP TABLE IF EXISTS query3 CASCADE;
DROP TABLE IF EXISTS query4 CASCADE;
DROP TABLE IF EXISTS query5 CASCADE;
DROP TABLE IF EXISTS query6 CASCADE;
DROP TABLE IF EXISTS query7 CASCADE;
DROP TABLE IF EXISTS query8 CASCADE;
DROP TABLE IF EXISTS query9 CASCADE;
DROP TABLE IF EXISTS RomanceAndComedy CASCADE;
DROP TABLE IF EXISTS RomanceMovies CASCADE;

CREATE TABLE query1(
 	name TEXT,
	moviecount BIGINT
);

INSERT INTO query1(name,moviecount)
	SELECT name, COUNT(*) AS moviecount
	FROM hasagenre
	LEFT JOIN genres
	ON hasagenre.genreid = genres.genreid
	GROUP BY name;
	
CREATE TABLE query2(
	name TEXT,
	rating NUMERIC
);

INSERT INTO query2(name,rating)
	SELECT name, avg_r
	FROM 
		(SELECT genreid, AVG(rating) AS avg_r
		FROM ratings
		INNER JOIN hasagenre
		ON ratings.movieid = hasagenre.movieid
		GROUP BY genreid) AS huyna
	LEFT JOIN genres
	ON huyna.genreid = genres.genreid;
	
CREATE TABLE query3(
	title TEXT,
	CountOfRatings BIGINT
);

INSERT INTO query3(title,CountOfRatings)
	SELECT title, CountOfRatings
	FROM 
		(SELECT movieid, COUNT(ratings) AS CountOfRatings
		FROM ratings
		GROUP BY movieid) AS huyna
	LEFT JOIN movies
	ON huyna.movieid = movies.movieid 
	WHERE CountOfRatings >= 10;

CREATE TABLE query4(
	movieid INT,
	title TEXT
);

INSERT INTO query4(movieid,title)
	SELECT movies.movieid, title
	FROM 
	 	(SELECT movieid
		FROM hasagenre
	 	LEFT JOIN genres
	 	ON hasagenre.genreid=genres.genreid
		WHERE genres.name='Comedy') AS ComedyMovies
	LEFT JOIN movies
	ON movies.movieid = ComedyMovies.movieid;
	
CREATE TABLE query5(
	title TEXT,
	average NUMERIC
);

INSERT INTO query5(title, average)
	SELECT title, AVG(rating)
	FROM movies
	INNER JOIN ratings
	ON movies.movieid = ratings.movieid
	GROUP BY movies.movieid;

CREATE TABLE query6(
	average NUMERIC
);

INSERT INTO query6(average)
	SELECT AVG(rating)
	FROM 
	 	(SELECT movieid, genres.genreid
		FROM hasagenre
	 	LEFT JOIN genres
	 	ON hasagenre.genreid=genres.genreid
		WHERE genres.name='Comedy') AS ComedyMovies
	INNER JOIN ratings 
	ON ComedyMovies.movieid = ratings.movieid
	GROUP BY ComedyMovies.genreid;

CREATE TABLE RomanceMovies(
	movieid INT
);

INSERT INTO RomanceMovies(movieid)
	SELECT movies.movieid
	FROM 
	 	(SELECT movieid
		FROM hasagenre
	 	LEFT JOIN genres
	 	ON hasagenre.genreid=genres.genreid
		WHERE genres.name='Romance') AS RomanceMovies
	LEFT JOIN movies
	ON movies.movieid = RomanceMovies.movieid;
	
CREATE TABLE query7(
	average NUMERIC
);

INSERT INTO query7(average)
	SELECT AVG(rating)
	FROM
		(SELECT RomanceMovies.movieid
		FROM RomanceMovies
		INNER JOIN query4
		ON query4.movieid = RomanceMovies.movieid) AS ComedyAndRomanceMovieid
	INNER JOIN ratings 
	ON ComedyAndRomanceMovieid.movieid = ratings.movieid;
	
CREATE TABLE RomanceAndComedy(
	movieid INT
);

INSERT INTO RomanceAndComedy(movieid)
	SELECT RomanceMovies.movieid
			FROM RomanceMovies
			INNER JOIN query4
			ON query4.movieid = RomanceMovies.movieid;
		
CREATE TABLE query8(
	average NUMERIC
);
	

INSERT INTO query8(average)
  SELECT AVG(rating)
  FROM
    (SELECT DISTINCT RomanceMovies.movieid, genreid
    FROM RomanceMovies
    LEFT JOIN hasagenre
      ON RomanceMovies.movieid = hasagenre.movieid
    LEFT JOIN RomanceAndComedy
      ON RomanceMovies.movieid = RomanceAndComedy.movieid
      WHERE RomanceAndComedy.movieid IS NULL) AS RomanceNotComedy
  INNER JOIN ratings
  ON RomanceNotComedy.movieid = ratings.movieid;

CREATE TABLE query9(
	movieid INT,
	rating NUMERIC
);

INSERT INTO query9(movieid, rating)
	SELECT movieid, rating 
	FROM ratings
	WHERE userid = :v1; 
	



