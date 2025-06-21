# # recommendation_engine.py - Auto-generated stub

# # services/recommendation_engine.py

# import numpy as np
# from collections import defaultdict
# from sklearn.metrics.pairwise import cosine_similarity

# class RecommendationEngine:
#     def __init__(self):
#         # Placeholder for user-track interactions: user_id -> [track_id, ...]
#         self.user_history = defaultdict(list)

#         # Placeholder for track features: track_id -> feature vector
#         self.track_features = {}

#     def add_user_interaction(self, user_id, track_id):
#         """Log that a user has played or liked a track."""
#         if track_id not in self.user_history[user_id]:
#             self.user_history[user_id].append(track_id)

#     def add_track_features(self, track_id, feature_vector):
#         """Store a track's feature vector (e.g., [genre_tag1, genre_tag2, tempo, mood...])."""
#         self.track_features[track_id] = np.array(feature_vector)

#     def recommend_tracks(self, user_id, top_k=5):
#         """
#         Recommend similar tracks to what the user has liked/listened to.
#         Uses average feature vector of user's interactions.
#         """
#         if user_id not in self.user_history or not self.user_history[user_id]:
#             return []

#         # Get vectors for the user’s listened tracks
#         vectors = [self.track_features[tid]
#                    for tid in self.user_history[user_id]
#                    if tid in self.track_features]

#         if not vectors:
#             return []

#         user_profile = np.mean(vectors, axis=0)

#         similarities = []
#         for tid, vec in self.track_features.items():
#             if tid in self.user_history[user_id]:
#                 continue  # Skip already seen
#             sim = cosine_similarity([user_profile], [vec])[0][0]
#             similarities.append((tid, sim))

#         similarities.sort(key=lambda x: x[1], reverse=True)

#         return [track_id for track_id, _ in similarities[:top_k]]

#     def get_similar_tracks(self, track_id, top_k=5):
#         """
#         Return top-K tracks similar to a given track based on feature vector.
#         """
#         if track_id not in self.track_features:
#             return []

#         ref_vec = self.track_features[track_id]
#         similarities = []

#         for tid, vec in self.track_features.items():
#             if tid == track_id:
#                 continue
#             sim = cosine_similarity([ref_vec], [vec])[0][0]
#             similarities.append((tid, sim))

#         similarities.sort(key=lambda x: x[1], reverse=True)
#         return [track_id for track_id, _ in similarities[:top_k]]

# services/recommendation_engine.py

import numpy as np
from collections import defaultdict
from sklearn.metrics.pairwise import cosine_similarity

class RecommendationEngine:
    def __init__(self):
        # Placeholder for user-track interactions: user_id -> [track_id, ...]
        self.user_history = defaultdict(list)

        # Placeholder for track features: track_id -> feature vector
        self.track_features = {}

    def add_user_interaction(self, user_id, track_id):
        """Log that a user has played or liked a track."""
        if track_id not in self.user_history[user_id]:
            self.user_history[user_id].append(track_id)

    def add_track_features(self, track_id, feature_vector):
        """Store a track's feature vector (e.g., [genre_tag1, genre_tag2, tempo, mood...])."""
        self.track_features[track_id] = np.array(feature_vector)

    def recommend_tracks(self, user_id, top_k=5):
        """
        Recommend similar tracks to what the user has liked/listened to.
        Uses average feature vector of user's interactions.
        """
        if user_id not in self.user_history or not self.user_history[user_id]:
            return []

        # Get vectors for the user’s listened tracks
        vectors = [self.track_features[tid]
                   for tid in self.user_history[user_id]
                   if tid in self.track_features]

        if not vectors:
            return []

        user_profile = np.mean(vectors, axis=0)

        similarities = []
        for tid, vec in self.track_features.items():
            if tid in self.user_history[user_id]:
                continue  # Skip already seen
            sim = cosine_similarity([user_profile], [vec])[0][0]
            similarities.append((tid, sim))

        similarities.sort(key=lambda x: x[1], reverse=True)

        return [track_id for track_id, _ in similarities[:top_k]]

    def get_similar_tracks(self, track_id, top_k=5):
        """
        Return top-K tracks similar to a given track based on feature vector.
        """
        if track_id not in self.track_features:
            return []

        ref_vec = self.track_features[track_id]
        similarities = []

        for tid, vec in self.track_features.items():
            if tid == track_id:
                continue
            sim = cosine_similarity([ref_vec], [vec])[0][0]
            similarities.append((tid, sim))

        similarities.sort(key=lambda x: x[1], reverse=True)
        return [track_id for track_id, _ in similarities[:top_k]]


# Option 2: Expose instance methods at the module level
_recommender = RecommendationEngine()
add_user_interaction = _recommender.add_user_interaction
add_track_features = _recommender.add_track_features
get_recommendations_for_user = _recommender.recommend_tracks
get_similar_tracks = _recommender.get_similar_tracks
