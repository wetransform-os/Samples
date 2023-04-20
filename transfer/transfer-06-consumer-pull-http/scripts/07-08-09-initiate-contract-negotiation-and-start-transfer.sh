#!/bin/bash

# https://github.com/eclipse-edc/Samples/blob/main/transfer/transfer-06-consumer-pull-http/README.md#7-negotiate-a-contract

OFFER=$(curl -X 'POST' \
  'http://localhost:29193/api/v1/data/catalog/request' \
  -H 'accept: application/json' \
  -H 'X-Api-Key: ApiKeyDefaultValue' \
  -H 'Content-Type: application/json' \
  -d '{"providerUrl": "http://localhost:19194/api/v1/ids/data"}' | jq '.contractOffers[]  | select(.asset.id == "assetId")')

OFFER_ID=$(echo $OFFER | jq .id)
echo "Offer ID: $OFFER_ID"

ASSET_ID=$(echo $OFFER | jq .asset.id)
echo "Asset ID: $ASSET_ID"

POLICY=$(echo $OFFER | jq .policy)
# echo "Policy: $POLICY"

REQUEST=$(cat <<EOF
{
  "connectorId": "http-pull-provider",
  "connectorAddress": "http://localhost:19194/api/v1/ids/data",
  "protocol": "ids-multipart",
  "offer": {
    "offerId": ${OFFER_ID},
    "assetId": ${ASSET_ID},
    "policy": ${POLICY}
  }
}
EOF
)

echo ""
echo "Attempting to post request for intiating contract negotiation to consumer:"
echo $REQUEST
echo ""

NEGOTIATION=$(curl -d "$REQUEST" -X POST -H 'content-type: application/json' -H 'X-Api-Key: ApiKeyDefaultValue' http://localhost:29193/api/v1/data/contractnegotiations \
         -s)

NEGOTIATION_ID=$(echo $NEGOTIATION | jq -r .id)
echo "Negotiation ID: $NEGOTIATION_ID"

NEGOTIATION=$(curl -X GET "http://localhost:29193/api/v1/data/contractnegotiations/$NEGOTIATION_ID" \
    --header 'Content-Type: application/json' -H 'X-Api-Key: ApiKeyDefaultValue' \
         -s)

echo ""
echo "Negotation result:"
echo "$NEGOTIATION"

AGREEMENT_ID=$(echo $NEGOTIATION | jq -r .contractAgreementId)
echo ""
echo "Agreement ID: $AGREEMENT_ID"

while [ "$AGREEMENT_ID" == "null" ]
do
	sleep 1s
	NEGOTIATION=$(curl -X GET "http://localhost:29193/api/v1/data/contractnegotiations/$NEGOTIATION_ID" \
    --header 'Content-Type: application/json' -H 'X-Api-Key: ApiKeyDefaultValue' \
         -s)
    AGREEMENT_ID=$(echo $NEGOTIATION | jq -r .contractAgreementId)
    echo "Agreement ID: $AGREEMENT_ID"
done

echo ""
echo "Starting transfer..."
curl -X POST "http://localhost:29193/api/v1/data/transferprocess" \
    --header "Content-Type: application/json" \
    -H 'X-Api-Key: ApiKeyDefaultValue' \
    --data "{
                \"connectorId\": \"http-pull-provider\",
                \"connectorAddress\": \"http://localhost:19194/api/v1/ids/data\",
                \"contractId\": \"$AGREEMENT_ID\",
                \"assetId\": \"assetId\",
                \"managedResources\": \"false\",
                \"dataDestination\": { \"type\": \"HttpProxy\" }
            }" \
    -s | jq