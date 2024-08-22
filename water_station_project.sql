-- water_stations table
CREATE TABLE water_stations (
    station_id SERIAL PRIMARY KEY,
    station_name VARCHAR(100) NOT NULL,
    station_location VARCHAR(255) NOT NULL
);

--the pumps table
CREATE TABLE pumps (
    pump_id SERIAL PRIMARY KEY,
    station_id INT REFERENCES water_stations(station_id),
    status VARCHAR(10) NOT NULL,
    head DECIMAL(5, 2) NOT NULL,
    flow DECIMAL(10, 2) NOT NULL,
    power_factor DECIMAL(3, 2) NOT NULL,
    power_consumption DECIMAL(10, 2) NOT NULL,
    working_hours_per_day INT NOT NULL,
    last_maintenance_date DATE NOT NULL
);

-- pump_operations table
CREATE TABLE pump_operations (
    operation_id SERIAL PRIMARY KEY,
    pump_id INT REFERENCES pumps(pump_id),
    datetime TIMESTAMP NOT NULL,
    operational_pumps_count VARCHAR(50) NOT NULL
);

--  water_flow table
CREATE TABLE water_flow (
    flow_id SERIAL PRIMARY KEY,
    station_id INT REFERENCES water_stations(station_id),
    datetime TIMESTAMP NOT NULL,
    total_input_flow DECIMAL(10, 2) NOT NULL,
    total_output_flow DECIMAL(10, 2) NOT NULL,
    total_output_pressure DECIMAL(5, 2) NOT NULL
);

--  tank_levels table
CREATE TABLE tank_levels (
    tank_level_id SERIAL PRIMARY KEY,
    station_id INT REFERENCES water_stations(station_id),
    datetime TIMESTAMP NOT NULL,
    tank_level DECIMAL(5, 2) NOT NULL
);

--  the customer_complaints table
CREATE TABLE customer_complaints (
    complaint_id SERIAL PRIMARY KEY,
    station_id INT REFERENCES water_stations(station_id),
    datetime TIMESTAMP NOT NULL,
    complaint_count INT NOT NULL,
    complaint_type VARCHAR(50) NOT NULL
);

--  city_network_maintenance table
CREATE TABLE city_network_maintenance (
    maintenance_id SERIAL PRIMARY KEY,
    station_id INT REFERENCES water_stations(station_id),
    datetime TIMESTAMP NOT NULL,
    maintenance_time_hours DECIMAL(5, 2) NOT NULL,
    maintenance_cost DECIMAL(10, 2) NOT NULL
);

--  leakages table
CREATE TABLE leakages (
    leakage_id SERIAL PRIMARY KEY,
    station_id INT REFERENCES water_stations(station_id),
    datetime TIMESTAMP NOT NULL,
    leakage_location VARCHAR(255) NOT NULL,
    wasted_water_litres DECIMAL(10, 2) NOT NULL
);


--  dummy data for the water_stations table
INSERT INTO water_stations (station_name, station_location)
SELECT
    'Station_' || (RANDOM() * 5 + 1)::int,              -- from 1 to 6
    'Location_' || (RANDOM() * 10 + 1)::int             -- from 1 to 11
FROM
    generate_series(1, 100) AS s;                       -- 100 rows for the water_stations table



--  dummy data for the pumps table
INSERT INTO pumps (station_id, status, head, flow, power_factor, power_consumption, working_hours_per_day, last_maintenance_date)
SELECT
    (RANDOM() * 99 + 1)::int,                           -- starting from 1
    CASE WHEN RANDOM() > 0.5 THEN 'On' ELSE 'Off' END,  --  status (On/Off)
    ROUND((RANDOM() * 10 + 50)::numeric, 2),            --  maxi height which can the pump reaches (50-59 bar)
    ROUND((RANDOM() * 1000 + 5000)::numeric, 2),        --  flow (5000-5900 Liters/hour)
    ROUND((RANDOM() * 0.2 + 0.7)::numeric, 2),          -- power factor (0.7-0.9)
    ROUND((RANDOM() * 500 + 2000)::numeric, 2),         --  power consumption (2000-2500 Watts)
    (RANDOM() * 23 + 1)::int,                           --  working hours per day (1-24)
    CURRENT_DATE - INTERVAL '1 day' * (RANDOM() * 100 + 1)::int  --  last maintenance date within the last 100 days
FROM
    generate_series(1, 100) AS s;                       --  100 rows for pumps table



