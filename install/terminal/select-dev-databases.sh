#!/bin/bash

# Install selected databases via Docker
if [[ -n "$SELECTED_DBS" ]]; then
  
  # Ensure Docker is available
  if ! command -v docker >/dev/null 2>&1; then
    echo "Docker is required for database installation but not found. Installing Docker..."
    source $OMAKUB_SZAMSKI_PATH/install/terminal/docker.sh
  fi

  IFS=$','
  for db in $SELECTED_DBS; do
    case $db in
    "MySQL") 
      sudo docker run -d --restart unless-stopped -p "127.0.0.1:3306:3306" --name=mysql8 -e MYSQL_ROOT_PASSWORD= -e MYSQL_ALLOW_EMPTY_PASSWORD=true mysql:8.4 
      ;;
    "PostgreSQL") 
      sudo docker run -d --restart unless-stopped -p "127.0.0.1:5432:5432" --name=postgres16 -e POSTGRES_HOST_AUTH_METHOD=trust postgres:16 
      ;;
    "MariaDB") 
      sudo docker run -d --restart unless-stopped -p "127.0.0.1:3306:3306" --name=mariadb11 -e MARIADB_ROOT_PASSWORD= -e MARIADB_ALLOW_EMPTY_ROOT_PASSWORD=true mariadb:11.2 
      ;;
    "Redis") 
      sudo docker run -d --restart unless-stopped -p "127.0.0.1:6379:6379" --name=redis redis:7 
      ;;
    "MongoDB") 
      sudo docker run -d --restart unless-stopped -p "127.0.0.1:27017:27017" --name mongodb -e MONGO_INITDB_ROOT_USERNAME=admin -e MONGO_INITDB_ROOT_PASSWORD=admin123 mongo:latest 
      ;;
    esac
  done
fi
