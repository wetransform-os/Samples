curl -d '{
  "id": "1",
  "accessPolicyId": "aPolicy",
  "contractPolicyId": "aPolicy",
  "criteria": []
}' -H 'content-type: application/json' http://localhost:19193/api/v1/data/contractdefinitions \
-s | jq