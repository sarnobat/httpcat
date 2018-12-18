import java.io.File;
import java.io.IOException;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.List;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.FilenameUtils;

import com.google.common.collect.ImmutableList;

/**
 * Uses wget. If successful, remove the line from the file
 */
public class DownloadFileFromList {

	public static void main(String[] args) throws InterruptedException, IOException {
		if (args.length != 3) {
			throw new RuntimeException(
					"Usage: groovy download_file_from_list.groovy [list.txt] [/destdir] [success.txt] ");
		}
		String listFile = args[0];
		String destination = args[1];
		String successFilePath = args[2];
		File listfile1 = Paths.get(listFile).toFile();

		while (true) {
			List<String> linesList = FileUtils.readLines(listfile1);
			if (linesList.size() < 1) {
				System.err.println("Finished");
				return;
			}
			String url = linesList.get(0);

			if (!Paths.get(destination).toFile().exists()) {
				throw new RuntimeException("Does not exist: " + destination);
			}
try {
			String url1 = new URL(url).getPath();
			String b = FilenameUtils.getBaseName(url1);
			String x = FilenameUtils.getExtension(url1);
			String filename = b + "." + x;

			// find a file name that doesn't clash with what's on disk
			String destPathNonColliding = determineDestinationPathAvoidingExisting(
					destination + "/" + filename).toString();
			Process p = new ProcessBuilder()
					.directory(Paths.get(destination).toFile())
					.command("echo", "hello world")
					.command(
							"/bin/sh",
							"-c",
							"wget --content-disposition --tries=3 --no-check-certificate --backups=10 --directory-prefix='"
									+ destination + "' --output-document='" + destPathNonColliding
									+ "' '" + url + "'").inheritIO().start();
			p.waitFor();
			if (p.exitValue() == 0) {
				System.err.println("appendToTextFile() - successfully downloaded " + url);
			} else {
				System.err.println("appendToTextFile() - error downloading " + url);
			}

			// Check that the file exists locally
			if (!Paths.get(destPathNonColliding).toFile().exists()) {
			//	throw new RuntimeException("Did not get downloaded successfully: "
			//			+ destPathNonColliding);
				System.err.println("[ERROR: File did not get downloaded, skipping]");
			}
			// Remove the line from the top of the file
			String attemptedUrl = linesList.remove(0);
			linesList.add(attemptedUrl);
			FileUtils.writeLines(listfile1, linesList);

			// Write the url to a success file
			File successFile = Paths.get(successFilePath).toFile();
			String entry = url + "::" + destPathNonColliding;
			if (Paths.get(destPathNonColliding).toFile().exists()) {
				FileUtils.writeLines(successFile, ImmutableList.of(entry), true);
			} else {
				System.err.println("[ERROR] Did not get downloaded to expected location: " + entry);
			}
} catch (Exception e) {
                                System.err.println("[ERROR] Exception: " + e);
//throw new RuntimeException("Temp");

                        // Remove the line from the top of the file
                        String attemptedUrl = linesList.remove(0);
                        linesList.add(attemptedUrl);
                        FileUtils.writeLines(listfile1, linesList);
}
			// print the URL in case we want to do more things after (but note
			// it is
			// unreliable)
			System.out.println(url);
		}
	}

	private static java.nio.file.Path determineDestinationPathAvoidingExisting(
			String iDestinationFilePath) throws IllegalAccessError {
		String theDestinationFilePathWithoutExtension = iDestinationFilePath.substring(0,
				iDestinationFilePath.lastIndexOf('.'));
		String extension = FilenameUtils.getExtension(iDestinationFilePath);
		java.nio.file.Path oDestinationFile = Paths.get(iDestinationFilePath);
		while (Files.exists(oDestinationFile)) {
			theDestinationFilePathWithoutExtension += "1";
			iDestinationFilePath = theDestinationFilePathWithoutExtension + "." + extension;
			oDestinationFile = Paths.get(iDestinationFilePath);
		}
		if (Files.exists(oDestinationFile)) {
			throw new RuntimeException("an existing file will get overwritten");
		}
		return oDestinationFile;
	}

}

