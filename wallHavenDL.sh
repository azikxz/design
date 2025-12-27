#! /usr/bin/env bash

usage() {
    echo "Использование: $0 -f файл_со_ссылками"
    exit 1
}

while getopts ":f:" opt; do
    case "$opt" in
        f) INPUT_FILE="$OPTARG" ;;
        *) usage ;;
    esac
done

[[ -z "$INPUT_FILE" ]] && usage
[[ ! -f "$INPUT_FILE" ]] && { echo "Файл не найден: $INPUT_FILE"; exit 1; }

while read -r url custom_name; do
    [[ -z "$url" || "$url" =~ ^# ]] && continue

    if [[ -n "$custom_name" ]]; then
        ext="${url##*.}"
        filename="${custom_name}.${ext}"
    else
        filename="${url##*/}"
    fi

    echo "Скачиваю: $url -> $filename"
    curl -L --fail -o "$filename" "$url"

done < "$INPUT_FILE"
