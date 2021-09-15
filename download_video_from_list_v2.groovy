import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.List;


import java.io.*;
import com.google.common.collect.HashMultimap;
import com.google.common.collect.Multimap;
import org.apache.commons.io.FileUtils;

import com.google.common.collect.ImmutableList;

/**
 * If successful, remove the line from the file
 */
// Is there a way to rewrite this without specifying the input file and using stdin instead?
public class DownloadVideosFromList {

	public static final String YOUTUBE_DOWNLOAD = System.getProperty("user.home") + "/bin/youtube_download";

	public static void main(String[] args) throws IOException, InterruptedException {
System.err.println("DownloadVideosFromList() - begin");
		if (args.length != 4) {
			throw new RuntimeException(
					"Usage: groovy download_file_from_list.groovy [list.txt] [/destdir] [success.txt] ");
		}
		// /tmp/yurl_queue_httpcat_videos_undownloaded_reduced.txt ~/videos/ /tmp/yurl_queue_httpcat_videos_downloaded.txt ~/sarnobat.git/db/auto/yurl_queue_httpcat_videos_failed.txt 2> ~/download_video_from_list.log  | tee -a /tmp/yurl_queue_httpcat_videos_downloaded_unreliable.txt 
		String listFile = args[0]; // /tmp/yurl_queue_httpcat_videos_undownloaded_reduced.txt
		String destinationDir = args[1]; // ~/videos/
		String successFilePath = args[2]; // REDUNDANT - we update this when doing a "file exists" check 
			// /tmp/yurl_queue_httpcat_videos_downloaded.txt
		String failureFilePath = args[3]; // ~/sarnobat.git/db/auto/yurl_queue_httpcat_videos_failed.txt
		File listfile1 = Paths.get(listFile).toFile();
System.err.println("[DEBUG] Iterating over lines in " + listFile);

		_new: {
		 
			Multimap<String, String> parentToChildren = HashMultimap.create();
			BufferedReader br = null;
			try {
				int attemptedCount = 0;
				br = new BufferedReader(new InputStreamReader(System.in));
				String line;
				while ((line = br.readLine()) != null) {
					// log message
					System.err.println("[DEBUG] current line is: " + line);
			
// 					String[] elements = line.split("::");
// 					String parent = elements[0];
// 					String child = elements[1];

					++attemptedCount;

					if (attemptedCount > Integer.parseInt(System.getProperty("max","100"))) {
							System.err.println("[DEBUG] exceeded limit");
						// we can't use stdin because we need to edit the source file
						break;
					}
//					List<String> linesList = FileUtils.readLines(listfile1);
// 					if (linesList.size() < 1) {
// 						System.err.println("Finished");
// 						return;
// 					}
					String url = line;
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

					//linesList.remove(0);
//					FileUtils.writeLines(listfile1, linesList);

					// Write the url to either the success file or the failure file
					File successFile = Paths.get(successOrFailureFilePath).toFile();
					FileUtils.writeLines(successFile, ImmutableList.of(url), true);
		System.err.println("[DEBUG] Wrote to " + successOrFailureFilePath + ":\t" + url);

					// print the URL in case we want to do more things after (but note
					// it is unreliable)
					System.out.println(url);
			//		parentToChildren.put(parent, child);

					// program output
			//		System.out.println(line);
				}
			} catch (IOException e) {
				e.printStackTrace();
			} finally {
				if (br != null) {
					try {
						br.close();
					} catch (IOException e) {
						e.printStackTrace();
					}

				}
			}			
		}


		_old : {
		

			// Re-read the file on EVERY iteration
//			while (true) {
				
				// TODO: Check that the file exists locally

				// Remove the line from the top of the file

//			}
		}
	}

}

