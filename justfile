# Default recipe: list available commands
default:
    @just --list

# ─── Setup ────────────────────────────────────────────────────────────

# Full project setup from scratch
setup: services-up install db-setup
    @echo "Setup complete!"

# Install Ruby dependencies
install:
    bundle install

# ─── Services (Docker Compose) ───────────────────────────────────────

# Start all infrastructure services
services-up:
    docker compose up -d

# Stop all infrastructure services
services-down:
    docker compose down

# Restart all infrastructure services
services-restart:
    docker compose restart

# Show infrastructure services status
services-status:
    docker compose ps

# View services logs (follow mode)
services-logs *args='':
    docker compose logs -f {{ args }}

# Remove services and their volumes (destructive)
services-nuke:
    docker compose down -v

# ─── Database ─────────────────────────────────────────────────────────

# Create, migrate, and seed the database
db-setup:
    bin/rails db:setup

# Run pending migrations
db-migrate:
    bin/rails db:migrate

# Rollback last migration
db-rollback *args='':
    bin/rails db:rollback {{ args }}

# Reset database (drop, create, migrate, seed)
db-reset:
    bin/rails db:reset

# Open PostgreSQL console
db-console:
    bin/rails dbconsole

# ─── Server ───────────────────────────────────────────────────────────

# Start Rails server
server:
    bin/rails server

# Start Rails console
console:
    bin/rails console

# ─── Background Jobs ─────────────────────────────────────────────────

# Start Sidekiq worker
sidekiq:
    bundle exec sidekiq

# ─── Tests ────────────────────────────────────────────────────────────

# Run the full test suite
test *args='':
    bundle exec rspec {{ args }}

# Run only previously failed tests
test-failures:
    bundle exec rspec --only-failures

# ─── Redis ────────────────────────────────────────────────────────────

# Open Redis CLI
redis-cli:
    docker compose exec redis redis-cli

# Flush Redis cache (current database)
redis-flush:
    docker compose exec redis redis-cli FLUSHDB
