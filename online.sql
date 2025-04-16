CREATE DATABASE PizzaHut;
USE PizzaHut;

-- Customer Table
CREATE TABLE Customer (
    CustomerID INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Password VARCHAR(255) NOT NULL, -- Hashed password
    Phone VARCHAR(15),
    Address TEXT,
    CONSTRAINT chk_email CHECK (Email LIKE '%@%.%')
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT 'Stores customer information';

-- Restaurant Table
CREATE TABLE Restaurant (
    RestaurantID INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Location VARCHAR(255) NOT NULL,
    Contact VARCHAR(15),
    Rating DECIMAL(2,1) DEFAULT 0.0,
    CONSTRAINT chk_rating CHECK (Rating BETWEEN 0.0 AND 5.0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT 'Stores restaurant details';

-- Menu Table
CREATE TABLE Menu (
    ItemID INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    RestaurantID INT UNSIGNED NOT NULL,
    ItemName VARCHAR(100) NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    Category VARCHAR(50),
    Availability BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (RestaurantID) REFERENCES Restaurant(RestaurantID) ON DELETE CASCADE,
    CONSTRAINT chk_price CHECK (Price >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT 'Stores menu items for each restaurant';

-- Orders Table
CREATE TABLE Orders (
    OrderID INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT UNSIGNED NOT NULL,
    RestaurantID INT UNSIGNED NOT NULL,
    OrderDate DATETIME NOT NULL,
    TotalAmount DECIMAL(10,2) NOT NULL,
    Status ENUM('Placed', 'Preparing', 'Ready', 'Delivered', 'Cancelled') DEFAULT 'Placed',
    DeliveryAddress TEXT NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID) ON DELETE RESTRICT,
    FOREIGN KEY (RestaurantID) REFERENCES Restaurant(RestaurantID) ON DELETE RESTRICT,
    CONSTRAINT chk_total CHECK (TotalAmount >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT 'Stores order details';

-- OrderDetails Table
CREATE TABLE OrderDetails (
    OrderDetailID INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    OrderID INT UNSIGNED NOT NULL,
    ItemID INT UNSIGNED NOT NULL,
    Quantity INT NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID) ON DELETE CASCADE,
    FOREIGN KEY (ItemID) REFERENCES Menu(ItemID) ON DELETE RESTRICT,
    CONSTRAINT chk_quantity CHECK (Quantity > 0),
    CONSTRAINT chk_price_od CHECK (Price >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT 'Stores items in each order';

-- DeliveryPersonnel Table
CREATE TABLE DeliveryPersonnel (
    DeliveryID INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Phone VARCHAR(15) NOT NULL,
    Availability BOOLEAN DEFAULT TRUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT 'Stores delivery personnel details';

-- Delivery Table
CREATE TABLE Delivery (
    DeliveryAssignmentID INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    OrderID INT UNSIGNED NOT NULL,
    DeliveryID INT UNSIGNED NOT NULL,
    DeliveryStatus ENUM('Assigned', 'InTransit', 'Delivered', 'Failed') DEFAULT 'Assigned',
    DeliveryTime DATETIME,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID) ON DELETE CASCADE,
    FOREIGN KEY (DeliveryID) REFERENCES DeliveryPersonnel(DeliveryID) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT 'Stores delivery assignments';

-- Payment Table
CREATE TABLE Payment (
    PaymentID INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    OrderID INT UNSIGNED NOT NULL,
    Amount DECIMAL(10,2) NOT NULL,
    PaymentMethod ENUM('CreditCard', 'DebitCard', 'Cash', 'UPI', 'NetBanking') NOT NULL,
    PaymentStatus ENUM('Pending', 'Completed', 'Failed') DEFAULT 'Pending',
    TransactionID VARCHAR(50),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID) ON DELETE CASCADE,
    CONSTRAINT chk_amount CHECK (Amount >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT 'Stores payment details';

-- Feedback Table
CREATE TABLE Feedback (
    FeedbackID INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    OrderID INT UNSIGNED NOT NULL,
    CustomerID INT UNSIGNED NOT NULL,
    RestaurantID INT UNSIGNED NOT NULL,
    Rating DECIMAL(2,1) NOT NULL,
    Comments TEXT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID) ON DELETE CASCADE,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID) ON DELETE RESTRICT,
    FOREIGN KEY (RestaurantID) REFERENCES Restaurant(RestaurantID) ON DELETE RESTRICT,
    CONSTRAINT chk_rating_fb CHECK (Rating BETWEEN 1.0 AND 5.0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT 'Stores customer feedback';

-- Indexes for Performance
CREATE INDEX idx_customer_email ON Customer(Email);
CREATE INDEX idx_order_date ON Orders(OrderDate);
CREATE INDEX idx_menu_restaurant ON Menu(RestaurantID, Availability);
CREATE INDEX idx_delivery_order ON Delivery(OrderID);

