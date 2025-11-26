# monoctl - A Go based CLI Tool

monoctl fetches data from MongoDB and exports it to:

- A local CSV file.
* Google Sheets.

It supports multiple subcommands, configuration options, and export formats.

---

# Project Structure

```
mono/
├── cmd/
│   ├── root.go                 # CLI entrypoint
│   ├── export.go               # group of export options
│   ├── export_file.go          # insert rows to csv file
│   ├── export_google_sheet.go  # insert rows to google sheet
│   └── version.go              # show current version
│
├── internal/
│   ├── config/         # YAML config loading
│   ├── database/       # MongoDB database
│   ├── documents/      # map[]
│   ├── localsheet/     # save CSV file
│   └── googlesheet/    # append rows to Google sheet
│
├── main.go
├── go.mod
└── README.md
```

---

# Core Code Flow

The flow for `monoctl <subcommand> [option]` command:

1. Load config
2. Connect to database
3. Run aggregation
4. Convert docs to rows
5. Export based on `<subcommand> + [options]`
6. Disconnect DB

---

# Make Binary File

```sh
### Clone
git clone https://github.com/salmanwaheed/devops-projects.git
cd ./devops-projects/golang/mono

### Install dependencies
go mod tidy

### Build
go build -ldflags='-w -s' -o ./bin/monoctl main.go

### Install binary
cp ./bin/monoctl /usr/local/bin/monoctl
```

---

# CLI Usage

```sh
monoctl help
monoctl version

monoctl export file --output <file> --category <credit-cards|mortgages>
monoctl export google-sheet --id <sheet-id> --name <sheet-name> --category <credit-cards|mortgages>
```

---

# Config File

```yaml
# config.yml
database_uri: mongodb://...
category: xxx # credit-cards | mortgages
format: xxx # localsheet | googlesheet

# if format is localsheet
localsheet:
  filename: export.csv

# if format is googlesheet
googlesheet:
  id: xxxxxx
  name: Sheet1
  service_account_file: key.json
```

# TODO
- Add column headers only to the first row.
- Fix Arabic sorting/ordering issue.
- Replace custom `config.go` with `Viper` config management.
- Replace `ToCSV` / `ToRows` with generics.
- Remove `$limit` from `pipeline.go`.
- Generate `category` and `dateCreated` dynamically in `pipeline.go`.
- `monoctl config set|edit|list|delete <key> <value>`.
