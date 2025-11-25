#!/bin/bash

set -euo pipefail

function log() {
	echo -e "\033[1;34m[prepare_push]\033[0m $1"
}

function pub_update() {
	local package_path=$1
	log "Running 'dart pub update' in $package_path"
	dart pub update --directory "$package_path"
}

function dart_format() {
    local package_path=$1
    log "Running 'dart format' in $package_path"
    dart format "$package_path"
}

function dart_analyze() {
    local package_path=$1
    log "Running 'dart analyze' in $package_path."
    dart analyze --no-fatal-warnings "$package_path"
}

function dart_test() {
    local package_path=$1
    log "Running 'dart test' in $package_path"
    pushd "$package_path"
    dart test -r expanded
    popd
}

function main() {
	log "Preparing for push..."
	pub_update packages/theme_extensions_builder
    dart_format packages/theme_extensions_builder
    dart_analyze packages/theme_extensions_builder
    dart_test packages/theme_extensions_builder

    pub_update packages/theme_extensions_builder_annotation
	dart_format packages/theme_extensions_builder_annotation
    dart_analyze packages/theme_extensions_builder_annotation
    dart_test packages/theme_extensions_builder_annotation
	log "Done."
    
}

main $@
