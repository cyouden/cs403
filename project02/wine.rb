require 'sqlite3'

db = SQLite3::Database.new("wine.db")
result = db.execute("SELECT * FROM wine")

result.each do|row|
	printf("ID: %s\nName: %s\nPrice: %s\nDate Purchased: %s\nDate Drunk: %s\nRating: %s\nComment: %s\n\n\n",
       row[0], row[1], row[2], row[3], row[4], row[5], row[6])
end

print("Enter the attributes of a new wine:\n")
print("Name: ")
$name = gets.chomp
print("Price: ")
$price = gets.chomp
print("Date Purchased: ")
$purch_date = gets.chomp
print("Date Drunk: ")
$drunk_date = gets.chomp
print("Rating: ")
$rating = gets.chomp
print("Comment: ")
$comment = gets.chomp

db.execute(
	sprintf(
            'INSERT INTO wine (name, price, purchase_date, drunk_date, rating, comment) VALUES ("%s", "%s", "%s", "%s", "%s", "%s")',
			$name, $price, $purch_date, $drunk_date, $rating, $comment))