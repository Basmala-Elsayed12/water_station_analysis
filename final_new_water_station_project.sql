

-- water_stations table
CREATE TABLE water_stations (
    station_id SERIAL PRIMARY KEY,
    station_name VARCHAR(100) NOT NULL,
    station_location VARCHAR(255) NOT NULL,
	latitude DECIMAL(9, 6),
    longitude DECIMAL(9, 6)
); 


INSERT INTO water_stations (station_name, station_location, latitude, longitude)
VALUES
    -- Riyadh Stations
    ('Station1_Riyadh', 'Riyadh', (RANDOM() * (25.0 - 24.0) + 24.0), (RANDOM() * (47.0 - 46.0) + 46.0)),
    ('Station2_Riyadh', 'Riyadh', (RANDOM() * (25.0 - 24.0) + 24.0), (RANDOM() * (47.0 - 46.0) + 46.0)),
    ('Station3_Riyadh', 'Riyadh', (RANDOM() * (25.0 - 24.0) + 24.0), (RANDOM() * (47.0 - 46.0) + 46.0)),
    ('Station4_Riyadh', 'Riyadh', (RANDOM() * (25.0 - 24.0) + 24.0), (RANDOM() * (47.0 - 46.0) + 46.0)),
    
    -- Jeddah Stations
    ('Station1_Jeddah', 'Jeddah', (RANDOM() * (22.0 - 21.0) + 21.0), (RANDOM() * (40.0 - 39.0) + 39.0)),
    ('Station2_Jeddah', 'Jeddah', (RANDOM() * (22.0 - 21.0) + 21.0), (RANDOM() * (40.0 - 39.0) + 39.0)),
    ('Station3_Jeddah', 'Jeddah', (RANDOM() * (22.0 - 21.0) + 21.0), (RANDOM() * (40.0 - 39.0) + 39.0)),
    ('Station4_Jeddah', 'Jeddah', (RANDOM() * (22.0 - 21.0) + 21.0), (RANDOM() * (40.0 - 39.0) + 39.0)),
    
    -- Makkah Stations
    ('Station1_Makkah', 'Makkah', (RANDOM() * (21.5 - 21.2) + 21.2), (RANDOM() * (40.0 - 39.6) + 39.6)),
    ('Station2_Makkah', 'Makkah', (RANDOM() * (21.5 - 21.2) + 21.2), (RANDOM() * (40.0 - 39.6) + 39.6)),
    ('Station3_Makkah', 'Makkah', (RANDOM() * (21.5 - 21.2) + 21.2), (RANDOM() * (40.0 - 39.6) + 39.6)),
    ('Station4_Makkah', 'Makkah', (RANDOM() * (21.5 - 21.2) + 21.2), (RANDOM() * (40.0 - 39.6) + 39.6)),
    
    -- Dammam Stations
    ('Station1_Dammam', 'Dammam', (RANDOM() * (27.0 - 26.0) + 26.0), (RANDOM() * (50.0 - 49.0) + 49.0)),
    ('Station2_Dammam', 'Dammam', (RANDOM() * (27.0 - 26.0) + 26.0), (RANDOM() * (50.0 - 49.0) + 49.0)),
    ('Station3_Dammam', 'Dammam', (RANDOM() * (27.0 - 26.0) + 26.0), (RANDOM() * (50.0 - 49.0) + 49.0)),
    ('Station4_Dammam', 'Dammam', (RANDOM() * (27.0 - 26.0) + 26.0), (RANDOM() * (50.0 - 49.0) + 49.0)),
    
    -- Madinah Stations
    ('Station1_Madinah', 'Madinah', (RANDOM() * (25.0 - 24.3) + 24.3), (RANDOM() * (40.0 - 39.5) + 39.5)),
    ('Station2_Madinah', 'Madinah', (RANDOM() * (25.0 - 24.3) + 24.3), (RANDOM() * (40.0 - 39.5) + 39.5)),
    ('Station3_Madinah', 'Madinah', (RANDOM() * (25.0 - 24.3) + 24.3), (RANDOM() * (40.0 - 39.5) + 39.5)),
    ('Station4_Madinah', 'Madinah', (RANDOM() * (25.0 - 24.3) + 24.3), (RANDOM() * (40.0 - 39.5) + 39.5));

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
    last_maintenance_date DATE NOT NULL,
	datetime TIMESTAMP ,
	operational_pumps int,
	standby_pumps int,
	maintenance_pumps int
);


