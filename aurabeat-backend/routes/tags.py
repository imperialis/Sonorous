# routes/tags.py

from flask import Blueprint, request, jsonify, g
from models.database import db
from models.track import Track
from models.tag import Tag
# from services.ai_service import generate_tags
from services.ai_service import AIService
from utils.auth import login_required

tags_bp = Blueprint('tags', __name__, url_prefix='/api/tags')

ai_service = AIService()
@tags_bp.route('/<int:track_id>', methods=['POST'])
@login_required
def add_manual_tags(track_id):
    """
    Add manual tags to a track.
    """
    track = Track.query.filter_by(id=track_id, user_id=g.user_id).first()
    if not track:
        return jsonify({'error': 'Track not found or access denied'}), 404

    data = request.get_json()
    tags = data.get('tags', [])

    if not isinstance(tags, list) or not tags:
        return jsonify({'error': 'No tags provided'}), 400

    for tag_name in tags:
        tag = Tag(track_id=track_id, name=tag_name, is_ai_generated=False)
        db.session.add(tag)

    db.session.commit()

    return jsonify({'message': 'Tags added successfully'}), 201


@tags_bp.route('/generate/<int:track_id>', methods=['POST'])
@login_required
def generate_ai_tags(track_id):
    """
    Generate AI-based tags for a track using audio analysis.
    """
    track = Track.query.filter_by(id=track_id, user_id=g.user_id).first()
    if not track:
        return jsonify({'error': 'Track not found or access denied'}), 404

    try:
        ai_tags = ai_service.generate_tags(track.file_path, track.artist)
        #ai_tags = ai_service.generate_tags(track.file_path)  # note: file_path field name corrected
        #ai_tags = generate_tags_for_track(track.file_path)  # note: file_path field name corrected
        for tag_name in ai_tags:
            tag = Tag(track_id=track_id, name=tag_name, is_ai_generated=True)
            db.session.add(tag)

        db.session.commit()

        return jsonify({'message': 'AI tags generated', 'tags': ai_tags}), 201

    except Exception as e:
        print(f"[Tagging Error] {e}")
        return jsonify({'error': 'Failed to generate tags'}), 500
