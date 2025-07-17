#!/bin/bash

# Airflow 启动脚本
# 作者: Auto-generated
# 描述: 启动 Airflow 服务

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

print_info "开始启动 Airflow 服务..."

# 设置 AIRFLOW_UID 环境变量（如果未设置）
if [ -z "$AIRFLOW_UID" ]; then
    export AIRFLOW_UID=$(id -u)
    print_info "设置 AIRFLOW_UID=$AIRFLOW_UID"
fi

# 创建必要的目录
print_info "创建必要的目录..."
mkdir -p logs dags plugins

# 设置目录权限
print_info "设置目录权限..."
chmod -R 777 logs dags plugins 2>/dev/null || print_warning "无法设置目录权限，可能需要 sudo"

# 检查 Docker 是否运行
if ! docker info >/dev/null 2>&1; then
    print_error "Docker 未运行，请先启动 Docker"
    exit 1
fi

# 停止可能存在的旧容器
print_info "停止可能存在的旧容器..."
docker compose -f docker-compose.yaml down 2>/dev/null || true

# 启动服务
print_info "启动 Airflow 服务..."
docker compose -f docker-compose.yaml up -d

# 等待服务启动
print_info "等待服务启动..."
sleep 10

# 检查服务状态
print_info "检查服务状态..."
docker compose -f docker-compose.yaml ps

print_success "Airflow 服务启动完成！"
print_info "Web UI 地址: http://localhost:9090"
print_info "默认登录凭据: airflow / airflow"
print_info "Flower 监控地址: http://localhost:5555"
print_info ""
print_info "查看日志: docker compose -f docker-compose.yaml logs -f"
print_info "停止服务: ./bin/stop.sh" 