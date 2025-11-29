#!/bin/bash

set -euo pipefail

function build_runner() {
	local dir=$1
	pushd "$dir" || return 1

	echo "Running build_runner to update generated files..."
	if dart run build_runner build --delete-conflicting-outputs; then
		echo "build_runner completed successfully."
	else
		echo "build_runner failed." >&2
		popd >/dev/null || return 1
		return 1
	fi
	popd >/dev/null || return 1

	return 0
}

function update_goldens() {
	local dir=$1
	pushd "$dir" || return 1

	echo "Updating golden files..."
	SOURCE_GEN_TEST_UPDATE_GOLDENS=1 dart test
	echo "Golden files updated."
	popd >/dev/null || return 1

	return 0
}

function main() {
	build_runner "packages/theme_extensions_builder" || {
		echo "Failed to run build_runner."
		return 1
	}

	update_goldens "packages/theme_extensions_builder" || {
		echo "Failed to update golden files."
		return 1
	}
}

main
