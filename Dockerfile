# Use the Jenkins LTS (Long-Term Support) image as the base image
FROM jenkins/jenkins:lts

# Switch to the root user to install packages
USER root

# Install Node.js and npm
RUN curl -fsSL https://deb.nodesource.com/setup_14.x | bash - && \
    apt-get install -y nodejs && \
    apt-get install -y npm && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Verify Node.js and npm installation
RUN node -v && npm -v

# Switch back to the Jenkins user
USER jenkins

