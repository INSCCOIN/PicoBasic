# cERP - PicoCalc Enterprise Resource Planning System v2.0

## Overview

cERP is a comprehensive business management system designed for the PicoCalc/MMBasic platform. This 1980s-style ERP solution provides essential business functionality in a retro computing environment, offering customer management, inventory control, sales tracking, employee records, and financial reporting capabilities.

## What This Program Does

cERP is a complete business management solution that handles:

- **Customer Management**: Track customer information, balances, and transaction history
- **Inventory Management**: Monitor product stock levels, prices, and valuations
- **Sales & Invoicing**: Create invoices, track sales history, and analyze customer purchases
- **Employee Records**: Maintain employee information and calculate payroll
- **Financial Reporting**: Generate profit/loss statements, aging reports, and sales summaries
- **System Utilities**: Database management, diagnostics, and system customization

## System Requirements

- **Platform**: PicoCalc Pico 1/2 or MMBasic-compatible system
- **Memory**: Sufficient RAM for database arrays (configurable limits)
- **Storage**: File system support for database persistence
- **Display**: Text-based display for menu navigation and reports

## Database Capacity

The system supports:
- **25 Customers** maximum
- **50 Products** maximum  
- **100 Invoices** maximum
- **15 Employees** maximum

*These limits can be modified by changing the CONST values at the top of the program.*

## How It Works

### Architecture

cERP uses a modular design with the following components:

1. **Data Storage**: Arrays hold all business data in memory
2. **Database Persistence**: Data is saved to/loaded from text files
3. **Menu System**: Hierarchical menus provide organized access to features
4. **Reporting Engine**: Real-time calculation and display of business metrics
5. **User Interface**: Color-coded, text-based interface with keyboard shortcuts

### Data Structure

The system organizes data into four main categories:

```
Customers: Name, Address, Phone, Balance
Products: Code, Name, Price, Stock Level
Invoices: Number, Customer ID, Amount, Date
Employees: ID, Name, Annual Salary
```

### Database File Format

Data is automatically saved to `ERPDATA.TXT` in a structured text format that includes:
- Version header for compatibility
- Record counts for each data type
- Sequential data records
- System settings (colors, preferences)

## Enhanced Features (v2.0)

### Universal Keyboard Shortcuts

The system now supports convenient keyboard shortcuts throughout all menus:

- **F5 or R**: Refresh/Reload current screen
- **F10 or S**: Take screenshot (saves as timestamped BMP file)
- **ESC or E**: Exit/Cancel current operation

*These shortcuts work using string-based input detection for MMBasic compatibility.*

### Screenshot Functionality

- Automatically saves screen captures with timestamps
- Files named format: `SCREENSHOT_YYYYMMDD_HHMMSS_XX.BMP`
- Includes random 2-digit number for uniqueness
- Robust error handling and user feedback

### Color Customization

- Customizable system colors (RGB values)
- Default green theme for professional appearance
- Settings persist between sessions

## Getting Started

### First Run

1. **Load the program**: Run `ERP2.bas` on your PicoCalc/MMBasic system
2. **Enter your name**: The system will prompt for user identification
3. **Automatic setup**: Sample data loads automatically if no existing database is found
4. **Main menu**: Navigate using numbered options or keyboard shortcuts

### Sample Data

The system includes realistic sample data:

**Sample Customers:**
- ACME CORPORATION ($1,250.50 balance)
- TECH SOLUTIONS INC ($875.25 balance)
- GLOBAL ENTERPRISES ($2,100.00 balance)
- SMALL BUSINESS LLC ($450.75 balance)
- RETAIL MART CHAIN ($3,250.00 balance)

**Sample Products:**
- Standard widgets, deluxe gadgets, utility tools
- Price range: $15.25 - $125.50
- Stock levels: 25 - 999 units

**Sample Employees:**
- Manager, Sales rep, Clerk, Admin
- Salary range: $25,000 - $45,000

## Usage Examples and When to Use Each Feature

