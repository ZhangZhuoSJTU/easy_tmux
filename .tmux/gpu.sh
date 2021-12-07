#!/usr/bin/env bash

print_gpu_usage() {
    gpuUsage=($(nvidia-smi -q -d UTILIZATION | grep Gpu | awk '{printf "%d\n", $3}'))
    memUsage=($(nvidia-smi | sed -nr 's/.*\s([0-9]+)MiB\s*\/\s*([0-9]+)MiB.*/\1 \2/p'  | awk -v format="%2.f\n" '{printf format, 100*$1/$2}'))
    ids=("⓪ " "① " "② " "③ " "④ " "⑤ " "⑥ " "⑦ ")

    output=""
    for index in ${!gpuUsage[*]}; do
        if [ "${gpuUsage[$index]}" != "100" ]; then
            mem=$(printf "%02d" ${memUsage[$index]})
            gpu=$(printf "%02d" ${gpuUsage[$index]})
            if [[ "$mem" < "20" && "$gpu" < "40" ]]; then
                output+=$(printf "%s " ${ids[$index]})
            fi
        fi
    done

    if [ -z "$output" ]; then
    echo "GPU: FULL "
    else
    echo "GPU: $output"
    fi
}

main() {
  print_gpu_usage
}

main
