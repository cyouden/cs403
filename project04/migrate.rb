require 'sqlite3'
require 'set'

query_wines_tmp = "SELECT * FROM wines_tmp;"

insert_queries = Hash[
  "countries"        => "INSERT INTO countries (name) VALUES (?);",
  "regions"          => "INSERT INTO regions (name, country_id) VALUES (?, (SELECT id FROM countries WHERE name=?));", 
  "wineries"         => "INSERT INTO wineries (name) VALUES (?);",
  "vineyards"        => "INSERT INTO vineyards (name, winery_id, region_id) VALUES (?, (SELECT id FROM wineries WHERE name=?), (SELECT id FROM regions WHERE name=?));",
  "grapes"           => "INSERT INTO grapes (name) VALUES (?);", 
  "grapes_vineyards" => "INSERT INTO grapes_vineyards (grape_id, vineyard_id) VALUES ((SELECT id FROM grapes WHERE name=?), (SELECT id FROM vineyards WHERE name=?));",
  "wines"            => "INSERT INTO wines (name, purchase_date, drunk_date, rating, comment, price, vintage, winery_id) VALUES (?, ?, ?, ?, ?, ?, ?, (SELECT id FROM wineries WHERE name=?));",
  "grapes_wines"     => "INSERT INTO grapes_wines (grape_id, wine_id) VALUES ((SELECT id FROM grapes WHERE name=?), (SELECT id FROM wines WHERE name=?));"
]

db = SQLite3::Database.new("wine04.db")
db.results_as_hash = true

query_result = db.execute(query_wines_tmp);

# General pattern: add results to sets to remove duplicates, add sets to database

# Countries
countries_set = Set[];

query_result.each do |row|
  countries_set.add(row["country_name"])
end
  
countries_set.each do |item|
  db.execute(insert_queries["countries"], item);
end

#Regions
regions_set = Set[];

query_result.each do |row|
  regions_set.add("#{row["region_name"]}|#{row["country_name"]}")
end

regions_set.each do |item|
  split = item.split("|")
  if not split[0].empty? 
    db.execute(insert_queries["regions"], split[0], split[1])
  end
end

#Wineries
wineries_set = Set[];

query_result.each do |row|
  wineries_set.add(row["winery_name"])
end

wineries_set.each do |item|
  db.execute(insert_queries["wineries"], item)
end

#Vineyards
vineyards_set = Set[];

query_result.each do |row|
  vineyards_set.add("#{row["vinyard_name"]}|#{row["winery_name"]}|#{row["region_name"]}")
end

vineyards_set.each do |item|
  split = item.split("|")
  if not split[0].empty? 
    db.execute(insert_queries["vineyards"], split[0], split[1], split[2])
  end
end

#Grapes
grapes_set = Set[];

query_result.each do |row|
  split = row["grape_name"].split(", ")
  
  split.each do |substr|
    grapes_set.add(substr)
  end
end

grapes_set.each do |item|
  db.execute(insert_queries["grapes"], item)
end

#Grapes_Vineyards
grapes_vineyards_set = Set[];

query_result.each do |row|
  split = row["grape_name"].split(", ")
  
  split.each do |substr|
    grapes_vineyards_set.add("#{substr}|#{row["vinyard_name"]}")
  end
end

grapes_vineyards_set.each do |item|
  split = item.split("|")
  db.execute(insert_queries["grapes_vineyards"], split[0], split[1])
end

#Wines + Grapes_Wines
query_result.each do |row|
  if row["price"] == "free"
    row["price"] = 0
  end
  
  db.execute(insert_queries["wines"], row["name"], row["purchase_date"], row["drunk_date"], row["rating"], row["comment"], row["price"], row["vintage"], row["winery_name"])
  
  split = row["grape_name"].split(", ")
  
  split.each do |substr|  
    db.execute(insert_queries["grapes_wines"], substr, row["name"])
  end
end
  
db.close()