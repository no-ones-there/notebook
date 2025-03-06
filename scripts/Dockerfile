FROM ubuntu:latest

# Install necessary utilities
RUN apt-get update && apt-get install -y \
    bash \
    coreutils \
    tzdata \
    vim \
    jq \
    && ln -fs /usr/share/zoneinfo/Pacific/Auckland /etc/localtime && \
    dpkg-reconfigure --frontend noninteractive tzdata
# Set working directory
WORKDIR /home

# Copy scripts into the container
COPY td.sh /scripts/td
COPY mt.sh /scripts/mt

# Make scripts executable
RUN chmod +x /scripts/td /scripts/mt

# Add scripts to PATH
ENV PATH="/scripts:$PATH"

# Default command
CMD ["bash"]
