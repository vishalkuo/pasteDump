package pastedump.vishalkuo.com.pastedump;

import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.hardware.SensorManager;
import android.support.v4.app.Fragment;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.inputmethod.EditorInfo;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.facebook.AccessToken;
import com.facebook.AccessTokenTracker;
import com.facebook.CallbackManager;
import com.facebook.FacebookCallback;
import com.facebook.FacebookException;
import com.facebook.FacebookSdk;
import com.facebook.Profile;
import com.facebook.login.LoginManager;
import com.facebook.login.LoginResult;
import com.facebook.login.widget.LoginButton;
import com.squareup.seismic.ShakeDetector;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;


/**
 * A placeholder fragment containing a simple view.
 */
public class MainFragment extends Fragment{

    private CallbackManager callbackManager;
    private AccessToken accessToken;
    private ProgressBar progressBar;
    private TextView textResult;
    private TextView nameWelcome;
    private TextView title;
    private Profile profile;
    private Button pasteButton;
    private Button clipboardButton;
    private Button refreshButton;
    private Button loginButton;
    private EditText pasteField;
    private boolean isInPasteState = false;
    private Context c;


    private AccessTokenTracker accessTokenTracker;

    public MainFragment() {
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);


        FacebookSdk.sdkInitialize(getActivity().getApplicationContext());

        callbackManager = CallbackManager.Factory.create();


        profile = Profile.getCurrentProfile();

