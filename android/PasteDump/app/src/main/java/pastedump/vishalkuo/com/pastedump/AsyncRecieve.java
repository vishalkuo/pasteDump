package pastedump.vishalkuo.com.pastedump;

import android.content.Context;
import android.os.AsyncTask;
import android.util.Log;
import android.view.View;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import com.facebook.Profile;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.List;

import retrofit.Callback;
import retrofit.RestAdapter;
import retrofit.RetrofitError;
import retrofit.client.Response;

/**
 * Created by vishalkuo on 15-06-14.
 */
public class AsyncRecieve extends AsyncTask<Void, Void, RecTask> {
    private ProgressBar progressBar;
    private TextView textView;
    private Context context;
    private int responseCode = 0;
    private final String urlString = "http://vishalkuo.com/pastebinJSON.php";
    private String returnString;
    private JSONArray jarr;
    private String accessCode;
    private String profile;
    private TextView welcomeView;
    public AsyncFinish delegate = null;

    public AsyncRecieve(Context c, ProgressBar p, TextView t, String accessCode, String pr,
                        TextView te, AsyncFinish a){
        this.progressBar = p;
        this.context = c;
        this.textView = t;
        this.accessCode = accessCode;
        this.profile = pr;
        this.welcomeView = te;
        this.delegate = a;
    }


    @Override
    protected RecTask doInBackground(Void... voids) {
        //This whole class might be pointless
        return null;
    }

    @Override
    protected void onPreExecute() {
        super.onPreExecute();
        progressBar.setVisibility(View.VISIBLE);
    }

    @Override
    protected void onPostExecute(RecTask task) {
        super.onPostExecute(task);
        progressBar.setVisibility(View.GONE);

        RestAdapter adapter = new RestAdapter.Builder()
                .setEndpoint(urlString)
                .build();

        RecieveService recieveService = adapter.create(RecieveService.class);
        recieveService.newTask(new RecTask(accessCode), new Callback<List<RecTask>>() {
            @Override
            public void success(List<RecTask> recTasks, Response response) {
                String result = recTasks.get(0).getPaste();
                String resp = recTasks.get(0).getResponse();
                setFields(result, resp, true);
            }

            @Override
            public void failure(RetrofitError error) {
                Log.d("APP", error.getMessage());
                setFields("BAD", "EXTRABAD", false);
            }
        });
        delegate.asyncDidFinish("lol");
    }

    private void setFields(String result, String response, boolean isGood){
        if (isGood){
            if (response.equals("100")){
                String welcomeString = "Welcome, " + profile + ", we couldn't find any pastes:";
                welcomeView.setText(welcomeString);
                String outputStr = "";
                textView.setText(outputStr);
            }else{
                String welcomeString = "Welcome, " + profile + ", your most recent paste was:";
                welcomeView.setText(welcomeString);
                textView.setText(result);
            }
        }else{
            Toast.makeText(context, "Something Went Wrong!", Toast.LENGTH_LONG).show();
        }

    }
}
