# DB_URL=postgresql://root:wFnvZVrFcpzGO0B5fuwo@transfer-bank.ca8is6ljjqfm.ap-southeast-1.rds.amazonaws.com:5432/transfer_bank?sslmode=disable
DB_USER=root
DB_PASSWORD=nZNnn41RuhrDEZcjO01X
DB_HOST=transfer-bank.ca8is6ljjqfm.ap-southeast-1.rds.amazonaws.com
DB_URL=postgresql://$(DB_USER):$(DB_PASSWORD)@$(DB_HOST):5432/transfer_bank?sslmode=disable

postgres:
	docker run --name postgres12 --network bank-network -p 5432:5432 -e POSTGRES_USER=$(DB_USER) -e POSTGRES_PASSWORD=$(DB_PASSWORD) -d postgres:12-alpine
createdb:
	docker exec -it postgres12 createdb --username=root --owner=root transfer_bank
dropdb:
	docker exec -it postgres12 dropdb transfer_bank
migrateup:
	migrate -path db/migration -database "$(DB_URL)" -verbose up
migrateup1:
	migrate -path db/migration -database "$(DB_URL)" -verbose up 1
migratedown:
	migrate -path db/migration -database "$(DB_URL)" -verbose down
migratedown1:
	migrate -path db/migration -database "$(DB_URL)" -verbose down 1
sqlc:
	docker run --rm -v "${CURDIR}:/src" -w /src kjconroy/sqlc generate
test:
	go test -v -cover ./...
server:
	go run main.go
mock:
	docker run -v $(CURDIR):/app -w /app ekofr/gomock:go-1.13 \
	mockgen -package mockdb -destination db/mock/store.go github.com/phongngohuu/bank_transfer/db/sqlc Store
.PHONY: postgres createdb dropdb migrateup migratedown sqlc test server mock migrateup1 migratedown1

#install AWS CLI https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
#####config aws secret
#aws configure to 
#####to get secret value
#aws secretsmanager get-secret-value --secret-id transfer_bank 
#aws secretsmanager get-secret-value --secret-id transfer_bank --query SecretString
#aws secretsmanager get-secret-value --secret-id transfer_bank --query SecretString --output text
#https://stedolan.github.io/jq/  scoop install jq  return output query filter from json
#format output query text
#aws secretsmanager get-secret-value --secret-id transfer_bank --query SecretString --output text | jq "to_entries"
#get keys 
#aws secretsmanager get-secret-value --secret-id transfer_bank --query SecretString --output text | jq "to_entries|map(.key)"
#get value
#aws secretsmanager get-secret-value --secret-id transfer_bank --query SecretString --output text | jq "to_entries|map(.value)"
#get key and value
#aws secretsmanager get-secret-value --secret-id transfer_bank --query SecretString --output text | jq "to_entries|map(\"\(.key)=\(.value)\")"
#remove square quote
#aws secretsmanager get-secret-value --secret-id transfer_bank --query SecretString --output text | jq "to_entries|map(\"\(.key)=\(.value)\")|.[]"
#remove double quote
#aws secretsmanager get-secret-value --secret-id transfer_bank --query SecretString --output text | jq -r "to_entries|map(\"\(.key)=\(.value)\")|.[]"
#get login password 
#aws ecr get-login-password
#login aws https://docs.aws.amazon.com/cli/latest/reference/ecr/get-login-password.html
#aws ecr get-login-password | docker login --username AWS --password-stdin 502320843173.dkr.ecr.ap-southeast-1.amazonaws.com