WITH pump_data AS (
    SELECT
        station_id,  -- Select existing station IDs
        CASE WHEN RANDOM() > 0.2 THEN 'On' ELSE 'Off' END AS status,
        TO_CHAR(CURRENT_TIMESTAMP - INTERVAL '1 day' * (RANDOM() * 30 + 1)::int + 
        INTERVAL '1 hour' * (RANDOM() * 23 + 1)::int + 
        INTERVAL '1 minute' * (RANDOM() * 59 + 1)::int, 'YYYY-MM-DD HH24:MI:SS')::timestamp AS datetime  -- Format datetime until seconds
    FROM
        water_stations  -- Pull station IDs from water_stations
    ORDER BY RANDOM()  -- Randomize the selection of stations
    LIMIT 20  -- Limit to 20 rows
)
INSERT INTO pumps (
    station_id, status, head, flow, power_factor, power_consumption, 
    working_hours_per_day, last_maintenance_date, datetime, operational_pumps, standby_pumps, 
    maintenance_pumps
)
SELECT
    station_id,
    status,
    CASE 
        WHEN status = 'On' THEN ROUND((RANDOM() * 10 + 50)::numeric, 2)  -- head (50-59 bar) if status is On
        ELSE 0  -- head is 0 if status is Off
    END AS head,
    CASE 
        WHEN status = 'On' THEN ROUND((RANDOM() * 1000 + 5000)::numeric, 2)  -- flow (5000-5900 Liters/hour) if status is On
        ELSE 0  -- flow is 0 if status is Off
    END AS flow,
    CASE 
        WHEN status = 'On' THEN ROUND((RANDOM() * 0.2 + 0.7)::numeric, 2)  -- power factor (0.7-0.9) if status is On
        ELSE 0  -- power factor is 0 if status is Off
    END AS power_factor,
    CASE 
        WHEN status = 'On' THEN ROUND((RANDOM() * 500 + 2000)::numeric, 2)  -- power consumption (2000-2500 Watts) if status is On
        ELSE 0  -- power consumption is 0 if status is Off
    END AS power_consumption,
    CASE 
        WHEN status = 'On' THEN (RANDOM() * 23 + 1)::int  -- working hours per day (1-24) if status is On
        ELSE 0  -- working hours per day is 0 if status is Off
    END AS working_hours_per_day,

    CURRENT_DATE - INTERVAL '1 day' * (RANDOM() * 100 + 1)::int AS last_maintenance_date, -- last maintenance date within the last 100 days

    datetime,  -- Use the calculated datetime from the CTE
    
    -- Calculate the number of operational, standby, and maintenance pumps based on total pumps
    CASE 
        WHEN status = 'On' THEN 
            CASE 
                WHEN EXTRACT(HOUR FROM datetime) BETWEEN 22 AND 23 OR EXTRACT(HOUR FROM datetime) BETWEEN 0 AND 4 
                THEN ROUND((RANDOM() * 2 + 1))::int  -- Fewer operational pumps at night (1-3)
                ELSE ROUND((RANDOM() * 6 + 2))::int  -- More operational pumps during day/evening (2-8)
            END
        ELSE 0  -- No operational pumps if status is Off
    END AS operational_pumps,
    
    CASE 
        WHEN status = 'On' THEN ROUND((RANDOM() * 2))::int  -- Random number of standby pumps between 0 and 2 if status is On
        ELSE 0  -- No standby pumps if status is Off
    END AS standby_pumps,
    
    CASE 
        WHEN status = 'On' THEN ROUND((RANDOM() * 2))::int  -- Random number of maintenance pumps between 0 and 2 if status is On
        ELSE CASE WHEN RANDOM() > 0.5 THEN ROUND((RANDOM() * 2))::int ELSE 0 END  -- Random chance for maintenance pumps when Off
    END AS maintenance_pumps
   
FROM
    pump_data;


--  water_flow table
CREATE TABLE water_flow (
    flow_id SERIAL PRIMARY KEY,
    station_id INT REFERENCES water_stations(station_id),
    datetime TIMESTAMP NOT NULL,
    total_input_flow DECIMAL(10, 2) NOT NULL,
    total_output_flow DECIMAL(10, 2) NOT NULL,
    total_output_pressure DECIMAL(5, 2) NOT NULL
);




