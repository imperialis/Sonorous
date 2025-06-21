# models/remix.py

from models.database import db
from datetime import datetime

class Remix(db.Model):
    __tablename__ = 'remixes'

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(120), nullable=False)
    description = db.Column(db.Text, nullable=True)
    
    remix_file_path = db.Column(db.String(200), nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)

    # Relationship: each remix is linked to a base track
    original_track_id = db.Column(db.Integer, db.ForeignKey('tracks.id'), nullable=False)
    original_track = db.relationship('Track', backref=db.backref('remixes', lazy='dynamic', cascade='all, delete-orphan'))

    # Optional: Track the user who created the remix
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=True)
    user = db.relationship('User', backref=db.backref('remixes', lazy='dynamic'))

    def serialize(self):
        return {
            'id': self.id,
            'name': self.name,
            'description': self.description,
            'remix_file_path': self.remix_file_path,
            'created_at': self.created_at.isoformat(),
            'original_track_id': self.original_track_id,
            'user_id': self.user_id
        }
