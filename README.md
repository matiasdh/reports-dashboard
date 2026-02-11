# Reports Dashboard

## Requirements

- Ruby 3.4.1
- PostgreSQL 17
- Redis 7
- [direnv](https://direnv.net/)
- [just](https://github.com/casey/just)

## Setup

### 1. Environment variables

```bash
cp .envrc.sample .envrc
```

Add your `RAILS_MASTER_KEY` to `.envrc` (provided separately by the project owner).

```bash
direnv allow
```

### 2. Full setup (services + dependencies + database)

```bash
just setup
```

This runs `docker compose up -d`, `bundle install`, and `rails db:setup`.

### 3. Run the app

```bash
just server
```

### 4. Background jobs

```bash
just sidekiq
```

## Available commands

Run `just` to see all available recipes:

```
just                   # List all commands
just setup             # Full project setup from scratch
just services-up       # Start infrastructure (PostgreSQL + Redis)
just services-down     # Stop infrastructure
just services-status   # Show services status
just services-logs     # Follow services logs
just services-nuke     # Remove services and volumes (destructive)
just db-setup          # Create, migrate, and seed
just db-migrate        # Run pending migrations
just db-rollback       # Rollback last migration
just db-reset          # Drop, create, migrate, seed
just db-console        # Open PostgreSQL console
just server            # Start Rails server
just console           # Start Rails console
just sidekiq           # Start Sidekiq worker
just test              # Run test suite (RSpec)
just test-failures     # Re-run only failed tests
just lint              # Run RuboCop linter
just lint-fix          # Run RuboCop with auto-correct
just security          # Run Brakeman security scanner
just ci                # Run all checks locally (lint + security + tests)
just redis-cli         # Open Redis CLI
just redis-flush       # Flush Redis cache
```

## Report Data

Report data is fetched via `ReportData::Reports.fetch(report_type)`. The current implementation uses **mocked classes** (Faker-generated data) under `app/services/report_data/reports/`. These can be swapped for real implementations (e.g. database queries, external APIs) without changing the caller. Just replace the fetcher classes behind the same interface.

**Report types:** `daily_sales`, `monthly_summary`, `inventory_snapshot`

**Monetary values:** All prices and totals are returned as **integers in cents** (e.g. the last two digits are the cents part, so `1299` = $12.99). The system assumes a single currency (**USD**). This format is compatible with the [money-rails](https://github.com/RubyMoney/money-rails) gem if we need it.

## Design Trade-offs

- **Report uniqueness constraint:** The auto-generated `code` field (`REPORT_TYPE-YYYYMMDD-USERID`) inherently encodes the user, report type, and date. A single unique index on `code` is sufficient to enforce the one-report-per-type-per-user-per-day rule, avoiding the need for a multi-column composite index.

- **User deletion and report retention:** Currently `has_many :reports, dependent: :destroy` is used for simplicity. In production, users should not be hard-deleted since their reports need to be preserved. A soft-delete approach using `paranoia` (`with_deleted` scope) would allow deactivating users while keeping their reports intact.

- **Integer enums vs PostgreSQL native enums:** Report `status` and `report_type` use Rails integer-backed enums instead of PostgreSQL native enum types. PG enums are self-documenting at the DB level and provide type safety, but require migrations to add or modify values. For the simplicity of this project, integer-backed enums are the right choice. They are easy to evolve, well-supported by Rails, and adding a new report type is a one-line change in the model with no migration needed.

## Services

| Service    | Purpose                      | Default URL              |
|------------|------------------------------|--------------------------|
| PostgreSQL | Database                     | localhost:5432           |
| Redis      | Cache, Action Cable, Sidekiq | redis://localhost:6379/0 |