WITH water_flow_data AS (
    SELECT
        station_id,  -- Select existing station IDs
        CASE 
            -- Randomly decide if the station is operational (On/Off)
            WHEN RANDOM() > 0.2 THEN 'On' 
            ELSE 'Off' 
        END AS status,
        -- Randomly generate the number of operational pumps (0 to 8 pumps)
        CASE 
            WHEN RANDOM() > 0.2 THEN ROUND(RANDOM() * 7 + 1)::int  -- 1 to 8 operational pumps
            ELSE 0  -- No operational pumps if status is Off
        END AS operational_pumps,
        CURRENT_TIMESTAMP - INTERVAL '1 day' * (RANDOM() * 30 + 1)::int + 
        INTERVAL '1 hour' * (RANDOM() * 23 + 1)::int + 
        INTERVAL '1 minute' * (RANDOM() * 59 + 1)::int AS datetime  -- Random datetime within the last 30 days
    FROM
        water_stations  
    ORDER BY RANDOM()  
    LIMIT 20 
)
INSERT INTO water_flow (station_id, datetime, total_input_flow, total_output_flow, total_output_pressure)
SELECT
    station_id,  -- Include station ID
    datetime,  -- Include datetime

    -- Calculate total input flow based on the number of operational pumps (Assume each pump provides 1000-1200 L/hour)
    CASE 
        WHEN operational_pumps > 0 THEN operational_pumps * ROUND((RANDOM() * 200 + 1000)::numeric, 2)  -- 1000 to 1200 L/hour per pump
        ELSE 0  -- No flow if no pumps are operational
    END AS total_input_flow,

    -- Calculate total output flow based on the number of operational pumps (Assume each pump provides 800-1000 L/hour to the city network)
    CASE 
        WHEN operational_pumps > 0 THEN operational_pumps * ROUND((RANDOM() * 200 + 800)::numeric, 2)  -- 800 to 1000 L/hour per pump
        ELSE 0  -- No flow if no pumps are operational
    END AS total_output_flow,

    -- Calculate total output pressure based on the number of operational pumps (Assume each pump adds 2-3 bar pressure)
    CASE 
        WHEN operational_pumps > 0 THEN ROUND((operational_pumps * (RANDOM() * 1 + 2))::numeric, 2)  -- 2 to 3 bar per pump
        ELSE 0  -- No pressure if no pumps are operational
    END AS total_output_pressure

FROM
    water_flow_data;



--  tank_levels table
CREATE TABLE tank_levels (
    tank_level_id SERIAL PRIMARY KEY,
    station_id INT REFERENCES water_stations(station_id),
    datetime TIMESTAMP NOT NULL,
    tank_level DECIMAL(5, 2) NOT NULL
);


--  dummy data for the tank_levels table
WITH tank_levels_data AS (
    SELECT
        station_id 
    FROM
        water_stations  
    ORDER BY RANDOM()  -- Randomize the selection of stations
    LIMIT 20  -- Limit to 20 rows
)
INSERT INTO tank_levels (station_id, datetime, tank_level)
SELECT
    station_id,  
    TO_CHAR(CURRENT_TIMESTAMP - INTERVAL '1 day' * (RANDOM() * 30 + 1)::int + 
        INTERVAL '1 hour' * (RANDOM() * 23 + 1)::int + 
        INTERVAL '1 minute' * (RANDOM() * 59 + 1)::int, 'YYYY-MM-DD HH24:MI:SS')::timestamp AS datetime, 
	  ROUND((RANDOM() * 100 + 1)::numeric, 2)             -- Random tank level (1-100%)
   
FROM
    tank_levels_data;
select * from customer_complaints


--  the customer_complaints table
CREATE TABLE customer_complaints (
    complaint_id SERIAL PRIMARY KEY,
    station_id INT REFERENCES water_stations(station_id),
    datetime TIMESTAMP NOT NULL,
    complaint_count INT NOT NULL,
    complaint_type VARCHAR(50) NOT NULL
);
--  dummy data for the customer_complaints table
WITH customer_complaints_data AS (
    SELECT
        station_id 
    FROM
        water_stations  
    ORDER BY RANDOM()  -- Randomize the selection of stations
    LIMIT 20  -- Limit to 20 rows
)
INSERT INTO customer_complaints (station_id, datetime, complaint_count, complaint_type)
SELECT
	station_id,
   
   TO_CHAR(CURRENT_TIMESTAMP - INTERVAL '1 day' * (RANDOM() * 30 + 1)::int + 
        INTERVAL '1 hour' * (RANDOM() * 23 + 1)::int + 
        INTERVAL '1 minute' * (RANDOM() * 59 + 1)::int, 'YYYY-MM-DD HH24:MI:SS')::timestamp AS datetime, 
    (RANDOM() * 50 + 1)::int,                           -- Random number of complaints (1-50)
    CASE WHEN RANDOM() > 0.5 THEN 'Water_Shortage' ELSE 'Water_Outage' END  -- Random complaint type
