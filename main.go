package main

import (
	"database/sql"
	"log"

	_ "github.com/lib/pq"
	"github.com/phongngohuu/bank_transfer/api"
	db "github.com/phongngohuu/bank_transfer/db/sqlc"
)

const (
	dbDriver      = "postgres"
	dbSource      = "postgresql://root:123456@localhost:7432/transfer_bank?sslmode=disable"
	serverAddress = "0.0.0.0:8888"
)

func main() {
	conn, err := sql.Open(dbDriver, dbSource)
	if err != nil {
		log.Fatal("cannot connect to db:", err)
	}

	store := db.NewStore(conn)
	server := api.NewServer(store)

	err = server.Start(serverAddress)
	if err != nil {
		log.Fatal("Cannot start server:", err)
	}
}
