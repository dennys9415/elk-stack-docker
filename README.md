# ELK Stack Docker

A complete Elasticsearch, Logstash, and Kibana (ELK) stack running in Docker containers for log aggregation, analysis, and visualization.

## 🚀 Features

- **Elasticsearch 8.x** - Distributed search and analytics engine
- **Logstash 8.x** - Server-side data processing pipeline
- **Kibana 8.x** - Visualization and management dashboard
- **Docker Compose** - Easy deployment and management
- **Production Ready** - Configurable and scalable setup
- **Health Monitoring** - Built-in health checks and monitoring
- **Data Persistence** - Volume-based data persistence
- **Backup Scripts** - Automated backup and recovery

## 📋 Prerequisites

- Docker 20.10+
- Docker Compose 2.0+
- 4GB RAM minimum (8GB recommended)
- 10GB free disk space

## 🛠 Quick Start

### Option 1: Automated Setup (Recommended)

```bash
git clone https://github.com/your-username/elk-stack-docker.git
cd elk-stack-docker
chmod +x scripts/*.sh
./scripts/setup.sh
```

## Option 2: Manual Setup

```bash
# Clone the repository
git clone https://github.com/your-username/elk-stack-docker.git
cd elk-stack-docker

# Copy environment file
cp .env.example .env

# Build and start services
docker-compose up -d --build

# Check services
./scripts/health-check.sh
```

## Option 3: With Monitoring (Filebeat + Metricbeat)

```bash
docker-compose -f docker-compose.yml -f docker-compose.monitoring.yml up -d
```

## 📊 Access Services

* Kibana Dashboard: http://localhost:5601
* Elasticsearch API: http://localhost:9200
* Logstash Monitoring: http://localhost:9600

## 📁 Project Structure

```
elk-stack-docker/
├── .github/
│   └── workflows/
│       └── docker-build.yml
├── docker-compose.yml              # Main composition file
├── docker-compose.monitoring.yml   # Monitoring services
├── elasticsearch/                  # Elasticsearch config
│   ├── config/
│   │   └── elasticsearch.yml
│   ├── Dockerfile
│   └── data/                       # Data persistence
├── logstash/                       # Logstash config
│   ├── config/
│   │   └── logstash.yml
│   ├── pipeline/
│   │   └── logstash.conf
│   └── Dockerfile
├── kibana/                         # Kibana config
│   ├── config/
│   │   └── kibana.yml
│   └── Dockerfile
├── filebeat/                       # Filebeat config
│   └── filebeat.yml
├── scripts/                        # Utility scripts
│   ├── setup.sh
│   ├── backup.sh
│   ├── health-check.sh
│   └── cleanup.sh
├── .env.example                    # Environment template
├── .dockerignore
├── README.md
├── LICENSE
└── .gitignore
```

## ⚙️ Configuration

### Environment Variables

Copy and modify the environment file:

```bash
cp .env.example .env
```

Edit the .env file to adjust:

* Memory settings: ELASTICSEARCH_HEAP_SIZE, LOGSTASH_HEAP_SIZE
* Port configurations: Service exposure ports
* Security settings: Enable/disable X-Pack security

### Logstash Pipelines

Modify logstash/pipeline/logstash.conf to customize:

* Inputs: Beats, TCP, HTTP, File inputs
* Filters: Grok patterns, JSON parsing, Mutations
* Outputs: Elasticsearch indices, external services

### Elasticsearch Configuration

Adjust elasticsearch/config/elasticsearch.yml for:

* Cluster settings
* Memory and performance tuning
* Security configurations

## 🔧 Usage Examples

Send Logs via Filebeat

```yaml
# filebeat.yml
filebeat.inputs:
- type: log
  paths:
    - /var/log/*.log

output.logstash:
  hosts: ["localhost:5044"]
```

### Send Logs via TCP

```bash
echo '{"message": "Test log", "level": "INFO", "timestamp": "'$(date -Iseconds)'"}' | nc localhost 5000
```

### Send Logs via HTTP

```bash
curl -X POST http://localhost:8080 -H "Content-Type: application/json" -d '{
  "message": "HTTP test log",
  "level": "ERROR",
  "service": "api"
}'
```

## 🛠 Management

### Check Service Health

```bash
./scripts/health-check.sh
```

### View Logs

```bash
# All services
docker-compose logs

# Specific service
docker-compose logs elasticsearch
docker-compose logs -f logstash  # Follow mode
```

### Backup Data

```bash
./scripts/backup.sh
```

### Stop Services

```bash
docker-compose down
```

### Stop and Remove All Data

```bash
./scripts/cleanup.sh
```

## 🐛 Troubleshooting

### Common Issues

1. Containers not starting

    * Check available memory: free -h
    * Check port conflicts: netstat -tulpn | grep :9200

2. Elasticsearch health yellow

    * Single node cluster, this is normal
    * Check disk space: df -h

3. Connection refused errors

    * Wait for services to fully start (30-60 seconds)
    * Check service health: ./scripts/health-check.sh

4. High memory usage

    * Adjust heap sizes in .env file
    * Reduce ELASTICSEARCH_HEAP_SIZE if needed

### Debugging

```bash
# Check container status
docker-compose ps

# Check service logs
docker-compose logs elasticsearch
docker-compose logs logstash
docker-compose logs kibana

# Check resource usage
docker stats

# Check Elasticsearch indices
curl http://localhost:9200/_cat/indices?v
```

## 🔒 Security Considerations

For production deployments:

1. Enable X-Pack Security in .env:

```env
XPACK_SECURITY_ENABLED=true
```

2. Set strong passwords for built-in users

3. Configure SSL/TLS for encrypted communications

4. Use network security groups to restrict access

5. Regular updates to latest versions

## 📈 Monitoring & Maintenance

### Health Monitoring

Use the provided health check script:

```bash
./scripts/health-check.sh
```

### Regular Backups

Schedule regular backups using cron:

```bash
# Add to crontab (crontab -e)
0 2 * * * /path/to/elk-stack-docker/scripts/backup.sh
```

### Performance Tuning

* Adjust JVM heap sizes based on available memory
* Configure Logstash worker threads for throughput
* Monitor disk space for Elasticsearch data

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: git checkout -b feature/new-feature
3. Commit your changes: git commit -am 'Add new feature'
4. Push to the branch: git push origin feature/new-feature
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

* Elastic for the ELK Stack
* Docker for containerization
* Community contributors and maintainers