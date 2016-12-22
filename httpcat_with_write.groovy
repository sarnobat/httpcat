import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.nio.file.Paths;
import java.security.KeyManagementException;
import java.security.KeyStoreException;
import java.security.NoSuchAlgorithmException;
import java.security.UnrecoverableKeyException;
import java.security.cert.CertificateException;

import javax.ws.rs.GET;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.Response;

import org.apache.commons.io.FileUtils;
import org.glassfish.jersey.jdkhttp.JdkHttpServerFactory;
import org.glassfish.jersey.server.ResourceConfig;
import org.json.JSONException;

public class HttpCat {

	@javax.ws.rs.Path("")
	public static class MyResource { // Must be public

		@GET
		@javax.ws.rs.Path("")
		@Produces("application/json")
		public Response list(@QueryParam("value") String iValue,
				@QueryParam("key") String iKey,
				@QueryParam("categoryId") String iCategoryId)
				throws JSONException, IOException {
System.err.println("list()");
String line = iCategoryId + "::" + System.currentTimeMillis() + "::" + iValue;
System.err.println("Writing to stdout: " + line);
FileUtils.write(Paths.get(System.getProperty("user.home") + "sarnobat.git/yurl_queue_httpcat.txt").toFile(), line + "\n", true);
System.out.println(line);
			return Response.ok().header("Access-Control-Allow-Origin", "*")
					.type("application/json").build();
		}
	}

	public static void main(String[] args) throws URISyntaxException, IOException,
			KeyManagementException, UnrecoverableKeyException, NoSuchAlgorithmException,
			KeyStoreException, CertificateException, InterruptedException {
		try {
			JdkHttpServerFactory.createHttpServer(new URI("http://localhost:" + args[0] + "/"),
					new ResourceConfig(MyResource.class));
		} catch (Exception e) {
			// e.printStackTrace();
			System.err.println("Port already listened on.");
			System.exit(-1);
		}
	}
}