--  dummy data for the pump_operations table
INSERT INTO pump_operations (pump_id, datetime, operational_pumps_count)
SELECT
    (RANDOM() * 99 + 1)::int,                           -- Random pump_id starting from 1
    CURRENT_TIMESTAMP - INTERVAL '1 day' * (RANDOM() * 30 + 1)::int + 
    INTERVAL '1 hour' * (RANDOM() * 23 + 1)::int + 
    INTERVAL '1 minute' * (RANDOM() * 59 + 1)::int,     -- Random date within the last 30 days
    CASE
        -- Nighttime(0:00 AM - 6:00 AM): Fewer pumps operational (1-3 pumps on)
        WHEN EXTRACT(HOUR FROM CURRENT_TIMESTAMP - INTERVAL '1 day' * (RANDOM() * 30 + 1)::int + INTERVAL '1 hour' * (RANDOM() * 23 + 1)::int) BETWEEN 0 AND 6 THEN 
            (RANDOM() * 2 + 1)::int || ' On, ' || (RANDOM() * 1 + 1)::int || ' Standby, ' || (RANDOM() * 1 + 1)::int || ' Maintenance'
        -- Daytime: More pumps operational (2-5 pumps on)
        ELSE 
            (RANDOM() * 3 + 2)::int || ' On, ' || (RANDOM() * 1 + 1)::int || ' Standby, ' || (RANDOM() * 1 + 1)::int || ' Maintenance'
    END -- Conditional logic for nighttime vs. daytime operations
FROM
    generate_series(1, 100) AS s;                       --  100 rows of dummy data

--  dummy data for the water_flow table
INSERT INTO water_flow (station_id, datetime, total_input_flow, total_output_flow, total_output_pressure)
SELECT
    (RANDOM() * 99 + 1)::int,                           -- Random station_id starting from 1
    CURRENT_TIMESTAMP - INTERVAL '1 day' * (RANDOM() * 30 + 1)::int + 
    INTERVAL '1 hour' * (RANDOM() * 23 + 1)::int + 
    INTERVAL '1 minute' * (RANDOM() * 59 + 1)::int,     -- Random date within the last 30 days
    ROUND((RANDOM() * 1000 + 5000)::numeric, 2),        -- Random total input flow (5000-6000 Liters/hour)
    ROUND((RANDOM() * 1000 + 4000)::numeric, 2),        -- Random total output flow (4000-5000 Liters/hour)
    ROUND((RANDOM() * 10 + 20)::numeric, 2)             -- Random total output pressure (20-30 bar)
FROM
    generate_series(1, 100) AS s;                       -- Generating 100 rows for the water_flow table

--  dummy data for the tank_levels table
INSERT INTO tank_levels (station_id, datetime, tank_level)
SELECT
    (RANDOM() * 99 + 1)::int,                           -- Random station_id starting from 1
    CURRENT_TIMESTAMP - INTERVAL '1 day' * (RANDOM() * 30 + 1)::int + 
    INTERVAL '1 hour' * (RANDOM() * 23 + 1)::int + 
    INTERVAL '1 minute' * (RANDOM() * 59 + 1)::int,     -- Random date within the last 30 days
    ROUND((RANDOM() * 100 + 1)::numeric, 2)             -- Random tank level (1-100%)
FROM
    generate_series(1, 100) AS s;                       --  100 rows for the tank_levels table

--  dummy data for the customer_complaints table
INSERT INTO customer_complaints (station_id, datetime, complaint_count, complaint_type)
SELECT
    (RANDOM() * 99 + 1)::int,                           -- Random station_id starting from 1
    CURRENT_TIMESTAMP - INTERVAL '1 day' * (RANDOM() * 30 + 1)::int + 
    INTERVAL '1 hour' * (RANDOM() * 23 + 1)::int + 
    INTERVAL '1 minute' * (RANDOM() * 59 + 1)::int,     -- Random date within the last 30 days
    (RANDOM() * 50 + 1)::int,                           -- Random number of complaints (1-50)
    CASE WHEN RANDOM() > 0.5 THEN 'Water_Shortage' ELSE 'Water_Outage' END  -- Random complaint type
FROM
    generate_series(1, 100) AS s;                       --  100 rows for the customer_complaints table

--  dummy data for the city_network_maintenance table
INSERT INTO city_network_maintenance (station_id, datetime, maintenance_time_hours, maintenance_cost)
SELECT
    (RANDOM() * 99 + 1)::int,                           -- Random station_id starting from 1
    CURRENT_TIMESTAMP - INTERVAL '1 day' * (RANDOM() * 30 + 1)::int + 
    INTERVAL '1 hour' * (RANDOM() * 23 + 1)::int + 
    INTERVAL '1 minute' * (RANDOM() * 59 + 1)::int,     -- Random date within the last 30 days
    ROUND((RANDOM() * 5 + 1)::numeric, 2),              -- Random city network maintenance hours (1-5)
    ROUND((RANDOM() * 500 + 1000)::numeric, 2)          -- Random maintenance cost (1000-1500 currency units)
