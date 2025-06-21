# metadata.py - Auto-generated stub

# routes/metadata.py

import os
from flask import Blueprint, request, jsonify
from models.database import db
from models.track import Track

from mutagen import File as MutagenFile
from tinytag import TinyTag

metadata_bp = Blueprint('metadata', __name__, url_prefix='/api/metadata')

@metadata_bp.route('/<int:track_id>', methods=['GET'])
def extract_metadata(track_id):
    """
    Extract metadata from a track by ID.
    """
    track = Track.query.get(track_id)
    if not track or not os.path.isfile(track.file_path):
        return jsonify({'error': 'Track not found or file missing'}), 404

    metadata = {
        'title': track.title,
        'artist': track.artist,
        'album': None,
        'duration': None,
        'bitrate': None,
        'genre': None,
        'year': None
    }

    try:
        tag = TinyTag.get(track.file_path)
        metadata.update({
            'title': tag.title or metadata['title'],
            'artist': tag.artist or metadata['artist'],
            'album': tag.album,
            'duration': tag.duration,
            'bitrate': tag.bitrate,
            'genre': tag.genre,
            'year': tag.year
        })
    except Exception as e:
        print(f"[TinyTag] Error: {e}")

    try:
        muta = MutagenFile(track.file_path, easy=True)
        if muta:
            metadata['title'] = muta.get('title', [metadata['title']])[0]
            metadata['artist'] = muta.get('artist', [metadata['artist']])[0]
            metadata['album'] = muta.get('album', [metadata['album']])[0]
            metadata['genre'] = muta.get('genre', [metadata['genre']])[0]
            metadata['year'] = muta.get('date', [metadata['year']])[0]
    except Exception as e:
        print(f"[Mutagen] Error: {e}")

    # Optional: Update DB with extracted metadata
    track.title = metadata['title']
    track.artist = metadata['artist']
    db.session.commit()

    return jsonify(metadata), 200
