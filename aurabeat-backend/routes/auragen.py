from flask import Blueprint, request, jsonify, g
from models.database import db
from models.track import Track
from services.auragen_service import AuraGenService
from utils.auth import login_required
import os

auragen_bp = Blueprint("auragen", __name__, url_prefix="/api/auragen")

# Add your Beatoven API key here or use an env variable
API_KEY = os.getenv("BEATOVEN_API_KEY", "jKZ2mYlZZoYr9SmDzF1nXQ")
auragen_service = AuraGenService(api_key=API_KEY)

@auragen_bp.route("/generate", methods=["POST"])
@login_required
def generate_ai_track():
    """
    Generate a new AI song using Beatoven.
    Payload: { "prompt": "mellow lo-fi", "lyrics": "optional text" }
    """
    data = request.get_json()
    prompt = data.get("prompt")
    lyrics = data.get("lyrics")

    if not prompt:
        return jsonify({"error": "Prompt is required"}), 400

    filepath, metadata = auragen_service.generate_song(prompt, lyrics)

    if not filepath:
        return jsonify({"error": "Song generation failed", "details": metadata}), 500

    new_track = Track(
        title=f"AuraGen: {prompt[:40]}",
        artist="AuraGen AI",
        genre="AI Generated",
        file_path=filepath,
        lyrics=lyrics,
        user_id=g.user_id
    )
    db.session.add(new_track)
    db.session.commit()

    return jsonify({
        "message": "AI track generated successfully",
        "track_id": new_track.id,
        "file_path": filepath,
        "metadata": metadata
    }), 201
