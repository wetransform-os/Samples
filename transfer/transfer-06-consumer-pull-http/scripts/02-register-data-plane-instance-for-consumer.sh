#!/bin/bash

curl -H 'Content-Type: application/json' \
    -d '{
  "edctype": "dataspaceconnector:dataplaneinstance",
  "id": "http-pull-consumer-dataplane",
  "url": "http://localhost:29192/control/transfer",
  "allowedSourceTypes": [ "HttpData" ],
  "allowedDestTypes": [ "HttpProxy", "HttpData" ],
  "properties": {
    "publicApiUrl": "http://localhost:29291/public/"
  }
}' \
    -X POST "http://localhost:29193/api/v1/data/instances"