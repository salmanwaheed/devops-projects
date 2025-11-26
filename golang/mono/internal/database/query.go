package database

import (
	"time"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/mongo"
)

type Query struct {
	Fields []string
	Category string
	DateCreated time.Time
}

func (q *Query) projection() bson.D {
	proj := bson.D{{Key: "_id", Value: 1}}

	for _, field := range q.Fields {
		proj = append(proj, bson.E{Key: field, Value: 1})
	}

	return proj
}

func (q *Query) Pipeline() mongo.Pipeline {
	return mongo.Pipeline{
		{{Key: "$match", Value: bson.M{
			"category": q.Category,
			"dateCreated": bson.M{"$gte": q.DateCreated},
		}}},
		{{Key: "$group", Value: bson.M{
			"_id": bson.M{"name": "$name", "email": "$email", "telephone": "$telephone"},
			"doc": bson.M{"$first": "$$ROOT"},
		}}},
		{{Key: "$replaceRoot", Value: bson.M{"newRoot": "$doc"}}},
		{{Key: "$project", Value: q.projection()}},
		{{Key: "$sort", Value: bson.M{"dateCreated": -1}}},
		{{Key: "$limit", Value: 2}},
	}
}
