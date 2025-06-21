# auth_service.py - Auto-generated stub

# services/auth_service.py

import os
import jwt
import bcrypt
from datetime import datetime, timedelta

# Secret key for JWT encoding/decoding
SECRET_KEY = os.environ.get("JWT_SECRET", "super-secret-key")
JWT_ALGORITHM = "HS256"
JWT_EXP_DELTA_SECONDS = 3600  # 1 hour


class AuthService:
    @staticmethod
    def hash_password(plain_password: str) -> str:
        """Hash a plain-text password using bcrypt."""
        return bcrypt.hashpw(plain_password.encode('utf-8'), bcrypt.gensalt()).decode('utf-8')

    @staticmethod
    def check_password(plain_password: str, hashed_password: str) -> bool:
        """Check whether a plain-text password matches the hash."""
        return bcrypt.checkpw(plain_password.encode('utf-8'), hashed_password.encode('utf-8'))

    @staticmethod
    def generate_token(user_id: int) -> str:
        """Create a JWT token for a user."""
        payload = {
            "user_id": user_id,
            "exp": datetime.utcnow() + timedelta(seconds=JWT_EXP_DELTA_SECONDS)
        }
        token = jwt.encode(payload, SECRET_KEY, algorithm=JWT_ALGORITHM)
        return token

    @staticmethod
    def verify_token(token: str) -> dict:
        """Decode and verify a JWT token."""
        try:
            decoded = jwt.decode(token, SECRET_KEY, algorithms=[JWT_ALGORITHM])
            return decoded
        except jwt.ExpiredSignatureError:
            raise ValueError("Token expired")
        except jwt.InvalidTokenError:
            raise ValueError("Invalid token")

# Add at the bottom of auth_service.py
auth_service = AuthService()
hash_password = auth_service.hash_password
generate_token = auth_service.generate_token
check_password = auth_service.check_password