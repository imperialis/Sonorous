# utils/auth.py

from functools import wraps
from flask import request, jsonify, g
from services.auth_service import AuthService

def login_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        auth_header = request.headers.get('Authorization', None)
        if not auth_header:
            return jsonify({'error': 'Authorization header missing'}), 401

        try:
            token = auth_header.split(" ")[1]
            decoded = AuthService.verify_token(token)
            g.user_id = decoded.get('user_id')
            if not g.user_id:
                return jsonify({'error': 'Invalid token payload'}), 401
        except (IndexError, ValueError) as e:
            return jsonify({'error': str(e)}), 401

        return f(*args, **kwargs)
    return decorated_function
