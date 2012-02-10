CREATE TABLE countries (
  id INTEGER PRIMARY KEY,
  name TEXT UNIQUE
);

CREATE TABLE regions (
  id INTEGER PRIMARY KEY,
  name TEXT,
  country_id INTEGER,
  FOREIGN KEY(country_id) REFERENCES countries(id)
);

CREATE TABLE wineries (
  id INTEGER PRIMARY KEY,
  tax_id TEXT UNIQUE,
  name TEXT
);

CREATE TABLE vineyards (
  id INTEGER PRIMARY KEY,
  parcel_id TEXT UNIQUE,
  name TEXT,
  winery_id INTEGER,
  region_id INTEGER,
  FOREIGN KEY(winery_id) REFERENCES wineries(id),
  FOREIGN KEY(region_id) REFERENCES regions(id)
);

CREATE TABLE grapes (
  id INTEGER PRIMARY KEY,
  name TEXT UNIQUE
);

CREATE TABLE grapes_vineyards (
  grape_id INTEGER,
  vineyard_id, INTEGER,
  FOREIGN KEY(grape_id) REFERENCES grapes(id),
  FOREIGN KEY(vineyard_id) REFERENCES vineyards(id)
);

CREATE TABLE wines (
  id INTEGER PRIMARY KEY,
  sku TEXT UNIQUE,
  name TEXT,
  purchase_date TEXT,
  drunk_date TEXT,
  rating INTEGER,
  comment TEXT,
  price REAL,
  vintage INTEGER,
  winery_id INTEGER,
  FOREIGN KEY(winery_id) REFERENCES wineries(id)
);

CREATE TABLE grapes_wines (
  grape_id INTEGER,
  wine_id INTEGER,
  FOREIGN KEY(grape_id) REFERENCES grapes(id),
  FOREIGN KEY(wine_id) REFERENCES wines(id)
);