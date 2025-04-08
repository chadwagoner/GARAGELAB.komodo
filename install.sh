#!/bin/sh

### GLOBAL VARIABLES
ENV=$(cat <<-END
  ### CONTAINER VERSIONS
  KOMODO_VERSION: "$komodo_version"
  MONGO_VERSION: "$mongo_version"

  ### SERVICE PATH
  SERVICE_PATH: "$service_path"

  ### KOMODO SPECIFIC
  KOMODO_TITLE: "Komodo"
  KOMODO_FIRST_SERVER: "https://periphery:8120"
  KOMODO_DISABLE_CONFIRM_DIALOG: false
  KOMODO_PASSKEY: "a_random_passkey"
  KOMODO_MONITORING_INTERVAL: "15-sec"
  KOMODO_RESOURCE_POLL_INTERVAL: "5-min"
  KOMODO_WEBHOOK_SECRET: "a_random_secret"
  KOMODO_JWT_SECRET: "a_random_jwt_secret"
  KOMODO_LOCAL_AUTH: true
  KOMODO_DISABLE_USER_REGISTRATION: false
  KOMODO_ENABLE_NEW_USERS: false
  KOMODO_DISABLE_NON_ADMIN_CREATE: false
  KOMODO_TRANSPARENT_MODE: false
  KOMODO_JWT_TTL: "1-day"
  KOMODO_OIDC_ENABLED: false
  KOMODO_GITHUB_OAUTH_ENABLED: false
  KOMODO_GOOGLE_OAUTH_ENABLED: false

  ### MONGO SPECIFIC
  MONGO_USERNAME: "$mongo_username"
  MONGO_PASSWORD: "$mongo_password"
END

)

### USER INPUT VARIABLES
read -p 'KOMODO VERSION [latest]: ' komodo_version < /dev/tty
read -p 'MONGO VERSION [latest] ' mongo_version < /dev/tty
read -p 'SERVICE PATH [/opt/services]: ' service_path < /dev/tty
read -p 'MONGO USERNAME [mongo]: ' mongo_username < /dev/tty
read -p 'MONGO PASSWORD [mongo]: ' mongo_password < /dev/tty

### SET DEFAULT VALUES
komodo_version=${komodo_version:-latest}
mongo_version=${mongo_version:-latest}
service_path=${service_path:-'/opt/services'}
mongo_username=${mongo_username:-mongo}
mongo_password=${mongo_password:-mongo}

### MAKE KOMODO DIRECTORY
mkdir -p $service_path/komodo
mkdir -p $service_path/komodo/data

### MAKE MONGO DIRECTORY
mkdir -p $service_path/mongo
mkdir -p $service_path/mongo/config
mkdir -p $service_path/mongo/data

### CREATE .ENV
echo -e "$ENV" | tee $service_path/komodo/.env >/dev/null

### GET COMPOSE FILE
curl -sL -o $service_path/komodo/compose.yaml -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/chadwagoner/GARAGELAB.komodo/main/compose.yaml

### START KOMODO
#docker compose -f $service_path/komodo/compose.yaml up -d