package googlesheet

import (
	"context"
	"fmt"
	"os"

	"golang.org/x/oauth2/google"
	"google.golang.org/api/option"
	"google.golang.org/api/sheets/v4"
)

type gsConfig struct {
	srv *sheets.Service
}

func New(serviceAccountFile string) (*gsConfig, error) {
	key, err := os.ReadFile(serviceAccountFile)
	if err != nil {
		return nil, fmt.Errorf("service account file not found or unreadable: %v", err)
	}

	config, err := google.JWTConfigFromJSON(key, sheets.SpreadsheetsScope)
	if err != nil {
		return nil, fmt.Errorf("unable to parse service account json: %v", err)
	}

	ctx := context.Background()
	httpClient := config.Client(ctx)
	srv, err := sheets.NewService(ctx, option.WithHTTPClient(httpClient))
	if err != nil {
		return nil, fmt.Errorf("unable to retreive sheets client: %v", err)
	}

	return &gsConfig{srv: srv}, nil
}

func (g *gsConfig) InsertRows(sheetId, sheetName string, rows [][]any) error {
	valueRange := &sheets.ValueRange{Values: rows}

	_, err := g.srv.Spreadsheets.Values.Append(sheetId, sheetName, valueRange).ValueInputOption("RAW").InsertDataOption("INSERT_ROWS").Do()
	if err != nil {
		return fmt.Errorf("unable to append data: %v", err)
	}

	return nil
}
