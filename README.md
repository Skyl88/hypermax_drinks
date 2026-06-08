# Hyper Max Store - Drinks Department Management System

A Windows Forms C# application for managing the Drinks Department at Hyper Max Store.

## Features

- **Login System** - Secure authentication with role-based access (Manager/Staff)
- **Drinks Management** - Add, edit, delete, and search drinks with full validation
- **Suppliers Management** - Manage supplier information with referential integrity checks
- **Orders Management** - Create, update, and track purchase orders
- **Order Details** - Add drinks to orders with automatic total calculation
- **Inventory Management** - Monitor stock levels with low-stock alerts
- **SQL Server Database** - All data is persisted in a SQL Server Express database

## Login Credentials

| Username | Password  | Role     |
|----------|-----------|----------|
| admin    | admin123  | Manager  |
| staff1   | staff123  | Staff    |
| staff2   | password  | Staff    |

## Data Validation Rules

The application enforces the following validation rules:
- Price must be greater than zero
- Quantity must be greater than or equal to zero
- Expiry date must be after today's date
- Phone number must contain numbers only
- Drink name and supplier name cannot be empty
- Category must be: Fizzy, Juice, Water, or Energy
- Size must be: 250ml, 500ml, 1L, or 2L
- Email must contain the @ symbol

## Database

This application uses **SQL Server Express** for data persistence. The database connects to a local SQL Server Express instance using Windows Authentication. You must have SQL Server Express installed and running, and the database `HyperMaxDrinksDB` must be created before launching the application.

### Database Setup

1. Install [SQL Server Express](https://www.microsoft.com/en-us/sql-server/sql-server-downloads) if not already installed
2. Open SQL Server Management Studio (SSMS) or Azure Data Studio
3. Create a new database named `HyperMaxDrinksDB`
4. Run the schema scripts to create the required tables (see Database Schema below)
5. Seed the database with initial data (see Seed Data below)
6. If your SQL Server instance name differs from `localhost\SQLEXPRESS`, update the `Server` constant in `Data/DatabaseHelper.cs`

### Connection String

The connection string is defined in `Data/DatabaseHelper.cs`:

```
Server=localhost\SQLEXPRESS;Database=HyperMaxDrinksDB;Integrated Security=True;TrustServerCertificate=True;
```

Update the `Server` and `Database` constants at the top of `DatabaseHelper.cs` if your setup differs.

### Database Schema

- **Users** - UserID (PK, AutoIncrement), Username, Password, Role
- **Suppliers** - SupplierID (PK, AutoIncrement), Name, Phone, Address, Email
- **Drinks** - DrinkID (PK, AutoIncrement), Name, ExpiryDate, SupplierID (FK), Price, Category, Size
- **Inventory** - DrinkID (PK/FK), StockQuantity, LastUpdate
- **Orders** - OrderID (PK, AutoIncrement), OrderDate, SupplierID (FK), TotalPrice, Status
- **OrderDetails** - OrderID + DrinkID (Composite PK), Quantity, Price

### Seed Data

Populate the database with sample data before first use:
- 3 Users (1 Manager, 2 Staff)
- 3 Suppliers
- 8 Drinks (across Fizzy, Juice, Water, Energy categories)
- 8 Inventory records (2 with low stock alerts)
- 3 Orders (2 Pending, 1 Delivered)
- 5 Order Detail records

## How to Open and Run

> **Prerequisites:** SQL Server Express must be installed, running, and the `HyperMaxDrinksDB` database must exist before launching the application.

### Option 1: Visual Studio 2022

1. Open Visual Studio 2022
2. Click **"Open a local folder"**
3. Browse to the `HyperMaxDrinksApp` folder and select it
4. Wait for Visual Studio to restore NuGet packages and load the project
5. Press **F5** or click **Start** to run the application

### Option 2: Visual Studio Code

1. Open the `HyperMaxDrinksApp` folder in VS Code
2. Install the **C# Dev Kit** extension if not already installed
3. Open the terminal and run:
   ```
   dotnet run
   ```
   > Note: Windows Forms applications require a Windows machine to run.

### Option 3: Command Line

1. Open a terminal/command prompt
2. Navigate to the project folder:
   ```
   cd path/to/HyperMaxDrinksApp
   ```
3. Build and run:
   ```
   dotnet build
   dotnet run
   ```

## Project Structure

```
HyperMaxDrinksApp/
├── Program.cs                          # Application entry point (verifies DB connection)
├── HyperMaxDrinksApp.csproj            # Project configuration (includes SqlClient NuGet)
├── Models/
│   ├── Drink.cs                        # Drink entity model
│   ├── Supplier.cs                     # Supplier entity model
│   ├── Order.cs                        # Order entity model
│   ├── OrderDetail.cs                  # OrderDetail entity model
│   ├── InventoryItem.cs                # Inventory entity model
│   └── User.cs                         # User entity model
├── Data/
│   ├── DatabaseHelper.cs               # SQL Server connection and configuration
│   └── DataStore.cs                    # Database-backed data access layer
└── Forms/
    ├── LoginForm.cs                    # Login page with authentication
    ├── MainForm.cs                     # Dashboard with navigation sidebar
    ├── DrinksForm.cs                   # Drinks CRUD operations
    ├── SuppliersForm.cs                # Suppliers CRUD operations
    ├── OrdersForm.cs                   # Orders CRUD operations
    ├── OrderDetailsForm.cs             # Order items management
    └── InventoryForm.cs                # Stock level monitoring & alerts
```

## Entity Relationships

- One Supplier SUPPLIES Many Drinks (1:M)
- One Drink is STORED IN Inventory (1:1)
- One Order INCLUDES Many Order_Details (1:M)
- One Drink appears in Many Order_Details (1:M)
- One Order is RECEIVED from one Supplier (M:1)

## Dependencies

- **.NET 8.0** - Target framework
- **Microsoft.Data.SqlClient 7.0.1** - SQL Server database provider for .NET

## Important Notes

- **SQL Server Required**: The application requires a running SQL Server Express instance. Ensure the service is started before launching the app.
- **Windows Authentication**: The connection uses Integrated Security (Windows Authentication) by default — no SQL username/password is needed.
- **Configure Connection**: If your server instance name is different from `localhost\SQLEXPRESS`, update `Data/DatabaseHelper.cs` before running.
- **Windows Only**: This is a Windows Forms application and runs only on Windows.
