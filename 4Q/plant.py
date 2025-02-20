import argparse
import matplotlib.pyplot as plt
import os
output_dir = os.path.join(os.path.dirname(__file__), "2_4")
os.makedirs(output_dir, exist_ok=True)
# Argument parser setup
parser = argparse.ArgumentParser(description="Generate plant growth analysis plots")
parser.add_argument("--plant", type=str, required=True, help="Plant name")
parser.add_argument("--height", type=float, nargs='+', required=True, help="List of plant heights")
parser.add_argument("--leaf_count", type=int, nargs='+', required=True, help="List of leaf counts")
parser.add_argument("--dry_weight", type=float, nargs='+', required=True, help="List of dry weights")

args = parser.parse_args()

# Assign parsed values
plant = args.plant
height_data = args.height
leaf_count_data = args.leaf_count
dry_weight_data = args.dry_weight

# Log file for tracking execution
log_file = os.path.join(os.path.dirname(__file__), "log.txt")
with open(log_file, "a") as log:
    log.write(f"Running analysis for {plant}\n")

try:
    # Print out plant data
    print(f"Plant: {plant}")
    print(f"Height data: {height_data} cm")
    print(f"Leaf count data: {leaf_count_data}")
    print(f"Dry weight data: {dry_weight_data} g")

    # Scatter Plot - Height vs Leaf Count
    plt.figure(figsize=(10, 6))
    plt.scatter(height_data, leaf_count_data, color='b')
    plt.title(f'Height vs Leaf Count for {plant}')
    plt.xlabel('Height (cm)')
    plt.ylabel('Leaf Count')
    plt.grid(True)
    scatter_path = os.path.join(output_dir, f"{plant}_scatter.png")
    plt.savefig(scatter_path)
    plt.close()

    # Histogram - Distribution of Dry Weight
    plt.figure(figsize=(10, 6))
    plt.hist(dry_weight_data, bins=5, color='g', edgecolor='black')
    plt.title(f'Histogram of Dry Weight for {plant}')
    plt.xlabel('Dry Weight (g)')
    plt.ylabel('Frequency')
    plt.grid(True)
    histogram_path = os.path.join(output_dir, f"{plant}_histogram.png")
    plt.savefig(histogram_path)
    plt.close()

    # Line Plot - Plant Height Over Time
    weeks = [f"Week {i+1}" for i in range(len(height_data))]
    plt.figure(figsize=(10, 6))
    plt.plot(weeks, height_data, marker='o', color='r')
    plt.title(f'{plant} Height Over Time')
    plt.xlabel('Week')
    plt.ylabel('Height (cm)')
    plt.grid(True)
    line_plot_path = os.path.join(output_dir, f"{plant}_line_plot.png")
    plt.savefig(line_plot_path)
    plt.close()

    # Log success
    with open(log_file, "a") as log:
        log.write(f"Successfully generated plots for {plant}\n")

except Exception as e:
    with open(log_file, "a") as log:
        log.write(f"Error processing {plant}: {str(e)}\n")
    print(f"Error: {e}")