### 1. Customer Management

**When to use:**
- Adding new clients to your business
- Updating customer contact information
- Tracking customer payment history
- Managing accounts receivable

**Example scenarios:**

**Adding a New Customer:**
```
Main Menu → 1. Customer Management → 1. Add New Customer

Enter:
- Customer Name: "ABC Manufacturing"
- Address: "456 Industrial Blvd, Factory Town"
- Phone: "555-2468"
- Initial balance: $0.00
```

**Searching for a Customer:**
```
Customer Menu → 3. Search Customer
Enter: "ACME"
Result: Shows all customers with "ACME" in their name
```

**Viewing Customer Statements:**
```
Customer Menu → 5. Customer Statements
Select customer ID or 0 for all customers
Result: Detailed invoice history and current balance
```

### 2. Inventory Management

**When to use:**
- Receiving new inventory shipments
- Processing sales transactions
- Monitoring stock levels
- Updating product prices

**Example scenarios:**

**Adding New Products:**
```
Inventory Menu → 1. Add New Product

Enter:
- Product Code: "GAD003"
- Product Name: "Super Gadget Pro"
- Unit Price: $89.99
- Initial Stock: 100
```

**Updating Stock After Receiving Shipment:**
```
Inventory Menu → 3. Update Stock
Select Product ID: 5 (Utility Tool)
Choose: 1. Add Stock (Receiving)
Enter quantity: 50
Result: Stock increases from 100 to 150 units
```

**Price Increase for All Products:**
```
Inventory Menu → 4. Price Changes
Choose: 2. Apply Percentage Increase to All
Enter percentage: 10
Result: All product prices increase by 10%
```

**Low Stock Alert:**
```
Inventory Menu → 5. Low Stock Report
Result: Lists all products with less than 50 units in stock
```

### 3. Sales & Invoicing

**When to use:**
- Recording customer purchases
- Tracking sales performance
- Analyzing customer buying patterns
- Managing revenue streams

**Example scenarios:**

**Creating a Sales Invoice:**
```
Sales Menu → 1. Create New Invoice

Available customers displayed
Select Customer ID: 3 (Global Enterprises)
Enter Invoice Amount: $1,500.00
Result: Invoice #1004 created, customer balance updated
```

**Daily Sales Analysis:**
```
Sales Menu → 3. Daily Sales Report
Enter date: "14-JUL-2025"
Result: Shows all sales for that date with totals and averages
```

**Customer Sales Performance:**
```
Sales Menu → 4. Customer Sales Analysis
Result: Shows sales totals by customer, identifies top performers
```

### 4. Employee Records

**When to use:**
- Onboarding new employees
- Processing payroll
- Tracking personnel costs
- Managing HR information

**Example scenarios:**

**Adding New Employee:**
```
Employee Menu → 1. Add New Employee

Enter:
- Employee ID: "EMP005"
- Employee Name: "MIKE TECHNICIAN"
- Annual Salary: $38,000
```

**Weekly Payroll Calculation:**
```
Employee Menu → 3. Payroll Calculation
Choose: 1. Weekly Payroll
Result: Shows weekly pay for all employees (Annual ÷ 52)
```

**Finding Employee Information:**
```
Employee Menu → 4. Employee Search
Enter: "JOHN"
Result: Shows all employees with "JOHN" in name or ID
```

### 5. Financial Reports

**When to use:**
- End-of-period financial analysis
- Business performance evaluation
- Tax preparation
- Investor reporting

**Example scenarios:**

**Sales Summary for Management:**
```
Reports Menu → 1. Sales Summary Report
Result: Total sales, average invoice, top customers by revenue
```

**Accounts Receivable Analysis:**
```
Reports Menu → 2. Customer Aging Report
Result: Outstanding balances, payment priorities, collection targets
```

**Inventory Investment Analysis:**
```
Reports Menu → 3. Inventory Valuation
Result: Total inventory value based on current prices and stock
```

