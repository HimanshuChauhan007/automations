ZONE_ID=XXXXXXXXXXXXX

CLOUDFLARE_EMAIL=XXXXXXXXXXXXX

CLOUDFLARE_KEY=XXXXXXXXXXXXX

STARTDATE=$(($(date +%s)-3900))

ENDDATE=$((STARTDATE+3600))

FILENAME=/tmp/cloudflare.log

FIELDS=$(curl -s -H "X-Auth-Email: ${CLOUDFLARE_EMAIL}" -H "X-Auth-Key: ${CLOUDFLARE_KEY}" "https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/logs/received/fields" | jq '. | to_entries[] | .key' -r | paste -sd "," -)

curl -s \

  -H "X-Auth-Email: ${CLOUDFLARE_EMAIL}" \

  -H "X-Auth-Key: ${CLOUDFLARE_KEY}" \

  "https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/logs/received?start=${STARTDATE}&end=${ENDDATE}&fields=${FIELDS}" \

  > "${FILENAME}" \

  && echo "Logs written to ${FILENAME}"

cat ${FILENAME} |  grep -i 'Monotype Fonts ' > /tmp/sort.log

FILENAME1=/tmp/sort.log

jq 'select(.EdgeResponseStatus >= 500) | "\(.ClientIP)"' ${FILENAME1} | sort -n | uniq -c | sort -nr > /tmp/output.txt
