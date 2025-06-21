# # models/track.py

# from models.database import db
# from datetime import datetime
# from sqlalchemy.orm import relationship

# class Track(db.Model):
#     __tablename__ = 'tracks'

#     id = db.Column(db.Integer, primary_key=True)
#     title = db.Column(db.String(120), nullable=False)
#     artist = db.Column(db.String(120), nullable=True)
#     album = db.Column(db.String(120), nullable=True)
#     genre = db.Column(db.String(80), nullable=True)
#     year = db.Column(db.String(4), nullable=True)
#     lyrics = db.Column(db.Text, nullable=True)

#     file_path = db.Column(db.String(200), nullable=False)
#     duration = db.Column(db.Float, nullable=True)  # Duration in seconds
#     uploaded_at = db.Column(db.DateTime, default=datetime.utcnow)

    
#     user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
#     user = relationship('User', back_populates='tracks')

#     def serialize(self):
#         return {
#             'id': self.id,
#             'title': self.title,
#             'artist': self.artist,
#             'album': self.album,
#             'genre': self.genre,
#             'year': self.year,
#             'file_path': self.file_path,
#             'duration': self.duration,
#             'uploaded_at': self.uploaded_at.isoformat(),
#             'user_id': self.user_id,
#         }


# models/track.py

from models.database import db
from datetime import datetime
from flask import url_for
from sqlalchemy.orm import relationship
import os
class Track(db.Model):
    __tablename__ = 'tracks'

    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(120), nullable=False)
    artist = db.Column(db.String(120), nullable=True)
    album = db.Column(db.String(120), nullable=True)
    genre = db.Column(db.String(80), nullable=True)
    year = db.Column(db.String(4), nullable=True)
    lyrics = db.Column(db.Text, nullable=True)

    file_path = db.Column(db.String(200), nullable=False)
    duration = db.Column(db.Float, nullable=True)  # Duration in seconds
    uploaded_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow)

    
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    user = relationship('User', back_populates='tracks')

    def serialize(self):
        return {
            'id': self.id,
            'title': self.title,
            'artist': self.artist,
            'album': self.album,
            'genre': self.genre,
            'year': self.year,
            'file_path': url_for('uploaded_file', filename=os.path.basename(self.file_path), _external=True),
            'duration': self.duration,
            'uploaded_at': self.uploaded_at.isoformat(),
            'updated_at': self.updated_at.isoformat(),
            'user_id': self.user_id,
        }
