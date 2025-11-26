package database

import (
	"context"
	"fmt"
	"log"
	"mono/internal/documents"
	"time"

	// "go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
	"go.mongodb.org/mongo-driver/x/mongo/driver/connstring"
)

const timeout = 10 * time.Second

type dbConfig struct {
	client *mongo.Client
	uri    string
	ctx    context.Context
}

func New(uri string) *dbConfig {
	return &dbConfig{uri: uri}
}

func (c *dbConfig) Connect() error {
	ctxBg := context.Background()
	ctx, cancel := context.WithTimeout(ctxBg, timeout)
	defer cancel()

	clientOptions := options.Client().ApplyURI(c.uri)
	client, err := mongo.Connect(ctx, clientOptions)
	if err != nil {
		return fmt.Errorf("connect error: %w", err)
	}

	if err := client.Ping(ctx, nil); err != nil {
		return fmt.Errorf("ping error: %w", err)
	}

	c.client = client
	c.ctx = ctxBg

	log.Println("database is connected!")
	return nil
}

func (c *dbConfig) Disconnect() {
	if c.client != nil {
		_ = c.client.Disconnect(c.ctx)
		log.Println("database is disconnected!")
	}
}

type collection struct {
	col *mongo.Collection
	ctx context.Context
}

func (c *dbConfig) Collection(name string) *collection {
	cs, _ := connstring.ParseAndValidate(c.uri)

	return &collection{
		col: c.client.Database(cs.Database).Collection(name),
		ctx: c.ctx,
	}
}

func (c *collection) Aggregate(pipeline mongo.Pipeline) (documents.New, error) {
	cursor, err := c.col.Aggregate(c.ctx, pipeline)
	if err != nil {
		return nil, fmt.Errorf("aggregate error: %w", err)
	}
	defer cursor.Close(c.ctx)

	var results documents.New
	if err := cursor.All(c.ctx, &results); err != nil {
		return nil, fmt.Errorf("cursor decode error: %w", err)
	}

	return results, nil
}
