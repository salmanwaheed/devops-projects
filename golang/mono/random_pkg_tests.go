package main

// // manual data
// rawDoc := documents.New{
//   {"name": "Alice", "email": "alice@example.com", "telephone": "123456789", "dateCreated": "1764013582805"},
//   {"name": "محمد علي الحسني", "email": "bob@example.com", "telephone": "987654321", "dateCreated": "1764047261276"},
// }

// fields := []string{"name", "email"}
// fmt.Println("RAW DOC - key/val:", rawDoc)
// fmt.Println("Rows (type any) - Google Sheet:", rawDoc.ToRows(fields))
// fmt.Println("Rows (type string) - CSV:", rawDoc.ToCSV(fields))
// // manual data

// // save to csv file
// if err := localsheet.SaveFile("export.csv", rawDoc.ToCSV(fields)); err != nil {
//   fmt.Println("Error saving CSV:", err)
// }
// // save to csv file

// // insert rows to google sheet
// id := "1LEh1_-7z_vlBJGf9rlWkogFZttGN4Fn4G_WrFLCbHuc"
// tab := "Sheet1"
// gs, err := googlesheet.New("/home/salman/.ssh/google-service-account.json")
// if err != nil {
//   fmt.Println(err)
// }

// if err := gs.InsertRows(id, tab, rawDoc.ToRows(fields)); err != nil {
//   fmt.Println(err)
// }
// // insert rows to google sheet

// // dynamic data from database
// db := database.New("mongodb://<USER>:<PASS>@<HOST>:<PORT>/<DB_NAME>?ssl=true&authSource=admin&retryWrites=true&w=majority&appName=<APP_NAME>")
// if err := db.Connect(); err != nil {
//   fmt.Println(err)
// }
// defer db.Disconnect()

// col := db.Collection("lead")
// rawDoc, err := col.Aggregate(database.Pipeline)
// if err != nil {
//   fmt.Println(err)
// }

// fields := []string{"name", "email"}
// fmt.Println("RAW DOC - key/val:", rawDoc)
// fmt.Println("Rows (type any) - Google Sheet:", rawDoc.ToRows(fields))
// fmt.Println("Rows (type string) - CSV:", rawDoc.ToCSV(fields))
// // dynamic data from database
