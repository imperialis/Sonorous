# file_utils.py - Auto-generated stub

# utils/file_utils.py

import os

def save_uploaded_file(file, destination_path):
    """
    Saves the uploaded file to the specified destination.
    
    Args:
        file (FileStorage): The uploaded file object from Flask.
        destination_path (str): Full path where the file should be saved.
    """
    os.makedirs(os.path.dirname(destination_path), exist_ok=True)
    file.save(destination_path)
    return destination_path


def delete_file(path):
    """
    Deletes a file at the specified path if it exists.

    Args:
        path (str): Full path to the file to delete.
    """
    if os.path.exists(path):
        os.remove(path)
