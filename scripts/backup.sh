#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

BACKUP_DIR="./backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_NAME="elk_backup_$TIMESTAMP"

echo -e "${YELLOW}💾 Starting ELK Stack Backup...${NC}"

# Create backup directory
mkdir -p "$BACKUP_DIR/$BACKUP_NAME"

# Function to create backup
create_backup() {
    local service=$1
    local container_id=$(docker ps -q -f "name=$service")
    
    if [ -n "$container_id" ]; then
        echo -e "${YELLOW}Backing up $service...${NC}"
        
        case $service in
            "elasticsearch")
                # Create Elasticsearch snapshot
                docker exec elasticsearch curl -X PUT "localhost:9200/_snapshot/backup_repository/$BACKUP_NAME?wait_for_completion=true" -H 'Content-Type: application/json' -d'
                {
                    "indices": "*",
                    "ignore_unavailable": true,
                    "include_global_state": false
                }'
                ;;
            "logstash")
                # Backup Logstash configuration
                docker cp logstash:/usr/share/logstash/config "$BACKUP_DIR/$BACKUP_NAME/logstash_config"
                docker cp logstash:/usr/share/logstash/pipeline "$BACKUP_DIR/$BACKUP_NAME/logstash_pipeline"
                ;;
            "kibana")
                # Backup Kibana configuration
                docker cp kibana:/usr/share/kibana/config "$BACKUP_DIR/$BACKUP_NAME/kibana_config"
                ;;
        esac
        
        echo -e "${GREEN}✅ $service backup completed${NC}"
    else
        echo -e "${RED}❌ $service container not found${NC}"
    fi
}

# Backup each service
create_backup "elasticsearch"
create_backup "logstash"
create_backup "kibana"

# Backup Docker Compose files
echo -e "${YELLOW}Backing up configuration files...${NC}"
cp docker-compose.yml "$BACKUP_DIR/$BACKUP_NAME/"
cp docker-compose.monitoring.yml "$BACKUP_DIR/$BACKUP_NAME/" 2>/dev/null || true
cp .env "$BACKUP_DIR/$BACKUP_NAME/" 2>/dev/null || true

# Create archive
echo -e "${YELLOW}Creating backup archive...${NC}"
tar -czf "$BACKUP_DIR/$BACKUP_NAME.tar.gz" -C "$BACKUP_DIR" "$BACKUP_NAME"

# Cleanup
rm -rf "$BACKUP_DIR/$BACKUP_NAME"

echo -e "${GREEN}🎉 Backup completed: $BACKUP_DIR/$BACKUP_NAME.tar.gz${NC}"

# Display backup size
backup_size=$(du -h "$BACKUP_DIR/$BACKUP_NAME.tar.gz" | cut -f1)
echo -e "${YELLOW}Backup size: $backup_size${NC}"

# List recent backups
echo -e "\n${YELLOW}📦 Recent backups:${NC}"
ls -lt "$BACKUP_DIR"/*.tar.gz 2>/dev/null | head -5 || echo "No backups found"