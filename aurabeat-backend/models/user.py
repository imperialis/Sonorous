# models/user.py

from models.database import db
from sqlalchemy.orm import relationship
from werkzeug.security import generate_password_hash, check_password_hash

class User(db.Model):
    __tablename__ = 'users'

    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), unique=True, nullable=False)
    password_hash = db.Column(db.String(255), nullable=False)

    # 🔗 Relationship to Track
    tracks = relationship('Track', back_populates='user', cascade='all, delete-orphan')

    # 🔒 Set password
    def set_password(self, password):
        self.password_hash = generate_password_hash(password)

    # 🔑 Verify password
    def check_password(self, password):
        return check_password_hash(self.password_hash, password)

    def serialize(self):
        return {
            'id': self.id,
            'username': self.username
        }
