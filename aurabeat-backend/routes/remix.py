# # # routes/remix.py

# # from flask import Blueprint, jsonify, request, g
# # from models.database import db
# # from models.remix import Remix
# # from models.track import Track
# # from services.remix_service import create_remix
# # from utils.auth import login_required
# # import json

# # remix_bp = Blueprint('remix', __name__, url_prefix='/api/remix')


# # @remix_bp.route('/<int:track_id>', methods=['POST'])
# # @login_required
# # def remix_track(track_id):
# #     """
# #     Initiate remix creation for a track (e.g., modify tempo, pitch, structure).
# #     """
# #     track = Track.query.filter_by(id=track_id, user_id=g.user_id).first()
# #     if not track:
# #         return jsonify({'error': 'Track not found or access denied'}), 404

# #     params = request.json or {}

# #     try:
# #         remix_path, remix_metadata = create_remix(track.file_path, params)

# #         new_remix = Remix(
# #             track_id=track_id,
# #             remix_path=remix_path,
# #             settings=json.dumps(params),  # JSON serialize settings
# #             metadata=remix_metadata
# #         )
# #         db.session.add(new_remix)
# #         db.session.commit()

# #         return jsonify({
# #             'message': 'Remix created',
# #             'remix_id': new_remix.id,
# #             'remix_path': remix_path
# #         }), 201

# #     except Exception as e:
# #         print(f"[Remix Error] {e}")
# #         return jsonify({'error': 'Remix creation failed'}), 500

# ##******version 2******##
# from flask import Blueprint, jsonify, request, g
# from models.database import db
# from models.remix import Remix
# from models.track import Track
# from services.remix_service import RemixService
# from utils.auth import login_required
# import json
# import os

# remix_bp = Blueprint('remix', __name__, url_prefix='/api/remix')


# @remix_bp.route('/<int:track_id>', methods=['POST'])
# @login_required
# def remix_track(track_id):
#     """
#     Create a remix by recombining stems and sections based on user-defined structure.
#     Expected JSON params:
#     {
#         "structure": [
#             {"source": "vocals", "section": "chorus"},
#             {"source": "drums", "section": "verse"},
#             {"source": "bass"},
#             ...
#         ]
#     }
#     """
#     track = Track.query.filter_by(id=track_id, user_id=g.user_id).first()
#     if not track:
#         return jsonify({'error': 'Track not found or access denied'}), 404

#     params = request.get_json() or {}
#     structure = params.get('structure')

#     if not structure or not isinstance(structure, list):
#         return jsonify({'error': 'Invalid or missing remix structure'}), 400

#     try:
#         remix_service = RemixService()
#         stems_dir = f"static/uploads/stems/{track_id}/"
#         sections_dir = os.path.join(stems_dir, "sections")
#         output_dir = "static/uploads/remixes/"
#         os.makedirs(output_dir, exist_ok=True)

#         remix_audio = remix_service.compose_remix(
#             structure=structure,
#             stems_folder=stems_dir,
#             sections_folder=sections_dir
#         )

#         if remix_audio is None:
#             raise Exception("Failed to generate remix audio")

#         remix_filename = f"track_{track_id}_remix.mp3"
#         remix_path = os.path.join(output_dir, remix_filename)
#         remix_service.export_mix(remix_audio, remix_path)

#         new_remix = Remix(
#             track_id=track_id,
#             remix_path=remix_path,
#             settings=json.dumps(params),
#             metadata={
#                 "structure": structure,
#                 "duration_sec": len(remix_audio) / 1000,
#                 "source_track_id": track_id
#             }
#         )

#         db.session.add(new_remix)
#         db.session.commit()

#         return jsonify({
#             'message': 'Remix created',
#             'remix_id': new_remix.id,
#             'remix_path': remix_path
#         }), 201

#     except Exception as e:
#         print(f"[Remix Error] {e}")
#         return jsonify({'error': 'Remix creation failed'}), 500

##*******version 3*******##
from flask import Blueprint, jsonify, request, g
from models.database import db
from models.remix import Remix
from models.track import Track
from services.remix_service import RemixService
from utils.auth import login_required
import json
import os

remix_bp = Blueprint('remix', __name__, url_prefix='/api/remix')


@remix_bp.route('/<int:track_id>', methods=['POST'])
@login_required
def remix_track(track_id):
    """
    Create a remix by recombining stems and sections with optional audio effects.
    Expected JSON:
    {
        "structure": [
            {
                "source": "vocals",
                "section": "chorus",            # optional
                "effects": {                    # optional
                    "volume_db": 3,
                    "fade_in": 1000,
                    "tempo": 1.05,
                    "normalize": true
                }
            },
            ...
        ]
    }
    """
    track = Track.query.filter_by(id=track_id, user_id=g.user_id).first()
    if not track:
        return jsonify({'error': 'Track not found or access denied'}), 404

    params = request.get_json() or {}
    structure = params.get('structure')

    if not structure or not isinstance(structure, list):
        return jsonify({'error': 'Invalid or missing remix structure'}), 400

    try:
        remix_service = RemixService()
        stems_dir = os.path.join("static", "uploads", "stems", str(track_id))
        sections_dir = os.path.join("static", "uploads", "sections", str(track_id))
        output_dir = os.path.join("static", "uploads", "remixes")
        os.makedirs(output_dir, exist_ok=True)

        # Build the remix audio
        remix_audio = remix_service.compose_remix(
            structure=structure,
            stems_folder=stems_dir,
            sections_folder=sections_dir
        )

        if not remix_audio:
            raise Exception("Failed to generate remix audio.")

        # Export to file
        remix_filename = f"track_{track_id}_remix.mp3"
        remix_path = os.path.join(output_dir, remix_filename)
        if not remix_service.export_mix(remix_audio, remix_path):
            raise Exception("Failed to export remix.")

        # Save to DB
        new_remix = Remix(
            name=f"{track.title} Remix",
            description="Auto-generated remix with custom structure.",
            remix_file_path=remix_path,
            original_track_id=track_id,
            user_id=g.user_id,
        )
        db.session.add(new_remix)
        db.session.commit()

        return jsonify({
            "message": "Remix created successfully.",
            "remix_id": new_remix.id,
            "remix_path": remix_path
        }), 201

    except Exception as e:
        print(f"[Remix Error] {e}")
        return jsonify({'error': 'Remix creation failed'}), 500
