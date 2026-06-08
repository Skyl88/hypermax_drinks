# Hyper Max Store - Drinks Department Management System

A Windows Forms C# application for managing the Drinks Department at Hyper Max Store.

## Features

- **Login System** - Secure authentication with role-based access (Manager/Staff)
- **Drinks Management** - Add, edit, delete, and search drinks with full validation
- **Suppliers Management** - Manage supplier information with referential integrity checks
- **Orders Management** - Create, update, and track purchase orders
- **Order Details** - Add drinks to orders with automatic total calculation
- **Inventory Management** - Monitor stock levels with low-stock alerts
- **SQLite Database** - All data is persisted in a local SQLite database file

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

This application uses **SQLite** for data persistence. The database file (`HyperMaxDrinks.db`) is automatically created in the application's output directory on first run. No external database server or configuration is required.

### Database Schema

- **Users** - Username (PK), Password, Role
- **Suppliers** - SupplierID (PK, AutoIncrement), Name, Phone, Address, Email
- **Drinks** - DrinkID (PK, AutoIncrement), Name, ExpiryDate, SupplierID (FK), Price, Category, Size
- **Inventory** - DrinkID (PK/FK), StockQuantity, LastUpdate
- **Orders** - OrderID (PK, AutoIncrement), Date, SupplierID (FK), TotalPrice, Status
- **OrderDetails** - OrderID + DrinkID (Composite PK), Quantity, Price

### Seed Data

On first run, the database is automatically seeded with sample data:
- 3 Users (1 Manager, 2 Staff)
- 3 Suppliers
- 8 Drinks (across Fizzy, Juice, Water, Energy categories)
- 8 Inventory records (2 with low stock alerts)
- 3 Orders (2 Pending, 1 Delivered)
- 5 Order Detail records

## How to Open and Run

### Option 1: Visual Studio 2022

1. Open Visual Studio 2022
2. Click **"Open a local folder"**
3. Browse to the `HyperMaxDrinksApp` folder and select it
4. Wait for Visual Studio to restore NuGet packages and load the project
5. Press **F5** or click **Start** to run the application

### Option 2: Visual Studio Code

1. Open the `HyperMaxDrinksApp` folder in VS Code
2. Install the C# Dev Kit extension if not already installed
3. Open the terminal and run:
   ```
   dotnet run
   ```

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
├── Program.cs                          # Application entry point (initializes DB)
├── HyperMaxDrinksApp.csproj            # Project configuration (includes SQLite NuGet)
├── Models/
│   ├── Drink.cs                        # Drink entity model
│   ├── Supplier.cs                     # Supplier entity model
│   ├── Order.cs                        # Order entity model
│   ├── OrderDetail.cs                  # OrderDetail entity model
│   └── InventoryItem.cs                # Inventory entity model
├── Data/
│   ├── DatabaseHelper.cs               # SQLite connection, schema creation, seed data
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
- **Microsoft.Data.Sqlite 8.0.11** - SQLite database provider for .NET

## Important Notes

- **SQLite Database**: All data is stored in a local SQLite database file (`HyperMaxDrinks.db`) and persists between application sessions
- **Auto-Created**: The database file is created automatically on first run — no manual setup needed
- **.NET 8.0**: Requires .NET 8.0 SDK or later installed on your machine
- **Windows Only**: This is a Windows Forms application and runs only on Windows
