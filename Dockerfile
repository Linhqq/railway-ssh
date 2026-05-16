FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# -----------------------------
# Install packages
# -----------------------------
RUN apt update && apt install -y --no-install-recommends \
    openssh-server \
    curl \
    wget \
    unzip \
    sudo \
    python3 \
    ca-certificates \
    && apt clean && rm -rf /var/lib/apt/lists/*

# -----------------------------
# Create user
# -----------------------------
RUN useradd -m -s /bin/bash trthaodev && \
    echo "trthaodev:thaodev" | chpasswd && \
    adduser trthaodev sudo

# -----------------------------
# SSH setup
# -----------------------------
RUN mkdir -p /var/run/sshd

RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    echo "UsePAM yes" >> /etc/ssh/sshd_config && \
    echo "ClientAliveInterval 60" >> /etc/ssh/sshd_config && \
    echo "ClientAliveCountMax 3" >> /etc/ssh/sshd_config

# -----------------------------
# Install ngrok v3
# -----------------------------
RUN wget -q https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz && \
    tar -xzf ngrok-v3-stable-linux-amd64.tgz && \
    mv ngrok /usr/local/bin/ngrok && \
    rm ngrok-v3-stable-linux-amd64.tgz

# -----------------------------
# Copy startup script
# -----------------------------
COPY start-ngrok-ssh.sh /start-ngrok-ssh.sh
RUN chmod +x /start-ngrok-ssh.sh

# -----------------------------
# Ports
# -----------------------------
EXPOSE 22 8080

# -----------------------------
# Start container
# -----------------------------
CMD ["/start-ngrok-ssh.sh"]
