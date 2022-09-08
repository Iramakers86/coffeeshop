create table coffee (
	Region varchar,
	Place_name varchar,
	Place_type varchar,
	Rating varchar,
	Reviews varchar,
	Price varchar,
	Delivery_option boolean,
	Dine_in_option boolean,
	Takeout_option boolean);
	
COPY coffee(Region, Place_name, Place_type, Rating, Reviews, Price, Delivery_option, Dine_in_option, Takeout_option)
FROM '/Users/ingeramakers/DataCamp/coffee.csv'
CSV HEADER;

truncate table public.coffee;
ALTER TABLE public.coffee 
RENAME COLUMN 
	"Place name" to place_name;
ALTER TABLE public.coffee 
RENAME COLUMN 
	"Place type" to place_type;
ALTER TABLE public.coffee 
RENAME COLUMN 
	"Delivery option" to delivery_option;
ALTER TABLE public.coffee 
RENAME COLUMN 
	"Dine in option" to dine_in_option;
ALTER TABLE public.coffee 
RENAME COLUMN 
	"Takeout option" to take_out_option;
);