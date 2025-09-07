create database ZATX1;
use ZATX1;
/*TABLE 1 CI_COMPANY*/
create table ci_company
(company_id int auto_increment primary key,
company_name varchar(50)  not null);
insert into ci_company values(1,'ZATX');
select*from ci_company;

/*TABLE 2 CI_OPERATION*/
CREATE TABLE ci_operation (
    operation_code varchar(50) primary KEY,
    operation_name VARCHAR(100) NOT NULL,
    operation_amount DECIMAL(15,2)
);

insert into  ci_operation(operation_code,operation_name,
operation_amount) values('FILLTANK','Tank filling operation',15.00),
('LOADTRUCK','Truck loading operation',7.00),
('TRFTOTANK','Tank to tank transfer',12.00),
('FLUSHPIPE','Pipe flushing opration',5.50),
('CLEANTANK','Tank cleaning operation',9.00),
('RENTAL','Tank rental charges',15.00);
select*from ci_operation;

/*TABLE 3 CI_CUSTOMER*/

CREATE TABLE ci_customer (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(50) NOT NULL
);

ALTER TABLE ci_customer 
AUTO_INCREMENT = 5001;

insert into ci_customer(customer_name) 
values('Linde'),
('Dow Chemical company'),
('ExxonMobil Chemical'),
('BASF'),
('Shell Chemicals'),
('Chevron Phillips Chemical'),
('LyondellBasell'),
('SABIC'),
('Ineos'),
('DuPont'),
('Air Liquide'),
('Eastman Chemical Company'),
('Huntsman Corporation'),
('Solvay'),
('Sumitomo Chemical');

select*from ci_customer;
/*TABLE 4 CI_TANK*/
create table ci_tank
(tank_id int auto_increment primary key,
tank_type enum('small','medium','large'),
max_capacity decimal(15,2),
min_threshold decimal(15,2),
max_threshold decimal(15,2),
current_balance decimal(15,2),
status char(1) default 'f',  -- free
check(current_balance <= max_capacity));

ALTER TABLE ci_Tank AUTO_INCREMENT = 9001;

insert into ci_tank(tank_type,max_capacity,min_threshold,max_threshold,current_balance
,status)values('small', 1000.00, 100.00, 950.00, 0.00, 'F'),
('small', 1200.00, 120.00, 1140.00, 0.00, 'C'),
('small', 1500.00, 150.00, 1425.00, 0.00, 'F'),
('large', 10000.00, 1000.00, 9500.00, 0.00,'F'),
('large', 12000.00, 1200.00, 11400.00, 0.00, 'F'),
('large', 15000.00, 1500.00, 14250.00, 0.00, 'F'),
('large', 18000.00, 1800.00, 17100.00, 0.00, 'F'),
('medium', 5000.00, 500.00, 4750.00, 0.00, 'F'),
('medium', 6000.00, 600.00, 5700.00, 0.00, 'F'),
('medium', 7500.00, 750.00, 7125.00, 0.00, 'F');
select*from ci_tank;

/*TABLE 5 CI_CONTRACT*/
CREATE TABLE ci_contract (
    contract_ID INT PRIMARY KEY AUTO_INCREMENT,
    Customer_ID INT NOT NULL,
    Tank_ID INT NOT NULL,
    Start_Date DATE NOT NULL,
    Duration INT DEFAULT 1,
    End_Date DATE GENERATED ALWAYS AS (DATE_ADD(Start_Date, INTERVAL Duration YEAR)) STORED,
    Status VARCHAR(1) DEFAULT 'A' CHECK (Status IN ('A', 'C')),
    
    FOREIGN KEY (Customer_ID) REFERENCES ci_Customer(Customer_ID),
    FOREIGN KEY (Tank_ID) REFERENCES ci_Tank(Tank_ID)
);
ALTER TABLE ci_contract AUTO_INCREMENT = 7001;

