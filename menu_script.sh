#!/bin/bash

CSV_FILE="$HOME/Work_Course_Linux/5Q/data.csv"
OUTPUT_FILE="$HOME/Work_Course_Linux/5Q/output_5.txt"

# Ensure the CSV file exists with headers
if [ ! -f "$CSV_FILE" ]; then
    echo "Date collected,Species,Sex,Weight" > "$CSV_FILE"
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

# Function to create a new CSV file
create_csv() {
    read -p "Enter CSV file name (without .csv extension): " filename
    if [[ -z "$filename" ]]; then
        log_output "Invalid filename!"
        return
    fi
    CSV_PATH="$HOME/Work_Course_Linux/5Q/$filename.csv"
    echo "Date collected,Species,Sex,Weight" > "$CSV_PATH"
    log_output "CSV file $filename.csv created in $HOME/Work_Course_Linux/5Q/."
}

# Function to display CSV with index
display_csv() {
    awk 'NR==1 {print "Index, "$0} NR>1 {print NR-1","$0}' "$CSV_FILE" | tee -a "$OUTPUT_FILE"
}

# Function to add a new row
add_row() {
    read -p "Enter Date collected: " date
    read -p "Enter Species: " species
    read -p "Enter Sex (M/F): " sex
    read -p "Enter Weight: " weight
    if [[ "$sex" != "M" && "$sex" != "F" ]] || ! [[ "$weight" =~ ^[0-9]+$ ]]; then
        log_output "Invalid input!"
        return
    fi
    echo "$date,$species,$sex,$weight" >> "$CSV_FILE"
    log_output "Added row: $date,$species,$sex,$weight"
}

# Function to display data by species
filter_by_species() {
    read -p "Enter Species: " species
    result=$(awk -F"," -v sp="$species" 'NR==1 || $2==sp' "$CSV_FILE")
    avg=$(awk -F"," -v sp="$species" '$2==sp {sum+=$4; count++} END {if (count > 0) print sum/count; else print "N/A"}' "$CSV_FILE")
    log_output "$result\nAverage Weight: $avg"
}

# Function to filter by sex
filter_by_sex() {
    read -p "Enter Sex (M/F): " sex
    if [[ "$sex" != "M" && "$sex" != "F" ]]; then
        log_output "Invalid sex input!"
        return
    fi
    awk -F"," -v sx="$sex" 'NR==1 || $3==sx' "$CSV_FILE" | tee -a "$OUTPUT_FILE"
}

# Function to save last output to a new CSV
save_last_output() {
    read -p "Enter new CSV filename: " filename
    cp "$OUTPUT_FILE" "$HOME/Work_Course_Linux/5Q/$filename.csv"
    log_output "Saved output to $filename.csv"
}

# Function to delete a row by index
delete_row() {
    read -p "Enter row index to delete: " index
    if ! [[ "$index" =~ ^[0-9]+$ ]]; then
        log_output "Invalid index!"
        return
    fi
    sed -i "$((index+1))d" "$CSV_FILE"
    log_output "Deleted row $index"
}

# Function to update weight by index
update_weight() {
    read -p "Enter row index: " index
    read -p "Enter new weight: " weight
    if ! [[ "$index" =~ ^[0-9]+$ ]] || ! [[ "$weight" =~ ^[0-9]+$ ]]; then
        log_output "Invalid input!"
        return
    fi
    awk -F"," -v i="$index" -v w="$weight" 'NR==i+1 {$4=w} {print}' "$CSV_FILE" > temp.csv && mv temp.csv "$CSV_FILE"
    log_output "Updated weight for row $index"
}

# Main loop
while true; do
    display_menu
    read -p "Enter choice: " choice
    case $choice in
        1) create_csv ;;
        2) display_csv ;;
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

