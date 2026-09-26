import json
import os
import urllib.request
import urllib.parse


def lambda_handler(event, context):

    try:
        params = event.get("queryStringParameters") or {}

        city = params.get("city")

        if not city:
            return {
                "statusCode": 400,
                "headers": {
                    "Access-Control-Allow-Origin": "*"
                },
                "body": json.dumps({
                    "error": "City is required"
                })
            }

        api_key = os.environ["WEATHER_API_KEY"]

        encoded_city = urllib.parse.quote(city)

        url = (
            "https://api.openweathermap.org/data/2.5/weather"
            f"?q={encoded_city}"
            f"&appid={api_key}"
            "&units=metric"
        )

        with urllib.request.urlopen(url) as response:
            data = json.loads(response.read().decode())

        return {
            "statusCode": 200,
            "headers": {
                "Access-Control-Allow-Origin": "*",
                "Content-Type": "application/json"
            },
            "body": json.dumps(data)
        }

    except Exception as e:

        return {
            "statusCode": 500,
            "headers": {
                "Access-Control-Allow-Origin": "*"
            },
            "body": json.dumps({
                "error": str(e)
            })
        }
