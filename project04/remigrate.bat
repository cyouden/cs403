del wine04.db
copy wine04.create_schema.db wine04.db
ruby migrate.rb
sqlite3 wine04.db