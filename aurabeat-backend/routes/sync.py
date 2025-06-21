# routes/sync.py

from flask import Blueprint, request, jsonify, g
from utils.auth import login_required

sync_bp = Blueprint('sync', __name__, url_prefix='/api/sync')

# In-memory store for demo purposes; replace with Redis or DB in production
playback_states = {}

@sync_bp.route('/state', methods=['POST'])
@login_required
def update_playback_state():
    """
    Update playback state for the authenticated user.
    """
    data = request.get_json()

    required_fields = {'track_id', 'position', 'is_playing'}
    if not data or not required_fields.issubset(data):
        return jsonify({'error': 'Missing fields'}), 400

    user_id = str(g.user_id)
    playback_states[user_id] = {
        'track_id': data['track_id'],
        'position': data['position'],
        'is_playing': data['is_playing']
    }

    return jsonify({'message': 'Playback state updated'}), 200


@sync_bp.route('/state', methods=['GET'])
@login_required
def get_playback_state():
    """
    Get the latest playback state for the authenticated user.
    """
    user_id = str(g.user_id)
    state = playback_states.get(user_id)
    if not state:
        return jsonify({'error': 'No state found'}), 404

    return jsonify(state), 200
