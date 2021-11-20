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

select 
hotel
,is_canceled
,lead_time
,hotels.meal --There was a confusion, so called from hotels
,country
,hotels.market_segment --There was a confusion of which market segment was it, so called from hotels
,distribution_channel
,is_repeated_guest
,reserved_room_type
,assigned_room_type
,booking_changes
,deposit_type
,agent
,company
,days_in_waiting_list
,customer_type
,adr
,required_car_parking_spaces
,total_of_special_requests
,reservation_status
,convert(nvarchar, reservation_status_date, 103) as Reservation_date
,concat(RIGHT('0' + CAST(arrival_date_day_of_month AS VARCHAR(2)), 2), '/', SUBSTRING( arrival_date_month, 1, 3 ) ,'/', arrival_date_year)
,convert(int,(stays_in_weekend_nights+stays_in_week_nights)) as Total_stay
,convert(int, (adults+(case when ISNUMERIC(children)=1 then children else 0 end)+babies)) as Guest_number_in_room --some of children data had NA which was 0, so made the conversion with case function
,convert(float,((stays_in_weekend_nights+stays_in_week_nights)*(1-discount)*adr) ) as Reveneue
,convert(float,(cost*(stays_in_weekend_nights+stays_in_week_nights))) as Total_meal_cost
,(convert(float,((stays_in_weekend_nights+stays_in_week_nights)*(1-discount)*adr) )-convert(float,(cost*(stays_in_weekend_nights+stays_in_week_nights)))) as Fic_Profit
,convert(float,discount) as Discount

from Hotels
left join Hotel.dbo.segment --let's keep original data from 2018/19/20 united data, so use left join
on hotels.market_segment = segment.market_segment 
left join Hotel.dbo.meals --let's keep original data from 2018/19/20 united data, so use left join
on meals.meal = hotels.meal
where (is_canceled = 0) OR (reservation_status = 'Checked-Out') OR (( reservation_status != 'Checked-Out') AND (deposit_type = 'Non Refund')) OR (( reservation_status = 'No-Show') AND (deposit_type != 'No Deposit'))
