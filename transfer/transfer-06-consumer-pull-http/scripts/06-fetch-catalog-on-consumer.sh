curl -X POST "http://localhost:29193/api/v1/data/catalog/request" \
--header 'Content-Type: application/json' \
--data-raw '{
  "providerUrl": "http://localhost:19194/api/v1/ids/data"
}'