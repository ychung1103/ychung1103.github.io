#!/bin/bash
# test-encoding-detection.sh
# 测试 HTML 编码提取逻辑

# 提取编码的函数（完全复制你的逻辑）
extract_encoding() {
    local file="$1"
    local encoding=""
    
    # Method 1: 从 HTML 文件中提取 charset
    encoding=$(head -n 50 "$file" 2>/dev/null | grep -iE 'charset\s*=\s*["'']?[^"'';>]+' | head -1 | sed -E 's/.*charset\s*=\s*["'']?([^"'';>]+).*/\1/i' | tr '[:upper:]' '[:lower:]')
    echo "M1 applied"

    # Method 2: 如果没找到，尝试从 <meta> 标签中提取（更精确）
    if [ -z "$encoding" ]; then
        encoding=$(head -n 50 "$file" 2>/dev/null | grep -i '<meta' | grep -i 'charset' | head -1 | sed -E 's/.*charset\s*=\s*["'']?([^"'';>]+).*/\1/i' | tr '[:upper:]' '[:lower:]')
        echo "M2 applied"
    fi
    
    # Method 3: 如果还是没找到，尝试用 file 命令作为备选
    if [ -z "$encoding" ]; then
        encoding=$(file -i "$file" 2>/dev/null | awk -F'charset=' '{print $2}')
    fi
    
    echo "$encoding"
}

# 测试单个文件
test_file() {
    local file="$1"
    
    if [ ! -f "$file" ]; then
        echo "❌ File not found: $file"
        return 1
    fi
    
    # 提取编码
    local encoding=$(extract_encoding "$file")
    
    # 检查文件是否包含 charset 声明（用于参考）
    local has_declaration=$(head -n 50 "$file" 2>/dev/null | grep -i 'charset' | wc -l)
    
    # 显示结果
    if [ -n "$encoding" ]; then
        echo "✅ $file -> $encoding"
        # 如果文件有声明但提取成功，显示 OK
        if [ $has_declaration -gt 0 ]; then
            echo "   └─ Has charset declaration ✓"
        else
            echo "   └─ No charset declaration, detected by file command"
        fi
        return 0
    else
        if [ $has_declaration -gt 0 ]; then
            echo "⚠️  $file -> Has charset but extraction failed!"
            echo "   └─ Showing context:"
            head -n 50 "$file" | grep -i 'charset' | head -3 | sed 's/^/      /'
        else
            echo "ℹ️  $file -> No charset declaration found"
        fi
        return 1
    fi
}

# 显示使用说明
show_usage() {
    cat << EOF
Usage: $0 [OPTIONS] [DIRECTORY or FILE]

Options:
    -h, --help      显示此帮助信息
    -v, --verbose   显示详细信息
    -r, --recursive 递归查找子目录

Examples:
    $0 ./test.html              # 测试单个文件
    $0 ./html-files/            # 测试目录下所有 .htm .html 文件
    $0 -r ./                    # 递归测试当前目录及子目录
    $0 -v ./html-files/         # 详细模式
EOF
}

# 主函数
main() {
    local target="."
    local verbose=false
    local recursive=false
    
    # 解析命令行参数
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_usage
                exit 0
                ;;
            -v|--verbose)
                verbose=true
                shift
                ;;
            -r|--recursive)
                recursive=true
                shift
                ;;
            *)
                target="$1"
                shift
                ;;
        esac
    done
    
    # 检查目标是否存在
    if [ ! -e "$target" ]; then
        echo "❌ Error: $target does not exist"
        exit 1
    fi
    
    echo "=========================================="
    echo "HTML Encoding Detection Test"
    echo "=========================================="
    echo "Target: $target"
    echo "Recursive: $recursive"
    echo "=========================================="
    echo
    
    # 统计变量
    local total=0
    local success=0
    local failed=0
    
    # 生成文件列表
    local file_list=()
    
    if [ -f "$target" ]; then
        # 单个文件
        file_list=("$target")
    elif [ -d "$target" ]; then
        # 目录
        if [ "$recursive" = true ]; then
            while IFS= read -r file; do
                file_list+=("$file")
            done < <(find "$target" -type f \( -name "*.htm" -o -name "*.html" \) | sort)
        else
            while IFS= read -r file; do
                file_list+=("$file")
            done < <(find "$target" -maxdepth 1 -type f \( -name "*.htm" -o -name "*.html" \) | sort)
        fi
    fi
    
    # 检查是否有文件
    if [ ${#file_list[@]} -eq 0 ]; then
        echo "⚠️  No HTML files found in: $target"
        exit 0
    fi
    
    echo "Found ${#file_list[@]} HTML files"
    echo
    
    # 测试每个文件
    for file in "${file_list[@]}"; do
        if [ "$verbose" = true ]; then
            echo "--- Testing: $file ---"
            # 显示文件前几行（包含 charset 的部分）
            echo "File preview (lines with charset):"
            head -n 50 "$file" | grep -i 'charset' | head -5 | sed 's/^/  /'
            echo "Extraction result:"
        fi
        
        test_file "$file"
        
        if [ $? -eq 0 ]; then
            success=$((success + 1))
        else
            failed=$((failed + 1))
        fi
        total=$((total + 1))
        echo
    done
    
    # 显示统计
    echo "=========================================="
    echo "Summary:"
    echo "  Total files:  $total"
    echo "  ✅ Success:   $success"
    echo "  ❌ Failed:    $failed"
    if [ $total -gt 0 ]; then
        local rate=$((success * 100 / total))
        echo "  Success rate: $rate%"
    fi
    echo "=========================================="
}

# 执行主函数
main "$@"