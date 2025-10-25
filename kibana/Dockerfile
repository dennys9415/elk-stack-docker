FROM docker.elastic.co/kibana/kibana:8.11.0

# Switch to root user to install tools
USER root

# Install required packages
RUN yum update -y && yum install -y curl && yum clean all

# Create kibana user and set permissions
RUN groupadd -g 1000 kibana && \
    useradd -u 1000 -g 1000 -d /usr/share/kibana kibana

# Set permissions
RUN chown -R kibana:kibana /usr/share/kibana

# Switch back to kibana user
USER kibana

EXPOSE 5601

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=300s --retries=3 \
  CMD curl -f http://localhost:5601/api/status || exit 1