insert into ci_contract
(customer_id, tank_id, start_date, status)
VALUES
(5001,9001,'2024-11-01','A'),
(5002,9002,'2024-11-18','A'),
(5003,9003,'2024-11-28','A'),
(5004,9004,'2024-12-01','A'),
(5005,9005,'2024-12-12','A'),
(5006,9006,'2024-12-25','C'),
(5007,9007,'2025-01-01','A'),
(5008,9008,'2025-01-20','C'),
(5009,9009,'2025-01-30','A'),
(5010,9010,'2025-02-01','A');
select*from ci_contract;

/*TABLE 6 CI_TANKFILL*/
CREATE TABLE ci_tankfill (
    TXN_ID INT AUTO_INCREMENT PRIMARY KEY,    
    TANK_ID INT,                              
    Customer_ID INT,                              
    operation_code VARCHAR(15) NOT NULL,            
    trx_date DATE NOT NULL,                  
    Ship_No VARCHAR(15),                      
    Quantity DECIMAL(15, 2) CHECK (Quantity > 0.00), 
    Status VARCHAR(1) NOT NULL,              
    
    FOREIGN KEY (TANK_ID) REFERENCES ci_tank(Tank_ID),
    FOREIGN KEY (Customer_ID) REFERENCES ci_customer(Customer_ID)
);

INSERT INTO ci_tankfill (TANK_ID, Customer_ID, operation_code, trx_date, Ship_No, Quantity, Status)
VALUES 
(9001, 5001, 'FILLTANK', '2024-11-02', 'SHIP001', 500.00, 'A'),
(9002, 5002, 'FILLTANK', '2024-11-12', 'SHIP002', 600.00, 'A'),
(9003, 5003, 'FILLTANK', '2024-11-22', 'SHIP003', 750.00, 'A'),
(9004, 5004, 'FILLTANK', '2024-12-03', 'SHIP004', 900.00, 'C'),
(9005, 5005, 'FILLTANK', '2024-12-15', 'SHIP005', 850.00, 'A'),
(9006, 5006, 'FILLTANK', '2024-12-28', 'SHIP006', 1000.00, 'C'),
(9007, 5007, 'FILLTANK', '2025-01-05', 'SHIP007', 1100.00, 'A'),
(9008, 5008, 'FILLTANK', '2025-01-18', NULL, 700.00, 'C'),
(9009, 5009, 'FILLTANK', '2025-01-28', 'SHIP009', 950.00, 'A'),
(9010, 5010, 'FILLTANK', '2025-02-05', 'SHIP010', 800.00, 'A');

select*from ci_tankfill;

/*TABLE 7 CI_TRUCKLOAD*/
CREATE TABLE ci_truckload (
    TXN_ID INT AUTO_INCREMENT PRIMARY KEY,              
    TANK_ID INT,                                    
    Customer_ID INT,                                    
    operation_code VARCHAR(15) NOT NULL,               
    trx_date DATE NOT NULL,                       
    Truck_No VARCHAR(15) NOT NULL,                  
    entry_truck_wt DECIMAL(15,2) DEFAULT NULL,      
    exit_truck_wt DECIMAL(15,2) DEFAULT NULL,       
    net_wt DECIMAL(15,2) DEFAULT NULL,              
    Status VARCHAR(1) NOT NULL DEFAULT 'A',         
    
    FOREIGN KEY (TANK_ID) REFERENCES ci_tank(Tank_ID),
    FOREIGN KEY (Customer_ID) REFERENCES ci_customer(Customer_ID)
);
INSERT INTO ci_truckload (TANK_ID, Customer_ID, operation_code, trx_date, Truck_No, entry_truck_wt, exit_truck_wt, net_wt, Status)
VALUES 
(9001, 5001, 'LOADTRUCK', '2024-11-05', 'TRUCK001', 5000.00, 8000.00, 3000.00, 'A'),
(9002, 5002, 'LOADTRUCK', '2024-11-15', 'TRUCK002', 4800.00, 7500.00, 2700.00, 'A'),
(9003, 5003, 'LOADTRUCK', '2024-11-25', 'TRUCK003', 5100.00, 7900.00, 2800.00, 'A'),
(9004, 5004, 'LOADTRUCK', '2024-12-05', 'TRUCK004', 4900.00, 7700.00, 2800.00, 'C'),
(9005, 5005, 'LOADTRUCK', '2024-12-16', 'TRUCK005', 4700.00, 7200.00, 2500.00, 'A'),
(9006, 5006, 'LOADTRUCK', '2024-12-28', 'TRUCK006', 4950.00, 7950.00, 3000.00, 'A'),
(9007, 5007, 'LOADTRUCK', '2025-01-07', 'TRUCK007', 4800.00, 7600.00, 2800.00, 'A'),
(9008, 5008, 'LOADTRUCK', '2025-01-19', 'TRUCK008', 5100.00, 7900.00, 2800.00, 'C'),
(9009, 5009, 'LOADTRUCK', '2025-01-30', 'TRUCK009', 5200.00, 8000.00, 2800.00, 'A'),
(9010, 5010, 'LOADTRUCK', '2025-02-07', 'TRUCK010', 5000.00, 7900.00, 2900.00, 'A');
select*from ci_truckload;

