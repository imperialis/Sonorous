# # remix_service.py - Auto-generated stub

# # services/remix_service.py
# # services/remix_service.py

# import os
# import logging
# from pydub import AudioSegment

# __all__ = ['RemixService', 'create_remix']

# remix_output_folder = "static/uploads/remixes/"
# os.makedirs(remix_output_folder, exist_ok=True)

# logger = logging.getLogger(__name__)


# class RemixService:
#     def __init__(self, stems_folder="static/uploads/stems/"):
#         self.stems_folder = stems_folder
#         os.makedirs(self.stems_folder, exist_ok=True)

#     def load_stems(self, track_id):
#         stems = {}
#         track_stem_dir = os.path.join(self.stems_folder, str(track_id))

#         if not os.path.exists(track_stem_dir):
#             logger.warning(f"Stems not found for track {track_id}")
#             return {}

#         for filename in os.listdir(track_stem_dir):
#             stem_name, ext = os.path.splitext(filename)
#             if ext.lower() in [".mp3", ".wav"]:
#                 path = os.path.join(track_stem_dir, filename)
#                 try:
#                     audio = AudioSegment.from_file(path)
#                     stems[stem_name] = audio
#                 except Exception as e:
#                     logger.error(f"Failed to load stem {filename}: {e}")

#         return stems

#     def mix_stems(self, stems: dict):
#         if not stems:
#             return None

#         logger.info("Mixing stems...")
#         base = None
#         for stem in stems.values():
#             if base is None:
#                 base = stem
#             else:
#                 base = base.overlay(stem)

#         return base

#     def export_mix(self, audio_segment, output_path):
#         try:
#             audio_segment.export(output_path, format="mp3")
#             logger.info(f"Exported remix to {output_path}")
#             return True
#         except Exception as e:
#             logger.error(f"Failed to export mix: {e}")
#             return False


# # Standalone function - NOT inside the class
# def create_remix(track_path, params):
#     """
#     Entry point for creating a remix. Loads stems, applies basic mixing,
#     and exports the combined track.
#     :param track_path: Original track file path
#     :param params: Remix parameters (currently unused)
#     :return: remix_path, remix_metadata
#     """
#     remix_service = RemixService()

#     # Derive track_id from filename
#     track_id = os.path.basename(track_path).split('.')[0]

#     stems = remix_service.load_stems(track_id)
#     if not stems:
#         raise Exception("No stems available for remixing.")

#     mixed_audio = remix_service.mix_stems(stems)
#     if mixed_audio is None:
#         raise Exception("Failed to mix stems.")

#     remix_filename = f"{track_id}_remix.mp3"
#     remix_path = os.path.join(remix_output_folder, remix_filename)
#     success = remix_service.export_mix(mixed_audio, remix_path)
#     if not success:
#         raise Exception("Export failed.")

#     remix_metadata = {
#         "duration_sec": len(mixed_audio) / 1000,
#         "num_stems": len(stems),
#         "settings_applied": params
#     }

#     return remix_path, remix_metadata

##*******version 2********##
import os
import logging
import json
from pydub import AudioSegment, effects
from pathlib import Path

logger = logging.getLogger(__name__)
remix_output_folder = "static/uploads/remixes/"
os.makedirs(remix_output_folder, exist_ok=True)


class RemixService:
    def __init__(self, stems_folder="static/uploads/stems/", sections_folder="static/uploads/sections/"):
        self.stems_folder = stems_folder
        self.sections_folder = sections_folder
        os.makedirs(self.stems_folder, exist_ok=True)
        os.makedirs(self.sections_folder, exist_ok=True)

    def load_audio_file(self, path):
        try:
            return AudioSegment.from_file(path)
        except Exception as e:
            logger.error(f"Failed to load audio file: {path} - {e}")
            return None

    def apply_effects(self, audio: AudioSegment, effects_config: dict) -> AudioSegment:
        if not audio or not effects_config:
            return audio

        try:
            if effects_config.get("normalize"):
                audio = effects.normalize(audio)
            if "volume_db" in effects_config:
                audio += effects_config["volume_db"]
            if "fade_in" in effects_config:
                audio = audio.fade_in(effects_config["fade_in"])
            if "fade_out" in effects_config:
                audio = audio.fade_out(effects_config["fade_out"])
            if effects_config.get("reverse"):
                audio = audio.reverse()
            if "tempo" in effects_config:
                tempo = effects_config["tempo"]
                if tempo > 0:
                    audio = self.change_tempo(audio, tempo)
        except Exception as e:
            logger.error(f"Failed to apply effects: {e}")

        return audio

    def change_tempo(self, audio: AudioSegment, factor: float) -> AudioSegment:
        try:
            new_frame_rate = int(audio.frame_rate * factor)
            audio = audio._spawn(audio.raw_data, overrides={'frame_rate': new_frame_rate})
            return audio.set_frame_rate(audio.frame_rate)
        except Exception as e:
            logger.error(f"Tempo change failed: {e}")
            return audio

    def compose_remix(self, structure, stems_folder, sections_folder=None):
        final_mix = AudioSegment.silent(duration=0)

        for part in structure:
            source = part.get("source")
            section = part.get("section")
            effects_cfg = part.get("effects", {})

            audio_segment = None

            if section and sections_folder:
                section_path = os.path.join(sections_folder, source, f"{section}.wav")
                if os.path.exists(section_path):
                    audio_segment = self.load_audio_file(section_path)

            if audio_segment is None:
                stem_path = os.path.join(stems_folder, source + ".wav")
                audio_segment = self.load_audio_file(stem_path)

            if audio_segment:
                audio_segment = self.apply_effects(audio_segment, effects_cfg)
                final_mix += audio_segment
            else:
                logger.warning(f"Missing audio for {source} - section: {section}")

        return final_mix if len(final_mix) > 0 else None

    def export_mix(self, audio_segment, output_path):
        try:
            audio_segment.export(output_path, format="mp3")
            logger.info(f"Remix exported to: {output_path}")
            return True
        except Exception as e:
            logger.error(f"Failed to export remix: {e}")
            return False


# 🔁 ENTRY POINT FUNCTION
def create_remix(track_path, params):
    """
    Entry point for remixing with provided structure and effects.
    :param track_path: Original uploaded track path
    :param params: Remix structure dictionary
    :return: remix_path, remix_metadata
    """
    remix_service = RemixService()

    track_id = os.path.basename(track_path).split('.')[0]
    stems_folder = os.path.join(remix_service.stems_folder, track_id)
    sections_folder = os.path.join(remix_service.sections_folder, track_id)

    structure = params.get("structure", [])

    if not structure:
        raise Exception("No remix structure provided.")

    mixed_audio = remix_service.compose_remix(structure, stems_folder, sections_folder)
    if mixed_audio is None:
        raise Exception("Failed to generate remix.")

    remix_filename = f"{track_id}_remix.mp3"
    remix_path = os.path.join(remix_output_folder, remix_filename)
    success = remix_service.export_mix(mixed_audio, remix_path)
    if not success:
        raise Exception("Export failed.")

    remix_metadata = {
        "duration_sec": len(mixed_audio) / 1000,
        "num_layers": len(structure),
        "structure_used": structure
    }

    return remix_path, remix_metadata

