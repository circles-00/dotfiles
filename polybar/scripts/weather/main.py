
import argparse
import os
import requests
from requests.adapters import HTTPAdapter
from typing import Optional, Dict

URL = "https://api.openweathermap.org/data/2.5/weather"
API_KEY = os.environ.get("OPENWEATHER_API_KEY", "970606528befaa317698cc75083db8b2")
HEADER = {"User-agent": "Mozilla/5.0"}


def get_city() -> str:
    try:
        r = requests.get("https://ipapi.co/json", headers=HEADER)
        return r.json()["city"]
    except requests.exceptions.ConnectionError:
        print("E: couldn't get city name")
        return "london"


def unit_suffix(unit: str) -> str:
    if unit == "metric":
        return "ºC"
    elif unit == "imperial":
        return "ºF"
    else:
        return " K"


def get_weather(city: str, lang: str, unit: str, api_key: str) -> Optional[Dict[str, str]]:
    try:
        s = requests.Session()
        s.mount("https://", HTTPAdapter(max_retries=5))
        r = s.get(
            f"{URL}?q={city}&lang={lang}&units={unit}&appid={api_key}",
            headers=HEADER,
            timeout=10,
        )
        data = r.json()
        temp = data["main"]["temp"]
        desc = data["weather"][0]["description"]
        unit_str = unit_suffix(unit)

        return {
            "temp": f"{int(temp)}{unit_str}",
            "desc": desc.title(),
        }

    except requests.exceptions.ConnectionError:
        print("E: failed to establish connection with the API")
        return None


def main() -> None:
    parser = argparse.ArgumentParser(description="Display information about the weather.")
    parser.add_argument("-c", metavar="CITY", dest="city", type=str, nargs="+", help="city name")
    parser.add_argument("-l", metavar="LANG", dest="lang", type=str, nargs=1, help="language")
    parser.add_argument(
        "-u", metavar="metric/imperial", choices=("metric", "imperial"),
        dest="unit", type=str, nargs=1, help="unit of temperature (default: kelvin)"
    )
    parser.add_argument("-a", metavar="API_KEY", dest="api_key", nargs=1, help="API Key")
    parser.add_argument("-v", "--verbose", action="store_true", dest="verbose", help="verbose mode")

    args = parser.parse_args()

    api_key = args.api_key[0] if args.api_key else API_KEY
    city = args.city[0] if args.city else get_city()
    lang = args.lang[0] if args.lang else "en"
    unit = args.unit[0] if args.unit else "standard"

    weather = get_weather(city, lang, unit, api_key)
    if weather:
        temp, desc = weather["temp"], weather["desc"]
        if args.verbose:
            print(f"{temp}, {desc}")
        else:
            print(f"{temp}")


if __name__ == "__main__":
    main()
