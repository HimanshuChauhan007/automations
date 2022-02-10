token=`curl https://accounts.zoho.com/oauth/v2/token -X POST -d "client_id=1000.X3QRZXLVXPMXCT5B3VIO0WGWLM2D6T" -d "client_secret=d0ea51da9507a02532a560870deb72b577ed7512de" -d "refresh_token=1000.3788bc8b9fc0d728bb5eefff647832cc.fdba75e27ea82a79b9698eda5d267ae2" -d "grant_type=refresh_token" | jq '.access_token' | tr '"' ' '`
 
echo $token 

curl https://www.site24x7.com/api/monitors/348310000056472185 \
    -X PUT \
    -H "Content-Type: application/json;charset=UTF-8" \
    -H "Accept: application/json; version=2.1" \
    -H "Authorization: Zoho-oauthtoken $token" \
    -d '{
        "display_name": "MYF-S-URL-Auth0-Connector",
        "type": "URL",
        "website": "https://secure-pp.myfonts.com/",
        "check_frequency": "1",
        "timeout": 10,
        "http_method": "P",
        "location_profile_id": "348310000002284123",
        "notification_profile_id": "348310000000071021",
        "threshold_profile_id": "348310000054620153",
        "user_group_ids": ["348310000000002007"],
        "tag_ids":[
            "348310000055758268",
            "348310000055758298",
          ]
    }'