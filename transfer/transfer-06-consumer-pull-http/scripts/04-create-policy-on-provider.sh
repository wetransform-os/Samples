curl -d '{
  "id": "aPolicy",
  "policy": {
    "uid": "231802-bb34-11ec-8422-0242ac120002",
    "permissions": [
      {
        "target": "assetId",
        "action": {
          "type": "USE"
        },
        "edctype": "dataspaceconnector:permission"
      }
    ],
    "@type": {
      "@policytype": "set"
    }
  }
}' -H 'content-type: application/json' http://localhost:19193/api/v1/data/policydefinitions \
-s | jq