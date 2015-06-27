package pastedump.vishalkuo.com.pastedump;

import java.util.List;

import retrofit.Callback;
import retrofit.http.Body;
import retrofit.http.POST;

/**
 * Created by vishalkuo on 15-06-26.
 */
public interface RecieveService {
    @POST("/")
    void newTask(@Body RecTask task, Callback<List<RecTask>> taskCallback);
}
