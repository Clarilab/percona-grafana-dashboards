#!/usr/bin/env sh

# This script converts all PMM dashboards to grafana dashboards.

convert_dashboard() {
    file="$1"
    orig_content=$(cat "$file")

    # Datasource replacements
    new_content=$orig_content
    new_content=$(echo "$new_content" | sed "s|\"\${DS_PTSUMMARY}\"|\"PTSummary\"|g")
    new_content=$(echo "$new_content" | sed "s|\"\${DS_CLICKHOUSE}\"|\"ClickHouse\"|g")
    new_content=$(echo "$new_content" | sed "s|\"\${DS_PROMETHEUS}\"|\"victoriametrics\"|g")
    new_content=$(echo "$new_content" | sed "s|\"\${DS_METRICS}\"|\"victoriametrics\"|g")
    new_content=$(echo "$new_content" | sed 's|"Prometheus"|"victoriametrics"|g')
    new_content=$(echo "$new_content" | sed 's|"Metrics"|"victoriametrics"|g')

    echo "$new_content" > "$2"
}

find ./dashboards -name "*.json" -type f | while read -r old; do
    new="./dashboards-grafana${old#./dashboards}"
    mkdir -p "$(dirname "$new")"

    echo --- CONVERTING FROM "$old" TO "$new" ---
    convert_dashboard "$old" "$new" || echo "Failed to convert"
done
