#!/bin/bash

# Airflow 重启脚本
# 作者: Auto-generated
# 描述: 重启 Airflow 服务

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

print_info "开始重启 Airflow 服务..."

# 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

# 切换到项目目录
cd "$PROJECT_DIR"

# 停止服务
print_info "停止现有服务..."
./bin/stop.sh

# 等待一下
sleep 3

# 启动服务
print_info "重新启动服务..."
./bin/start.sh

print_success "Airflow 服务重启完成！" 