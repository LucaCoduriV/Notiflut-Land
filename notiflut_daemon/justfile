# @mason: flutter_rust_bridge

# When 'just' is called with no arguments,
# these recipes are run by default.

default: check lint

# Add new recipes to these meta-recipes as you add new modules.

lint: lint_native
clean: clean_native
    flutter clean
check: check_native
    flutter analyze

alias c := check
alias l := lint


# Recipes for native

lint_native:
    cd native && cargo fmt
    cd native && dart format --line-length 80
clean_native:
    cd native && cargo clean
check_native:
    cd native && cargo check
