#!/bin/bash

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
	update_goldens "packages/theme_extensions_builder" || {
		echo "Failed to update golden files."
		return 1
	}
}

main
