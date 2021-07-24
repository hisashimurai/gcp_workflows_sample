from get_token import get_token
import get_gcp_secret


def main(request):
    """Responds to any HTTP request.
    Args:
        request (flask.Request): HTTP request object.
    Returns:
        The response text or any set of values that can be turned into a
        Response object using
        `make_response <http://flask.pocoo.org/docs/1.0/api/#flask.Flask.make_response>`.
    """

    # 事前にCloudIAP Client IDをSecretManagerに保存しておき、ここで取得する
    client_id = get_gcp_secret.get_secret_text_from_env(
        "CLOUD_IAP_CLIENT_ID_SECRET_NAME", "CLOUD_IAP_CLIENT_ID_SECRET_VERSION"
    )
    if client_id is None:
        print("Client ID 取得不可")
        return "", 500

    # セキュリティ面で気にしなければ、ここにベタ打ちしてもいい
    # client_id = "******************"

    # CloudIAP token取得
    token = get_token(client_id)

    return token
