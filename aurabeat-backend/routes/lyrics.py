# # # lyrics.py - Auto-generated stub

# # # routes/lyrics.py

# # from flask import Blueprint, jsonify, request
# # from models.database import db
# # from models.track import Track
# # from services.lyrics_service import LyricsService
# # import os
# # lyrics_bp = Blueprint('lyrics', __name__, url_prefix='/api/lyrics')


# # @lyrics_bp.route('/<int:track_id>/transcribe', methods=['POST'])
# # def generate_lyrics(track_id):
# #     """
# #     Generate lyrics using AI transcription.
# #     """
# #     track = Track.query.get(track_id)
# #     if not track:
# #         return jsonify({'error': 'Track not found'}), 404

# #     try:
# #         lyrics_service = LyricsService()
# #         #lyrics = LyricsService.transcribe_audio(track.file_path)
# #         lyrics = lyrics_service.transcribe_audio(track.file_path)
# #         # For demonstration, let's save it to a temporary path.
# #         output_dir = 'transcribed_lyrics'
# #         os.makedirs(output_dir, exist_ok=True) # Ensure directory exists
# #         lyrics_output_path = os.path.join(output_dir, f'track_{track_id}_lyrics.txt')
        
# #         # Save lyrics using the instance method
# #         lyrics_service.export_lyrics(lyrics, lyrics_output_path) # Changed to use export_lyrics
# #         #save_lyrics(track, lyrics)#revisit this method call l8r.
# #         return jsonify({'message': 'Lyrics generated', 'lyrics': lyrics}), 200

# #     except Exception as e:
# #         print(f"[Lyrics Error] {e}")
# #         return jsonify({'error': 'Transcription failed'}), 500


# # @lyrics_bp.route('/<int:track_id>/edit', methods=['POST'])
# # def edit_lyrics(track_id):
# #     """
# #     Edit or update lyrics manually.
# #     """
# #     data = request.get_json()
# #     lyrics = data.get('lyrics')

# #     if not lyrics:
# #         return jsonify({'error': 'No lyrics provided'}), 400

# #     track = Track.query.get(track_id)
# #     if not track:
# #         return jsonify({'error': 'Track not found'}), 404

# #     try:
# #         lyrics_service = LyricsService()
# #         lyrics_service.save_lyrics(track, lyrics)#this method doesnt exist yet.
# #         return jsonify({'message': 'Lyrics updated'}), 200

# #     except Exception as e:
# #         print(f"[Lyrics Edit Error] {e}")
# #         return jsonify({'error': 'Failed to update lyrics'}), 500
# ###version 2####
# from flask import Blueprint, jsonify, request, send_file
# from models.track import Track
# from services.lyrics_service import LyricsService
# import os

# lyrics_bp = Blueprint('lyrics', __name__, url_prefix='/api/lyrics')


# @lyrics_bp.route('/<int:track_id>/transcribe', methods=['POST'])
# def generate_lyrics(track_id):
#     track = Track.query.get(track_id)
#     if not track:
#         return jsonify({'error': 'Track not found'}), 404

#     try:
#         lyrics_service = LyricsService()
#         lyrics = lyrics_service.transcribe_audio(track.file_path)

#         if not lyrics:
#             return jsonify({'error': 'No lyrics extracted'}), 500

#         if not lyrics_service.save_lyrics_to_db(track_id, lyrics):
#             return jsonify({'error': 'Failed to save lyrics to database'}), 500

#         return jsonify({'message': 'Lyrics generated and saved', 'lyrics': lyrics}), 200

#     except Exception as e:
#         print(f"[Lyrics Error] {e}")
#         return jsonify({'error': 'Transcription failed'}), 500


# @lyrics_bp.route('/<int:track_id>/edit', methods=['POST'])
# def edit_lyrics(track_id):
#     data = request.get_json()
#     lyrics = data.get('lyrics')

#     if not lyrics:
#         return jsonify({'error': 'No lyrics provided'}), 400

#     try:
#         lyrics_service = LyricsService()
#         if not lyrics_service.save_lyrics_to_db(track_id, lyrics):
#             return jsonify({'error': 'Failed to update lyrics in database'}), 500

#         return jsonify({'message': 'Lyrics updated successfully'}), 200

#     except Exception as e:
#         print(f"[Lyrics Edit Error] {e}")
#         return jsonify({'error': 'Failed to update lyrics'}), 500


# @lyrics_bp.route('/<int:track_id>', methods=['GET'])
# def get_lyrics(track_id):
#     """
#     Get saved lyrics from the database.
#     """
#     track = Track.query.get(track_id)
#     if not track:
#         return jsonify({'error': 'Track not found'}), 404

#     if not track.lyrics:
#         return jsonify({'error': 'No lyrics available'}), 404

#     return jsonify({'lyrics': track.lyrics}), 200


# @lyrics_bp.route('/<int:track_id>/export', methods=['GET'])
# def export_lyrics_file(track_id):
#     """
#     Export lyrics to a .txt file and serve it.
#     """
#     track = Track.query.get(track_id)
#     if not track:
#         return jsonify({'error': 'Track not found'}), 404

#     if not track.lyrics:
#         return jsonify({'error': 'No lyrics to export'}), 404

#     try:
#         output_dir = 'static/exports/lyrics'
#         os.makedirs(output_dir, exist_ok=True)
#         file_path = os.path.join(output_dir, f'track_{track_id}_lyrics.txt')

#         with open(file_path, 'w', encoding='utf-8') as f:
#             f.write(track.lyrics)

