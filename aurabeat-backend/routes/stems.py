# # # routes/stems.py

# # from flask import Blueprint, jsonify, g
# # from models.database import db
# # from models.track import Track
# # from services.stem_service import extract_stems_for_track
# # from utils.auth import login_required

# # stems_bp = Blueprint('stems', __name__, url_prefix='/api/stems')


# # @stems_bp.route('/<int:track_id>', methods=['POST'])
# # @login_required
# # def extract_stems(track_id):
# #     """
# #     Extract stems (e.g., vocals, drums, bass) from an uploaded track.
# #     """
# #     track = Track.query.filter_by(id=track_id, user_id=g.user_id).first()
# #     if not track:
# #         return jsonify({'error': 'Track not found or access denied'}), 404

# #     try:
# #         stem_paths = stem_service.extract_stems_for_track(track.file_path)  # note underscore in file_path

# #         return jsonify({
# #             'message': 'Stems extracted successfully',
# #             'stems': stem_paths
# #         }), 200

# #     except Exception as e:
# #         print(f"[Stem Error] {e}")
# #         return jsonify({'error': 'Stem extraction failed'}), 500
# ##***********version 2**********##
# from flask import Blueprint, jsonify, g
# from models.database import db
# from models.track import Track
# from services.stem_service import StemService  # FIX: import the class
# from utils.auth import login_required

# stems_bp = Blueprint('stems', __name__, url_prefix='/api/stems')


# @stems_bp.route('/<int:track_id>', methods=['POST'])
# @login_required
# def extract_stems(track_id):
#     """
#     Extract stems (e.g., vocals, drums, bass) from an uploaded track.
#     """
#     track = Track.query.filter_by(id=track_id, user_id=g.user_id).first()
#     if not track:
#         return jsonify({'error': 'Track not found or access denied'}), 404

#     try:
#         stem_service = StemService()
#         output_dir = f"static/uploads/stems/{track_id}/"
#         success = stem_service.extract_stems_for_track(track.file_path, output_dir)

#         if not success:
#             raise Exception("Stem extraction failed")

#         stem_paths = stem_service.get_stem_paths(track.file_path, output_dir)

#         return jsonify({
#             'message': 'Stems extracted successfully',
#             'stems': stem_paths
#         }), 200

#     except Exception as e:
#         print(f"[Stem Error] {e}")
#         return jsonify({'error': 'Stem extraction failed'}), 500

# ##******version 3*******##

from flask import Blueprint, jsonify, g
from models.database import db
from models.track import Track
from services.stem_service import StemService
from utils.auth import login_required
import os
from pathlib import Path

stems_bp = Blueprint('stems', __name__, url_prefix='/api/stems')


@stems_bp.route('/<int:track_id>', methods=['POST'])
@login_required
def extract_stems(track_id):
    """
    Extract stems (e.g., vocals, drums, bass) from an uploaded track.
    """
    track = Track.query.filter_by(id=track_id, user_id=g.user_id).first()
    if not track:
        return jsonify({'error': 'Track not found or access denied'}), 404

    try:
        stem_service = StemService()
        output_dir = f"static/uploads/stems/{track_id}/"
        os.makedirs(output_dir, exist_ok=True)

        success = stem_service.extract_stems_for_track(track.file_path, output_dir)
        if not success:
            raise Exception("Stem extraction failed")

        stem_paths = stem_service.get_stem_paths(track.file_path, output_dir)

        return jsonify({
            'message': 'Stems extracted successfully',
            'stems': stem_paths
        }), 200

    except Exception as e:
        print(f"[Stem Error] {e}")
        return jsonify({'error': 'Stem extraction failed'}), 500


@stems_bp.route('/<int:track_id>/sections', methods=['POST'])
@login_required
def extract_stems_and_sections(track_id):
    """
    Extract stems and split relevant ones (e.g., vocals) into musical sections.
    """
    track = Track.query.filter_by(id=track_id, user_id=g.user_id).first()
    if not track:
        return jsonify({'error': 'Track not found or access denied'}), 404

    try:
        stem_service = StemService()
        output_dir = f"static/uploads/stems/{track_id}/"
        os.makedirs(output_dir, exist_ok=True)

        success = stem_service.extract_stems_for_track(track.file_path, output_dir)
        if not success:
            raise Exception("Stem extraction failed")

        stem_paths = stem_service.get_stem_paths(track.file_path, output_dir)

        sectioned_paths = {}
        section_dir = os.path.join(output_dir, "sections")
        os.makedirs(section_dir, exist_ok=True)

        for filename, path in stem_paths.items():
            if 'vocals' in filename.lower():  # You can expand this rule
                stem_name = Path(filename).stem
                sections = stem_service.split_by_sections(path, section_dir, stem_name=stem_name)
                sectioned_paths[filename] = sections

        return jsonify({
            'message': 'Stems and sections extracted successfully',
            'stems': stem_paths,
            'sections': sectioned_paths
        }), 200

    except Exception as e:
        print(f"[Section Error] {e}")
        return jsonify({'error': 'Stem and section extraction failed'}), 500

