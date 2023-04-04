postgres:
	docker run --name postgres12 -p 7432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=123456 -d postgres:12-alpine
createdb:
	docker exec -it postgres12 createdb --username=root --owner=root transfer_bank
dropdb:
	docker exec -it postgres12 dropdb transfer_bank
migrateup:
	migrate -path db/migration -database "postgresql://root:123456@localhost:7432/transfer_bank?sslmode=disable" -verbose up
migratedown:
	migrate -path db/migration -database "postgresql://root:123456@localhost:7432/transfer_bank?sslmode=disable" -verbose down
sqlc:
	docker run --rm -v "${CURDIR}:/src" -w /src kjconroy/sqlc generate
test:
	go test -v -cover ./...
server:
	go run main.go
mockgen:
	docker run -v $(CURDIR):/app -w /app ekofr/gomock:go-1.13 \
	mockgen -package mockdb -destination db/mock/store.go github.com/phongngohuu/bank_transfer/db/sqlc Store
.PHONY: postgres createdb dropdb migrateup migratedown sqlc test server mockgen