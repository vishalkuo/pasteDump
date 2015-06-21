package pastedump.vishalkuo.com.pastedump;

import android.content.Context;
import android.os.AsyncTask;

import java.io.BufferedWriter;
import java.io.IOException;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.ProtocolException;
import java.net.URL;
import java.util.AbstractMap;

/**
 * Created by vishalkuo on 15-06-21.
 */
public class AsyncSend extends AsyncTask<Void, Void, Void> {
    private String sendVal;
    private final String URLSTRING = "http://vishalkuo.com/pastebin.php";
    private String idString;
    private int responseCode = 1;

    public AsyncSend(String paste, Context c, String id) {
        sendVal = paste;
        this.idString = id;
    }

    @Override
    protected void onPreExecute() {
        super.onPreExecute();
    }

    @Override
    protected void onPostExecute(Void aVoid) {
        super.onPostExecute(aVoid);
    }

    @Override
    protected Void doInBackground(Void... voids) {
    try {
        URL url = new URL(URLSTRING);
        HttpURLConnection conn = (HttpURLConnection)url.openConnection();
        conn.setReadTimeout(10000);
        conn.setConnectTimeout(15000);
        conn.setRequestMethod("POST");
        conn.setDoInput(true);
        conn.setDoOutput(true);

        String postString = "id=" + idString + "&code=1&paste=" + sendVal;

        OutputStream os = conn.getOutputStream();
        BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(os, "UTF-8"));

        writer.write(postString);
        writer.flush();
        writer.close();
        os.close();

        conn.disconnect();

    }catch(MalformedURLException e){
        responseCode = 1;
    }catch(ProtocolException e){
        responseCode = 1;
    }catch(IOException e){
        responseCode = 1;
    }
        responseCode = 0;
        return null;
    }
}
