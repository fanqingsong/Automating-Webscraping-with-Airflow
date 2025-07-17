#!/bin/bash

# Airflow 状态查看脚本
# 作者: Auto-generated
# 描述: 查看 Airflow 服务状态

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

print_info "Airflow 服务状态："
echo ""

# 检查 Docker 是否运行
if ! docker info >/dev/null 2>&1; then
    print_error "Docker 未运行"
    exit 1
fi

# 显示容器状态
docker compose -f docker-compose.yaml ps

echo ""
print_info "服务访问地址："
echo "  - Airflow Web UI: http://localhost:9090"
echo "  - Flower 监控: http://localhost:5555"
echo ""
print_info "默认登录凭据: airflow / airflow"
echo ""
print_info "常用命令："
echo "  - 启动服务: ./bin/start.sh"
echo "  - 停止服务: ./bin/stop.sh"
echo "  - 重启服务: ./bin/restart.sh"
echo "  - 查看日志: docker compose -f docker-compose.yaml logs -f" 