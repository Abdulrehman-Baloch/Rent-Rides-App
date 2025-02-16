CREATE TABLE Renter (
    renterID SERIAL PRIMARY KEY,
    renterName VARCHAR(100) NOT NULL,
    username VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(100),
    address VARCHAR(100),
	madeReservation BOOLEAN DEFAULT FALSE
);

CREATE TABLE RentalCompany (
    companyID SERIAL PRIMARY KEY,
    companyName VARCHAR(100) NOT NULL,
    username VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    contactNumber VARCHAR(100),
    address VARCHAR(100),
    companyStatus BOOLEAN DEFAULT TRUE
);

CREATE TABLE Vehicle (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    model VARCHAR(255) NOT NULL,
    location VARCHAR(255),
    registration_number VARCHAR(255) NOT NULL UNIQUE,
    rent_per_day DECIMAL(10, 2),
    features TEXT,
    vehicle_type VARCHAR(50),
    isAvailable BOOLEAN DEFAULT TRUE,
    rental_company_id INT NOT NULL, 
    CONSTRAINT fk_rental_company FOREIGN KEY (rental_company_id) REFERENCES RentalCompany(companyID)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE Reservation (
    reservationID SERIAL PRIMARY KEY,
    renterID INT NOT NULL,
    vehicleID INT NOT NULL, 
    companyID INT NOT NULL,
	driverID INT,
    startDate DATE NOT NULL,
    endDate DATE NOT NULL,
    paymentStatus BOOLEAN DEFAULT FALSE,
    additionalCharges DECIMAL(10, 2) DEFAULT 0,
	isDriver BOOLEAN DEFAULT FALSE,
	FOREIGN KEY (driverID) REFERENCES Driver(driverID) ON DELETE CASCADE,
	FOREIGN KEY (vehicleID) REFERENCES Vehicle(id) ON DELETE CASCADE,
    FOREIGN KEY (renterID) REFERENCES Renter(renterID) ON DELETE CASCADE,
    FOREIGN KEY (companyID) REFERENCES RentalCompany(companyID) ON DELETE CASCADE
);

CREATE TABLE Driver (
    driverID SERIAL PRIMARY KEY,
    driverName VARCHAR(100) NOT NULL,
    username VARCHAR(100) NOT NULL,
    password VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    contactNumber VARCHAR(100),
    address VARCHAR(100),
    licenseNum VARCHAR(100) NOT NULL,
    availabilityStatus BOOLEAN DEFAULT TRUE,
    companyID INT,
	status VARCHAR(20) DEFAULT 'Pending',
    FOREIGN KEY (companyID) REFERENCES RentalCompany(companyID) ON DELETE SET NULL
);

CREATE TABLE Image (
    id SERIAL PRIMARY KEY,
    url VARCHAR(255) NOT NULL,
    vehicle_id INT NOT NULL UNIQUE,
    FOREIGN KEY (vehicle_id) REFERENCES Vehicle(id) ON DELETE CASCADE
);

CREATE TABLE AppAdmin (
    adminID SERIAL PRIMARY KEY,
    adminName VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(100),
    address VARCHAR(100),
    username VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL
);

CREATE TABLE Payments (
    payment_id SERIAL PRIMARY KEY,                
    reservation_id INT NOT NULL,                  
    payment_method VARCHAR(50) NOT NULL,           
    amount DECIMAL(10, 2) NOT NULL,               
    payment_status VARCHAR(20) NOT NULL,           
    card_number VARCHAR(16),                       
    card_expiry varchar(10),                       
    card_cvv VARCHAR(10),                        
    bank_account_number VARCHAR(20),               
    bank_name VARCHAR(100),                       
    easypaisa_phone_number VARCHAR(15),            
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,   
    FOREIGN KEY (reservation_id) REFERENCES Reservation(reservationid) ON DELETE CASCADE 
);

CREATE TABLE Feedback (
    feedback_id SERIAL PRIMARY KEY,
    reservation_id INT NOT NULL,
    renter_id INT NOT NULL,
    vehicle_id INT NOT NULL,
    driver_id INT,
    driver_rating INT NOT NULL CHECK (driver_rating BETWEEN 1 AND 5),
    company_service_rating INT NOT NULL CHECK (company_service_rating BETWEEN 1 AND 5),
    vehicle_condition_rating INT NOT NULL CHECK (vehicle_condition_rating BETWEEN 1 AND 5),
    overall_experience_rating INT NOT NULL CHECK (overall_experience_rating BETWEEN 1 AND 5),
    comments TEXT,
    FOREIGN KEY (reservation_id) REFERENCES Reservation (reservationid) ON DELETE CASCADE,
    FOREIGN KEY (renter_id) REFERENCES Renter (renterid) ON DELETE SET NULL,
    FOREIGN KEY (vehicle_id) REFERENCES Vehicle (id) ON DELETE SET NULL,
    FOREIGN KEY (driver_id) REFERENCES Driver (driverid) ON DELETE SET NULL
);

CREATE TABLE CustomerSupport (
    supportID SERIAL PRIMARY KEY,         
    renterID INT NOT NULL,                
    issueType VARCHAR(100) NOT NULL,      
    issueDescription TEXT NOT NULL,       
    status VARCHAR(50) DEFAULT 'Pending',    
	response VARCHAR(100) DEFAULT NULL,                
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  
    FOREIGN KEY (renterID) REFERENCES Renter(renterID) ON DELETE CASCADE
);

-- Inserting dummy data into Renter table
INSERT INTO Renter (renterName, username, password, email, phone, address, madeReservation)
VALUES
('Ali Khan', 'alikhan', '123', 'alikhan@email.com', '3001234567', 'G-9, Islamabad', FALSE),
('Sara Ahmed', 'saraahmed', '456', 'saraahmed@email.com', '3007654321', 'F-10, Islamabad', FALSE),
('Usman Malik', 'usmanmalik', '789', 'usmanmalik@email.com', '3001122334', 'Saddar, Rawalpindi', FALSE),
('Ayesha Bibi', 'ayeshabibi', 'password321', 'ayeshabibi@email.com', '3012233445', 'B-17, Islamabad', FALSE),
('Zahid Hussain', 'zahidhussain', 'password654', 'zahidhussain@email.com', '3009988776', 'Peshawar Road, Rawalpindi', FALSE);

-- Inserting dummy data into RentalCompany table
INSERT INTO RentalCompany (companyName, username, password, email, contactNumber, address, companyStatus)
VALUES
('Islamabad Rent-A-Car', 'isbrents', 'car1234', 'info@islamabadrent.com', '3002345678', 'Blue Area, Islamabad', TRUE),
('Rawalpindi Rides', 'rawalpindirides', 'bike5678', 'info@rawalpindirides.com', '3012345678', 'Committee Chowk, Rawalpindi', FALSE),
('Pak Wheels Rentals', 'pakwheelsrent', 'rent2345', 'contact@pakwheels.com', '3008765432', 'F-11, Islamabad', FALSE);

-- Inserting dummy data into Vehicle table
INSERT INTO Vehicle (name, model, location, registration_number, rent_per_day, features, vehicle_type, isAvailable, rental_company_id)
VALUES
('Honda Civic', '2022', 'Blue Area, Islamabad', 'ABC-1234', 5000.00, 'Air Conditioning, Leather Seats, Sunroof', 'Car', TRUE, 1),
('Suzuki Mehran', '2020', 'G-9, Islamabad', 'XYZ-5678', 2500.00, 'Air Conditioning, Power Steering', 'Car', TRUE, 1),
('Yamaha YBR', '2021', 'Rawalpindi', 'MNO-4567', 1500.00, 'ABS Brakes, Sport Mode', 'Bike', TRUE, 1),
('Automatic Scooter', '2020', 'Rawalpindi', 'DEF-7890', 2000.00, 'ABS, Sports Exhaust', 'Bike', TRUE, 1),
('Toyota Fortuner', '2021', 'F-11, Islamabad', 'PQR-1234', 4500.00, 'GPS, Bluetooth Connectivity', 'Car', TRUE, 1);

-- Inserting dummy data into Reservation table
INSERT INTO Reservation (renterID, vehicleID, companyID, driverID, startDate, endDate, additionalCharges, isDriver)
VALUES
(2, 1, 1, NULL, '2024-11-25', '2024-11-28', 0, TRUE); 
INSERT INTO Reservation (renterID, vehicleID, companyID, driverID, startDate, endDate, additionalCharges, isDriver)
VALUES
(2, 2, 1, NULL, '2024-11-25', '2024-11-28', 0, FALSE); 

INSERT INTO Reservation (renterID, vehicleID, companyID, driverID, startDate, endDate, additionalCharges, isDriver)
VALUES
(2, 35, 1, NULL, '2024-11-24', '2024-11-26', 500, TRUE),
(3, 36, 1, NULL, '2024-11-26', '2024-11-29', 0, TRUE),
(4, 37, 1, NULL, '2024-11-27', '2024-11-30', 200, TRUE),
(5, 38, 1, NULL, '2024-12-01', '2024-12-03', 1000, FALSE);

-- Inserting dummy data into Driver table
INSERT INTO Driver (driverName, username, password, email, contactNumber, address, licenseNum, availabilityStatus, companyID)
VALUES
('Ahmed Khan', 'ahmedkhan', 'driver123', 'ahmedkhan@driver.com', '3001122334', 'G-9, Islamabad', 'PKR123456', TRUE, 1),
('Fatima Ali', 'fatimaali', 'driver456', 'fatimaali@driver.com', '3009988777', 'F-10, Islamabad', 'PKR789012', TRUE, 1),
('Rashid Mehmood', 'rashidmehmood', 'driver789', 'rashidmehmood@driver.com', '3006655443', 'Saddar, Rawalpindi', 'PKR345678', TRUE, 1),
('Ali Ahmed', 'aliahmed', 'driver012', 'aliahmed@driver.com', '3001239876', 'Peshawar Road, Rawalpindi', 'PKR901234', TRUE, 1),
('Nadia Khan', 'nadiakhan', 'driver345', 'nadiakhan@driver.com', '3011122334', 'F-11, Islamabad', 'PKR567890', TRUE, 1);

INSERT INTO Image (vehicle_id, url)
VALUES
(1, '/vehicle_images/civic.jpg'),
(2, '/vehicle_images/mehran.jpg'),
(3, '/vehicle_images/ybr.jpg'),
(4, '/vehicle_images/scooter.jpeg'),
(5, '/vehicle_images/fortuner.jpeg');

-- Inserting dummy data into AppAdmin table
INSERT INTO AppAdmin (adminName, email, phone, address, username, password)
VALUES
('Sara Imran', 'admin@saralimran.com', '3004433221', 'G-10, Islamabad', 'admin123', '123'),
('Bilal Ahmed', 'admin@bilalahmed.com', '3001122335', 'F-8, Islamabad', 'bilaladmin', 'adminpass567');

-- Inserting dummy data into Payments table
INSERT INTO Payments (reservation_id, payment_method, amount, payment_status, card_number, card_expiry, card_cvv, bank_account_number, bank_name, easypaisa_phone_number, payment_date)
VALUES
(1, 'Credit Card', 5000.00, 'Completed', '1234567812345678', '12/25', '123', '1234567890', 'Bank Alfalah', '03001234567', '2024-11-25 10:00:00'),
(2, 'Debit Card', 3000.00, 'Completed', '2345678923456789', '10/24', '456', '9876543210', 'HBL', '03122334455', '2024-11-24 14:30:00'),
(3, 'Cash', 4500.00, 'Completed', NULL, NULL, NULL, NULL, NULL, '03111223344', '2024-11-26 11:00:00'),
(4, 'Easypaisa', 2500.00, 'Completed', NULL, NULL, NULL, NULL, NULL, '03334445566', '2024-11-27 16:45:00'),
(5, 'Bank Transfer', 3500.00, 'Pending', NULL, NULL, NULL, '4567890123', 'Bank Islami', NULL, '2024-12-01 08:00:00');

-- Inserting dummy data into Feedback table
INSERT INTO Feedback (reservation_id, renter_id, vehicle_id, driver_id, driver_rating, company_service_rating, vehicle_condition_rating, overall_experience_rating, comments)
VALUES
(31, 1, 34, 28, 5, 4, 5, 5, 'The driver was excellent and the vehicle was in perfect condition. The company service was efficient, but there is always room for improvement. Overall, a great experience!'),
(32, 2, 35, 25, 4, 3, 3, 4, 'The vehicle had some issues with the AC, but the driver was helpful. The company service could be faster, but the overall experience was still good.'),
(33, 3, 36, 26, 5, 5, 5, 5, 'The bike was in great shape and the driver was very professional. The company service was top-notch, and everything went smoothly. Excellent overall experience!'),
(34, 4, 37, 27, 4, 4, 4, 4, 'The car was fine, but there was a slight delay in the pickup. The driver was courteous, and the company service could be a bit quicker. Overall, a positive experience.'),
(35, 5, 38, NULL, 2, 3, 2, 2, 'The vehicle had some mechanical issues and the pickup was delayed. The driver could have been more helpful. The company service needs significant improvement.');

INSERT INTO CustomerSupport (renterID, issueType, issueDescription)
VALUES 
(1, 'Payment', 'Payment not reflecting in my account.'),
(3, 'Reservation', 'Unable to reserve a car for my trip on the selected date.'),
(4, 'Technical Issue', 'The app crashes whenever I try to view my reservations.'),
(5, 'Reservation', 'Incorrect vehicle assigned to my booking.')

SELECT
    f.feedback_id,
    f.reservation_id,
    f.renter_id,
    f.vehicle_id,
    f.driver_id,
    f.driver_rating,
    f.company_service_rating,
    f.vehicle_condition_rating,
    f.overall_experience_rating,
    f.comments
FROM
    feedback f
INNER JOIN
    reservation r ON f.reservation_id = r.reservationid
INNER JOIN
    vehicle v ON r.vehicleid = v.id
WHERE
    v.rental_company_id = 14;


TRUNCATE TABLE Vehicle RESTART IDENTITY;
TRUNCATE TABLE Image RESTART IDENTITY;
TRUNCATE TABLE Driver RESTART IDENTITY;
TRUNCATE TABLE Reservation RESTART IDENTITY;
TRUNCATE TABLE RentalCompany RESTART IDENTITY;
TRUNCATE TABLE Renter RESTART IDENTITY;
TRUNCATE TABLE AppAdmin RESTART IDENTITY;

SELECT * FROM Vehicle
SELECT * FROM Image
SELECT * FROM AppAdmin
SELECT * FROM Reservation
SELECT * FROM Driver
SELECT * FROM RentalCompany
SELECT * FROM Renter

DROP TABLE Vehicle;
DROP TABLE Image;
DROP TABLE AppAdmin;
DROP TABLE Reservation;
DROP TABLE Driver;
DROP TABLE RentalCompany;
DROP TABLE Renter;