# Use Ubuntu as the base image
FROM ubuntu:latest

# Set the working directory inside the container
WORKDIR /app

# Install necessary dependencies
RUN apt-get update && apt-get install -y bash coreutils

# Copy the CSV management script and necessary files
COPY ./manage_csv.sh /app/manage_csv.sh

# Give execution permissions
RUN chmod +x /app/manage_csv.sh

# Define the entry point (run the script)
CMD ["/app/manage_csv.sh"]
