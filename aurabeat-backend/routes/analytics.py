# analytics.py - Auto-generated stub

# routes/analytics.py

from flask import Blueprint, request, jsonify
from datetime import datetime
import os
import json

analytics_bp = Blueprint('analytics', __name__, url_prefix='/api/analytics')

# For demo purposes, logs are written to a JSONL file
LOG_FILE = 'static/analytics/usage_logs.jsonl'

# Ensure the directory exists
os.makedirs(os.path.dirname(LOG_FILE), exist_ok=True)

@analytics_bp.route('/log', methods=['POST'])
def log_event():
    """
    Log a user interaction or system event.
    """
    data = request.get_json()
    if not data or 'event' not in data:
        return jsonify({'error': 'Missing event type'}), 400

    log_entry = {
        'timestamp': datetime.utcnow().isoformat(),
        'event': data['event'],
        'user_id': data.get('user_id'),
        'track_id': data.get('track_id'),
        'details': data.get('details', {})
    }

    with open(LOG_FILE, 'a') as f:
        f.write(json.dumps(log_entry) + '\n')

    return jsonify({'message': 'Event logged'}), 201


@analytics_bp.route('/summary', methods=['GET'])
def analytics_summary():
    """
    Get a simple summary of recent analytics.
    """
    if not os.path.exists(LOG_FILE):
        return jsonify({'summary': {}, 'total_events': 0})

    event_counts = {}
    with open(LOG_FILE, 'r') as f:
        for line in f:
            entry = json.loads(line)
            event = entry['event']
            event_counts[event] = event_counts.get(event, 0) + 1

    return jsonify({
        'summary': event_counts,
        'total_events': sum(event_counts.values())
    })
