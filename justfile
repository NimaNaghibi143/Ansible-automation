default:
    @just --list

# Ping all servers as root to test connectivity
ping:
    uv run ansible all -m ping

# List all the available hosts in the inventory
list-hosts:
    uv run ansible all --list-hosts

# Gather factos about the hosts
facts:
    uv run ansible all -m gather_facts

# Lint all Ansible files
lint:
    uv run ansible-lint

# Auto-fix fixable linting errors
lint-fix:
    uv run ansible-lint --write