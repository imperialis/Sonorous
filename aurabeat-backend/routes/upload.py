# routes/upload.py

import os
from flask import Blueprint, request, jsonify, g
from werkzeug.utils import secure_filename
import json

from models.database import db
from models.track import Track
from utils.file_utils import save_uploaded_file
from utils.auth import login_required

upload_bp = Blueprint('upload', __name__, url_prefix='/api/upload')

UPLOAD_FOLDER = 'static/uploads/'

@upload_bp.route('/', methods=['POST'])
@login_required
def upload_file():
    """
    Upload an audio file.
    ---
    tags:
      - Upload
    """
    if 'file' not in request.files:
        return jsonify({'error': 'No file part in request'}), 400

    file = request.files['file']
    if file.filename == '':
        return jsonify({'error': 'No selected file'}), 400

    filename = secure_filename(file.filename)
    file_path = os.path.join(UPLOAD_FOLDER, filename)

    save_uploaded_file(file, file_path)

    # Use user_id from token
    user_id = g.user_id

    new_track = Track(
        title=os.path.splitext(filename)[0],
        artist="Unknown",
        file_path=file_path,
        user_id=user_id
    )
    db.session.add(new_track)
    db.session.commit()

    return jsonify({'message': 'File uploaded', 'track_id': new_track.id}), 201
    
@upload_bp.route('/', methods=['GET'])
@login_required
def get_tracks():
    """
    Get all uploaded tracks for the authenticated user.
    ---
    tags:
      - Upload
    responses:
      200:
        description: A list of tracks
    """
    user_id = g.user_id

    # Fetch tracks that belong to the logged-in user
    tracks = Track.query.filter_by(user_id=user_id).order_by(Track.uploaded_at.desc()).all()

    # Serialize them
    serialized_tracks = [track.serialize() for track in tracks]
    # Log the JSON response to the console
    print(json.dumps({'tracks': serialized_tracks}, indent=2))

    return jsonify({'tracks': serialized_tracks}), 200

# # routes/upload.py

# import os
# from flask import Blueprint, request, jsonify, g
# from werkzeug.utils import secure_filename

# from models.database import db
# from models.track import Track
# from utils.file_utils import save_uploaded_file
# from utils.auth import login_required

# upload_bp = Blueprint('upload', __name__, url_prefix='/api/upload')

# UPLOAD_FOLDER = 'static/uploads/'

# @upload_bp.route('/', methods=['POST'])
# @login_required
# def upload_file():
#     """
#     Upload an audio file.
#     ---
#     tags:
#       - Upload
#     """
#     if 'file' not in request.files:
#         return jsonify({'error': 'No file part in request'}), 400

#     file = request.files['file']
#     if file.filename == '':
#         return jsonify({'error': 'No selected file'}), 400

#     filename = secure_filename(file.filename)
#     file_path = os.path.join(UPLOAD_FOLDER, filename)

#     save_uploaded_file(file, file_path)

#     # Use user_id from token
#     user_id = g.user_id

#     new_track = Track(
#         title=os.path.splitext(filename)[0],
#         artist="Unknown",
#         file_path=file_path,
#         user_id=user_id
#     )
#     db.session.add(new_track)
#     db.session.commit()

#     return jsonify({'message': 'File uploaded', 'track_id': new_track.id}), 201

# # routes/upload.py

# # import os
# # from flask import request, jsonify, g
# # from flask_restx import Namespace, Resource
# # from werkzeug.utils import secure_filename

# # from models.database import db
# # from models.track import Track
# # from utils.file_utils import save_uploaded_file
# # from utils.auth import login_required

# # api = Namespace('Upload', description='Audio file upload')

# # UPLOAD_FOLDER = 'static/uploads/'

# # @api.route('/')
# # class UploadResource(Resource):
# #     @login_required
# #     def post(self):
# #         """
# #         Upload an audio file.
# #         """
# #         if 'file' not in request.files:
# #             return {'error': 'No file part in request'}, 400

# #         file = request.files['file']
# #         if file.filename == '':
# #             return {'error': 'No selected file'}, 400

# #         filename = secure_filename(file.filename)
# #         file_path = os.path.join(UPLOAD_FOLDER, filename)

# #         save_uploaded_file(file, file_path)

# #         user_id = g.user_id

# #         new_track = Track(
# #             title=os.path.splitext(filename)[0],
# #             artist="Unknown",
# #             file_path=file_path,
# #             user_id=user_id
# #         )
# #         db.session.add(new_track)
# #         db.session.commit()

# #         return {'message': 'File uploaded', 'track_id': new_track.id}, 201

