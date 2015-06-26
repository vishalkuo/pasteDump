package pastedump.vishalkuo.com.pastedump;

import android.content.Context;
import android.os.AsyncTask;
import android.util.Log;
import android.widget.Toast;

import java.io.BufferedWriter;
import java.io.IOException;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.ProtocolException;
import java.net.URL;
import java.util.AbstractMap;

import retrofit.Callback;
import retrofit.RestAdapter;
import retrofit.RetrofitError;
import retrofit.client.Response;

/**
 * Created by vishalkuo on 15-06-21.
 */
public class AsyncSend extends AsyncTask<Void, Void, Void> {
    private String sendVal;
    private final String URLSTRING = "http://vishalkuo.com/pastebin.php";
    private String idString;
    private int responseCode = 1;
    private Context c;

    public AsyncSend(String paste, Context c, String id) {
        sendVal = paste;
        this.idString = id;
        this.c = c;
    }

    @Override
    protected void onPreExecute() {
        super.onPreExecute();
    }

    @Override
    protected void onPostExecute(Void aVoid) {
        super.onPostExecute(aVoid);
        if (responseCode == 1) {
            Toast.makeText(c, "Something Went Wrong!", Toast.LENGTH_LONG).show();
        }
    }

    @Override
    protected Void doInBackground(Void... voids) {
    /*try {
        URL url = new URL(URLSTRING);
        HttpURLConnection conn = (HttpURLConnection)url.openConnection();
        conn.setReadTimeout(10000);
        conn.setConnectTimeout(15000);
        conn.setRequestMethod("POST");
        conn.setDoInput(true);
        conn.setDoOutput(true);

        String postString = "id=" + idString + "&code=1&paste=" + sendVal;
        Log.d("APP", postString);
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
    }*/
        RestAdapter restAdapter = new RestAdapter.Builder()
                .setEndpoint(URLSTRING)
                .build();
        Service service = restAdapter.create(Service.class);
        service.newTask(new Task(idString, sendVal), new Callback<Task>() {
            @Override
            public void success(Task task, Response response) {
                Log.d("YEAH", "WE DID IT");
            }

            @Override
            public void failure(RetrofitError error) {
                Log.d("OOPS", "HERE");
                Log.d("ERR", error.getMessage());
            }
        });

        responseCode = 0;
        return null;
    }
}
