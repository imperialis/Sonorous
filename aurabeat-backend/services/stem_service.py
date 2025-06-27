# # # stem_service.py - Auto-generated stub

# # # services/stem_service.py

# import os
# import subprocess
# import logging
# from pathlib import Path

# logger = logging.getLogger(__name__)

# class StemService:
#     def __init__(self, model="htdemucs"):
#         """
#         Initialize the stem service using Demucs.
#         :param model: The Demucs model to use (e.g., htdemucs, mdx_extra_q)
#         """
#         self.model = model

#     def extract_stems_for_track(self, input_path, output_dir):
#         """
#         Run Demucs to separate the audio into stems.
#         :param input_path: Path to the input audio file
#         :param output_dir: Directory to save the separated stems
#         :return: True if successful, False otherwise
#         """
#         try:
#             os.makedirs(output_dir, exist_ok=True)
#             command = [
#                 "demucs",
#                 input_path,
#                 "-n", self.model,
#                 "-o", output_dir
#             ]
#             logger.info(f"Running Demucs command: {' '.join(command)}")
#             subprocess.run(command, check=True)
#             return True
#         except subprocess.CalledProcessError as e:
#             logger.error(f"[Demucs Error] Stem extraction failed: {e}")
#             return False

#     def get_stem_paths(self, input_path, output_dir):
#         """
#         Get paths to the extracted stem files.
#         :param input_path: Original file name (used to locate output dir)
#         :param output_dir: Directory where Demucs stores the separated stems
#         :return: Dict of stem type to file path
#         """
#         file_stem = Path(input_path).stem
#         # Output structure: output_dir / model_name / file_stem / stems.wav
#         stem_folder = Path(output_dir) / self.model / file_stem
#         if not stem_folder.exists():
#             logger.warning(f"Stem folder not found: {stem_folder}")
#             return {}

#         return {f.name: str(f) for f in stem_folder.glob("*.wav")}

##*****version 2********##
import os
import subprocess
import logging
from pathlib import Path
import librosa
import soundfile as sf
import numpy as np

logger = logging.getLogger(__name__)

class StemService:
    def __init__(self, model="htdemucs"):
        """
        Initialize the stem service using Demucs.
        :param model: The Demucs model to use (e.g., htdemucs, mdx_extra_q)
        """
        self.model = model

    def extract_stems_for_track(self, input_path, output_dir):
        """
        Run Demucs to separate the audio into stems.
        :param input_path: Path to the input audio file
        :param output_dir: Directory to save the separated stems
        :return: True if successful, False otherwise
        """
        try:
            os.makedirs(output_dir, exist_ok=True)
            command = [
                "demucs",
                input_path,
                "-n", self.model,
                "-o", output_dir
            ]
            logger.info(f"Running Demucs command: {' '.join(command)}")
            subprocess.run(command, check=True)
            return True
        except subprocess.CalledProcessError as e:
            logger.error(f"[Demucs Error] Stem extraction failed: {e}")
            return False

    def get_stem_paths(self, input_path, output_dir):
        """
        Get paths to the extracted stem files.
        :param input_path: Original file name (used to locate output dir)
        :param output_dir: Directory where Demucs stores the separated stems
        :return: Dict of stem type to file path
        """
        file_stem = Path(input_path).stem
        stem_folder = Path(output_dir) / self.model / file_stem
        if not stem_folder.exists():
            logger.warning(f"Stem folder not found: {stem_folder}")
            return {}

        return {f.name: str(f) for f in stem_folder.glob("*.wav")}

    def split_by_sections(self, audio_path, output_dir, stem_name="full"):
        """
        Analyze and split the given audio stem into musical sections.
        :param audio_path: Path to a .wav file (e.g., full mix or vocals stem)
        :param output_dir: Directory to save the sectioned audio clips
        :param stem_name: Label prefix for saved sections
        :return: List of saved section file paths
        """
        try:
            y, sr = librosa.load(audio_path, sr=None)
            logger.info(f"Analyzing {stem_name} stem for section segmentation")

            # Harmonic + Percussive separation (optional enhancement)
            y_harmonic, y_percussive = librosa.effects.hpss(y)

            # Compute structural features
            chroma = librosa.feature.chroma_cqt(y=y_harmonic, sr=sr)
            recurrence = librosa.segment.recurrence_matrix(chroma, mode='affinity')
            sequence = librosa.segment.path_enhance(recurrence, n=3)
            boundaries = librosa.segment.agglomerative(sequence, k=5)  # ~5 sections

            boundary_samples = librosa.frames_to_samples(boundaries)
            boundary_samples = np.append(boundary_samples, len(y))  # Add end

            os.makedirs(output_dir, exist_ok=True)
            saved_files = []

            for i in range(len(boundary_samples) - 1):
                start = boundary_samples[i]
                end = boundary_samples[i + 1]
                section_audio = y[start:end]

                filename = f"{stem_name}_section_{i+1}.wav"
                filepath = os.path.join(output_dir, filename)

                sf.write(filepath, section_audio, sr)
                saved_files.append(filepath)
                logger.info(f"Saved section {i+1}: {filepath}")

            return saved_files

        except Exception as e:
            logger.error(f"[Section Split Error] {e}")
            return []


