default:
    @just --list

# Ping all servers as root to test connectivity
ping:
    uv run ansible all -m ping -u root