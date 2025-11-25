#!/bin/bash

set -euo pipefail

# Color codes
readonly COLOR_BLUE="\033[1;34m"
readonly COLOR_GREEN="\033[1;32m"
readonly COLOR_RED="\033[1;31m"
readonly COLOR_YELLOW="\033[1;33m"
readonly COLOR_CYAN="\033[1;36m"
readonly COLOR_RESET="\033[0m"
readonly STYLE_BOLD="\033[1m"

# Root directory of the project
readonly PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

function log() {
	echo -e "${COLOR_CYAN} • ${COLOR_RESET} $1"
}

function log_info() {
	local title=$1
	local message=${2:-""}
	echo ""
	echo -e "[${STYLE_BOLD}${COLOR_CYAN}$title]${COLOR_RESET} $message"
	echo ""
}

function line() {
	local length=$1
	local line_char=${2:-"-"}
	local line=$(printf '%*s' "$length" '' | tr ' ' "$line_char")
	echo -e "${COLOR_BLUE}${line}${COLOR_RESET}"
}

function log_success() {
	echo -e "${COLOR_GREEN}[✓]${COLOR_RESET} $1"
}

function log_error() {
	echo -e "${COLOR_RED}[✗]${COLOR_RESET} $1" >&2
}

function log_warning() {
	echo -e "${COLOR_YELLOW}[!]${COLOR_RESET} $1"
}

function pub_update() {
	local package_path=$1
	log "Running 'dart pub update' in $package_path"
	if dart pub update --directory "$package_path"; then
		log_success "pub update completed for $package_path"
		return 0
	else
		log_error "pub update failed for $package_path"
		return 1
	fi
}

function dart_format() {
	local package_path=$1
	log "Running 'dart format' in $package_path"
	if dart format "$package_path" --set-exit-if-changed; then
		log_success "No formatting changes needed for $package_path"
		return 0
	else
		log_warning "Files were formatted in $package_path"
		return 0
	fi
}

function dart_analyze() {
	local package_path=$1
	log "Running 'dart analyze' in $package_path"
	if dart analyze --fatal-infos "$package_path"; then
		log_success "Analysis passed for $package_path"
		return 0
	else
		log_error "Analysis failed for $package_path"
		return 1
	fi
}

function dart_test() {
	local package_path=$1
	log "Running 'dart test' in $package_path"

	# Check if test directory exists
	if [[ ! -d "$package_path/test" ]]; then
		log_warning "No test directory found in $package_path, skipping tests"
		return 0
	fi

	if (cd "$package_path" && dart test -r expanded); then
		log_success "Tests passed for $package_path"
		return 0
	else
		log_error "Tests failed for $package_path"
		return 1
	fi
}

function build_runner() {
	local package_path=$1

	if ! grep -q "build_runner" "$package_path/pubspec.yaml"; then
		log "No build_runner dependency found in $package_path, skipping build_runner step"
		return 0
	fi

	log "Running 'dart run build_runner build' in $package_path"
	if (cd "$package_path" && dart run build_runner build --delete-conflicting-outputs); then
		log_success "build_runner completed for $package_path"
		return 0
	else
		log_error "build_runner failed for $package_path"
		return 1
	fi
}

function dart_fix() {
	local package_path=$1
	log "Running 'dart fix' in $package_path"
	if dart fix --apply "$package_path"; then
		log_success "dart fix completed for $package_path"
		return 0
	else
		log_error "dart fix failed for $package_path"
		return 1
	fi
}

function process_package() {
	local dir=$1
	local package_name=$(basename "$dir")

	log_info "Processing package:" "$package_name"


	local steps=(
		"pub_update"
		"dart_format"
		"dart_fix"
		"dart_analyze"
		"dart_test"
		"build_runner"
	)

	for step in "${steps[@]}"; do
		if ! $step "$dir"; then
			log_error "Failed at step '$step' for $package_name"
			return 1
		fi
	done

	log_success "All checks passed for $package_name"
	return 0
}

function main() {
	log "Preparing for push..."
	log "Project root: $PROJECT_ROOT"

	cd "$PROJECT_ROOT"

	local dirs=(
		"packages/theme_extensions_builder"
		"packages/theme_extensions_builder_annotation"
	)

	local failed_packages=()

	for dir in "${dirs[@]}"; do
		if [[ ! -d "$dir" ]]; then
			log_error "Directory not found: $dir"
			failed_packages+=("$dir")
			continue
		fi

		if ! process_package "$dir"; then
			failed_packages+=("$dir")
		fi
	done

	echo ""

	if [[ ${#failed_packages[@]} -eq 0 ]]; then
		log_success "All packages processed successfully! Ready to push."
		return 0
	else
		log_error "Failed to process ${#failed_packages[@]} package(s):"
		for pkg in "${failed_packages[@]}"; do
			log_error "  - $pkg"
		done
		return 1
	fi
}

main "$@"
