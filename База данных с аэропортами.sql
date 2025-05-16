
select array_agg(aircrafts.model) as "Самолёты без бизнес-класса"
from aircrafts 
left join seats on aircrafts.aircraft_code = seats.aircraft_code and seats.fare_conditions = 'Business'
where seats.aircraft_code is null 


select departure_airport as "Город отправления", arrival_airport as "Город назначения", count(*) as "Количество задержанных рейсов"
from flights 
where status = 'Delayed' 
group by departure_airport, arrival_airport
order by count(*) desc 



select count(*) as "Количество рейсов, на которые не продано ни одного билета"
from flights
left join ticket_flights on flights.flight_id = ticket_flights.flight_id
where ticket_flights.flight_id is null


select tickets.passenger_name as "Имя пассажира", array_agg(distinct ticket_flights.flight_id) as "Уникальные направления его полетов", count(*) as "Общее количество купленных билетов"
from tickets 
join ticket_flights on tickets.ticket_no = ticket_flights.ticket_no
group by tickets.passenger_name
having count(*) > 700 
order by count(*) 



select 'Количество рейсов, вылетающие из Пулково', count(*) as "Количество рейсов"  
from flights 
where departure_airport = 'LED'
union 
select 'Количество рейсов, приземляющихся в Домодедово', count(*) as "Количество рейсов" 
from flights 
where arrival_airport = 'DME'



select distinct arrival_airport as "Список аэропортов"
from flights
where date(scheduled_arrival) = '2016-11-02'
except 
select distinct arrival_airport
from flights
where date(scheduled_departure) = '2016-11-02' 

