#!/bin/bash

DB_FILE="$HOME/Work_Course_Linux/5Q/menu_script.db"
OUTPUT_FILE="$HOME/Work_Course_Linux/5Q/output_5.txt"

# Ensure the SQLite database exists
if [ ! -f "$DB_FILE" ]; then
    sqlite3 "$DB_FILE" "CREATE TABLE IF NOT EXISTS data (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date_collected TEXT NOT NULL,
        species TEXT NOT NULL,
        sex TEXT CHECK(sex IN ('M', 'F')) NOT NULL,
        weight INTEGER NOT NULL CHECK(weight > 0)
    );"
fi

# Function to log output
log_output() {
    echo "$1" | tee -a "$OUTPUT_FILE"
}

# Function to display menu
display_menu() {
    echo "Choose an option:"
    echo "1. Add new row"
    echo "2. Display all data"
    echo "3. Delete row by ID"
    echo "4. Update weight by ID"
    echo "5. Exit"
}

# Function to add a new row
add_row() {
    read -p "Enter Date collected (MM/DD): " date
    read -p "Enter Species: " species
    read -p "Enter Sex (M/F): " sex
    read -p "Enter Weight: " weight

    if [[ "$sex" != "M" && "$sex" != "F" ]] || ! [[ "$weight" =~ ^[0-9]+$ ]]; then
        log_output "Invalid input!"
        return
    fi

    sqlite3 "$DB_FILE" "INSERT INTO data (date_collected, species, sex, weight) VALUES ('$date', '$species', '$sex', $weight);"
    log_output "Added row: $date, $species, $sex, $weight"
}

# Function to display all data
display_data() {
    sqlite3 -header -column "$DB_FILE" "SELECT * FROM data;" | tee -a "$OUTPUT_FILE"
}

# Function to delete a row by ID
delete_row() {
    read -p "Enter row ID to delete: " id
    sqlite3 "$DB_FILE" "DELETE FROM data WHERE id=$id;"
    log_output "Deleted row with ID $id"
}

# Function to update weight by ID
update_weight() {
    read -p "Enter row ID to update: " id
    read -p "Enter new weight: " weight

    if ! [[ "$weight" =~ ^[0-9]+$ ]]; then
        log_output "Invalid weight!"
        return
    fi

    sqlite3 "$DB_FILE" "UPDATE data SET weight=$weight WHERE id=$id;"
    log_output "Updated weight for row ID $id"
}

# Main loop
while true; do
    display_menu
    read -p "Enter choice: " choice
    case $choice in
        1) add_row ;;
        2) display_data ;;
        3) delete_row ;;
        4) update_weight ;;
        5) log_output "Exiting..."; exit 0 ;;
        *) log_output "Invalid option!" ;;
    esac
done