/*TABLE 8 CI_TRANLOG*/
CREATE TABLE ci_tranlog (
    Txn_id INT AUTO_INCREMENT PRIMARY KEY,
    Operation_code VARCHAR(15) NOT NULL,
    Customer_ID INT NOT NULL,
    TRX_DT DATE NOT NULL,
    trx_qty DECIMAL(15,2) NOT NULL CHECK (trx_qty > 0.00)
);
INSERT INTO ci_tranlog (Operation_code, Customer_ID, TRX_DT, trx_qty)
VALUES 
('FILLTANK', 5001, '2024-11-01', 500.00),
('FILLTANK', 5002, '2024-11-18', 800.00),
('FILLTANK', 5003, '2024-11-28', 600.00),
('FILLTANK', 5004, '2024-12-01', 1000.00),
('FILLTANK', 5005, '2024-12-12', 900.00),
('LOADTRUCK', 5001, '2024-11-05', 3000.00),
('LOADTRUCK', 5002, '2024-11-15', 2700.00),
('LOADTRUCK', 5003, '2024-11-25', 2800.00),
('LOADTRUCK', 5004, '2024-12-05', 2800.00),
('LOADTRUCK', 5005, '2024-12-16', 2500.00);

select*from ci_tranlog;

DROP PROCEDURE IF EXISTS fill_tank;
DROP PROCEDURE IF EXISTS TruckEntry;
DROP PROCEDURE IF EXISTS add_new_contract;


/*STORED_PROCEDURE OF ADD_NEW_CONTRACT*/

DELIMITER //

CREATE PROCEDURE add_new_contract(
    IN p_customer_id INT,
    IN p_tank_id INT,
    IN p_start_date DATE,
    IN p_duration INT
)
BEGIN
    DECLARE v_customer_count INT;
    DECLARE v_tank_count INT;
    DECLARE v_tank_status CHAR(1);

    -- Check if the customer exists
    SELECT COUNT(*) INTO v_customer_count
    FROM ci_customer
    WHERE customer_id = p_customer_id;

    IF v_customer_count = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Customer does not exist.';
    END IF;

    -- Check if the tank exists and get its status
    SELECT COUNT(*), MAX(status) INTO v_tank_count, v_tank_status
    FROM ci_tank
    WHERE tank_id = p_tank_id;

    IF v_tank_count = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tank does not exist.';
    END IF;

    -- Check if the tank is free ('F')
    IF v_tank_status <> 'F' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tank is not available for new contract.';
    END IF;

    -- Check that start date is today or future
    IF p_start_date < CURRENT_DATE THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Start date must be today or a future date.';
    END IF;

    -- Insert new contract into ci_contract
    INSERT INTO ci_contract (customer_id, tank_id, start_date, duration)
    VALUES (p_customer_id, p_tank_id, p_start_date, p_duration);

    -- Update tank status to 'C' (Contracted)
    UPDATE ci_tank
    SET status = 'C'
    WHERE tank_id = p_tank_id;

