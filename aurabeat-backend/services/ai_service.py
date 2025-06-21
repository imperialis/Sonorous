# # ai_service.py - Auto-generated stub

# # services/ai_service.py

# from transformers import pipeline
# import logging

# logger = logging.getLogger(__name__)

# class AIService:
#     def __init__(self):
#         try:
#             self.tag_pipeline = pipeline("zero-shot-classification", model="facebook/bart-large-mnli")
#         except Exception as e:
#             logger.warning(f"AI pipeline initialization failed: {e}")
#             self.tag_pipeline = None

#     def generate_tags(self, title: str, artist: str, candidate_labels=None):
#         """
#         Uses zero-shot classification to generate tags based on title and artist.
#         """
#         if not self.tag_pipeline:
#             return []

#         candidate_labels = candidate_labels or ["chill", "energetic", "acoustic", "electronic", "instrumental", "vocal", "happy", "sad"]
#         text = f"{title} by {artist}"
#         result = self.tag_pipeline(text, candidate_labels)
#         return [label for label, score in zip(result['labels'], result['scores']) if score > 0.6]

#     def get_lyrics_summary(self, lyrics_text: str):
#         """
#         Summarizes lyrics using a transformer summarization pipeline.
#         """
#         try:
#             summarizer = pipeline("summarization")
#             return summarizer(lyrics_text[:1024])[0]['summary_text']
#         except Exception as e:
#             logger.warning(f"Lyrics summarization failed: {e}")
#             return None

# services/ai_service.py

from transformers import pipeline
import logging

logger = logging.getLogger(__name__)

class AIService:
    def __init__(self):
        try:
            # Replaced bart-large-mnli with lighter distilbert-based model
            self.tag_pipeline = pipeline(
                "zero-shot-classification",
                model="typeform/distilbert-base-uncased-mnli"
            )
        except Exception as e:
            logger.warning(f"AI pipeline initialization failed: {e}")
            self.tag_pipeline = None

    def generate_tags(self, title: str, artist: str, candidate_labels=None):
        """
        Uses zero-shot classification to generate tags based on title and artist.
        """
        if not self.tag_pipeline:
            return []

        candidate_labels = candidate_labels or [
            "chill", "energetic", "acoustic", "electronic",
            "instrumental", "vocal", "happy", "sad"
        ]
        text = f"{title} by {artist}"
        result = self.tag_pipeline(text, candidate_labels)
        return [
            label for label, score in zip(result['labels'], result['scores']) if score > 0.6
        ]

    def get_lyrics_summary(self, lyrics_text: str):
        """
        Summarizes lyrics using a transformer summarization pipeline.
        """
        try:
            summarizer = pipeline("summarization")
            return summarizer(lyrics_text[:1024])[0]['summary_text']
        except Exception as e:
            logger.warning(f"Lyrics summarization failed: {e}")
            return None

