CREATE TABLE appleStore_description_combined AS

SELECT * FROM appleStore_description1

UNION ALL

SELECT * FROM appleStore_description2

UNION ALL

SELECT * FROM appleStore_description3

UNION all

select * from appleStore_description4

**EXPLORATORY DATA ANALYSIS**

-- Check the number of unique apps in both tablesAppleStoreAppleStore

select count(DISTINCT id) AS UniqueAppIDs
FROM AppleStore

select count(DISTINCT id) AS UniqueAppIDs
FROM appleStore_description_combined

-- Check for missing values in key fieldsAppleStoreAppleStore

SELECT COUNT(*) MissingValues
FROM AppleStore
WHERE track_name IS NULL OR user_rating IS NULL OR prime_genre IS NULL

SELECT COUNT(*) MissingValues
FROM appleStore_description_combined
WHERE app_desc IS NULL

-- Find out the number of apps per genreAppleStore

SELECT prime_genre, count(*) AS NumApps
FROM AppleStore
GROUP BY prime_genre
ORDER BY NumApps DESC

-- Get overview of the apps ratings 
SELECT min(user_rating) AS MinRating,
	   max(user_rating) AS MaxRating,
       avg(user_rating) AS AvgRating
FROM AppleStore

-- Determine whether paid apps have higher ratings than free appsAppleStore

SELECT CASE
			when price > 0 THEN 'Paid'
        	Else 'Free'
    	END AS App_type, avg(user_rating) AS Avg_Rating
FROM AppleStore
GROUP by App_Type

-- Check if apps that support more languages have higher ratings

SELECT CASE
			WHEN lang_num < 10 THEN '10 Languages'
            WHEN lang_num BETWEEN 10 AND 30 THEN '10-30 Languages'
            ELSE '>30 Languages'
       END AS Language_bucket,
       avg(user_rating) AS Avg_Rating
FROM AppleStore
GROUP BY language_bucket
Order by Avg_Rating DESC

-- Check the genre with low ratings

SELECT prime_genre,
		avg(user_rating) AS Avg_Rating
FROM AppleStore
GROUP BY prime_genre
ORDER BY Avg_Rating ASC
limit 10

-- check if there is a correlation between the length of description and rating

SELECT CASE
			WHEN length(b.app_desc) < 500 THEN 'Short'
            WHEN length(b.app_desc) BETWEEN 500 AND 1000 THEN 'Medium'
            ELSE 'Long'
       END AS description_length_bucket, avg(a.user_rating) AS average_rating
       
from
	AppleStore as a
JOIN
	appleStore_description_combined AS b
on 
	a.id = b.id


GROUP BY description_length_bucket
order by average_rating ASC

-- Check the top-ratedapps for each category  

SELECT
	prime_genre,
    track_name,
    user_rating
FROM (
  	  SELECT
  		prime_genre,
  		track_name,
  		user_rating,
  		RANK() OVER(PARTITION BY prime_genre ORDER BY user_rating DESC, rating_count_tot DESC) AS rank
  		FROM
  		AppleStore
  	) AS a
WHERE
a.rank = 1
