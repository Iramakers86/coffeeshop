--CHECK DATA FROM CSV FILE
--the first step is to check the data from the csv file
--how much shops are in the file
select count(*) from coffee c ;
--200 shops are in the csv file
--we want to check if there are any doubles. Does a shop appear in the list more then once?
select place_name, region, place_type, rating, reviews, delivery_option, dine_in_option, take_out_option, count(*) from coffee c2 
group by place_name, region, place_type, rating, reviews, delivery_option, dine_in_option, take_out_option
having count(*) >1;
--There are no shops that appear more than once in the list with the exact same results.
--Are there any places with the same place_name and region listed?
select place_name, region, count(*) from coffee c2 
group by place_name, region, place_type
having count(*) >1;

/*
place_name			region	count
Svit Kavy				E	2
Lviv Coffee Manufacture	E	2
SV Кафе					D	2
Sweeter					I	2 */

--Where do these places differ from each other

select * from coffee c2 
where place_name = 'Svit Kavy' or place_name = 'Lviv Coffee Manufacture' or place_name = 'SV Кафе' or place_name ='Sweeter'
order by place_name;

--The places differ from each other on: 3 shops differ on rating, all 4 shops differ on review and 2 shops differ on delivery option and dine in option
--I would check wether these are the exact same places or wether there are two shops with the same name in a certain region
--If the places are the same the reviews can be added together 
/* example calculation rating for Lviv Coffee Manufacture
 * 778 + 17937 = 18715
 * 778 / 18715 = 4,1%
 * 17937 / 18715 = 96%
 * (4,1*4,5) + (96*4,7) / 100 = 4,6965 = 4,7 */

--REGION: does the region column contain 10 different charcaters from A to J?
select distinct(region) from coffee order by region asc;
select count(*) from coffee c where place_type is null
--yes the region column is correct

--PLACE NAME: does the column place_name contain charcaters, name of the shop?
select place_name from coffee;
select count(*) from coffee c where place_type is null
--there are different signs and languages used which makes it hard to check if something is a place name or a street name etc.

--PLACE TYPE: does the column place_type contain three different values cofee shop, caffee, espresso bar and others 
select distinct(place_type) from coffee c;
select count(*) from coffee where place_type is null
--this is correct and no values missing

--RATING: the column rating should contain a 5 scale numeric value
select count(rating) from coffee c where rating between 0 and 5;
select count(*) from coffee where rating is null;
--there are 2 missing ratings. The given ratings are all between 0 and 5

--REVIEWS: Numeric, number of reviews provided for the shop. Remove the rows if the number of reviews is missing.
select count(reviews) from coffee;
select region, place_name, place_type, rating, reviews from coffee where reviews is null;
--the shops that didn't receive a review also didn't receive a rating. Those two shops will deleted from the table
select * from coffee;
delete from coffee where reviews is null;

--PRICE: the column price contains a character, price category, one of “$”, “$$” or “$$$”.
select distinct(price) from coffee c 
-- this is correct

--DELIVERY: the column delivery_option contains either a true or a false value
select distinct(delivery_option) from coffee c;
select count(delivery_option) from coffee c
--checked or unchecked, no missing values 

--DINE IN: the column dine_in_option contains either a true of a false value
select distinct(dine_in_option) from coffee c ;
select count(dine_in_option) from coffee c 
--checked or null value, there are 140 shops with a dine in option. I am unsure whether a null value is just not filled or wether there it means false.

--TAKE OUT: 
select distinct(take_out_option) from coffee c ;
select count(take_out_option) from coffee 
-- checked or null value, there are 144 shops with a take out delivery_option. I am unsure whether a null value is just not filled or wether there it means false.

/* The only adaptation made to the data is deleting two shops who did not have a rating and review. 
 * In all the other columns the expected values were found. */


--QUESTIONS 
--What is the most common place type in this local market?
select place_type, count(*) from coffee c 
group by place_type 
order by count DESC;
--There are 96 coffee shops, followed by 57 cafe's, 25 others and 20 espresso bars. The coffee shops are the most common place type in this local market

--How does the range in number of reviews differ across all shops?
--For this question I have assumed that all the shops listed are different, including the once with the same region and place_name
select min(reviews) as min_review, max(reviews) as max_review from coffee c;
--Number of reviews range from 3 to 17,937
select * from 
(select 
	*, 
	row_number() over(order by reviews) min_review, 
	row_number() over (order by reviews desc) max_review 
from coffee review) 
review where 1 in (min_review, max_review) order by reviews;
--We have to keep in mind that the Lviv Coffee Manufacture is listed twice 

--How does the number of reviews vary across each place type?
select * from 
(select 
	*, 
	rank() over(partition by place_type order by reviews) min_review, 
	rank() over (partition by place_type order by reviews desc) max_review 
from coffee review) 
review where 1 in (min_review, max_review) order by place_type;
--Here we can see the highest and lowest amount of reviews per place_type
--Now I want to know which place type has the biggest range in reviews
 
select place_name, place_type, rating, reviews, 
reviews - lag(reviews) over (partition by place_type) as increase from 
(select 
	*, 
	rank() over(partition by place_type order by reviews) min_review, 
	rank() over (partition by place_type order by reviews desc) max_review 
from coffee review) 
review where 1 in (min_review, max_review) order by place_type;
--for the coffee shops there is the biggest range in number of reviews