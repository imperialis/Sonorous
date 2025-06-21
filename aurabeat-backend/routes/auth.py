# # auth.py - Auto-generated stub

# # routes/auth.py

# from flask import Blueprint, request, jsonify
# from werkzeug.security import check_password_hash

# from models.database import db
# from models.user import User
# from services.auth_service import hash_password, generate_token

# auth_bp = Blueprint('auth', __name__, url_prefix='/api/auth')


# @auth_bp.route('/register', methods=['POST'])
# def register():
#     """
#     Register a new user account.
#     """
#     data = request.get_json()
#     username = data.get('username')
#     password = data.get('password')

#     if not username or not password:
#         return jsonify({'error': 'Username and password required'}), 400

#     if User.query.filter_by(username=username).first():
#         return jsonify({'error': 'Username already exists'}), 409

#     hashed_pw = hash_password(password)
#     #user = User(username=username, password=hashed_pw)
#     user = User(username=username, password_hash=hashed_pw)

#     db.session.add(user)
#     db.session.commit()

#     return jsonify({'message': 'User registered successfully'}), 201


# @auth_bp.route('/login', methods=['POST'])
# def login():
#     """
#     Authenticate user and return access token.
#     """
#     data = request.get_json()
#     username = data.get('username')
#     password = data.get('password')

#     if not username or not password:
#         return jsonify({'error': 'Username and password required'}), 400

#     user = User.query.filter_by(username=username).first()
#     # if not user or not check_password_hash(user.password, password):
#     if not user or not check_password_hash(user.password_hash, password):

#         return jsonify({'error': 'Invalid credentials'}), 401

#     token = generate_token(user.id)
#     return jsonify({'message': 'Login successful', 'token': token}), 200

# routes/auth.py

from flask import Blueprint, request, jsonify
from models.database import db
from models.user import User
from services.auth_service import hash_password, check_password, generate_token

auth_bp = Blueprint('auth', __name__, url_prefix='/api/auth')


@auth_bp.route('/register', methods=['POST'])
def register():
    """
    Register a new user account.
    """
    data = request.get_json()
    username = data.get('username')
    password = data.get('password')

    if not username or not password:
        return jsonify({'error': 'Username and password required'}), 400

    if User.query.filter_by(username=username).first():
        return jsonify({'error': 'Username already exists'}), 409

    hashed_pw = hash_password(password)
    user = User(username=username, password_hash=hashed_pw)

    db.session.add(user)
    db.session.commit()

    return jsonify({'message': 'User registered successfully'}), 201


@auth_bp.route('/login', methods=['POST'])
def login():
    """
    Authenticate user and return access token.
    """
    data = request.get_json()
    username = data.get('username')
    password = data.get('password')

    if not username or not password:
        return jsonify({'error': 'Username and password required'}), 400

    user = User.query.filter_by(username=username).first()
    if not user or not check_password(password, user.password_hash):
        return jsonify({'error': 'Invalid credentials'}), 401

    token = generate_token(user.id)
    return jsonify({'message': 'Login successful', 'token': token}), 200

