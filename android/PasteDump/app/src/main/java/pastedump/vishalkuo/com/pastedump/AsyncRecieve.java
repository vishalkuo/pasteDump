package pastedump.vishalkuo.com.pastedump;

import android.content.Context;
import android.os.AsyncTask;
import android.util.Log;
import android.view.View;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;
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

/**
 * Created by vishalkuo on 15-06-14.
 */
public class AsyncRecieve extends AsyncTask<Void, Void, JSONArray> {
    private ProgressBar progressBar;
    private TextView textView;
    private Context context;
    private int responseCode = 0;
    private final String urlString = "http://vishalkuo.com/pastebin.php";
    private String returnString;
    private JSONArray jarr;
    private String accessCode;

    public AsyncRecieve(Context c, ProgressBar p, TextView t, String accessCode){
        this.progressBar = p;
        this.context = c;
        this.textView = t;
        this.accessCode = accessCode;
    }


    @Override
    protected JSONArray doInBackground(Void... voids) {
        try{
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
            return jarr;
        }catch(IOException e){
            responseCode = 4;
            return jarr;
        }try{
            jarr = new JSONArray(returnString);
            responseCode = 1;
        }catch(JSONException e){
            responseCode = 3;
        }
        return jarr;
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
        textView.setVisibility(View.VISIBLE);
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
                        Log.d("test", outputString);
                        textView.setText(outputString);
                    }else {
                        Toast.makeText(context, "No pastes found!", Toast.LENGTH_LONG).show();
                    }

                }catch(JSONException e){
                    Toast.makeText(context, "Something went wrong! Please try again later", Toast.LENGTH_LONG).show();
                }
        }
    }
}
