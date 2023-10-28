#!/bin/bash

kahn() {
    local graph=$1
    local n=$2
    declare -A inverse
    for u in ${!graph[@]}; do
        for v in ${graph[$u]}; do
            inverse[$v]="${inverse[$v]} $u"
        done
    done

    local stack=()
    for ((v = 0; v < n; v++)); do
        if [[ -z ${inverse[$v]} ]]; then
            stack+=("$v")
        fi
    done

    local order=()
    while [[ ${#stack[@]} -gt 0 ]]; do
        local u=${stack[-1]}
        unset 'stack[-1]'
        order+=("$u")
        for v in ${graph[$u]}; do
            graph[$u]=("${graph[$u]/$v}")
            inverse[$v]=("${inverse[$v]/$u}")
            if [[ -z ${inverse[$v]} ]]; then
                stack+=("$v")
            fi
        done
    done

    if [[ ${#order[@]} -ne $n ]]; then
        echo "Cyclic graph"
    else
        echo "${order[@]}"
    fi
}

input_file="input.txt"
output_file="output.txt"

t=0
while IFS= read -r line; do
    if [[ $t -eq 0 ]]; then
        t=$line
    else
        n=$line
        declare -A graph

        while IFS= read -r line; do
            if [[ -n $line ]]; then
                read -r u v <<< "$line"
                graph["$u"]="${graph["$u"]} $v"
            else
                output=$(kahn graph n)
                if [[ $output == "Cyclic graph" ]]; then
                    echo "Cyclic graph" >> "$output_file"
                else
                    echo "$output" >> "$output_file"
                fi
                break
            fi
        done < "$input_file"
    fi
done < "$input_file"
