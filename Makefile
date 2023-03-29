postgres:
	docker run --name postgres12 -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=123456 -d postgres:12-alpine
createdb:
	docker exec -it postgres12 createdb --username=root --owner=root transfer_bank
dropdb:
	docker exec -it postgres12 dropdb transfer_bank
migrateup:
	migrate -path db/migration -database "postgresql://root:123456@localhost:5432/transfer_bank?sslmode=disable" -verbose up
migratedown:
	migrate -path db/migration -database "postgresql://root:123456@localhost:5432/transfer_bank?sslmode=disable" -verbose down
.PHONY: createdb