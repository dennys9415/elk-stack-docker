#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}🔍 Checking ELK Stack Health...${NC}"

# Function to check service
check_service() {
    local name=$1
    local url=$2
    local response=$(curl -s -o /dev/null -w "%{http_code}" "$url")
    
    if [ "$response" = "200" ]; then
        echo -e "${GREEN}✅ $name: HTTP $response${NC}"
        return 0
    else
        echo -e "${RED}❌ $name: HTTP $response${NC}"
        return 1
    fi
}

# Check Elasticsearch
check_service "Elasticsearch" "http://localhost:9200"

# Check Kibana
check_service "Kibana" "http://localhost:5601/api/status"

# Check Logstash
check_service "Logstash" "http://localhost:9600"

# Check container status
echo -e "\n${YELLOW}🐳 Container Status:${NC}"
docker-compose ps

# Check disk space
echo -e "\n${YELLOW}💾 Disk Space:${NC}"
df -h | grep -E "Filesystem|/dev/"

# Check memory usage
echo -e "\n${YELLOW}🧠 Memory Usage:${NC}"
free -h

# Check Elasticsearch cluster health
echo -e "\n${YELLOW}📊 Elasticsearch Cluster Health:${NC}"
if curl -s http://localhost:9200/_cluster/health > /dev/null; then
    cluster_health=$(curl -s http://localhost:9200/_cluster/health | jq -r '.status')
    echo -e "Cluster status: $cluster_health"
    
    if [ "$cluster_health" = "green" ]; then
        echo -e "${GREEN}✅ Cluster is healthy${NC}"
    elif [ "$cluster_health" = "yellow" ]; then
        echo -e "${YELLOW}⚠️ Cluster is in warning state${NC}"
    else
        echo -e "${RED}❌ Cluster is in critical state${NC}"
    fi
else
    echo -e "${RED}❌ Could not retrieve cluster health${NC}"
fi