FROM
   customer_complaints_data;



CREATE TABLE city_network_maintenance (
    maintenance_id SERIAL PRIMARY KEY,
    station_id INT REFERENCES water_stations(station_id),
    datetime TIMESTAMP NOT NULL,
    city_network_maintenance_time_hours DECIMAL(5, 2) NOT NULL,  -- Duration of maintenance in hours
     city_network_maintenance_cost DECIMAL(10, 2) NOT NULL,      -- Cost of the maintenance
    num_employees INT NOT NULL,                    -- Number of employees involved in maintenance
    num_equipment INT NOT NULL                     -- Number of equipment used in maintenance
);

WITH city_network_maintenance_data AS (
    SELECT
        station_id,
        TO_CHAR(CURRENT_TIMESTAMP - INTERVAL '1 day' * (RANDOM() * 30 + 1)::int + 
            INTERVAL '1 hour' * (RANDOM() * 23 + 1)::int + 
            INTERVAL '1 minute' * (RANDOM() * 59 + 1)::int, 'YYYY-MM-DD HH24:MI:SS')::timestamp AS datetime, 
        (RANDOM() * 10 + 1)::numeric AS city_network_maintenance_time_hours,  -- Random maintenance time between 1 and 11 hours
        (RANDOM() * 10 + 5)::int AS num_employees,  -- Random number of employees (5 to 15 employees)
        (RANDOM() * 5 + 2)::int AS num_equipment   -- Random number of equipment (2 to 7 pieces of equipment)
    FROM
        water_stations
    LIMIT 20
)
INSERT INTO city_network_maintenance (station_id, datetime, city_network_maintenance_time_hours, city_network_maintenance_cost, num_employees, num_equipment)
SELECT
    station_id,
    datetime,
    city_network_maintenance_time_hours,
    -- Calculate maintenance cost based on employees and equipment
    (num_employees * 50 * city_network_maintenance_time_hours) +  -- SAR 50/hour per employee
    (num_equipment * 100 * city_network_maintenance_time_hours) AS city_network_maintenance_cost,  -- SAR 100/hour per equipment
    num_employees,
    num_equipment
FROM
    city_network_maintenance_data;

	

--  leakages table
CREATE TABLE leakages (
    leakage_id SERIAL PRIMARY KEY,
    station_id INT REFERENCES water_stations(station_id),
    maintenance_request_time TIMESTAMP NOT NULL,  -- When the leakage was reported
    datetime_maintenance_was_performed TIMESTAMP NOT NULL,  -- When the maintenance was performed
    leakage_location VARCHAR(255) NOT NULL,
    wasted_water_litres DECIMAL(10, 2) NOT NULL   -- Wasted water in liters
);
               
WITH leakage_data AS (
    SELECT
        station_id,
        station_name AS leakage_location,  -- Use station location as the leakage location,
        CURRENT_TIMESTAMP - INTERVAL '1 day' * (RANDOM() * 30 + 1)::int AS maintenance_request_time,  -- Random request time within the last 30 days
        CURRENT_TIMESTAMP - INTERVAL '1 day' * (RANDOM() * 30)::int + 
            INTERVAL '1 hour' * (RANDOM() * 23)::int + 
            INTERVAL '1 minute' * (RANDOM() * 59)::int AS datetime_maintenance_was_performed,  -- Random maintenance time after request time
        (RANDOM() * 10+1)::int AS leakage_rate  -- Random leakage rate between 1 and 11 liters/hour for illustration
    FROM
        water_stations
	WHERE
        RANDOM() < 0.25  -- Select approximately 10% of the stations
    ORDER BY RANDOM()
    LIMIT 20
)
INSERT INTO leakages (station_id, maintenance_request_time, datetime_maintenance_was_performed, leakage_location, wasted_water_litres)
SELECT
    station_id,
    maintenance_request_time,
    datetime_maintenance_was_performed,
    leakage_location,
    -- Calculate wasted water based on the time difference between request and maintenance
    EXTRACT(EPOCH FROM (datetime_maintenance_was_performed - maintenance_request_time)) / 3600 * leakage_rate AS wasted_water_litres  -- Convert seconds to hours and multiply by leakage rate
FROM
    leakage_data;


 
