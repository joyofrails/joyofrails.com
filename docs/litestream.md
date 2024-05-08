# Litestream

Litestream is a tool for replicating and restoring SQLite databases to and from S3-compatible storage services.

https://litestream.io/

joyofrails.com uses litestream in production. Integration is supported by the [litestream-ruby](https://github.com/fractaledmind/litestream-ruby) gem.

## Configuration

Litestream expects to use a YAML config file to determine what database files to use and which S3 bucket(s) with which to connect.

joyofrails.com dynamically generates environment specific config files, e.g. `config/litestream/production.yml` in the format Litestream expects.

## Replication

The Litestream replication task is run via a bin script as a separate process alongside the rails server in production.

```
# on production server
bin/litestream replicate --config=config/litestream/production.yml
```

## Restoration

We can restore the production database on production with the restore command for a particular database file, e.g. for the primary data store:

```
# on production server
bin/litestream restore --config=config/litestream/production.yml storage/production/data.sqlite3
```
