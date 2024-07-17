token=`curl https://accounts.zoho.com/oauth/v2/token -X POST -d "client_id=XXXXXXXXXXXX" -d "client_secret=XXXXXXXXXXXX" -d "refresh_token=XXXXXXXXXXXX" -d "grant_type=refresh_token" | jq '.access_token' | tr '"' ' '`
 
echo $token 

#Get api for Site24*7
curl https://www.site24x7.com/api/monitors/XXXXXXXXXXXX \
    -X PUT \
    -H "Content-Type: application/json;charset=UTF-8" \
    -H "Accept: application/json; version=2.1" \
    -H "Authorization: Zoho-oauthtoken $token" \
    -d '{
        "display_name": "Name",
        "type": "URL",
        "website": "Type your URL",
        "check_frequency": "1",
        "timeout": 10,
        "http_method": "P",
        "location_profile_id": "XXXXXXXXXXXX",
        "notification_profile_id": "XXXXXXXXXXXX",
        "threshold_profile_id": "XXXXXXXXXXXX",
        "user_group_ids": ["XXXXXXXXXXXX"],
        "tag_ids":[
            "XXXXXXXXXXXX",
            "XXXXXXXXXXXX",
          ]
    }'
