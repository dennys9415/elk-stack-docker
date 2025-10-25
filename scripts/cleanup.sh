#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}🧹 Cleaning up ELK Stack...${NC}"

read -p "Are you sure you want to stop and remove all ELK containers and data? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Cleanup cancelled.${NC}"
    exit 1
fi

# Stop and remove containers
echo -e "${YELLOW}Stopping containers...${NC}"
docker-compose down

# Remove volumes
read -p "Do you want to remove ALL data volumes? This cannot be undone! (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Removing data volumes...${NC}"
    docker-compose down -v
    echo -e "${GREEN}✅ All data volumes removed${NC}"
fi

# Remove Docker images
read -p "Do you want to remove Docker images? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Removing Docker images...${NC}"
    docker rmi $(docker images "elk-stack-docker*" -q) 2>/dev/null || true
    docker rmi $(docker images "elasticsearch*" -q) 2>/dev/null || true
    docker rmi $(docker images "logstash*" -q) 2>/dev/null || true
    docker rmi $(docker images "kibana*" -q) 2>/dev/null || true
    echo -e "${GREEN}✅ Docker images removed${NC}"
fi

# Clean up unused containers, networks, and images
echo -e "${YELLOW}Cleaning up unused Docker resources...${NC}"
docker system prune -f

echo -e "${GREEN}🎉 Cleanup completed!${NC}"