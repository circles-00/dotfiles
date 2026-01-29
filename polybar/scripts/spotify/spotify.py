#!/usr/bin/env python3
import requests
from pathlib import Path
from configparser import ConfigParser
import os
import sys

config = ConfigParser()
config.read(os.path.expanduser("~/.config/polybar/scripts/spotify/spotify.conf"))
CACHE_FILE = Path.home() / ".cache/spotify_token"
CLIENT_ID = config.get("spotify", "client_id")
CLIENT_SECRET = config.get("spotify", "client_secret")
REFRESH_TOKEN = config.get("spotify", "refresh_token")

def get_access_token():
    """Get a fresh access token using refresh token"""
    url = "https://accounts.spotify.com/api/token"
    data = {
        "grant_type": "refresh_token",
        "refresh_token": REFRESH_TOKEN,
        "client_id": CLIENT_ID,
        "client_secret": CLIENT_SECRET,
    }
    response = requests.post(url, data=data)
    return response.json()["access_token"]

def get_current_track():
    """Fetch currently playing track"""
    token = get_access_token()
    headers = {"Authorization": f"Bearer {token}"}

    response = requests.get(
        "https://api.spotify.com/v1/me/player/currently-playing",
        headers=headers
    )

    if response.status_code != 200:
        return ""

    data = response.json()
    if not data or not data.get("item"):
        return ""

    if not data.get("is_playing"):
        return ""

    track = data["item"]
    artist = track["artists"][0]["name"]
    song = track["name"]
    max_song_length = 30

    if len(song) > max_song_length:
        song = song[:max_song_length] + "..."

    result = f"{song} - {artist}"

    return result

def play_pause():
    """Toggle play/pause"""
    token = get_access_token()
    headers = {"Authorization": f"Bearer {token}"}

    # Get current state
    response = requests.get(
        "https://api.spotify.com/v1/me/player/currently-playing",
        headers=headers
    )
    is_playing = response.json().get("is_playing", False)

    # Toggle
    if is_playing:
        requests.put(
            "https://api.spotify.com/v1/me/player/pause",
            headers=headers
        )
    else:
        requests.put(
            "https://api.spotify.com/v1/me/player/play",
            headers=headers
        )

def next_track():
    """Skip to next track"""
    token = get_access_token()
    headers = {"Authorization": f"Bearer {token}"}
    requests.post(
        "https://api.spotify.com/v1/me/player/next",
        data = {},
        headers=headers
    )

def previous_track():
    """Skip to previous track"""
    token = get_access_token()
    headers = {"Authorization": f"Bearer {token}"}
    requests.post(
        "https://api.spotify.com/v1/me/player/previous",
        headers=headers
    )

def get_play_pause_icon():
    """Get play/pause icon based on current state"""
    token = get_access_token()
    headers = {"Authorization": f"Bearer {token}"}

    response = requests.get(
        "https://api.spotify.com/v1/me/player/currently-playing",
        headers=headers
    )

    is_playing = response.json().get("is_playing", False)

    if is_playing:
        return "󰏤 "  # pause icon
    else:
        return "󰐊 "  # play icon

def noop():
    pass

if __name__ == "__main__":
    try:
        if len(sys.argv) > 1:
            action = sys.argv[1]
            if action == "play_pause":
                play_pause()
            elif action == "next":
                next_track()
            elif action == "play_pause_icon":
                print(get_play_pause_icon())
            elif action == "previous":
                previous_track()
        else:
            print(get_current_track())
    except Exception as e:
        noop()
