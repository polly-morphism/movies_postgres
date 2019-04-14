--- users: userid (int, primary key), name (text)
--- movies: movieid (integer, primary key), title (text)
--- taginfo: tagid (int, primary key), content (text)
--- genres: genreid (integer, primary key), name (text)
--- ratings: userid (int, foreign key), movieid (int, foreign key), rating (numeric), timestamp (bigint, seconds since midnight Coordinated Universal Time (UTC) of January 1, 1970)
--- tags: userid (int, foreign key), movieid (int, foreign key), tagid (int, foreign key), timestamp (bigint, seconds since midnight Coordinated Universal Time (UTC) of January 1, 1970).
--- hasagenre: movieid (int, foreign key), genreid (int, foreign key)
DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS movies CASCADE;
DROP TABLE IF EXISTS taginfo CASCADE;
DROP TABLE IF EXISTS genres CASCADE;
DROP TABLE IF EXISTS ratings CASCADE;
DROP TABLE IF EXISTS tags CASCADE;
DROP TABLE IF EXISTS hasagenre CASCADE;

CREATE TABLE users(
   userid INT PRIMARY KEY NOT NULL,
   name TEXT NOT NULL
);
CREATE TABLE movies(
   movieid INT PRIMARY KEY NOT NULL,
   title TEXT NOT NULL
);
CREATE TABLE taginfo(
   tagid INT PRIMARY KEY NOT NULL,
   content TEXT NOT NULL
);
CREATE TABLE genres(
   genreid INT PRIMARY KEY NOT NULL,
   name TEXT NOT NULL
);
CREATE TABLE ratings(
   userid INT REFERENCES users(userid),
   movieid INT REFERENCES movies(movieid),
   rating NUMERIC NOT NULL CHECK(rating>=0 AND rating<=5),
   timestamp BIGINT NOT NULL,
   PRIMARY KEY (userid, movieid)
);
CREATE TABLE tags(
   userid INT REFERENCES users(userid),
   movieid INT REFERENCES movies(movieid),
   tagid INT REFERENCES taginfo(tagid),
   timestamp BIGINT NOT NULL,
   PRIMARY KEY (userid, movieid, tagid)
);
CREATE TABLE hasagenre(
   movieid INT REFERENCES movies(movieid),
   genreid INT REFERENCES genres(genreid),
   PRIMARY KEY (movieid, genreid)
);
