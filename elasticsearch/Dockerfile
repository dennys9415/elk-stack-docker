FROM docker.elastic.co/elasticsearch/elasticsearch:8.11.0

# Switch to root user to install tools
USER root

# Install required packages
RUN yum update -y && yum install -y curl && yum clean all

# Create elasticsearch user and set permissions
RUN groupadd -g 1000 elasticsearch && \
    useradd -u 1000 -g 1000 -d /usr/share/elasticsearch elasticsearch

# Set permissions
RUN chown -R elasticsearch:elasticsearch /usr/share/elasticsearch

# Switch back to elasticsearch user
USER elasticsearch

# Expose ports
EXPOSE 9200 9300

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=300s --retries=3 \
  CMD curl -f http://localhost:9200/_cluster/health || exit 1