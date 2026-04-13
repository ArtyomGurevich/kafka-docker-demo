#!/bin/bash
# start-kafka.sh - Script para iniciar Kafka con IP automática y health-check

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=========================================${NC}"
echo -e "${GREEN}🚀 Iniciador de Kafka con IP Automática${NC}"
echo -e "${BLUE}=========================================${NC}"

# OBTENER LA IP DIRECTAMENTE
echo -e "${YELLOW}🔍 Detectando IP...${NC}"

# Método 1: ip route
HOST_IP=$(ip route get 1 2>/dev/null | head -1 | awk '{print $7}')

# Método 2: hostname -I
if [ -z "$HOST_IP" ]; then
    HOST_IP=$(hostname -I 2>/dev/null | awk '{print $1}')
fi

# Método 3: buscar en interfaces
if [ -z "$HOST_IP" ]; then
    HOST_IP=$(ip -4 addr show | grep -v "docker\|br-\|veth\|lo" | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | head -1)
fi

# Mostrar IP detectada
echo -e "${GREEN}✅ IP detectada: $HOST_IP${NC}"

# Verificar que tenemos una IP válida
if [ -z "$HOST_IP" ]; then
    echo -e "${RED}❌ No se pudo detectar IP automáticamente${NC}"
    read -p "Ingresa la IP manualmente (ej: 192.168.1.103): " HOST_IP
fi

# Validar formato de IP
if [[ ! $HOST_IP =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo -e "${RED}❌ IP no válida: $HOST_IP${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Usando IP: $HOST_IP${NC}"

# Crear archivo .env
echo -e "${YELLOW}📝 Creando archivo .env...${NC}"
echo "HOST_IP=$HOST_IP" > .env
echo -e "${GREEN}✅ Archivo .env creado: HOST_IP=$HOST_IP${NC}"

# Detener contenedores anteriores
echo -e "${YELLOW}🛑 Deteniendo contenedores anteriores...${NC}"
docker compose down 2>/dev/null

# Iniciar Kafka
echo -e "${YELLOW}🚀 Iniciando Kafka con IP externa: $HOST_IP${NC}"
env HOST_IP="$HOST_IP" docker compose up -d

# Health-check loop
echo -e "${YELLOW}⏳ Esperando a que Kafka esté listo...${NC}"
for i in {1..30}; do
    if docker compose logs kafka 2>/dev/null | grep -qi "advertised.listeners"; then
        echo -e "${GREEN}✅ Kafka está listo${NC}"
        break
    fi
    echo -e "${YELLOW}...aún no está listo, reintentando ($i)${NC}"
    sleep 2
done

# Verificar si no se inicializó
if ! docker compose logs kafka 2>/dev/null | grep -qi "advertised.listeners"; then
    echo -e "${RED}❌ Kafka no se inicializó en el tiempo esperado${NC}"
    exit 1
fi

# Mostrar información final
echo -e "\n${BLUE}--- Configuración ---${NC}"
docker compose logs kafka 2>/dev/null | grep -i "advertised.listeners" | tail -5

echo -e "\n${BLUE}=========================================${NC}"
echo -e "${GREEN}✅ LISTO${NC}"
echo -e "${BLUE}=========================================${NC}"
echo -e "${YELLOW}📊 Kafka UI:${NC}      http://localhost:8080"
echo -e "${YELLOW}🔌 Conexión externa:${NC} $HOST_IP:29092"
echo -e "${BLUE}=========================================${NC}"

