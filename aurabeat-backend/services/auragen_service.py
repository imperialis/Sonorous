import os
import requests
import logging
from uuid import uuid4

logger = logging.getLogger(__name__)

class AuraGenService:
    def __init__(self, api_key, output_dir="static/uploads/auragen"):
        self.api_key = api_key
        self.base_url = "https://api.beatoven.ai/v1"
        self.output_dir = output_dir
        os.makedirs(output_dir, exist_ok=True)

    def generate_song(self, mood_prompt, lyrics=None):
        payload = {
            "prompt": mood_prompt,
            "include_lyrics": bool(lyrics),
            "lyrics": lyrics or ""
        }

        headers = {
            "Authorization": f"Bearer {self.api_key}",
            "Content-Type": "application/json"
        }

        try:
            logger.info(f"Requesting song from Beatoven: {payload}")
            response = requests.post(f"{self.base_url}/generate", json=payload, headers=headers)
            response.raise_for_status()
            result = response.json()

            download_url = result.get("audio_url")
            if not download_url:
                raise Exception("Missing audio URL in Beatoven response")

            filename = f"auragen_{uuid4().hex}.mp3"
            filepath = os.path.join(self.output_dir, filename)

            with requests.get(download_url, stream=True) as r:
                r.raise_for_status()
                with open(filepath, 'wb') as f:
                    for chunk in r.iter_content(chunk_size=8192):
                        f.write(chunk)

            logger.info(f"AuraGen track saved at {filepath}")
            return filepath, result

        except Exception as e:
            logger.error(f"AuraGen generation failed: {e}")
            return None, {"error": str(e)}
