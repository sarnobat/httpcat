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

	public static final String YOUTUBE_DOWNLOAD = "/home/sarnobat/bin/youtube_download";

	public static void main(String[] args) throws IOException, InterruptedException {
		if (args.length != 3) {
			throw new RuntimeException(
					"Usage: groovy download_file_from_list.groovy [list.txt] [/destdir] [success.txt] ");
		}
		String listFile = args[0];
		String destinationDir = args[1];
		String successFilePath = args[2];
		File listfile1 = Paths.get(listFile).toFile();

		while (true) {
			List<String> linesList = FileUtils.readLines(listfile1);
			if (linesList.size() < 1) {
				System.err.println("Finished");
				return;
			}
			String url = linesList.get(0);
			if (!url.contains("yout") && !url.contains("dailymo")) {
				throw new RuntimeException("This should have gotten filtered: " + url);
			}

			Process p = new ProcessBuilder().directory(Paths.get(destinationDir).toFile())
					.command(ImmutableList.of(YOUTUBE_DOWNLOAD, url)).inheritIO().start();
			p.waitFor();
			if (p.exitValue() == 0) {
				System.err.println("appendToTextFile() - successfully downloaded " + url);
			} else {
				System.err.println("appendToTextFile() - error downloading " + url);
				continue;
			}

			// TODO: Check that the file exists locally

			// Remove the line from the top of the file
			linesList.remove(0);
			FileUtils.writeLines(listfile1, linesList);

			// Write the url to a success file
			File successFile = Paths.get(successFilePath).toFile();
			FileUtils.writeLines(successFile, ImmutableList.of(url), true);

			// print the URL in case we want to do more things after (but note
			// it is unreliable)
			System.out.println(url);
		}
	}

}