END //

DELIMITER ;

CALL add_new_contract(5001, 9004, '2025-05-01', 2);


/*STORED_PROCEDURE 2.FILL_TANK*/

DELIMITER //

CREATE PROCEDURE fill_tank(
    IN p_tank_id INT,
    IN p_customer_id INT,
    IN p_fill_quantity DECIMAL(15,2),
    IN p_ship_no VARCHAR(15),
    IN p_trx_date DATE
)
BEGIN
    DECLARE v_max_capacity DECIMAL(15,2);
    DECLARE v_current_balance DECIMAL(15,2);

    -- Check if Tank exists
    SELECT max_capacity, current_balance INTO v_max_capacity, v_current_balance
    FROM ci_tank
    WHERE tank_id = p_tank_id;

    IF v_max_capacity IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tank does not exist.';
    END IF;

    -- Check if filling exceeds maximum capacity
    IF v_current_balance + p_fill_quantity > v_max_capacity THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Fill quantity exceeds tank maximum capacity.';
    END IF;

    -- Insert into ci_tankfill
    INSERT INTO ci_tankfill (TANK_ID, Customer_ID, operation_code, trx_date, Ship_No, Quantity, Status)
    VALUES (p_tank_id, p_customer_id, 'FILLTANK', p_trx_date, p_ship_no, p_fill_quantity, 'A');

    -- Update current balance in ci_tank
    UPDATE ci_tank
    SET current_balance = current_balance + p_fill_quantity
    WHERE tank_id = p_tank_id;
    
    -- Insert into ci_tranlog
    INSERT INTO ci_tranlog (Operation_code, Customer_ID, TRX_DT, trx_qty)
    VALUES ('FILLTANK', p_customer_id, p_trx_date, p_fill_quantity);

END //

DELIMITER ;

CALL fill_tank(9001, 5001, 500.00, 'SHIP011', '2025-06-05');


/*STORED_PROCEDURE 3 TRUCK ENTRY*/

DELIMITER //

CREATE PROCEDURE TruckEntry(
    IN p_tank_id INT,
    IN p_customer_id INT,
    IN p_truck_no VARCHAR(15),
    IN p_entry_truck_wt DECIMAL(15,2),
    IN p_trx_date DATE
)
BEGIN
    -- Insert a new truck entry record
    INSERT INTO ci_truckload (TANK_ID, Customer_ID, operation_code, trx_date, Truck_No, entry_truck_wt, Status)
    VALUES (p_tank_id, p_customer_id, 'LOADTRUCK', p_trx_date, p_truck_no, p_entry_truck_wt, 'A');
    
END //

DELIMITER ;

CALL TruckEntry(9001, 5001, 'TRUCK011', 4500.00, '2025-06-06');

/*STORED_PROCEDURE 4 TRUCK EXIT*/

DELIMITER //

CREATE PROCEDURE TruckExit(
    IN p_truck_no VARCHAR(15),
    IN p_exit_truck_wt DECIMAL(15,2)
)
BEGIN
    DECLARE v_entry_truck_wt DECIMAL(15,2);
    DECLARE v_net_weight DECIMAL(15,2);
    DECLARE v_customer_id INT;
    DECLARE v_trx_date DATE;

    -- Get the entry weight and customer_id for this truck (only the latest open trip)
    SELECT entry_truck_wt, Customer_ID, trx_date INTO v_entry_truck_wt, v_customer_id, v_trx_date
    FROM ci_truckload
    WHERE Truck_No = p_truck_no AND exit_truck_wt IS NULL
    ORDER BY TXN_ID DESC
    LIMIT 1;

    IF v_entry_truck_wt IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Truck entry not found or already exited.';
    END IF;

    -- Calculate net weight
    SET v_net_weight = p_exit_truck_wt - v_entry_truck_wt;

    IF v_net_weight <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Exit weight must be greater than entry weight.';
    END IF;

    -- Update ci_truckload with exit details
    UPDATE ci_truckload
    SET exit_truck_wt = p_exit_truck_wt,
        net_wt = v_net_weight,
        Status = 'C'
    WHERE Truck_No = p_truck_no
    AND exit_truck_wt IS NULL
    LIMIT 1;

    -- Insert into ci_tranlog
    INSERT INTO ci_tranlog (Operation_code, Customer_ID, TRX_DT, trx_qty)
    VALUES ('LOADTRUCK', v_customer_id, v_trx_date, v_net_weight);

