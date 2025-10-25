FROM docker.elastic.co/logstash/logstash:8.11.0

# Switch to root user to install tools
USER root

# Install required packages
RUN yum update -y && yum install -y curl && yum clean all

# Create logstash user and set permissions
RUN groupadd -g 1000 logstash && \
    useradd -u 1000 -g 1000 -d /usr/share/logstash logstash

# Set permissions
RUN chown -R logstash:logstash /usr/share/logstash

# Install custom plugins if needed
# RUN logstash-plugin install logstash-filter-json

# Switch back to logstash user
USER logstash

# Expose ports
EXPOSE 5044 5000 9600

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=300s --retries=3 \
  CMD curl -f http://localhost:9600/ || exit 1