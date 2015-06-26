package pastedump.vishalkuo.com.pastedump;

import retrofit.Callback;
import retrofit.http.Body;
import retrofit.http.POST;

/**
 * Created by vishalkuo on 15-06-25.
 */
public interface Service {
    @POST("/")
    void newTask(@Body Task task, Callback<String> taskCallback);
}
