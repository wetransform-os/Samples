#!/bin/bash

curl -d '{
  "asset": {
    "properties": {
      "asset:prop:id": "assetId",
      "asset:prop:name": "product description",
      "asset:prop:contenttype": "application/json"
    }
  },
  "dataAddress": {
    "properties": {
      "name": "Test asset",
      "baseUrl": "https://jsonplaceholder.typicode.com/users",
      "queryParams": "true",
      "proxyQueryParams": "true",
      "type": "HttpData"
    }
  }
}' -H 'content-type: application/json' http://localhost:19193/api/v1/data/assets \
-s | jq