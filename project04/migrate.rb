require 'sqlite3'
require 'set'

query_wines_tmp = "SELECT * FROM wines_tmp;"

select_queries = Hash[
  "countries"        => "SELECT country_name FROM wines_tmp;",
  "regions"          => "SELECT country_name, region_name FROM wines_tmp", 
  "wineries"         => "INSERT INTO wineries (name) VALUES (?);",
  "vineyards"        => "INSERT INTO vineyeards (name, winery_id, region_id) VALUES (?, SELECT id FROM wineries WHERE name=?, SELECT id FROM region WHERE name=?);",
  "grapes"           => "INSERT INTO grapes (name) VALUES (?);", 
  "grapes_vineyards" => "INSERT INTO grapes_vineyards (grape_id, vineyard_id) VALUES (SELECT id FROM grapes WHERE name=?, SELECT id FROM vineyards WHERE name=?);",
  "wines"            => "INSERT INTO wines (name, purchase_date, drunk_date, rating, comment, price, vintage, winery_id) VALUES (?, ?, ?, ?, ?, ?, ?, SELECT id FROM wineries WHERE name=?); ",
  "grapes_wines"     => "INSERT INTO grapes_wines (grape_id, wine_id) VALUES (SELECT id FROM grapes WHERE name=?, SELECT id FROM wines WHERE name=?);"
]

insert_queries = Hash[
  "countries"        => "INSERT INTO countries (name) VALUES (?);",
  "regions"          => "INSERT INTO regions (name, country_id) VALUES (?, (SELECT id FROM countries WHERE name=?));", 
  "wineries"         => "INSERT INTO wineries (name) VALUES (?);",
  "vineyards"        => "INSERT INTO vineyeards (name, winery_id, region_id) VALUES (?, SELECT id FROM wineries WHERE name=?, SELECT id FROM region WHERE name=?);",
  "grapes"           => "INSERT INTO grapes (name) VALUES (?);", 
  "grapes_vineyards" => "INSERT INTO grapes_vineyards (grape_id, vineyard_id) VALUES (SELECT id FROM grapes WHERE name=?, SELECT id FROM vineyards WHERE name=?);",
  "wines"            => "INSERT INTO wines (name, purchase_date, drunk_date, rating, comment, price, vintage, winery_id) VALUES (?, ?, ?, ?, ?, ?, ?, SELECT id FROM wineries WHERE name=?); ",
  "grapes_wines"     => "INSERT INTO grapes_wines (grape_id, wine_id) VALUES (SELECT id FROM grapes WHERE name=?, SELECT id FROM wines WHERE name=?);"
]

db = SQLite3::Database.new("wine04.db")
db.results_as_hash = true

# General pattern: add results to sets to remove duplicates, add sets to database

countries_query_result = db.execute(select_queries["countries"])

countries_set = Set[];

countries_query_result.each do |row|
  countries_set.add(row["country_name"])
end
  
countries_set.each do |item|
  db.execute(insert_queries["countries"], item);
end

regions_query_result = db.execute(select_queries["regions"])

regions_set = Set[];

regions_query_result.each do |row|
  regions_set.add("#{row["region_name"]}|#{row["country_name"]}")
end

regions_set.each do |item|
  split = item.split("|")
  if not split[0].empty? 
    db.execute(insert_queries["regions"], split[0], split[1])
  end
end
  
db.close()