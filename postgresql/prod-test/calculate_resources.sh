#!/bin/bash

# 设置命名空间
NAMESPACE="prod-old"

# 获取所有 Deployments 的资源请求信息，并保存到文件
kubectl get deploy -n $NAMESPACE -o=jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.spec.template.spec.containers[*].resources.requests.cpu}{"\t"}{.spec.template.spec.containers[*].resources.requests.memory}{"\n"}{end}' > deploy_resources.txt

# 计算总 CPU 和内存请求
awk -F'\t' '
{
    for (i=2; i<=NF; i+=2) {
        # 处理 CPU 请求，转换成核心数
        split($i, cpu, "m");
        total_cpu += cpu[1]/1000;
    }
    for (j=3; j<=NF; j+=2) {
        # 处理内存请求，转换成 KiB
        gsub(/Mi/, "*1024", $j);
        gsub(/Gi/, "*1024*1024", $j);
        total_mem += eval($j);
    }
}
function eval(expr) {
    num = expr;
    if (expr ~ /[*]/) {
        split(expr, parts, /[*]/);
        num = parts[1];
        for (k = 2; k in parts; k++) {
            num *= parts[k];
        }
    }
    return num;
}
END {printf "Total CPU: %f cores\nTotal Memory: %.3f Gi\n", total_cpu, total_mem / 1024 / 1024}
' deploy_resources.txt

