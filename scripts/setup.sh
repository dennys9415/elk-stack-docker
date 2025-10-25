#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}🚀 Setting up ELK Stack with Docker...${NC}"

# Function to print colored output
print_status() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️ $1${NC}"
}

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    print_error "Docker is not installed. Please install Docker first."
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    print_error "Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

# Create necessary directories
mkdir -p elasticsearch/data logstash/pipeline kibana/config filebeat
print_status "Created necessary directories"

# Copy environment file if it doesn't exist
if [ ! -f .env ]; then
    cp .env.example .env
    print_warning "Created .env file from .env.example. Please review and adjust settings."
else
    print_status ".env file already exists"
fi

# Set execute permissions on scripts
chmod +x scripts/*.sh
print_status "Set execute permissions on scripts"

# Build and start containers
print_status "Building and starting ELK containers..."
docker-compose up -d --build

echo -e "${YELLOW}⏳ Waiting for services to be healthy...${NC}"
sleep 40

# Check if Elasticsearch is running
if curl -s http://localhost:9200 > /dev/null; then
    print_status "Elasticsearch is running at http://localhost:9200"
else
    print_error "Elasticsearch is not responding"
    docker-compose logs elasticsearch
    exit 1
fi

# Check if Kibana is running
if curl -s http://localhost:5601 > /dev/null; then
    print_status "Kibana is running at http://localhost:5601"
else
    print_error "Kibana is not responding"
    docker-compose logs kibana
    exit 1
fi

# Check if Logstash is running
if curl -s http://localhost:9600 > /dev/null; then
    print_status "Logstash is running at http://localhost:9600"
else
    print_error "Logstash is not responding"
    docker-compose logs logstash
    exit 1
fi

echo -e "${GREEN}🎉 ELK Stack setup completed successfully!${NC}"
echo ""
echo -e "${YELLOW}📊 Access URLs:${NC}"
echo -e "  Kibana:      http://localhost:5601"
echo -e "  Elasticsearch: http://localhost:9200"
echo -e "  Logstash API: http://localhost:9600"
echo ""
echo -e "${YELLOW}📝 Log ingestion ports:${NC}"
echo -e "  Filebeat: 5044"
echo -e "  TCP:      5000"
echo -e "  HTTP:     8080"
echo ""
echo -e "${YELLOW}🔧 Useful commands:${NC}"
echo -e "  View logs:              docker-compose logs"
echo -e "  Stop services:          docker-compose down"
echo -e "  Restart services:       docker-compose restart"
echo -e "  Check health:           ./scripts/health-check.sh"
echo -e "  Backup data:            ./scripts/backup.sh"