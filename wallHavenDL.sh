#!/usr/bin/env bash

cmd="wget -cq --show-progress --limit-rate=10M --timeout=5 --tries=3"

# Генерация следующего доступного имени файла
get_next_filename_any_ext() {
  base="$1"
  ext="$2"
  max=0

  for f in ${base}*.*; do
    [[ -e "$f" ]] || continue

    f_ext="${f##*.}"
    [[ "$f_ext" =~ ^(png|jpg|jpeg)$ ]] || continue

    num=$(echo "$f" | sed -E "s/^${base}([0-9]*)\.$f_ext$/\1/")
    [[ "$num" =~ ^[0-9]*$ ]] || continue
    [[ -z "$num" ]] && num=0
    (( num > max )) && max=$num
  done

  next=$((max + 1))

  if [[ "$max" -eq 0 && ! -e "${base}.${ext}" ]]; then
    echo "${base}.${ext}"
  else
    echo "${base}${next}.${ext}"
  fi
}

# Определение расширения по URL
get_ext_from_url() {
  case "$1" in
    *.png)  echo "png" ;;
    *.jpg)  echo "jpg" ;;
    *.jpeg) echo "jpeg" ;;
    *) echo "" ;;
  esac
}

# Загрузка одного изображения
download_one() {
  local url="$1"
  local src="$2"

  # Удаление возможного префикса ./
  src="${src#./}"

  local base ext out

  if [[ "$src" =~ \.(png|jpe?g)$ ]]; then
    base="${src%.*}"
    ext="${src##*.}"
  else
    ext=$(get_ext_from_url "$url")
    [[ -z "$ext" ]] && echo "❌ Unsupported file extension in URL: $url" && return
    base="$src"
  fi

  out=$(get_next_filename_any_ext "$base" "$ext")
  $cmd "$url" -O "$out"
}

# Основная логика
if [[ "$1" == "-f" || "$1" == "--file" ]]; then
  listfile="$2"
  [[ ! -f "$listfile" ]] && echo "❌ File not found: $listfile" && exit 1

  while read -r url name; do
    [[ -z "$url" || -z "$name" ]] && continue
    download_one "$url" "$name"
  done < "$listfile"
else
  url="$1"
  src="$2"
  [[ -z "$url" || -z "$src" ]] && echo "❌ Invalid arguments" && exit 1
  download_one "$url" "$src"
fi
