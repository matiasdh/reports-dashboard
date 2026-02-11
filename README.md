# Reports Dashboard

## Requirements

- Ruby 3.4.1
- PostgreSQL 17
- Redis 7
- [direnv](https://direnv.net/)

## Setup

### 1. Start services

```bash
docker compose up -d
```

This starts PostgreSQL (port 5432) and Redis (port 6379).

### 2. Environment variables

```bash
cp .envrc.sample .envrc
direnv allow
```

Edit `.envrc` if you need to customize any values.

### 3. Database

```bash
bin/rails db:setup
```

### 4. Run the app

```bash
bin/rails server
```

### 5. Background jobs (Sidekiq)

```bash
bundle exec sidekiq
```

## Services

| Service    | Purpose                          | Default URL                  |
|------------|----------------------------------|------------------------------|
| PostgreSQL | Database                         | localhost:5432               |
| Redis      | Cache, Action Cable, Sidekiq     | redis://localhost:6379/0     |
| Sidekiq    | Background job processing        | http://localhost:3000/sidekiq (if mounted) |
