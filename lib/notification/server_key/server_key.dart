import 'package:googleapis_auth/auth_io.dart';

class ServerKey {
  Future<String> getServerKeyToken() async {
    final scopes = [
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/firebase.database',
      'https://www.googleapis.com/auth/firebase.messaging',
    ];

    final client = await clientViaServiceAccount(
      ServiceAccountCredentials.fromJson({
        "type": "service_account",
        "project_id": "food-cycle-app",
        "private_key_id": "6c20f9336ea1c6eacbc0e09db5b31a328e697453",
        "private_key":
            "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCrGTh+ca08OROQ\nMs77e8GMNfbWR959c4mlMCwSNd32MS3shiTtLmcfCXb2qnXLHsUd55DlQ1xBbevJ\nUGkHY2X0PtGOKWuX708IwKnXYg3aoMio9kyJ/1mYRmpfCVI0JbO65jqGrHBQqUGZ\nQxAmZfcXAf2wvWAQX6+OmkQcGEhPgemES/H83Bbb9aVbycdaYUb5xNyCc3i1EKE4\nJ4LbeUcfD6ZMqs+ZmSG3VjxY1lImzPMUIUPTOBW3rDiRZW12yM0vj+7WP7UG+ZbJ\nfytS3ldPNiQVkHe54UhBoqC2/s6FytH+CWtWevT/kF0KI7ng0eOk6TC55/VYYNoH\n1JSSLGadAgMBAAECggEAELU7CM/xfoTFVgq8Hx836Ij5hHXKsn32lki0uQeFGA43\n4ZW84+No4wVB1ncRXycvUQsEoXq5NtN017kQNI4+jcIXpRYC4XiXQ2/K9hMnbq7O\nQX+hvEUQ+vd/Wi33FswKt8jVNMMAicPpeb2shU9mOFszqo9notmxM0/5sDOn1gmd\nA2qKpOJ1yPLbW7P1joZIgSved8JuuuNY0cJmfExhxACk30J4slkz5ddFC3LkDvRM\nEdrOnk3HAm+G6xjV8aRbgEM6bt28gohnCXKCjme5VGkWeQa+uJ8vyXiuWL2lmSQ3\nmtA6oTYp9DJLNtOdlSyO1Gtj/ZBAgnb4PVCr3WxsYQKBgQDTPOVgmORxRXmUAzS2\nlVoWNwf94q/DcHlMTnE1rCb79A/ZaAsjESaNHF96UmRYrwZ9oXUNgizbASaExUG8\nA1jWRwcPrsCb/CeLULUIifl1/mMQmbo/Ace9xAubEiKLH7TUaXqFqsUQglgmy/ap\n8GOhyPRzmtBW3PDOZA2UwbxhvQKBgQDPWt6FLEfxdFZvG3eanZzqR542fgwSQjzr\nfAyOGXS2YHR1vlanIUcPFp89M4UBQ63RHY3m7dWLcpaRnwHrkvdvHkSAToqNoEUT\nlpGiLuB4d1v8csH7GiCVvBVqDRCSXs2RX/Z5NXliMIvy4Bvx+fcnB3BbcIF4ZFuL\n50N3iPu2YQKBgAe9+aI6uFS2eShFnc77VlvuFGrnvg1pt+hmD5wp/RvK7DHJsG7O\nmB0f5xfyoR7m+1PrcQDXvpEgT6saF7iuXrkrzURz4TdWXJSslpYDiJMcicD4AW2B\nwTJhVxON7JowxU3rt8PiaGqcfGKfoyDDYMNzPBJooC4u1tyZqi3DlAX5AoGBAMK4\nqs6UztrITYL5YFAqQvkfWEwEAoIDAgKB86hd72R1H+iSXf2FGp3ouJFYmEafr9L4\n1hFOt4LEkPEfSUZYNVR8MAftud9V6oiClTCgpNt7+z4O5mtQFdmHTvTQYAeUT6d9\nXpBkzyCORl5GZvfNrXNRYQn9lRfh5rZy7sCKOxcBAoGAHivtDzrUfrDw+vnOgXzL\nQp0NgjsS7l005IMrxRblmt42b2KpicR20PfU2DParlE+1KBNVWqekSHQ29A0FRzF\nBbW2LZvocccneJJDo6doQ7FQb0Xl2N8uHf1aVXFpjJOdyESogg9zYUm1Gkd6uw1g\nLhjuKW8lpBb6ZXU5r0Q7GRE=\n-----END PRIVATE KEY-----\n",
        "client_email":
            "firebase-adminsdk-9ug20@food-cycle-app.iam.gserviceaccount.com",
        "client_id": "105215255509453126743",
        "auth_uri": "https://accounts.google.com/o/oauth2/auth",
        "token_uri": "https://oauth2.googleapis.com/token",
        "auth_provider_x509_cert_url":
            "https://www.googleapis.com/oauth2/v1/certs",
        "client_x509_cert_url":
            "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-9ug20%40food-cycle-app.iam.gserviceaccount.com",
        "universe_domain": "googleapis.com"
      }),
      scopes,
    );
    final accessServerKey = client.credentials.accessToken.data;
    return accessServerKey;
  }
}
