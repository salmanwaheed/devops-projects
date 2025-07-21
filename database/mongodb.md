# MongoDB Reference Guide

## Overview
**MongoDB** is a **NoSQL database** that stores data in **JSON-like documents** instead of rows and tables. It is flexible, fast, and great for modern applications.

---

## Core MongoDB Operations (CRUD)

### Create (Insert)

```js
db.users.insertOne({ name: "Salman", age: "1,000 years old" });
db.users.insertMany([{ name: "Sara" }, { name: "Usman", age: 30 }]);
```

### Read (Find)

```js
db.users.find();                      // Get all documents
db.users.find({ age: { $gte: 18 } }); // Get users age 18 or more
db.users.findOne({ name: "Salman" }); // Get first match
```

### Update

```js
db.users.updateOne(
  { name: "Salman" },
  { $set: { age: 11000 } }
);

db.users.updateMany(
  { age: { $lt: 18 } },
  { $set: { status: "minor" } }
);
```

### Delete

```js
db.users.deleteOne({ name: "Salman" });
db.users.deleteMany({ age: { $lt: 18 } });
```

---

## Query Filters and Operators

### Comparison Operators

- `$eq`, `$ne`, `$gt`, `$lt`, `$gte`, `$lte`, `$in`, `$nin`

```js
db.products.find({ price: { $gte: 1000 } });
db.users.find({ country: { $in: ["USA", "UK"] } });
```

### Logical Operators

- `$and`, `$or`, `$not`, `$nor`

```js
db.users.find({
  $or: [
    { age: { $lt: 18 } },
    { country: "Pakistan" }
  ]
});
```

---

## Aggregation (Like GROUP BY in SQL)

```js
db.orders.aggregate([
  { $match: { status: "completed" } },
  { $group: { _id: "$customer_id", total: { $sum: "$amount" } } },
  { $sort: { total: -1 } }
]);
```

---

## Indexing (For Performance)

```js
db.users.createIndex({ email: 1 }, { unique: true });
db.users.find({ email: "a@b.com" }).explain("executionStats");
```

---

## Working with Arrays

```js
// Find users with "admin" role
db.users.find({ roles: "admin" });

// Match inside array of objects
db.posts.find({
  tags: { $elemMatch: { type: "tech", value: "mongodb" } }
});
```

---

## $lookup (Join two collections)

```js
db.orders.aggregate([
  {
    $lookup: {
      from: "customers",
      localField: "customer_id",
      foreignField: "_id",
      as: "customer_info"
    }
  }
]);
```

---

## Data Modeling Tips

- Use **embedded documents** when data is often used together.
- Use **references (foreign keys)** when data is large or reused in many places.
- Example:
  - Embed address inside user document.
  - Reference products in an order document.

---

## Admin Commands

```bash
# Connect to MongoDB
mongosh

# Show databases and collections
show dbs
use mydb
show collections

# Create new user
db.createUser({
  user: "admin",
  pwd: "secret",
  roles: [ { role: "readWrite", db: "mydb" } ]
});

# Create new collection
db.createCollection("<COLLECTION_NAME>")

# List users
db.getUsers();

# Drop collection or database
db.<COLLECTION_NAME>.drop();
db.dropDatabase();

# Export data
mongoexport --db=mydb --collection=users --out=users.json

# Import data
mongoimport --db=mydb --collection=users --file=users.json

# Backup
mongodump --db=mydb --out=/backup/
mongodump <CONNECTION_STRING> --gzip --archive=my-mongodb.tar.gz

# Restore
mongorestore /backup/
mongorestore <CONNECTION_STRING> --drop --gzip --archive=my-mongodb.tar.gz
```

---

## Sample Dummy Collections

### Customers

```js
{
  _id: ObjectId("..."),
  name: "Salman",
  email: "salman@example.com",
  country: "USA"
}
```

### Products

```js
{
  _id: ObjectId("..."),
  name: "Laptop",
  price: 1200,
  stock: 10
}
```

### Orders

```js
{
  _id: ObjectId("..."),
  customer_id: ObjectId("..."),
  product_id: ObjectId("..."),
  quantity: 2,
  order_date: ISODate("2024-05-10")
}
```

---

## Example Reports (Real Use)

### Top 5 Expensive Products

```js
db.products.find().sort({ price: -1 }).limit(5);
```

### Total Orders Per Customer

```js
db.orders.aggregate([
  { $group: { _id: "$customer_id", total_orders: { $sum: 1 } } }
]);
```

### Total Spent by Each Customer

```js
db.orders.aggregate([
  {
    $lookup: {
      from: "products",
      localField: "product_id",
      foreignField: "_id",
      as: "product"
    }
  },
  { $unwind: "$product" },
  {
    $group: {
      _id: "$customer_id",
      total_spent: { $sum: { $multiply: ["$quantity", "$product.price"] } }
    }
  }
]);
```

---

## References
- https://mongodb.com/docs/manual
- https://mongodb.com/playground
