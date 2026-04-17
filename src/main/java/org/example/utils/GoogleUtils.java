package org.example.utils;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import org.apache.http.client.fluent.Form;
import org.apache.http.client.fluent.Request;
import java.io.IOException;

public class GoogleUtils {
    public static String CLIENT_ID = "510783294208-jtmcvkh5n8hn5jn468ktejf5ufnucoqm.apps.googleusercontent.com";
    public static String CLIENT_SECRET = "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";
    public static String REDIRECT_URI = "http://localhost:8080/login-google";
    public static String GRANT_TYPE = "authorization_code";

    public static String getToken(String code) throws IOException {
        String response = Request.Post("https://accounts.google.com/o/oauth2/token")
                .bodyForm(Form.form().add("client_id", CLIENT_ID)
                        .add("client_secret", CLIENT_SECRET)
                        .add("redirect_uri", REDIRECT_URI)
                        .add("code", code)
                        .add("grant_type", GRANT_TYPE).build())
                .execute().returnContent().asString();
        JsonObject jobj = new Gson().fromJson(response, JsonObject.class);
        return jobj.get("access_token").toString().replaceAll("\"", "");
    }

    public static JsonObject getUserInfo(String accessToken) throws IOException {
        String link = "https://www.googleapis.com/oauth2/v1/userinfo?access_token=" + accessToken;
        String response = Request.Get(link).execute().returnContent().asString();
        return new Gson().fromJson(response, JsonObject.class);
    }
}