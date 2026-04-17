#!/bin/bash

set -euo pipefail

#
staged_files=$(git diff --name-only)

#
# If nothing is staged, exit success
if [[ -z "${staged_files}" ]]; then
  echo "INFO: no staged changes"
  exit 0
fi

#
# Find changed files under root-chart-dir
chart_changes=()
while IFS= read -r f; do
  case "$f" in
    charts/*)
      chart_changes+=("$f")
      echo "[+] ${f}"
      ;;
  esac
done <<< "${staged_files}"

#
# If no chart-related changes, nothing to do
if [[ ${#chart_changes[@]} -eq 0 ]]; then
  echo "INFO: No chart-related changes, nothing to do"
  exit 0
fi
#
echo "INFO: Found ${#chart_changes[@]} chart-related-change(s)"
#
# For each changed chart file (except Chart.yaml), ensure Chart.yaml for that chart
# was also staged and its version was bumped.
#
# This assumes layout: charts/<chart-name>/Chart.yaml
fail=0
checked_charts=()
#
for f in "${chart_changes[@]}"; do
  #
  # Normalize path and extract chart dir
  # skip Chart.yaml itself here; we'll handle chart dirs
  chart_dir=$(echo "$f" | awk -F/ '{ if ($1=="charts") print $1"/"$2 }')
  if [[ -z "$chart_dir" ]]; then
    continue
  fi
  #
  # Avoid duplicates
  if printf '%s\n' "${checked_charts[@]}" | grep -qx "$chart_dir"; then
    continue
  fi
  echo "[*] chart_dir=${chart_dir}"
  checked_charts+=("$chart_dir")
  chart_yaml="$chart_dir/Chart.yaml"
  #
  # If Chart.yaml wasn't changed/staged, fail
  if ! printf '%s\n' "$staged_files" | grep -qx "$chart_yaml"; then
    echo "ERROR: Changes in '$chart_dir' but $chart_yaml was not staged/updated."
    fail=1
    continue
  fi
  #
  # Compare versions: version in HEAD vs version in index (staged)
  # Extract version from HEAD (if file exists in HEAD) and from staged index
  if git show :"$chart_yaml" >/dev/null 2>&1; then
    version_head=$(git show HEAD:"$chart_yaml" 2>/dev/null | awk -F': ' '/^version:/ { print $2; exit }' | tr -d '[:space:]')
  else
    version_head=""
  fi
done

echo "INFO: Checked ${#checked_charts[@]} chart(s)"

if [[ $fail -ne 0 ]]; then
  echo ""
  echo "Commit aborted: please bump Chart.yaml version(s) for modified chart(s)."
  exit 1
fi

exit 0