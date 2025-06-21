# database.py - Auto-generated stub

# models/database.py

from flask_sqlalchemy import SQLAlchemy
from flask import Flask
from dotenv import load_dotenv
import os

load_dotenv()

db = SQLAlchemy()

def init_db(app: Flask):
    db_path = os.getenv("DATABASE_URL", "sqlite:///aurabeat.db")
    app.config['SQLALCHEMY_DATABASE_URI'] = db_path
    app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
    db.init_app(app)

    with app.app_context():
        from models.track import Track
        # Phase 3 Models
        try:
            from models.user import User
            from models.tag import Tag
            from models.remix import Remix
        except ImportError:
            pass  # Only loaded if present

        db.create_all()
