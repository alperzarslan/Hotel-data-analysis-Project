--Let's unite all the years together
select *
from Hotel.dbo.[2018]
union
select *
from Hotel.dbo.[2019]
union
select *
from Hotel.dbo.[2020]

--Let's do some explanatory data analysis
--Let's create temprorary table to make further analysis
with hotels as
(
select *
from Hotel.dbo.[2018]
union
select *
from Hotel.dbo.[2019]
union
select *
from Hotel.dbo.[2020]
)

select * from Hotels
order by 1, 4, 6

--Let's calculate the total_days_stayed, and revenue
with hotels as
(
select *
from Hotel.dbo.[2018]
union
select *
from Hotel.dbo.[2019]
union
select *
from Hotel.dbo.[2020]
)

select arrival_date_year, (cast(stays_in_weekend_nights as int)+cast(stays_in_week_nights as int)) as total_days_stayed
,(cast(stays_in_weekend_nights as int)+cast(stays_in_week_nights as int))*cast(adr as float) as revenue
from Hotels

--Let's now group it by year
-- Thereon we can see if revenue increases by year
with hotels as
(
select *
from Hotel.dbo.[2018]
union
select *
from Hotel.dbo.[2019]
union
select *
from Hotel.dbo.[2020]
)

select arrival_date_year, sum((cast(stays_in_weekend_nights as int)+cast(stays_in_week_nights as int))*cast(adr as float)) as revenue
from Hotels
group by arrival_date_year

--Let's break it down by hotel type
with hotels as
(
select *
from Hotel.dbo.[2018]
union
select *
from Hotel.dbo.[2019]
union
select *
from Hotel.dbo.[2020]
)

select arrival_date_year, 
hotel,
round(sum((cast(stays_in_weekend_nights as int)+cast(stays_in_week_nights as int))*cast(adr as float)),2) as revenue
from Hotels
group by arrival_date_year, hotel

-- Let's see market segment data
select * 
from Hotel.dbo.segment

--Let's see meals data
select * 
from Hotel.dbo.meals

--Let's join market segment into our united data
with hotels as
(
select *
from Hotel.dbo.[2018]
union
select *
from Hotel.dbo.[2019]
union
select *
from Hotel.dbo.[2020]
)

select * from Hotels
left join Hotel.dbo.segment --let's keep original data from 2018/19/20 united data, so use left join
on hotels.market_segment = segment.market_segment 
left join Hotel.dbo.meals --let's keep original data from 2018/19/20 united data, so use left join
on meals.meal = hotels.meal
