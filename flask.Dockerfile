FROM python:3.9-slim
 
# Update package lists, install packages, and clean up
RUN apt update -y && \
    apt install -y build-essential cmake libgtk-3-dev libboost-python-dev && \
    rm -rf /var/lib/apt/lists/*

# Create a new user 'vscode' and add it to the root group
RUN useradd -m -s /bin/bash vscode && \
    usermod -aG root vscode && \
    echo "vscode ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Set the working directory
WORKDIR /app

# Keep the container running
CMD ["sleep", "infinity"]