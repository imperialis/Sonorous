# from flask import Blueprint, request, jsonify, g
# from models.database import db
# from models.track import Track
# from services.auragen_service import AuraGenService
# from utils.auth import login_required
# import os

# auragen_bp = Blueprint("auragen", __name__, url_prefix="/api/auragen")

# # Add your Beatoven API key here or use an env variable
# API_KEY = os.getenv("BEATOVEN_API_KEY", "jKZ2mYlZZoYr9SmDzF1nXQ")
# auragen_service = AuraGenService(api_key=API_KEY)

# @auragen_bp.route("/generate", methods=["POST"])
# @login_required
# def generate_ai_track():
#     """
#     Generate a new AI song using Beatoven.
#     Payload: { "prompt": "mellow lo-fi", "lyrics": "optional text" }
#     """
#     data = request.get_json()
#     prompt = data.get("prompt")
#     lyrics = data.get("lyrics")

#     if not prompt:
#         return jsonify({"error": "Prompt is required"}), 400

#     filepath, metadata = auragen_service.generate_song(prompt, lyrics)

#     if not filepath:
#         return jsonify({"error": "Song generation failed", "details": metadata}), 500

#     new_track = Track(
#         title=f"AuraGen: {prompt[:40]}",
#         artist="AuraGen AI",
#         genre="AI Generated",
#         file_path=filepath,
#         lyrics=lyrics,
#         user_id=g.user_id
#     )
#     db.session.add(new_track)
#     db.session.commit()

#     return jsonify({
#         "message": "AI track generated successfully",
#         "track_id": new_track.id,
#         "file_path": filepath,
#         "metadata": metadata
#     }), 201

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
    Generate a new AI song using Beatoven.ai
    Payload: { 
        "prompt": "30 seconds peaceful lo-fi chill hop track",
        "format": "mp3",  // optional: mp3, aac, wav
        "looping": false  // optional: boolean
    }
    """
    data = request.get_json()
    prompt = data.get("prompt")
    format_type = data.get("format", "mp3")
    looping = data.get("looping", False)

    if not prompt:
        return jsonify({"error": "Prompt is required"}), 400

    # Validate format
    valid_formats = ["mp3", "aac", "wav"]
    if format_type not in valid_formats:
        return jsonify({
            "error": f"Invalid format. Must be one of: {', '.join(valid_formats)}"
        }), 400

    try:
        filepath, metadata = auragen_service.generate_song(
            prompt_text=prompt,
            format_type=format_type,
            looping=looping
        )

        if not filepath:
            return jsonify({
                "error": "Song generation failed", 
                "details": metadata
            }), 500

        # Create new track record
        new_track = Track(
            title=f"AuraGen: {prompt[:40]}...",
            artist="AuraGen AI",
            genre="AI Generated",
            file_path=filepath,
            lyrics=None,  # Beatoven doesn't support lyrics in their current API
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

    except Exception as e:
        return jsonify({
            "error": "Internal server error during track generation",
            "details": str(e)
        }), 500

@auragen_bp.route("/status/<task_id>", methods=["GET"])
@login_required
def check_task_status(task_id):
    """
    Check the status of a composition task
    """
    try:
        status_info = auragen_service.get_task_status(task_id)
        return jsonify(status_info), 200
    except Exception as e:
        return jsonify({
            "error": "Failed to get task status",
            "details": str(e)
        }), 500

@auragen_bp.route("/generate-async", methods=["POST"])
@login_required
def generate_ai_track_async():
    """
    Start an async AI song generation using Beatoven.ai
    Returns task_id immediately for status polling
    Payload: { 
        "prompt": "30 seconds peaceful lo-fi chill hop track",
        "format": "mp3",  // optional
        "looping": false  // optional
    }
    """
    data = request.get_json()
    prompt = data.get("prompt")
    format_type = data.get("format", "mp3")
    looping = data.get("looping", False)

    if not prompt:
        return jsonify({"error": "Prompt is required"}), 400

    # Validate format
    valid_formats = ["mp3", "aac", "wav"]
    if format_type not in valid_formats:
        return jsonify({
            "error": f"Invalid format. Must be one of: {', '.join(valid_formats)}"
        }), 400

    # Submit composition request (don't wait for completion)
    payload = {
        "prompt": {
            "text": prompt
        },
        "format": format_type,
        "looping": looping
    }

    headers = {
        "Authorization": f"Bearer {API_KEY}",
        "Content-Type": "application/json"
    }

    try:
        import requests
        response = requests.post(
            f"{auragen_service.base_url}/api/v1/tracks/compose", 
            json=payload, 
            headers=headers
        )
        response.raise_for_status()
        result = response.json()

        task_id = result.get("task_id")
        if not task_id or result.get("status") != "started":
            return jsonify({
                "error": "Failed to start composition", 
                "details": result
            }), 500

        return jsonify({
            "message": "Composition started",
            "task_id": task_id,
            "status": "started",
            "prompt": prompt
        }), 202

    except Exception as e:
        return jsonify({
            "error": "Failed to start composition",
            "details": str(e)
        }), 500