#         return send_file(file_path, as_attachment=True)

#     except Exception as e:
#         print(f"[Export Error] {e}")
#         return jsonify({'error': 'Failed to export lyrics'}), 500

####version 3#####
from flask import Blueprint, jsonify, request, send_file
from models.track import Track
from services.lyrics_service import LyricsService
import os

lyrics_bp = Blueprint('lyrics', __name__, url_prefix='/api/lyrics')


@lyrics_bp.route('/<int:track_id>/transcribe', methods=['POST'])
def generate_lyrics(track_id):
    track = Track.query.get(track_id)
    if not track:
        return jsonify({'error': 'Track not found'}), 404

    try:
        lyrics_service = LyricsService()
        lyrics = lyrics_service.transcribe_audio(track.file_path)

        if not lyrics:
            return jsonify({'error': 'No lyrics extracted'}), 500

        if not lyrics_service.save_lyrics_to_db(track_id, lyrics):
            return jsonify({'error': 'Failed to save lyrics to database'}), 500

        track = Track.query.get(track_id)  # Refresh with updated lyrics
        return jsonify({
            'message': 'Lyrics generated and saved',
            'lyrics': track.serialize()
        }), 200

    except Exception as e:
        print(f"[Lyrics Error] {e}")
        return jsonify({'error': 'Transcription failed'}), 500


@lyrics_bp.route('/<int:track_id>/edit', methods=['POST'])
def edit_lyrics(track_id):
    data = request.get_json()
    lyrics = data.get('lyrics')

    if not lyrics:
        return jsonify({'error': 'No lyrics provided'}), 400

    try:
        lyrics_service = LyricsService()
        if not lyrics_service.save_lyrics_to_db(track_id, lyrics):
            return jsonify({'error': 'Failed to update lyrics in database'}), 500

        track = Track.query.get(track_id)
        return jsonify({
            'message': 'Lyrics updated successfully',
            'lyrics': track.serialize()
        }), 200

    except Exception as e:
        print(f"[Lyrics Edit Error] {e}")
        return jsonify({'error': 'Failed to update lyrics'}), 500


@lyrics_bp.route('/<int:track_id>', methods=['GET'])
def get_lyrics(track_id):
    track = Track.query.get(track_id)
    if not track:
        return jsonify({'error': 'Track not found'}), 404

    if not track.lyrics:
        return jsonify({'error': 'No lyrics available'}), 404

    return jsonify({'lyrics': track.serialize()}), 200


# @lyrics_bp.route('/<int:track_id>/export', methods=['GET'])
# def export_lyrics_file(track_id):
#     track = Track.query.get(track_id)
#     if not track:
#         return jsonify({'error': 'Track not found'}), 404

#     if not track.lyrics:
#         return jsonify({'error': 'No lyrics to export'}), 404

#     try:
#         output_dir = 'static/exports/lyrics'
#         os.makedirs(output_dir, exist_ok=True)
#         file_path = os.path.join(output_dir, f'track_{track_id}_lyrics.txt')

    #     with open(file_path, 'w', encoding='utf-8') as f:
    #         f.write(track.lyrics)

    #     return send_file(file_path, as_attachment=True)

    # except Exception as e:
    #     print(f"[Export Error] {e}")
    #     return jsonify({'error': 'Failed to export lyrics'}), 500
##version 2###
# @lyrics_bp.route('/<int:track_id>/export', methods=['GET'])
# def export_lyrics_file(track_id):
#     track = Track.query.get(track_id)
#     if not track:
#         return jsonify({'error': 'Track not found'}), 404

#     if not track.lyrics:
#         return jsonify({'error': 'No lyrics to export'}), 404

    # try:
    #     output_dir = 'static/exports/lyrics'
    #     os.makedirs(output_dir, exist_ok=True)
    #     file_path = os.path.join(output_dir, f'track_{track_id}_lyrics.txt')

    #     with open(file_path, 'w', encoding='utf-8') as f:
    #         f.write(track.lyrics)

    #     return send_file(
    #         file_path,
    #         as_attachment=True,
    #         download_name=f'track_{track_id}_lyrics.txt',  # Ensures correct filename in browser
    #         mimetype='text/plain'  # Helps with browser compatibility
    #     )

    # except Exception as e:
    #     print(f"[Export Error] {e}")
    #     return jsonify({'error': 'Failed to export lyrics'}), 500

@lyrics_bp.route('/<int:track_id>/export', methods=['GET'])
def export_lyrics_file(track_id):
    track = Track.query.get(track_id)
    if not track:
        return jsonify({'error': 'Track not found'}), 404

    if not track.lyrics:
        return jsonify({'error': 'No lyrics to export'}), 404

    try:
        lyrics_service = LyricsService()
        output_dir = os.path.join('static', 'exports', 'lyrics')
        os.makedirs(output_dir, exist_ok=True)  # Ensure directory exists

        file_name = f'track_{track_id}_lyrics.txt'
        output_path = os.path.join(output_dir, file_name)

        file_path = lyrics_service.export_lyrics(track.lyrics, output_path)
        if not file_path:
            return jsonify({'error': 'Failed to export lyrics'}), 500

        # Return URL that frontend can request directly
        #download_url = f'/static/exports/lyrics/{file_name}'
        download_url = f'exports/lyrics/{file_name}'

        return jsonify({
            'message': 'Lyrics exported successfully',
            'download_url': download_url
        }), 200

    except Exception as e:
        print(f"[Export Error] {e}")
        return jsonify({'error': 'Failed to export lyrics'}), 500
