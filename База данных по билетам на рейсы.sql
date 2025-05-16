
with monthly_ticket_count as (
    select 
        count(ticket_no) as ticket_count, 
        date_trunc('month', book_date) as month
    from 
        tickets
    join 
        bookings using (book_ref)
    group by 
        date_trunc('month', book_date)
),
total_ticket_count as (
    select 
        count(ticket_no) as ticket_count
    from 
        tickets
    join 
        bookings using (book_ref)
)
select 
    monthly_ticket_count.month, 
    monthly_ticket_count.ticket_count, 
    round((monthly_ticket_count.ticket_count::numeric / total_ticket_count.ticket_count) * 100, 2) as perc
from 
    monthly_ticket_count, total_ticket_count
order by 
    monthly_ticket_count.month


select passenger_name, contact_data
from tickets
where contact_data->>'email' is not null
      and
      contact_data->>'phone' is not null



select 
    departure_airport, 
    arrival_airport,
    round(count(*) filter (where actual_departure is null and actual_arrival is null)::numeric / count(flight_no), 2) as ratio
from 
    flights
group by 
    departure_airport, arrival_airport;


with flight_ranks as (
    select 
        flight_no,
        departure_airport,
        scheduled_departure,
        row_number() over (partition by departure_airport, scheduled_departure order by scheduled_departure) as departure_rank,
        row_number() over (partition by departure_airport, scheduled_arrival order by scheduled_arrival) as arrival_rank
    from flights
)
select
    scheduled_departure::date as departure_date,  
    departure_airport as airport_code,             
    max(case when departure_rank = 1 then flight_no end) as first_departure_flight, 
    max(case when arrival_rank = 1 then flight_no end) as first_arrival_flight
from flight_ranks
group by scheduled_departure::date, departure_airport
having max(departure_rank) > 1 and max(arrival_rank) > 1




with flight_seats as (
    select 
        f.departure_airport as airport_code, 
        f.scheduled_departure::date, 
        count(s.seat_no) as seats, 
        count(f.flight_no) as flight_count
    from 
        flights f
    join 
        airports a on f.departure_airport = a.airport_code
    join 
        aircrafts a2 using (aircraft_code)
    join 
        seats s using (aircraft_code)
    group by 
        f.departure_airport, f.scheduled_departure::date
    having 
        count(f.flight_no) > 1
)
select 
    airport_code, 
    scheduled_departure, 
    flight_count, 
    seats, 
    sum(seats) over (partition by airport_code order by scheduled_departure) as cumulative_seats
from 
    flight_seats
order by 
    airport_code, scheduled_departure

