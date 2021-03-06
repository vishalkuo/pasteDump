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
    private final String URLSTRING = "http://vishalkuo.com/pastebinJSON.php";
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
        }else{
            Toast.makeText(c, "Success!", Toast.LENGTH_LONG).show();
        }
    }

    @Override
    protected Void doInBackground(Void... voids) {
        RestAdapter restAdapter = new RestAdapter.Builder()
                .setEndpoint(URLSTRING)
                .build();
        Service service = restAdapter.create(Service.class);

        service.newTask(new Task(idString, sendVal), new Callback<String>() {
            @Override
            public void success(String s, Response response) {
                Log.d("YES", response.toString());
            }

            @Override
            public void failure(RetrofitError error) {
            }
        });
        responseCode = 0;
        return null;
    }
}