# import os
# import requests
# import logging
# from uuid import uuid4

# logger = logging.getLogger(__name__)

# class AuraGenService:
#     def __init__(self, api_key, output_dir="static/uploads/auragen"):
#         self.api_key = api_key
#         self.base_url = "https://api.beatoven.ai/v1"
#         self.output_dir = output_dir
#         os.makedirs(output_dir, exist_ok=True)

#     def generate_song(self, mood_prompt, lyrics=None):
#         payload = {
#             "prompt": mood_prompt,
#             "include_lyrics": bool(lyrics),
#             "lyrics": lyrics or ""
#         }

#         headers = {
#             "Authorization": f"Bearer {self.api_key}",
#             "Content-Type": "application/json"
#         }

#         try:
#             logger.info(f"Requesting song from Beatoven: {payload}")
#             response = requests.post(f"{self.base_url}/generate", json=payload, headers=headers)
#             response.raise_for_status()
#             result = response.json()

#             download_url = result.get("audio_url")
#             if not download_url:
#                 raise Exception("Missing audio URL in Beatoven response")

#             filename = f"auragen_{uuid4().hex}.mp3"
#             filepath = os.path.join(self.output_dir, filename)

#             with requests.get(download_url, stream=True) as r:
#                 r.raise_for_status()
#                 with open(filepath, 'wb') as f:
#                     for chunk in r.iter_content(chunk_size=8192):
#                         f.write(chunk)

#             logger.info(f"AuraGen track saved at {filepath}")
#             return filepath, result

#         except Exception as e:
#             logger.error(f"AuraGen generation failed: {e}")
#             return None, {"error": str(e)}
import os
import requests
import logging
import time
from uuid import uuid4

logger = logging.getLogger(__name__)

class AuraGenService:
    def __init__(self, api_key, output_dir="static/uploads/auragen"):
        self.api_key = api_key
        self.base_url = "https://public-api.beatoven.ai"
        self.output_dir = output_dir
        os.makedirs(output_dir, exist_ok=True)

    def generate_song(self, prompt_text, format_type="mp3", looping=False, max_wait_time=300):
        """
        Generate a song using Beatoven.ai API
        
        Args:
            prompt_text (str): The text prompt for the track
            format_type (str): Format of the generated asset (mp3, aac, wav)
            looping (bool): Control the extent of looping in the track
            max_wait_time (int): Maximum time to wait for composition in seconds
        
        Returns:
            tuple: (filepath, metadata) or (None, error_dict)
        """
        
        # Step 1: Submit composition request
        payload = {
            "prompt": {
                "text": prompt_text
            },
            "format": format_type,
            "looping": looping
        }

        headers = {
            "Authorization": f"Bearer {self.api_key}",
            "Content-Type": "application/json"
        }

        try:
            logger.info(f"Requesting song composition from Beatoven: {payload}")
            response = requests.post(
                f"{self.base_url}/api/v1/tracks/compose", 
                json=payload, 
                headers=headers
            )
            response.raise_for_status()
            result = response.json()

            task_id = result.get("task_id")
            if not task_id or result.get("status") != "composing":
                raise Exception(f"Failed to start composition: {result}")

            logger.info(f"Composition started with task_id: {task_id}")

            # Step 2: Poll for completion
            track_url = self._wait_for_composition(task_id, max_wait_time)
            
            if not track_url:
                raise Exception("Composition failed or timed out")

            # Step 3: Download the generated track
            filename = f"auragen_{uuid4().hex}.{format_type}"
            filepath = os.path.join(self.output_dir, filename)

            logger.info(f"Downloading track from: {track_url}")
            with requests.get(track_url, stream=True) as r:
                r.raise_for_status()
                with open(filepath, 'wb') as f:
                    for chunk in r.iter_content(chunk_size=8192):
                        f.write(chunk)

            logger.info(f"AuraGen track saved at {filepath}")
            
            # Return both the local filepath and metadata
            metadata = {
                "task_id": task_id,
                "prompt": prompt_text,
                "format": format_type,
                "looping": looping,
                "track_url": track_url
            }
            
            return filepath, metadata

        except requests.exceptions.RequestException as e:
            logger.error(f"HTTP error during AuraGen generation: {e}")
            return None, {"error": f"HTTP error: {str(e)}"}
        except Exception as e:
            logger.error(f"AuraGen generation failed: {e}")
            return None, {"error": str(e)}

    def _wait_for_composition(self, task_id, max_wait_time):
        """
        Poll the task status until completion or timeout
        
        Args:
            task_id (str): The task ID to monitor
            max_wait_time (int): Maximum time to wait in seconds
        
        Returns:
            str: The track URL if successful, None if failed/timeout
        """
        headers = {
            "Authorization": f"Bearer {self.api_key}",
        }
        
        start_time = time.time()
        poll_interval = 5  # Poll every 5 seconds
        
        while time.time() - start_time < max_wait_time:
            try:
                response = requests.get(
                    f"{self.base_url}/api/v1/tasks/{task_id}",
                    headers=headers
                )
                response.raise_for_status()
                result = response.json()
                
                status = result.get("status")
                logger.info(f"Task {task_id} status: {status}")
                
                if status == "composed":
                    track_url = result.get("meta", {}).get("track_url")
                    if track_url:
                        return track_url
                    else:
                        logger.error("Composition completed but no track URL found")
                        return None
                        
                elif status in ["composing", "running"]:
                    # Still processing, wait and poll again
                    time.sleep(poll_interval)
                    continue
                    
                else:
                    # Unknown status or error
                    logger.error(f"Unexpected task status: {status}")
                    return None
                    
            except requests.exceptions.RequestException as e:
                logger.error(f"Error polling task status: {e}")
                time.sleep(poll_interval)
                continue
        
        logger.error(f"Task {task_id} timed out after {max_wait_time} seconds")
        return None

    def get_task_status(self, task_id):
        """
        Get the current status of a composition task
        
        Args:
            task_id (str): The task ID to check
        
        Returns:
            dict: Task status information
        """
        headers = {
            "Authorization": f"Bearer {self.api_key}",
        }
        
        try:
            response = requests.get(
                f"{self.base_url}/api/v1/tasks/{task_id}",
                headers=headers
            )
            response.raise_for_status()
            return response.json()
        except Exception as e:
            logger.error(f"Error getting task status: {e}")
            return {"error": str(e)}