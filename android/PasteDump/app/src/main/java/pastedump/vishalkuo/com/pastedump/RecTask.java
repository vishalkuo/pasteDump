package pastedump.vishalkuo.com.pastedump;

/**
 * Created by vishalkuo on 15-06-26.
 */
public class RecTask {
    private String id;
    private String code;
    private String paste;
    private String response;

    public String getResponse() {
        return response;
    }

    public void setResponse(String response) {
        this.response = response;
    }

    public String getId() {
        return id;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getPaste() {
        return paste;
    }

    public void setPaste(String paste) {
        this.paste = paste;
    }

    public RecTask(String i){
        this.id = i;
        this.code = "0";
    }

    public void setId(String id) {
        this.id = id;
    }

}
