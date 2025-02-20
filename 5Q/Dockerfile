# Use Ubuntu as base image
FROM ubuntu:latest

# Install dependencies
RUN apt-get update && apt-get install -y bash coreutils

# Set working directory
WORKDIR /app

# Copy script and data into container
COPY menu_script.sh .
COPY data.csv .

# Give execution permissions
RUN chmod +x menu_script.sh

# Run the script
CMD ["bash", "menu_script.sh"]
