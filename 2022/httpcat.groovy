package test;

import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.security.KeyManagementException;
import java.security.KeyStoreException;
import java.security.NoSuchAlgorithmException;
import java.security.UnrecoverableKeyException;
import java.security.cert.CertificateException;

import javax.ws.rs.GET;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.Response;

import org.apache.commons.cli.CommandLine;
import org.apache.commons.cli.DefaultParser;
import org.apache.commons.cli.HelpFormatter;
import org.apache.commons.cli.Option;
import org.apache.commons.cli.Options;
import org.apache.commons.cli.ParseException;
import org.glassfish.jersey.jdkhttp.JdkHttpServerFactory;
import org.glassfish.jersey.server.ResourceConfig;
import org.json.JSONException;

public class HttpCat {

  @javax.ws.rs.Path("")
  public static class MyResource { // Must be public

    @GET
    @javax.ws.rs.Path("")
    @Produces("application/json")
    public Response list(@QueryParam("value") String iValue, @QueryParam("key") String iKey,
        @QueryParam("categoryId") String iCategoryId) throws JSONException, IOException {
      System.err.println("list()");
      System.err.println("Writing to stdout: " + iCategoryId + "::" + System.currentTimeMillis() + "::" + iValue);
      System.out.println(iCategoryId + "::" + System.currentTimeMillis() + "::" + iValue);
      return Response.ok().header("Access-Control-Allow-Origin", "*").type("application/json").build();
    }
  }

  public static void main(String[] args)
      throws URISyntaxException, IOException, KeyManagementException, UnrecoverableKeyException,
      NoSuchAlgorithmException, KeyStoreException, CertificateException, InterruptedException {

    String port;
    _parseOptions: {

      Options options = new Options().addOption("p", "port", true, "Here you can set parameter .").addOption("h",
          "help", false, "show help.");

      Option option = Option.builder("a").longOpt("block-size").desc("use SIZE-byte blocks").hasArg().argName("SIZE")
          .build();
      options.addOption(option);

      // This doesn't work
      // options.addOption(Option.builder("p").argName("p").longOpt("port").required().build());

      try {
        CommandLine cmd = new DefaultParser().parse(options, args);
        port = cmd.getOptionValue("p", "4499");
        System.out.println("CommandLineOptionsExample.parse() - SRIDHAR: port = " + port);
        System.out.println("CommandLineOptionsExample.parse() - SRIDHAR: a = " + cmd.getOptionValue("a"));

        if (cmd.hasOption("h")) {
          // This prints out some help
          HelpFormatter formater = new HelpFormatter();

          formater.printHelp("Main", options);
          System.exit(0);
        }
      } catch (ParseException e) {
        e.printStackTrace();
      }
    }

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
