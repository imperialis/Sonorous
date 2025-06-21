# version 4. - Updated with file serving route

from flask import Flask, send_from_directory
from flask_cors import CORS
import os

from models.database import init_db

# Import Blueprints
from routes.upload import upload_bp
from routes.metadata import metadata_bp
from routes.tags import tags_bp
from routes.stems import stems_bp
from routes.remix import remix_bp
from routes.lyrics import lyrics_bp
from routes.auth import auth_bp
from routes.recommendations import recommendations_bp
from routes.sync import sync_bp
from routes.auragen import auragen_bp
from routes.analytics import analytics_bp

def create_app():
    app = Flask(__name__)
    #CORS(app)
    CORS(app,
         resources={r"/api/*": {"origins": "https://curly-space-carnival-5xwr9769jp6345wg-8080.app.github.dev"}},
         supports_credentials=True,
         allow_headers=["Content-Type", "Authorization"],
         methods=["GET", "POST", "PUT", "DELETE", "OPTIONS"]
    )


    app.config['UPLOAD_FOLDER'] = os.path.join('static', 'uploads')

    init_db(app)

    # Register Blueprints
    app.register_blueprint(upload_bp, url_prefix="/api/upload")
    app.register_blueprint(metadata_bp, url_prefix="/api/metadata")
    app.register_blueprint(tags_bp, url_prefix="/api/tags")
    app.register_blueprint(stems_bp, url_prefix="/api/stems")
    app.register_blueprint(remix_bp, url_prefix="/api/remix")
    app.register_blueprint(lyrics_bp, url_prefix="/api/lyrics")
    app.register_blueprint(auth_bp, url_prefix="/api/auth")
    app.register_blueprint(recommendations_bp, url_prefix="/api/recommendations")
    app.register_blueprint(sync_bp, url_prefix="/api/sync")
    app.register_blueprint(analytics_bp, url_prefix="/api/analytics")
    app.register_blueprint(auragen_bp, url_prefix="/api/auragen")

    # Public route to serve uploaded files
    @app.route('/uploads/<path:filename>')
    def uploaded_file(filename):
        return send_from_directory(app.config['UPLOAD_FOLDER'], filename)

    return app

# Optional: List all registered routes
def list_all_routes_in_app(flask_app):
    output = []
    for rule in flask_app.url_map.iter_rules():
        if rule.endpoint == 'static':
            continue
        methods = ','.join(sorted(rule.methods - {'HEAD', 'OPTIONS'}))
        output.append(f"Endpoint: {rule.endpoint:<30} | Methods: {methods:<15} | Rule: {rule.rule}")
    return "\n".join(output)

if __name__ == '__main__':
    app = create_app()

    print("\n--- All Registered Routes ---")
    with app.test_request_context():
        print(list_all_routes_in_app(app))
    print("-----------------------------\n")

    app.run(debug=True, port=5000)
 


# ##******version 3.*********##
# from flask import Flask
# from flask_cors import CORS
# import os # Import os for potential use in the list_routes function, though not strictly needed here for just printing.

# from models.database import init_db

# # Import Blueprints
# from routes.upload import upload_bp
# from routes.metadata import metadata_bp
# from routes.tags import tags_bp
# from routes.stems import stems_bp
# from routes.remix import remix_bp
# from routes.lyrics import lyrics_bp
# from routes.auth import auth_bp
# from routes.recommendations import recommendations_bp
# from routes.sync import sync_bp
# from routes.auragen import auragen_bp
# from routes.analytics import analytics_bp

# def create_app():
#     app = Flask(__name__)
#     CORS(app)

#     app.config['UPLOAD_FOLDER'] = 'static/uploads'

#     init_db(app)

#     # Register Blueprints
#     app.register_blueprint(upload_bp, url_prefix="/api/upload")
#     app.register_blueprint(metadata_bp, url_prefix="/api/metadata")
#     app.register_blueprint(tags_bp, url_prefix="/api/tags")
#     app.register_blueprint(stems_bp, url_prefix="/api/stems")
#     app.register_blueprint(remix_bp, url_prefix="/api/remix")
#     app.register_blueprint(lyrics_bp, url_prefix="/api/lyrics")
#     app.register_blueprint(auth_bp, url_prefix="/api/auth")
#     app.register_blueprint(recommendations_bp, url_prefix="/api/recommendations")
#     app.register_blueprint(sync_bp, url_prefix="/api/sync")
#     app.register_blueprint(analytics_bp, url_prefix="/api/analytics")
#     app.register_blueprint(auragen_bp, url_prefix="/api/auragen")

#     return app

# # Function to list all registered routes
# def list_all_routes_in_app(flask_app):
#     output = []
#     # Using app.url_map.iter_rules() to get all registered rules
#     for rule in flask_app.url_map.iter_rules():
#         # Exclude the static files rule, which is often not relevant for API documentation
#         if rule.endpoint == 'static':
#             continue
        
#         methods = ','.join(sorted(rule.methods - set(['HEAD', 'OPTIONS']))) # Exclude HEAD and OPTIONS for cleaner output
#         output.append(f"Endpoint: {rule.endpoint:<30} | Methods: {methods:<15} | Rule: {rule.rule}")
#     return "\n".join(output)

# if __name__ == '__main__':
#     app = create_app()

#     # Print all routes when the application starts
#     print("\n--- All Registered Routes ---")
#     with app.test_request_context(): # A request context is needed to inspect url_map fully
#         print(list_all_routes_in_app(app))
#     print("-----------------------------\n")

#     app.run(debug=True, port=5000)