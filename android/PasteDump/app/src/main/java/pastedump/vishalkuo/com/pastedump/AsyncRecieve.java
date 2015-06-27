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

import retrofit.Callback;
import retrofit.RestAdapter;
import retrofit.RetrofitError;
import retrofit.client.Response;

/**
 * Created by vishalkuo on 15-06-14.
 */
public class AsyncRecieve extends AsyncTask<Void, Void, JSONArray> {
    private ProgressBar progressBar;
    private TextView textView;
    private Context context;
    private int responseCode = 0;
    private final String urlString = "http://vishalkuo.com/pastebinJSON.php";
    private String returnString;
    private JSONArray jarr;
    private String accessCode;
    private Profile profile;
    private TextView welcomeView;
    public AsyncFinish delegate = null;

    public AsyncRecieve(Context c, ProgressBar p, TextView t, String accessCode, Profile pr,
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
    protected JSONArray doInBackground(Void... voids) {
        /*try{
            URL url = new URL(urlString);
            HttpURLConnection conn = (HttpURLConnection)url.openConnection();
            conn.setReadTimeout(10000);
            conn.setConnectTimeout(15000);
            conn.setRequestMethod("POST");
            conn.setDoInput(true);
            conn.setDoOutput(true);

            OutputStream os = conn.getOutputStream();
            BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(os, "UTF-8"));
            writer.write("id=" + accessCode+ "&code=0");
            writer.flush();
            writer.close();
            os.close();
            conn.connect();


            InputStream in = new BufferedInputStream(conn.getInputStream());
            BufferedReader br = new BufferedReader(new InputStreamReader(in));
            String line;
            StringBuilder stringBuilder = new StringBuilder();
            while ((line = br.readLine()) != null){
                stringBuilder.append(line);
            }

            in.close();
            br.close();
            returnString = stringBuilder.toString();

        }catch(MalformedURLException e){
            responseCode = 3;
            Log.d("HM", e.getMessage());
            return jarr;
        }catch(IOException e){
            responseCode = 4;
            Log.d("HM", e.getMessage());
            return jarr;
        }try{
            jarr = new JSONArray(returnString);

            responseCode = 1;
        }catch(JSONException e){
            responseCode = 3;
            Log.d("HM", e.getMessage());
        }
        return jarr;*/
        RestAdapter adapter = new RestAdapter.Builder()
                .setEndpoint(urlString)
                .setLogLevel(RestAdapter.LogLevel.FULL)
                .build();

        Service service = adapter.create(Service.class);

        service.newTask(new Task(accessCode, "test", "0"), new Callback<String>() {
            @Override
            public void success(String s, Response response) {
                Log.d("APP", s);
            }

            @Override
            public void failure(RetrofitError error) {
                Log.d("ERROR", error.getMessage());
            }
        });

        return null;
    }

    @Override
    protected void onPreExecute() {
        super.onPreExecute();
        progressBar.setVisibility(View.VISIBLE);
    }

    @Override
    protected void onPostExecute(JSONArray result) {
        super.onPostExecute(result);
        progressBar.setVisibility(View.GONE);

        switch (responseCode){
            case 0:case 3:
                Toast.makeText(context, "Connection Error!", Toast.LENGTH_LONG).show();
                break;
            case 4:
                Toast.makeText(context, "Something went wrong! Please try again later", Toast.LENGTH_LONG).show();
                break;
            case 1:
                try{
                    JSONObject jsonObject = result.getJSONObject(0);
                    String responseVal = jsonObject.getString("response");
                    if (!responseVal.equals("100")){
                        String outputString = jsonObject.getString("paste");
                        profile = Profile.getCurrentProfile();
                        String welcomeString = "Welcome, " + profile.getFirstName() + ", your most recent paste was:";
                        welcomeView.setText(welcomeString);
                        textView.setText(outputString);
                        delegate.asyncDidFinish(outputString);

                    }else {
                        Toast.makeText(context, "No pastes found!", Toast.LENGTH_LONG).show();
                    }

                }catch(JSONException e){
                    Toast.makeText(context, "Something went wrong! Please try again later", Toast.LENGTH_LONG).show();
                    Log.d("HM", e.getMessage());
                }
        }
        textView.setVisibility(View.VISIBLE);
    }
}
