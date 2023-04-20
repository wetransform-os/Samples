#!/bin/bash
curl -H 'Content-Type: application/json' \
    -d '{
  "edctype": "dataspaceconnector:dataplaneinstance",
  "id": "http-pull-provider-dataplane",
  "url": "http://localhost:19192/control/transfer",
  "allowedSourceTypes": [ "HttpData" ],
  "allowedDestTypes": [ "HttpProxy", "HttpData" ],
  "properties": {
    "publicApiUrl": "http://localhost:19291/public/"
  }
}' \
    -X POST "http://localhost:19193/api/v1/data/instances"