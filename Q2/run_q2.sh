#!/bin/bash

# Ensure we are in the correct directory
cd ~/Work_Course_Linux/Q2 || { echo "Q2 directory not found!"; exit 1; }

# Activate the virtual environment
source ~/Q2_ENV/bin/activate || { echo "Failed to activate virtual environment"; exit 1; }

# Install dependencies from requirements.txt
pip install -r requirements.txt || { echo "Failed to install dependencies"; exit 1; }

# Run py1.py and append the output to q2_output.txt
python3 py1.py >> q2_output.txt 2>&1 || { echo "Failed to run py1.py"; exit 1; }

# Print completion message
echo "Execution completed. Output appended to q2_output.txt."