FROM
    generate_series(1, 100) AS s;                       --  100 rows for the city_network_maintenance table

-- Generate dummy data for the leakages table
INSERT INTO leakages (station_id, datetime, leakage_location, wasted_water_litres)
SELECT
    (RANDOM() * 99 + 1)::int,                           -- Random station_id starting from 1
    CURRENT_TIMESTAMP - INTERVAL '1 day' * (RANDOM() * 30 + 1)::int + 
    INTERVAL '1 hour' * (RANDOM() * 23 + 1)::int + 
    INTERVAL '1 minute' * (RANDOM() * 59 + 1)::int,     -- Random date within the last 30 days
    'Leakage_Location_' || (RANDOM() * 10 + 1)::int,    -- Random leakage location starting from 1
    ROUND((RANDOM() * 500 + 1000)::numeric, 2)          -- Random leakage wasted water (1000-1500 Liters)
FROM
    generate_series(1, 100) AS s;                       --  100 rows for the leakages table






-- production efficiency (total_output_flow/total_input_flow *100)
CREATE TABLE production_efficiency AS
select station_name,station_location, SUM(total_input_flow)AS total_input_flow ,SUM(total_output_flow)AS total_output_flow,
	COALESCE(SUM(wasted_water_litres),0) AS total_leakage,
    ROUND((SUM(total_output_flow)/
	NULLIF((SUM(total_input_flow) - COALESCE(SUM(wasted_water_litres),0)),0))
	*100,2)AS production_efficiency
	
	from water_stations AS ws
	join water_flow AS wf
	on ws.station_id = wf.station_id
	left join leakages
	on ws.station_id = leakages.station_id
	group by ws.station_name ,ws.station_location

	select * from production_efficiency
	
-- convert power consumption into cost (power_consumption* working_hours_per_day* cost per unit lets assume it 0.00015 currency)
	create table power_cost AS
	select 
    ws.station_name,
    ws.station_location, 
    SUM(p.power_consumption * p.working_hours_per_day * 0.00015) AS power_cost
from water_stations AS ws
join  pumps AS p
    on ws.station_id = p.station_id
group by  ws.station_name, ws.station_location


-- Convert the production into Selling  (total_output_flow* price per liter of water produced , lets assume it 0.20 currency)
create table total_revenue AS
select 
    ws.station_name,
    ws.station_location, 
    sum(wf.total_output_flow) as total_output_flow,
    round(sum(wf.total_output_flow) * 0.20, 2) as total_revenue
from 
    water_stations as ws
join 
    water_flow as wf
    on ws.station_id = wf.station_id
group by 
    ws.station_name, 
    ws.station_location;

-- Show the maintenance period
create table maintenance_period AS
select 
    ws.station_name,
    ws.station_location,
    cnm.datetime as maintenance_date,
    lag(cnm.datetime) over (partition by ws.station_id order by cnm.datetime) as previous_maintenance_date,
    age(cnm.datetime, lag(cnm.datetime) over (partition by ws.station_id order by cnm.datetime)) as maintenance_period
from 
    water_stations as ws
join 
    city_network_maintenance as cnm
    on ws.station_id = cnm.station_id
order by 
    ws.station_name, 
    cnm.datetime;


--Waste of selling cost based on maintenance period (price per liter of water produced is 0.20 currency)
create table maintenance_cost_waste as
with maintenance_periods as (
    select 
        ws.station_id,
        coalesce(cnm.datetime::text, '-') as maintenance_date,
        coalesce(lag(cnm.datetime::text) over (partition by ws.station_id order by cnm.datetime), '-') as previous_maintenance_date,
        coalesce(round(extract(epoch from (cnm.datetime - lag(cnm.datetime) over (partition by ws.station_id order by cnm.datetime))) / 3600, 2), 0) as maintenance_hours
    from 
        water_stations ws
    join 
        city_network_maintenance cnm on ws.station_id = cnm.station_id
),
average_production as (
    select 
        wf.station_id,
        round(avg(wf.total_output_flow) / 24, 2) as avg_hourly_production  -- Assuming total_output_flow is daily production
    from 
        water_flow wf
    group by 
        wf.station_id
)
select 
    mp.station_id,
    mp.maintenance_date,
    mp.previous_maintenance_date,
    mp.maintenance_hours,
    
    -- Estimate lost production during maintenance
    coalesce(round(mp.maintenance_hours * ap.avg_hourly_production, 2), 0) as estimated_lost_production,
    
    -- Calculate waste of selling cost
    coalesce(round((mp.maintenance_hours * ap.avg_hourly_production) * 0.20, 2), 0) as waste_of_selling_cost
