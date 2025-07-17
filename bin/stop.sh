#!/bin/bash

# Airflow 停止脚本
# 作者: Auto-generated
# 描述: 停止 Airflow 服务

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 打印带颜色的消息
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 检查是否在正确的目录
if [ ! -f "docker-compose.yaml" ]; then
    print_error "请在包含 docker-compose.yaml 的目录中运行此脚本"
    exit 1
fi

print_info "开始停止 Airflow 服务..."

# 检查 Docker 是否运行
if ! docker info >/dev/null 2>&1; then
    print_error "Docker 未运行"
    exit 1
fi

# 停止服务
print_info "停止 Airflow 容器..."
docker compose -f docker-compose.yaml down

# 检查是否要清理数据
if [ "$1" = "--clean" ] || [ "$1" = "-c" ]; then
    print_warning "清理所有数据（包括数据库）..."
    docker compose -f docker-compose.yaml down -v
    print_info "数据已清理"
fi

print_success "Airflow 服务已停止！"
print_info ""
print_info "重新启动服务: ./bin/start.sh" 