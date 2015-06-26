package pastedump.vishalkuo.com.pastedump;

import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.support.v4.app.Fragment;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ProgressBar;
import android.widget.TextView;

import com.facebook.AccessToken;
import com.facebook.AccessTokenTracker;
import com.facebook.CallbackManager;
import com.facebook.FacebookCallback;
import com.facebook.FacebookException;
import com.facebook.FacebookSdk;
import com.facebook.Profile;
import com.facebook.login.LoginResult;
import com.facebook.login.widget.LoginButton;


/**
 * A placeholder fragment containing a simple view.
 */
public class MainFragment extends Fragment {

    private CallbackManager callbackManager;
    private AccessToken accessToken;
    private ProgressBar progressBar;
    private TextView textResult;
    private TextView nameWelcome;
    private Profile profile;
    private Button pasteButton;
    private Button clipboardButton;
    private EditText pasteField;
    private boolean isInPasteState = false;
    private Context c;



    private FacebookCallback<LoginResult> callback = new FacebookCallback<LoginResult>() {
        @Override
        public void onSuccess(LoginResult loginResult) {
            accessToken = loginResult.getAccessToken();
        }

        @Override
        public void onCancel() {

        }

        @Override
        public void onError(FacebookException e) {

        }
    };
    private AccessTokenTracker accessTokenTracker;

    public MainFragment() {
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        FacebookSdk.sdkInitialize(getActivity().getApplicationContext());

        callbackManager = CallbackManager.Factory.create();

        c = getActivity().getApplicationContext();
        accessTokenTracker = new AccessTokenTracker() {
            @Override
            protected void onCurrentAccessTokenChanged(AccessToken accessToken, AccessToken accessToken1) {
               if (accessToken1.getCurrentAccessToken() != null){
                   setHide(true);
                   new AsyncRecieve(getActivity().getApplicationContext(), progressBar, textResult,
                           accessToken1.getUserId()
                           , profile, nameWelcome, new AsyncFinish() {
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
        LoginButton loginButton = (LoginButton)view.findViewById(R.id.login_button);

        loginButton.setReadPermissions("user_friends");
        loginButton.setFragment(this);

        loginButton.registerCallback(callbackManager, callback);

        progressBar = (ProgressBar)view.findViewById(R.id.progressSpinner);
        textResult = (TextView)view.findViewById(R.id.pasteVal);
        nameWelcome = (TextView)view.findViewById(R.id.nameVal);
        pasteButton = (Button)view.findViewById(R.id.makePasteBtn);
        clipboardButton = (Button)view.findViewById(R.id.clipboardBtn);
        pasteField = (EditText)view.findViewById(R.id.makePasteField);


        final ClipboardManager clipboard = (ClipboardManager)getActivity().
                getSystemService(Context.CLIPBOARD_SERVICE);



        clipboardButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (!isInPasteState){
                    ClipData data = ClipData.newPlainText("myText", textResult.getText());
                    clipboard.setPrimaryClip(data);
                }else{
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
        }else{
            nameWelcome.setVisibility(View.VISIBLE);
            textResult.setVisibility(View.VISIBLE);
            clipboardButton.setVisibility(View.VISIBLE);
            pasteButton.setVisibility(View.VISIBLE);
        }
    }

    private void togglePasteState(boolean inPasteState){
        if (inPasteState){
            pasteButton.setText("Make a Paste");
            clipboardButton.setText("Copy to Clipboard");
            pasteField.setVisibility(View.GONE);
        }else{
            pasteField.setVisibility(View.VISIBLE);
            clipboardButton.setText("Send");
            pasteButton.setText("Back");
        }
    }
}
