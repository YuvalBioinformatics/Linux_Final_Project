#!/bin/bash

# ===== CONFIGURATION =====
CSV_FILE=$1
PYTHON_SCRIPT=~/Work_Course_Linux/4Q/plant.py
VENV_PATH=~/plant_analysis_venv
LOG_FILE=~/Work_Course_Linux/4Q/script_log.txt

# ===== VALIDATION: Ensure CSV file exists =====
if [[ ! -f "$CSV_FILE" ]]; then
    echo "[ERROR] CSV file not found: $CSV_FILE" | tee -a "$LOG_FILE"
    exit 1
fi

# ===== SETUP: Create Virtual Environment if it doesn't exist =====
if [[ ! -d "$VENV_PATH" ]]; then
    echo "[INFO] Creating virtual environment in: $VENV_PATH" | tee -a "$LOG_FILE"
    python3 -m venv "$VENV_PATH"
else
    echo "[INFO] Virtual environment already exists, skipping creation." | tee -a "$LOG_FILE"
fi

# ===== ACTIVATE VIRTUAL ENVIRONMENT =====
source "$VENV_PATH/bin/activate"
if [[ $? -ne 0 ]]; then
    echo "[ERROR] Failed to activate virtual environment" | tee -a "$LOG_FILE"
    exit 1
fi

# ===== INSTALL REQUIRED PACKAGES =====
pip install --upgrade pip &>> "$LOG_FILE"
pip install matplotlib pandas argparse &>> "$LOG_FILE"
echo "[INFO] Dependencies installed successfully" | tee -a "$LOG_FILE"

# ===== READ CSV FILE AND PROCESS EACH ROW =====
echo "[INFO] Processing CSV file: $CSV_FILE" | tee -a "$LOG_FILE"
while IFS=',' read -r PLANT HEIGHT LEAF_COUNT DRY_WEIGHT; do

    # Skip header row
    if [[ "$PLANT" == "PLANT" ]]; then
        continue
    fi

    # Validate data fields
    if [[ -z "$PLANT" || -z "$HEIGHT" || -z "$LEAF_COUNT" || -z "$DRY_WEIGHT" ]]; then
        echo "[WARNING] Skipping row with missing data: $PLANT, $HEIGHT, $LEAF_COUNT, $DRY_WEIGHT" | tee -a "$LOG_FILE"
        continue
    fi

    # Create plant directory inside 4Q
    PLANT_DIR=~/Work_Course_Linux/4Q/$PLANT
    mkdir -p "$PLANT_DIR"

    # Execute Python script with parameters
    echo "[INFO] Running analysis for plant: $PLANT" | tee -a "$LOG_FILE"
    python3 "$PYTHON_SCRIPT" --plant "$PLANT" --height $HEIGHT --leaf_count $LEAF_COUNT --dry_weight $DRY_WEIGHT &>> "$LOG_FILE"

    # Check if Python execution was successful
    if [[ $? -ne 0 ]]; then
        echo "[ERROR] Python script failed for: $PLANT" | tee -a "$LOG_FILE"
        continue
    fi

    # Move generated plots to the plant's directory
    mv ~/Work_Course_Linux/4Q/2_4/${PLANT}_*.png "$PLANT_DIR/" &>> "$LOG_FILE"
    echo "[INFO] Plots saved in: $PLANT_DIR" | tee -a "$LOG_FILE"

done < <(tail -n +2 "$CSV_FILE") # Skip CSV header

# ===== DEACTIVATE VIRTUAL ENVIRONMENT =====
deactivate
echo "[INFO] Virtual environment deactivated" | tee -a "$LOG_FILE"

echo "[INFO] Script completed successfully" | tee -a "$LOG_FILE"
exit 0