**Business Profitability:**
```
Reports Menu → 4. Profit & Loss Statement
Result: Revenue, costs, profit margins, financial health indicators
```

### 6. System Utilities

**When to use:**
- System maintenance and optimization
- Data integrity verification
- Performance monitoring
- Customization

**Example scenarios:**

**Checking System Health:**
```
Utilities Menu → 4. System Diagnostics
Result: Comprehensive system analysis including data validation
```

**Memory Usage Analysis:**
```
Utilities Menu → 3. Memory Usage
Result: Detailed breakdown of memory allocation and efficiency
```

**Customizing Appearance:**
```
Utilities Menu → 6. Change System Colors
Enter RGB values for custom color scheme
Result: Updated interface with new colors
```

**Data Validation:**
```
Utilities Menu → 5. Data Validation Check
Result: Identifies data inconsistencies, negative balances, duplicates
```

### 7. Data Backup/Restore

**When to use:**
- Regular data backups
- System upgrades
- Data recovery
- Transferring to new systems

**Example scenarios:**

**Creating Backup:**
```
Backup Menu → 1. Create Backup
Result: Saves current database to backup file with timestamp
```

**Restoring from Backup:**
```
Backup Menu → 2. Restore from Backup
Select backup file
Result: Restores database from selected backup
```

### 8. Help & Reference

**When to use:**
- Learning system features
- Troubleshooting issues
- Understanding reports
- Training new users

## Keyboard Shortcuts Reference

| Shortcut | Function | Available In |
|----------|----------|--------------|
| F5 or R | Refresh/Reload | All menus |
| F10 or S | Take Screenshot | All menus |
| ESC or E | Exit/Cancel | All menus |

## Data Management Best Practices

### Regular Maintenance

1. **Daily**: Create invoices, update inventory, take screenshots for records
2. **Weekly**: Run sales reports, check low stock alerts
3. **Monthly**: Generate profit/loss statements, customer aging reports
4. **Quarterly**: Validate data integrity, create system backups

### Data Entry Tips

- Use consistent naming conventions for customers and products
- Enter complete address information for customers
- Keep product codes short but descriptive
- Regular price updates maintain accurate inventory valuations

### Backup Strategy

- Create backups before major data entry sessions
- Store backup files on separate storage devices
- Test restore procedures periodically
- Document backup schedules and procedures

## Troubleshooting

### Common Issues

**Database Won't Load:**
- Check file permissions on ERPDATA.TXT
- Verify file isn't corrupted
- Load from backup if available

**Memory Errors:**
- Reduce database limits in CONST declarations
- Clear unused sample data
- Restart system to free memory

**Screenshot Issues:**
- Ensure adequate storage space
- Check file system write permissions
- Verify BMP format support

### Error Messages

- **"Database is full!"**: Maximum records reached, delete unused entries
- **"Invalid customer ID!"**: Enter valid ID number from customer list
- **"Cannot save database"**: Check storage space and file permissions

## Technical Details

### File Structure
```
ERP2.bas          - Main program file
ERPDATA.TXT       - Primary database file
SCREENSHOT_*.BMP  - Screenshot files (auto-generated)
```

### Memory Allocation
- String arrays for text data (names, addresses, codes)
- Numeric arrays for financial data (prices, balances, quantities)
- Dynamic memory management based on actual usage

### Compatibility
- Designed for MMBasic/PicoCalc environment
- Uses OPTION EXPLICIT for error prevention
- Compatible with text-based displays
- File I/O optimized for limited storage systems

## Future Enhancements

Potential improvements for future versions:
- Network database sharing
- Enhanced reporting with charts
- Import/export capabilities
- Multi-currency support
- Advanced inventory tracking
- Customer relationship management features

## Support

For technical support or feature requests:
- Review this documentation thoroughly
- Check system requirements and compatibility
- Verify data file integrity
- Consider system limitations and capacity

---

**cERP v2.0** - A comprehensive business management solution for retro computing environments.
*Compatible with PicoCalc Pico 1/2 and MMBasic systems.*
