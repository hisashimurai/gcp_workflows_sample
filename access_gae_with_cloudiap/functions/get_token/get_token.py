from google.auth.transport.requests import Request
from google.oauth2 import id_token


def get_token(client_id):

    return id_token.fetch_id_token(Request(), client_id)
