# # lyrics_service.py - Auto-generated stub

# # services/lyrics_service.py

# import os
# import logging
# import whisper  # OpenAI Whisper

# logger = logging.getLogger(__name__)

# class LyricsService:
#     def __init__(self, model_name="base"):
#         """
#         Initialize the ASR model (Whisper).
#         :param model_name: Whisper model variant (tiny, base, small, medium, large)
#         """
#         logger.info(f"Loading Whisper model: {model_name}")
#         self.model = whisper.load_model(model_name)

#     def transcribe_audio(self, audio_path):
#         """
#         Transcribe lyrics from an audio file.
#         :param audio_path: Path to the audio file (.mp3, .wav, etc.)
#         :return: A string containing the transcribed lyrics
#         """
#         if not os.path.exists(audio_path):
#             logger.error(f"Audio file not found: {audio_path}")
#             return ""

#         try:
#             logger.info(f"Transcribing audio: {audio_path}")
#             result = self.model.transcribe(audio_path)
#             return result.get("text", "")
#         except Exception as e:
#             logger.error(f"Transcription failed: {e}")
#             return ""

#     def export_lyrics(self, lyrics_text, output_path):
#         """
#         Save transcribed lyrics to a .txt file.
#         :param lyrics_text: The text to write
#         :param output_path: File path to save lyrics
#         :return: True on success, False on failure
#         """
#         try:
#             with open(output_path, "w", encoding="utf-8") as f:
#                 f.write(lyrics_text)
#             logger.info(f"Lyrics saved to: {output_path}")
#             return True
#         except Exception as e:
#             logger.error(f"Failed to save lyrics: {e}")
#             return False

#####****version 2*****#####
import os
import logging
import whisper  # OpenAI Whisper

from models.database import db
from models.track import Track

logger = logging.getLogger(__name__)

class LyricsService:
    def __init__(self, model_name="base"):
        """
        Initialize the ASR model (Whisper).
        :param model_name: Whisper model variant (tiny, base, small, medium, large)
        """
        logger.info(f"Loading Whisper model: {model_name}")
        self.model = whisper.load_model(model_name)

    def transcribe_audio(self, audio_path):
        """
        Transcribe lyrics from an audio file.
        :param audio_path: Path to the audio file (.mp3, .wav, etc.)
        :return: A string containing the transcribed lyrics
        """
        if not os.path.exists(audio_path):
            logger.error(f"Audio file not found: {audio_path}")
            return ""

        try:
            logger.info(f"Transcribing audio: {audio_path}")
            result = self.model.transcribe(audio_path)
            return result.get("text", "")
        except Exception as e:
            logger.error(f"Transcription failed: {e}")
            return ""

    def save_lyrics_to_db(self, track_id, lyrics_text):
        """
        Save transcribed lyrics directly into the Track record.
        :param track_id: ID of the track in the database
        :param lyrics_text: Transcribed lyrics
        :return: True on success, False on failure
        """
        try:
            track = Track.query.get(track_id)
            if not track:
                logger.error(f"No track found with ID: {track_id}")
                return False

            track.lyrics = lyrics_text
            db.session.commit()
            logger.info(f"Lyrics saved to DB for track ID: {track_id}")
            return True
        except Exception as e:
            logger.error(f"Failed to save lyrics to DB: {e}")
            db.session.rollback()
            return False

    def export_lyrics(self, lyrics_text, output_path):
        """
        Optional: Save lyrics to a file instead of the DB.
        """
        try:
            with open(output_path, "w", encoding="utf-8") as f:
                f.write(lyrics_text)
            logger.info(f"Lyrics saved to: {output_path}")
            return True
        except Exception as e:
            logger.error(f"Failed to save lyrics: {e}")
            return False
