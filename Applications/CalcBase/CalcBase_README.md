# CalcBase Family: Database Management Systems for PicoCalc/MMBasic

## Overview
The CalcBase series (versions 1.0, 2.0, and 3.0) are basic, menu-driven database management systems written in MMBasic for the PicoCalc. They are designed for small business/accounting tasks and demonstrate how to manage structured data in a resource constrained environment.

---

## CalcBase 1.0 Standard Edition
- **File:** `CalcBase1.0.bas`
- **Database File:** `calcbase.cb1`
- **Features:**
  - Add, list, find, modify, and delete records.
  - Each record contains: Record ID, First Name, Last Name, Amount.
  - Records are stored as comma-separated lines in a text file.
  - Simple menu interface using `PRINT` and `INPUT`.
- **How it works:**
  - Each menu option calls a subroutine for the selected action.
  - Records are read and written using standard file I/O.
  - No color or advanced formatting.

---

## CalcBase 2.0 Color Edition
- **File:** `CalcBase2.0.bas`
- **Database File:** `calcbase.cb1`
- **Features:**
  - All features of 1.0, but with colored text output using the `Text` command.
  - Menu and status messages are shown in yellow; errors in red.
  - Uses RGB color definitions for visual clarity.
- **How it works:**
  - Same logic as 1.0, but replaces `PRINT` with `Text` for colored output.
  - Color variables are defined at the top of the program.

---


## CalcBase 3.0 Standard Edition (S2 Format)
- **File:** `CalcBase3.0.bas`
- **Database File:** `calcbase.cb2`
- **Features:**
  - Upgraded to a Motorola S2-style record format: 6-digit record IDs, "CB2" prefix.
  - Enforces unique record IDs when adding records.
  - Prevents modification of non-existent records.
  - All standard database operations: add, list, find, modify, delete.
- **How it works:**
  - Record IDs are always stored and compared as 6-digit strings (e.g., `000123`).
  - When adding, the program checks for duplicates before writing.
  - When modifying, the program checks for existence before allowing changes.
  - File I/O and menu logic are similar to previous versions.

---

## CalcBase 4.0 Standard Edition (S3 Format)
- **File:** `CalcBase4.0.bas`
- **Database File:** `calcbase.cb3`
- **Features:**
  - Upgraded to a Motorola S3-style record format: 8-digit record IDs, "CB3" prefix.
  - Enforces unique record IDs when adding records.
  - Prevents modification of non-existent records.
  - All standard database operations: add, list, find, modify, delete.
  - New command: Show total record count.
- **How it works:**
  - Record IDs are always stored and compared as 8-digit strings (e.g., `00000001`).
  - When adding, the program checks for duplicates before writing.
  - When modifying, the program checks for existence before allowing changes.
  - File I/O and menu logic are similar to previous versions.

---

## General Usage
1. Load the desired `.bas` file on your PicoCalc/MMBasic system.
2. Run the program. The main menu will appear.
3. Use the menu to add, list, find, modify, or delete records.
4. Data is stored in the corresponding `.cb1`, `.cb2`, or `.cb3` file in the same directory.


## File Format Details
The `.cb1`, `.cb2`, and `.cb3` database files are inspired by Motorola S-records (S1, S2, and S3 types), which are line-based, ASCII-encoded formats originally used for programming and data transfer in embedded systems.

- **CalcBase 1.0/2.0 (.cb1):**
  - Follows a structure similar to Motorola S1 records, using a short (typically 4-digit) record ID.
  - Format: `CB1,04,<ID>,<FirstName>,<LastName>,<Amount>,00`
  - Example: `CB1,04,0001,John,Smith,100.00,00`
- **CalcBase 3.0 (.cb2):**
  - Follows a structure similar to Motorola S2 records, using a 6-digit record ID (address field).
  - Format: `CB2,04,<6-digitID>,<FirstName>,<LastName>,<Amount>,00`
  - Example: `CB2,04,000123,Jane,Doe,250.00,00`
- **CalcBase 4.0 (.cb3):**
  - Follows a structure similar to Motorola S3 records, using an 8-digit record ID (address field).
  - Format: `CB3,04,<8-digitID>,<FirstName>,<LastName>,<Amount>,00`
  - Example: `CB3,04,00000001,Jane,Doe,250.00,00`

These formats are human-readable and easy to parse, making them suitable for simple database management for the PicoCalc.

## Notes
- The programs are designed for up to 1000 records (due to array limits).
- No advanced error handling or data validation beyond uniqueness/existence checks.
- GPT ASSISTED WITH THE COLOR VERSIONS (I STILL DONT HAVE MY REPLACEMENT SCREENS)

## Authors
- INSCCOIN, 2025

