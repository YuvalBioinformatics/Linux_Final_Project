#!/bin/bash

# ===== CONFIGURATION =====
CSV_FILE="$HOME/Work_Course_Linux/5Q/data.csv"
LOG_FILE="$HOME/Work_Course_Linux/5Q/txt.output_5"
LAST_OUTPUT="$HOME/Work_Course_Linux/5Q/last_output.csv"

# ===== FUNCTION: Create CSV File =====
create_csv() {
    read -p "Enter the name of the new CSV file: " NEW_CSV
    echo "Date collected,Species,Sex,Weight" > "$NEW_CSV"
    echo "[INFO] CSV file '$NEW_CSV' created." | tee -a "$LOG_FILE"
}

# ===== FUNCTION: Display CSV Data with Index =====
display_csv() {
    echo "[INFO] Displaying CSV data:" | tee -a "$LOG_FILE"
    awk 'NR==1 {print "Index," $0} NR>1 {print NR-1 "," $0}' "$CSV_FILE" | tee -a "$LOG_FILE"
}

# ===== FUNCTION: Add New Row =====
add_row() {
    read -p "Enter Date collected: " date
    read -p "Enter Species: " species
    read -p "Enter Sex (M/F): " sex
    read -p "Enter Weight: " weight

    echo "$date,$species,$sex,$weight" >> "$CSV_FILE"
    echo "[INFO] Added row: $date, $species, $sex, $weight" | tee -a "$LOG_FILE"
}

# ===== FUNCTION: Filter by Species and Calculate AVG Weight =====
filter_by_species() {
    read -p "Enter Species: " species
    echo "[INFO] Filtering by species: $species" | tee -a "$LOG_FILE"
    
    awk -F',' -v spec="$species" 'NR==1 {print $0} $2 == spec {print $0; sum+=$4; count++} END {if(count>0) print "Average Weight: " sum/count}' "$CSV_FILE" | tee -a "$LOG_FILE"
}

# ===== FUNCTION: Filter by Species and Sex =====
filter_by_sex() {
    read -p "Enter Species: " species
    read -p "Enter Sex (M/F): " sex
    echo "[INFO] Filtering by species: $species and sex: $sex" | tee -a "$LOG_FILE"
    
    awk -F',' -v spec="$species" -v sx="$sex" 'NR==1 {print $0} $2 == spec && $3 == sx {print $0}' "$CSV_FILE" | tee -a "$LOG_FILE"
}

# ===== FUNCTION: Save Last Output to New CSV =====
save_last_output() {
    cp "$LOG_FILE" "$LAST_OUTPUT"
    echo "[INFO] Last output saved to '$LAST_OUTPUT'" | tee -a "$LOG_FILE"
}

# ===== FUNCTION: Delete Row by Index =====
delete_row() {
    read -p "Enter row index to delete: " index
    if [[ ! "$index" =~ ^[0-9]+$ ]]; then
        echo "[ERROR] Invalid index!" | tee -a "$LOG_FILE"
        return
    fi

    awk -v idx="$index" 'NR!=idx+1' "$CSV_FILE" > temp.csv && mv temp.csv "$CSV_FILE"
    echo "[INFO] Deleted row at index $index" | tee -a "$LOG_FILE"
}

# ===== FUNCTION: Update Weight by Index =====
update_weight() {
    read -p "Enter row index to update weight: " index
    read -p "Enter new weight: " new_weight

    if [[ ! "$index" =~ ^[0-9]+$ ]] || [[ ! "$new_weight" =~ ^[0-9]+$ ]]; then
        echo "[ERROR] Invalid input!" | tee -a "$LOG_FILE"
        return
    fi

    awk -F',' -v idx="$index" -v weight="$new_weight" 'NR==idx+1 {$4=weight} {print $0}' OFS=',' "$CSV_FILE" > temp.csv && mv temp.csv "$CSV_FILE"
    echo "[INFO] Updated weight at index $index to $new_weight" | tee -a "$LOG_FILE"
}

# ===== MENU LOOP =====
while true; do
    echo -e "\nChoose an option:"
    echo "1. CREATE CSV by name"
    echo "2. Display all CSV DATA with row INDEX"
    echo "3. Read user input for new row"
    echo "4. Read Specie And Display all Items & AVG weight"
    echo "5. Read Specie sex (M/F) and display all items"
    echo "6. Save last output to new csv file"
    echo "7. Delete row by row index"
    echo "8. Update weight by row index"
    echo "9. Exit"

    read -p "Enter your choice: " choice

    case $choice in
        1) create_csv ;;
        2) display_csv ;;
        3) add_row ;;
        4) filter_by_species ;;
        5) filter_by_sex ;;
        6) save_last_output ;;
        7) delete_row ;;
        8) update_weight ;;
        9) echo "[INFO] Exiting program." | tee -a "$LOG_FILE"; exit 0 ;;
        *) echo "[ERROR] Invalid option!" | tee -a "$LOG_FILE" ;;
    esac
done
