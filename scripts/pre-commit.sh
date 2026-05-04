#!/bin/bash

set -euo pipefail

#
staged_files=$(git diff --name-only --staged)

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
  #
  # Extract version from stated Chart.yaml
  version_staged=$(cat "${chart_yaml}" | awk -F': ' '/^version:/ { print $2; exit }' | tr -d '[:space:]')
  #
  # Check if versions are even different
  if [[ "${version_head}" == "${version_staged}" ]]; then
    echo "ERROR: You forgot to bump the '${chart_yaml}' Chart-Version!"
    exit 1
  fi
  #
  # Check if staged-version is bigger
  # Split versions in `Major.Minor.Patch`
  # e.g.: 1.2.3
  IFS='.' read -r major_staged minor_staged patch_staged <<< "${version_staged}"
  IFS='.' read -r major_head minor_head patch_head <<< "${version_head}"
  #
  # Whether the staged major/minor version is smaller than the HEAD-one
  if [[ $major_staged -lt $major_head ]]; then
    echo "ERROR: Decremented Major Chart-Version at '${chart_yaml}'!"
    exit 1
  else if [[ "${major_staged}" == "${major_head}" ]] && [[ $minor_staged -lt $minor_head ]]; then
    echo "ERROR: Decremented Minor Chart-Version at '${chart_yaml}'!"
    exit 1
  fi
  fi
  #
  # Get staged pre-release version - if it exists
  pre_release_staged=""
  patch_patch_staged=${patch_staged%%[-+]*}
  pre_release_suffix_staged=${patch_staged#"${patch_patch_staged}"}
  if [[ "${pre_release_suffix_staged}" == -* ]]; then
    #
    # Remove "+" from suffix (e.g.: '+build')
    pre_release_staged=${pre_release_suffix_staged%%+*}
    #
    # Remove "-" from suffix (e.g.: '-alpha')
    pre_release_staged=${pre_release_suffix_staged#-}
  fi
  #
  # Get HEAD pre-release version - if it exists
  pre_release_head=""
  patch_patch_head=${patch_head%%[-+]*}
  pre_release_suffix_head=${patch_staged#"${patch_patch_head}"}
  if [[ "${pre_release_suffix_head}" == -* ]]; then
    #
    # Remove "+" from suffix (e.g.: '+build')
    pre_release_head=${pre_release_suffix_head%%+*}
    #
    # Remove "-" from suffix (e.g.: '-alpha')
    pre_release_head=${pre_release_suffix_head#-}
  fi
  #
  # Whether staged-version is a pre-release, but head-version not
  # It's possible that the HEAD-Version isn't a pre-release and the
  # staged now is.
  # e.g.: HEAD=1.0.0 and STAGED=2.0.0-alpha
  # But this is invalid: HEAD=1.0.0 and STAGED=1.0.0-alpha
  if [[ "${pre_release_staged}" ]] && [[ ! "${pre_release_head}" ]]; then
    #
    # Whether its major, minor or patch isn't incremented
    if [[ $major_staged -eq $major_head ]] && [[ $minor_staged -eq $minor_head ]] && [[ $patch_patch_staged -eq $patch_patch_head ]]; then
      echo "ERROR: You forgot to version bump '${chart_yaml}'!"
      exit 1
    fi
  fi
  #
  # Whether staged-version is not a pre-release, but head-version is.
  # e.g.: HEAD=1.0.0-alpha and STAGED=1.0.0
  # But this is invalid: HEAD=1.0.0-alpha
  # TODO?
  #
  # Compare pre-release-versions of staged and HEAD if exists
  # TODO
  #if [[ "${pre_release_staged}" && "${pre_release_head}" ]]; then
  #  alpha_build_version_staged=${BASH_REMATCH[0]}
  #  IDF='.' read -r _ alpha_build_version_head <<< "${pre_release_head}"
  #  echo "alpha_build_version_head=${alpha_build_version_head} alpha_build_version_staged=${alpha_build_version_staged}"
  #fi
done

echo "INFO: Checked ${#checked_charts[@]} chart(s)"

if [[ $fail -ne 0 ]]; then
  echo ""
  echo "Commit aborted: please bump Chart.yaml version(s) for modified chart(s)."
  exit 1
fi

exit 0
