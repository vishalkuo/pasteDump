package pastedump.vishalkuo.com.pastedump;

import com.google.gson.annotations.Expose;

/**
 * Created by vishalkuo on 15-06-25.
 */
public class Task {
    @Expose
    private String id;
    @Expose
    private String paste;
    @Expose
    private String code = "1";

    public Task(String id, String pasteVal) {
        this.id = id;
        this.paste = pasteVal;
    }
}
