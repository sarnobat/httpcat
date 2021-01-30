import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.List;

import org.apache.commons.io.FileUtils;

import com.google.common.collect.ImmutableList;

/**
 * If successful, remove the line from the file
 */
public class DownloadVideosFromList {

	public static final String YOUTUBE_DOWNLOAD = System.getProperty("user.home") + "/bin/youtube_download";

	public static void main(String[] args) throws IOException, InterruptedException {
System.err.println("DownloadVideosFromList() - begin");
		if (args.length != 4) {
			throw new RuntimeException(
					"Usage: groovy download_file_from_list.groovy [list.txt] [/destdir] [success.txt] ");
		}
		String listFile = args[0];
		String destinationDir = args[1];
		String successFilePath = args[2]; // REDUNDANT - we update this when doing a "file exists" check 
		String failureFilePath = args[3];
		File listfile1 = Paths.get(listFile).toFile();
System.err.println("Iterating over lines in " + listFile);

		int attemptedCount = 0;
		while (true) {
			++attemptedCount;
			if (attemptedCount > Integer.parseInt(System.getProperty("max","100"))) {
			        System.err.println("[DEBUG] exceeded limit");
				break;
			}
			List<String> linesList = FileUtils.readLines(listfile1);
			if (linesList.size() < 1) {
				System.err.println("Finished");
				return;
			}
			String url = linesList.get(0);
			System.err.println("main(): url = " + url);
			if (!url.contains("yout") && !url.contains("dailymo")) {
				//throw new RuntimeException("This should have gotten filtered: " + url);
			}
			System.err.println("[DEBUG] About to launch process for " + url);

			Process p = new ProcessBuilder().directory(Paths.get(destinationDir).toFile())
					.command(ImmutableList.of(YOUTUBE_DOWNLOAD, url)).inheritIO().start();
			p.waitFor();
			String successOrFailureFilePath;
			if (p.exitValue() == 0) {
				System.err.println("appendToTextFile() - successfully downloaded " + url);
				successOrFailureFilePath = successFilePath;
			} else {
				System.err.println("appendToTextFile() - error downloading " + url);
				successOrFailureFilePath = failureFilePath;
			}

			// TODO: Check that the file exists locally

			// Remove the line from the top of the file
			linesList.remove(0);
			FileUtils.writeLines(listfile1, linesList);

			// Write the url to either the success file or the failure file
			File successFile = Paths.get(successOrFailureFilePath).toFile();
			FileUtils.writeLines(successFile, ImmutableList.of(url), true);
System.err.println("[DEBUG] Wrote to " + successOrFailureFilePath + ":\t" + url);

			// print the URL in case we want to do more things after (but note
			// it is unreliable)
			System.out.println(url);
		}
	}

}

