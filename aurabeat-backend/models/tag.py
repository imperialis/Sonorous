# models/tag.py

from models.database import db

class Tag(db.Model):
    __tablename__ = 'tags'

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(80), nullable=False)
    is_ai_generated = db.Column(db.Boolean, default=False)

    # Association to Track
    track_id = db.Column(db.Integer, db.ForeignKey('tracks.id'), nullable=False)
    track = db.relationship('Track', backref=db.backref('tags', lazy='dynamic', cascade='all, delete-orphan'))

    def serialize(self):
        return {
            'id': self.id,
            'name': self.name,
            'is_ai_generated': self.is_ai_generated,
            'track_id': self.track_id
        }
