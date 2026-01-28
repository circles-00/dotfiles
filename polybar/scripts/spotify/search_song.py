#!/usr/bin/env python3
import os
import sys
import requests
from configparser import ConfigParser

# --- Config ---
config = ConfigParser()
config.read(os.path.expanduser("~/.config/polybar/scripts/spotify/spotify.conf"))
CLIENT_ID = config.get("spotify", "client_id")
CLIENT_SECRET = config.get("spotify", "client_secret")
REFRESH_TOKEN = config.get("spotify", "refresh_token")

CACHE_DIR = os.path.expanduser("~/.cache/spotify-rofi-art")
RESULT_LIMIT = 5
STATE_FILE = "/tmp/rofi_spotify_query"  # stores last submitted query


def rofi_header(message: str | None = None):
    sys.stdout.write("\0prompt\x1fSpotify\n")
    sys.stdout.write("\0markup-rows\x1ffalse\n")
    sys.stdout.write("\0keep-filter\x1ftrue\n")
    # IMPORTANT: allow custom input so Enter can "submit" a search query
    sys.stdout.write("\0no-custom\x1ffalse\n")
    if message:
        sys.stdout.write(f"\0message\x1f{message}\n")


def get_filter_text() -> str:
    # Different rofi versions expose this differently; try all common ways.
    if len(sys.argv) > 1 and sys.argv[1].strip():
        return sys.argv[1].strip()
    env_filter = (os.environ.get("ROFI_FILTER") or "").strip()
    if env_filter:
        return env_filter
    env_input = (os.environ.get("ROFI_INPUT") or "").strip()
    if env_input:
        return env_input
    return ""


def write_state(query: str):
    try:
        with open(STATE_FILE, "w", encoding="utf-8") as f:
            f.write(query)
    except Exception:
        pass


def read_state() -> str:
    try:
        with open(STATE_FILE, "r", encoding="utf-8") as f:
            return f.read().strip()
    except Exception:
        return ""


def get_access_token() -> str:
    url = "https://accounts.spotify.com/api/token"
    data = {
        "grant_type": "refresh_token",
        "refresh_token": REFRESH_TOKEN,
        "client_id": CLIENT_ID,
        "client_secret": CLIENT_SECRET,
    }
    r = requests.post(url, data=data, timeout=10)
    r.raise_for_status()
    return r.json()["access_token"]


def download_image(url: str, out_path: str) -> bool:
    try:
        os.makedirs(os.path.dirname(out_path), exist_ok=True)
        if os.path.exists(out_path) and os.path.getsize(out_path) > 0:
            return True
        r = requests.get(url, timeout=10)
        r.raise_for_status()
        with open(out_path, "wb") as f:
            f.write(r.content)
        return True
    except Exception:
        return False


def search_tracks(query: str):
    token = get_access_token()
    headers = {"Authorization": f"Bearer {token}"}
    params = {"q": query, "type": "track", "limit": RESULT_LIMIT}

    r = requests.get("https://api.spotify.com/v1/search", headers=headers, params=params, timeout=10)
    r.raise_for_status()

    items = r.json().get("tracks", {}).get("items", [])
    results = []

    for track in items:
        name = track.get("name", "")
        artist = (track.get("artists") or [{}])[0].get("name", "")
        uri = track.get("uri", "")

        images = track.get("album", {}).get("images", [])
        art_url = images[0]["url"] if images else None

        icon_path = None
        if art_url:
            track_id = track.get("id") or "unknown"
            icon_path = os.path.join(CACHE_DIR, f"{track_id}.jpg")
            if not download_image(art_url, icon_path):
                icon_path = None

        results.append({"display": f"{name} - {artist}".strip(" -"), "uri": uri, "icon": icon_path})

    return results


def play_song(uri: str):
    token = get_access_token()
    headers = {"Authorization": f"Bearer {token}"}
    data = {"uris": [uri]}

    r = requests.put("https://api.spotify.com/v1/me/player/play", headers=headers, json=data, timeout=10)
    if r.status_code >= 400:
        try:
            detail = r.json()
        except Exception:
            detail = r.text
        raise RuntimeError(f"{r.status_code}: {detail}")


def print_results_for(query: str):
    rofi_header(f"Results for: {query}")
    try:
        tracks = search_tracks(query)
    except Exception as e:
        rofi_header(f"Search failed: {e}")
        print("Search failed")
        return

    if not tracks:
        print("No results")
        return

    for t in tracks:
        row = t["display"]
        opts = []
        if t["icon"]:
            opts.append(f"icon\x1f{t['icon']}")
        if t["uri"]:
            opts.append(f"info\x1f{t['uri']}")
        if opts:
            row += "\0" + "\x1f".join(opts)
        print(row)


def main():
    retv = os.environ.get("ROFI_RETV", "0")

    # retv meanings vary slightly by build, but generally:
    # - retv == "1": selected an entry from the list
    # - retv == "2": accepted custom input (pressed Enter with no list selection)
    if retv == "1":
        uri = (os.environ.get("ROFI_INFO") or "").strip()
        if uri:
            try:
                play_song(uri)
                rofi_header("Playing…")
            except Exception as e:
                rofi_header(f"Play failed: {e}")
        else:
            rofi_header("No URI received (row missing info).")
        return

    if retv == "2":
        # Enter pressed on query -> run search once
        query = get_filter_text()
        if not query:
            rofi_header("Type something, then press Enter to search.")
            print("Press Enter to search")
            return
        write_state(query)
        print_results_for(query)
        return

    # Normal refresh while typing: do NOT call Spotify.
    # Show last results only after a submitted search.
    last = read_state()
    if last:
        print_results_for(last)
    else:
        rofi_header("Type a query, then press Enter to search.")
        print("Press Enter to search")


if __name__ == "__main__":
    main()
