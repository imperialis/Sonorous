# # recommendations.py - Auto-generated stub

# # routes/recommendations.py

# from flask import Blueprint, request, jsonify
# from services.recommendation_engine import get_recommendations_for_user

# recommendations_bp = Blueprint('recommend', __name__, url_prefix='/api/recommend')


# @recommendations_bp.route('/', methods=['GET'])
# def get_recommendations():
#     """
#     Get recommended tracks for a user.
#     """
#     user_id = request.args.get('user_id')
#     if not user_id:
#         return jsonify({'error': 'Missing user_id'}), 400

#     try:
#         user_id = int(user_id)
#     except ValueError:
#         return jsonify({'error': 'Invalid user_id'}), 400

#     recommendations = get_recommendations_for_user(user_id)

#     return jsonify({'recommendations': recommendations}), 200

from flask import Blueprint, request, jsonify, g
from services.recommendation_engine import get_recommendations_for_user
from utils.auth import login_required  # assuming this sets g.user_id

recommendations_bp = Blueprint('recommend', __name__, url_prefix='/api/recommendations')


@recommendations_bp.route('/', methods=['GET'])
@login_required
def get_recommendations():
    """
    Get recommended tracks for the currently authenticated user.
    """
    user_id = g.get('user_id')
    if not user_id:
        return jsonify({'error': 'User not authenticated'}), 401

    try:
        recommendations = get_recommendations_for_user(user_id)
        return jsonify({'recommendations': recommendations}), 200
    except Exception as e:
        return jsonify({'error': f'Failed to get recommendations: {str(e)}'}), 500