        c = getActivity().getApplicationContext();
        accessTokenTracker = new AccessTokenTracker() {
            @Override
            protected void onCurrentAccessTokenChanged(final AccessToken accessToken, final AccessToken accessToken1) {
               if (accessToken1.getCurrentAccessToken() != null){
                   setHide(true);
                   profile = Profile.getCurrentProfile();
                   new AsyncRecieve(getActivity().getApplicationContext(), progressBar, textResult,
                           accessToken1.getUserId()
                           , profile.getFirstName(), nameWelcome, new AsyncFinish() {
                       @Override
                       public void asyncDidFinish(String result) {
                           //The result is a debug value
                           setHide(false);
                       }
                   })
                           .execute();
               }else{
                   setHide(true);
               }

            }
        };


    }

    @Override
    public void onDestroyView() {
        super.onDestroyView();
        accessTokenTracker.stopTracking();
    }

    @Override
    public void onViewCreated(View view, Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);

        loginButton = (Button)view.findViewById(R.id.login_button);
        progressBar = (ProgressBar)view.findViewById(R.id.progressSpinner);
        textResult = (TextView)view.findViewById(R.id.pasteVal);
        nameWelcome = (TextView)view.findViewById(R.id.nameVal);
        pasteButton = (Button)view.findViewById(R.id.makePasteBtn);
        clipboardButton = (Button)view.findViewById(R.id.clipboardBtn);
        pasteField = (EditText)view.findViewById(R.id.makePasteField);
        title=(TextView)view.findViewById(R.id.title);
        refreshButton = (Button)view.findViewById(R.id.refreshBtn);
        final Fragment fragment = this;


        final ClipboardManager clipboard = (ClipboardManager)getActivity().
                getSystemService(Context.CLIPBOARD_SERVICE);

        if (accessToken.getCurrentAccessToken() == null){
            setHide(true);
        }

        loginButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (AccessToken.getCurrentAccessToken() == null){
                    List<String> collection = new ArrayList<>();
                    collection.add("public_profile");
                    LoginManager.getInstance().logInWithReadPermissions(fragment, collection);
                    Log.d("HERE?", AccessToken.getCurrentAccessToken().toString());
                } else{
                    LoginManager.getInstance().logOut();
                }

            }
        });


        clipboardButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (!isInPasteState) {
                    ClipData data = ClipData.newPlainText("myText", textResult.getText());
                    clipboard.setPrimaryClip(data);
                    Toast.makeText(c, "Copied!", Toast.LENGTH_LONG).show();
                } else {
                    new AsyncSend(pasteField.getText().toString(),
                            getActivity().getApplicationContext(),
                            accessToken.getCurrentAccessToken().getUserId()).execute();
                }

            }
        });

        pasteButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                togglePasteState(isInPasteState);
                isInPasteState = !isInPasteState;
            }
        });

        pasteField.setOnEditorActionListener(new TextView.OnEditorActionListener() {
            @Override
            public boolean onEditorAction(TextView textView, int i, KeyEvent keyEvent) {
                if (i == EditorInfo.IME_ACTION_DONE || keyEvent.getKeyCode() ==
                        KeyEvent.KEYCODE_ENTER) {
                    new AsyncSend(pasteField.getText().toString(),
                            getActivity().getApplicationContext(),
                            accessToken.getCurrentAccessToken().getUserId()).execute();

                    InputMethodManager imm = (InputMethodManager) getActivity().getSystemService
                            (Context.INPUT_METHOD_SERVICE);
                    imm.hideSoftInputFromWindow(pasteField.getWindowToken(), 0);
                    pasteField.setText("");
                    return true;
                }

                return false;
            }
        });

        refreshButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                setHide(true);
                new AsyncRecieve(getActivity().getApplicationContext(), progressBar, textResult,
                        accessToken.getCurrentAccessToken().getUserId()
                        , profile.getFirstName(), nameWelcome, new AsyncFinish() {
                    @Override
                    public void asyncDidFinish(String result) {
                        //The result is a debug value
                        setHide(false);
                    }
                })
                        .execute();
            }
        });


    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        return inflater.inflate(R.layout.fragment_main, container, false);


    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        callbackManager.onActivityResult(requestCode, resultCode, data);
    }

    private void setHide(boolean isHidden){
        if (isHidden){
            nameWelcome.setVisibility(View.GONE);
            textResult.setVisibility(View.GONE);
            clipboardButton.setVisibility(View.GONE);
            pasteButton.setVisibility(View.GONE);
            refreshButton.setVisibility(View.GONE);
            loginButton.setText("Login");
        }else{
            nameWelcome.setVisibility(View.VISIBLE);
            textResult.setVisibility(View.VISIBLE);
            clipboardButton.setVisibility(View.VISIBLE);
            pasteButton.setVisibility(View.VISIBLE);
            loginButton.setText("Logout");
        }
    }

    private void togglePasteState(boolean inPasteState){
        if (inPasteState){
            pasteButton.setText("Make a Paste");
            clipboardButton.setText("Copy to Clipboard");
            pasteField.setVisibility(View.GONE);
            textResult.setVisibility(View.VISIBLE);
            nameWelcome.setVisibility(View.VISIBLE);
            title.setText("Paste Dump");
            RelativeLayout.LayoutParams params = new RelativeLayout.LayoutParams(
                    ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT
            );
            params.addRule(RelativeLayout.ABOVE, R.id.nameVal);
            params.addRule(RelativeLayout.CENTER_HORIZONTAL);
            title.setLayoutParams(params);
            refreshButton.setVisibility(View.VISIBLE);
            InputMethodManager imm = (InputMethodManager)getActivity().getSystemService
                    (Context.INPUT_METHOD_SERVICE);
            imm.hideSoftInputFromWindow(pasteField.getWindowToken() , 0);

        }else{
            title.setText("Make A Paste");
            RelativeLayout.LayoutParams params = new RelativeLayout.LayoutParams(
                    ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT
            );
            params.addRule(RelativeLayout.ABOVE, R.id.makePasteField);
            params.addRule(RelativeLayout.CENTER_HORIZONTAL);
            title.setLayoutParams(params);
            pasteField.setVisibility(View.VISIBLE);
            refreshButton.setVisibility(View.GONE);
            clipboardButton.setText("Send");
            pasteButton.setText("Back");
            textResult.setVisibility(View.GONE);
            nameWelcome.setVisibility(View.GONE);
            InputMethodManager imm = (InputMethodManager)getActivity().getSystemService
                    (Context.INPUT_METHOD_SERVICE);
            imm.toggleSoftInput(InputMethodManager.SHOW_FORCED, 0);
            pasteField.requestFocus();
        }
    }
}