END //

DELIMITER ;

CALL TruckExit('TRUCK011', 7500.00);

/*TRIGGER 1 AFTER_TRUCKLOAD_UPDATE*/

DELIMITER //

CREATE TRIGGER after_truckload_update
AFTER UPDATE ON ci_truckload
FOR EACH ROW
BEGIN
    -- Only act if the truck exit weight is updated and net weight is calculated
    IF NEW.exit_truck_wt IS NOT NULL AND OLD.exit_truck_wt IS NULL THEN
        -- Update the tank's current balance
        UPDATE ci_tank
        SET current_balance = current_balance - NEW.net_wt
        WHERE tank_id = NEW.TANK_ID;

        -- Insert transaction log
        INSERT INTO ci_tranlog (Operation_code, Customer_ID, TRX_DT, trx_qty)
        VALUES ('LOADTRUCK', NEW.Customer_ID, NEW.trx_date, NEW.net_wt);
    END IF;
END //

DELIMITER ;


/*GENERATING REPORTS*/
/*1. List of all tanks with their current status and balance*/

SELECT 
    tank_id, 
    tank_type, 
    status AS tank_status, 
    current_balance
FROM 
    ci_tank;
   

/*2. Active contracts with customer details*/

    SELECT 
    c.Contract_ID,
    c.Start_Date,
    c.End_Date,
    c.Status AS contract_status,
    cu.customer_name,
    t.tank_type,
    t.status AS tank_status
FROM 
    ci_contract c
JOIN 
    ci_customer cu ON c.Customer_ID = cu.Customer_ID
JOIN 
    ci_tank t ON c.Tank_ID = t.Tank_ID
WHERE 
    c.Status = 'A';  -- Active contracts
  
  

/*3. Transaction history for a specific customer*/

    SELECT 
    c.customer_name,
    tf.operation_code AS tank_operation,
    tf.trx_date AS transaction_date,
    tf.Quantity AS quantity_filled,
    tl.operation_code AS truck_operation,
    tl.trx_date AS truck_transaction_date,
    tl.net_wt AS truck_weight
FROM 
    ci_customer c
LEFT JOIN 
    ci_tankfill tf ON c.Customer_ID = tf.Customer_ID
LEFT JOIN 
    ci_truckload tl ON c.Customer_ID = tl.Customer_ID
WHERE 
    c.Customer_ID = 5001  -- Specify the customer ID here
ORDER BY 
    tf.trx_date DESC, tl.trx_date DESC;
  
  
  /*4. Daily summary of tank filling operations*/
  
    SELECT 
    tf.trx_date,
    t.tank_id,
    t.tank_type,
    SUM(tf.Quantity) AS total_quantity_filled
FROM 
    ci_tankfill tf
JOIN 
    ci_tank t ON tf.Tank_ID = t.Tank_ID
GROUP BY 
    tf.trx_date, t.tank_id
ORDER BY 
    tf.trx_date DESC;
    

/*5. Daily summary of truck loading operations*/

    SELECT 
    tl.trx_date,
    t.tank_id,
    t.tank_type,
    SUM(tl.net_wt) AS total_weight_loaded
FROM 
    ci_truckload tl
JOIN 
    ci_tank t ON tl.Tank_ID = t.Tank_ID
GROUP BY 
    tl.trx_date, t.tank_id
ORDER BY 
    tl.trx_date DESC;