from 
    maintenance_periods mp
join 
    average_production ap on mp.station_id = ap.station_id
order by 
    mp.station_id, mp.maintenance_date;

--Show the total amount of water production based on hourly/daily/monthly.
create table total_ptoduction_based_on_specific_period AS
select 
    production_data.station_name,
    production_data.station_location,
    
    -- Aggregate total production for each period type
    sum(case when production_data.period_type = 'hourly' then production_data.total_production else 0 end) as hourly_production,
    sum(case when production_data.period_type = 'daily' then production_data.total_production else 0 end) as daily_production,
    sum(case when production_data.period_type = 'monthly' then production_data.total_production else 0 end) as monthly_production

from (
    -- Hourly production
    select 
        ws.station_name,
        ws.station_location,
        'hourly' as period_type,
        sum(wf.total_output_flow) as total_production
    from 
        water_stations as ws
    join 
        water_flow as wf
        on ws.station_id = wf.station_id
    group by 
        ws.station_name, 
        ws.station_location, 
        date_trunc('hour', wf.datetime)
    
    union all
    
    -- Daily production
    select 
        ws.station_name,
        ws.station_location,
        'daily' as period_type,
        sum(wf.total_output_flow) as total_production
    from 
        water_stations as ws
    join 
        water_flow as wf
        on ws.station_id = wf.station_id
    group by 
        ws.station_name, 
        ws.station_location, 
        date_trunc('day', wf.datetime)
    
    union all
    
    -- Monthly production
    select 
        ws.station_name,
        ws.station_location,
        'monthly' as period_type,
        sum(wf.total_output_flow) as total_production
    from 
        water_stations as ws
    join 
        water_flow as wf
        on ws.station_id = wf.station_id
    group by 
        ws.station_name, 
        ws.station_location, 
        date_trunc('month', wf.datetime)
) as production_data

-- Group by station to pivot the data
group by 
    production_data.station_name, 
    production_data.station_location

order by 
    production_data.station_name;



--total profit (total revenue - total cost (total_power_cost + maintanence_cost))
create table station_total_profit as
with revenue as (
    select 
        ws.station_name,
        ws.station_location,
        sum(wf.total_output_flow * 0.20) as total_revenue  
    from 
        water_stations as ws
    join 
        water_flow as wf
        on ws.station_id = wf.station_id
    group by 
        ws.station_name, 
        ws.station_location
),
power_cost as (
    select 
        ws.station_name,
        ws.station_location,
        sum(p.power_consumption * p.working_hours_per_day * 0.00015) as total_power_cost 
    from 
        water_stations as ws
    join 
        pumps as p
        on ws.station_id = p.station_id
    group by 
        ws.station_name, 
        ws.station_location
),
maintenance_cost as (
    select 
        ws.station_name,
        ws.station_location,
        sum(cnm.maintenance_cost) as total_maintenance_cost
    from 
        water_stations as ws
    join 
        city_network_maintenance as cnm
        on ws.station_id = cnm.station_id
    group by 
        ws.station_name, 
        ws.station_location
)
select 
    r.station_name,
    r.station_location,
    r.total_revenue,
    pc.total_power_cost,
    mc.total_maintenance_cost,
    round(r.total_revenue - (pc.total_power_cost + mc.total_maintenance_cost), 2) as total_profit
from 
    revenue as r
join 
    power_cost as pc
    on r.station_name = pc.station_name and r.station_location = pc.station_location
join 
    maintenance_cost as mc
    on r.station_name = mc.station_name and r.station_location = mc.station_location
order by 
    r.station_name;



ALTER TABLE water_stations
ADD COLUMN latitude DECIMAL(9, 6),
ADD COLUMN longitude DECIMAL(9, 6);

-- Update water_stations table with random latitude and longitude within Saudi Arabia (KSA)
UPDATE water_stations
SET latitude = (RANDOM() * (32.0 - 16.0) + 16.0),  -- Latitude range for KSA
    longitude = (RANDOM() * (55.0 - 35.0) + 35.0)  -- Longitude range for KSA
WHERE station_id = station_id;
SELECT *FROM maintenance_period;
