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
    echo "1. CREATE CSV by name"
    echo "2. Display all CSV DATA with row INDEX"
    echo "3. Read user input for new row"
    echo "4. Read Specie and display items + AVG weight"
    echo "5. Read Specie sex and display items"
    echo "6. Save last output to new CSV file"
    echo "7. Delete row by index"
    echo "8. Update weight by row index"
    echo "9. Exit"
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

# Function to filter by species
filter_by_species() {
    read -p "Enter Species: " species
    result=$(sqlite3 -header -column "$DB_FILE" "SELECT * FROM data WHERE species='$species';")
    avg=$(sqlite3 "$DB_FILE" "SELECT AVG(weight) FROM data WHERE species='$species';")
    log_output "$result\nAverage Weight: $avg"
}

# Function to filter by sex
filter_by_sex() {
    read -p "Enter Sex (M/F): " sex
    result=$(sqlite3 -header -column "$DB_FILE" "SELECT * FROM data WHERE sex='$sex';")
    log_output "$result"
}

# Function to save last output to a new CSV
save_last_output() {
    read -p "Enter new CSV filename: " filename
    cp "$OUTPUT_FILE" "$HOME/Work_Course_Linux/5Q/$filename.csv"
    log_output "Saved output to $filename.csv"
}

# Main loop
while true; do
    display_menu
    read -p "Enter choice: " choice
    case $choice in
        1) log_output "Option 1 is not needed as we use SQLite instead of CSV." ;;
        2) display_data ;;
        3) add_row ;;
        4) filter_by_species ;;
        5) filter_by_sex ;;
        6) save_last_output ;;
        7) delete_row ;;
        8) update_weight ;;
        9) log_output "Exiting..."; exit 0 ;;
        *) log_output "Invalid option!" ;;
    esac
done
