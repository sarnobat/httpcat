import org.json.JSONObject;

import java.io.File;
import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.nio.charset.Charset;
import java.nio.file.Paths;
import java.security.KeyManagementException;
import java.security.KeyStoreException;
import java.security.NoSuchAlgorithmException;
import java.security.UnrecoverableKeyException;
import java.security.cert.CertificateException;
import java.util.List;

import javax.ws.rs.GET;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.Response;

import org.apache.commons.cli.*;
import org.apache.commons.io.FileUtils;
import org.glassfish.jersey.jdkhttp.JdkHttpServerFactory;
import org.glassfish.jersey.server.ResourceConfig;
import org.json.JSONException;

/** Just write the value. No key. */
public class HttpCatRemove {

	@javax.ws.rs.Path("")
	public static class MyResource { // Must be public

		@GET
		@javax.ws.rs.Path("")
		@Produces("application/json")
		public Response list(@QueryParam("value") String iValue)
				throws JSONException, IOException {
			// I wish I didn't have to do this in Java but I found that even
			// though the browser was returning success, nothing was getting
			// written to the file.

			List<String> lines = FileUtils.readLines(new File(filepath),
					Charset.defaultCharset());
			if (lines.remove(iValue)) {
				FileUtils.writeLines(Paths.get(filepath).toFile(), lines, false);
				System.err.println("[DEBUG] Successfully removed from file: "
						+ iValue);
				return Response.ok().header("Access-Control-Allow-Origin", "*")
						.type("application/json")
						.entity(new JSONObject().toString()).build();
			} else {
				return Response.serverError()
						.header("Access-Control-Allow-Origin", "*")
						.type("application/json")
						.entity(new JSONObject().toString()).build();
			}
		}
	}

	private static String filepath;

	@SuppressWarnings("unused")
	public static void main(String[] args) throws URISyntaxException,
			IOException, KeyManagementException, UnrecoverableKeyException,
			NoSuchAlgorithmException, KeyStoreException, CertificateException,
			InterruptedException {

		String port = null;
		_parseOptions: {

			Options options = new Options().addOption("h", "help", false,
					"show help.").addOption("f", "file", true, "use FILE to write incoming data to");

//			Option option = org.apache.commons.cli.Option.builder("f").longOpt("file")
//					.desc("use FILE to write incoming data to").hasArg()
//					.argName("FILE").build();
//			options.addOption(option);

			// This doesn't work with java 7
			// "hasarg" is needed when the option takes a value
			options.addOption(Option.builder("p").longOpt("port").hasArg()
					.required().build());

			try {
				CommandLine cmd = new DefaultParser().parse(options, args);
				port = cmd.getOptionValue("p", "4444");
				filepath = cmd.getOptionValue("f");

				if (cmd.hasOption("h")) {

					// This prints out some help
					HelpFormatter formater = new HelpFormatter();

					formater.printHelp("httpcat_remove.groovy", options);
					System.exit(0);
				}
			} catch (ParseException e) {
				e.printStackTrace();
				System.exit(-1);
			}
		}
		try {
			String url = "http://localhost:" + port + "/";
			JdkHttpServerFactory.createHttpServer(new URI(url),
					new ResourceConfig(MyResource.class));
		} catch (Exception e) {
			e.printStackTrace();
			System.err.println("Port already listened on.");
			System.exit(-1);
		}
	}
}
