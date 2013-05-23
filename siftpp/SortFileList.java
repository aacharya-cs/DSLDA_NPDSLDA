import java.io.*;
import java.util.Map;
import java.util.TreeMap;
public class SortFileList 
{
	public static void main(String args[])
	{
		try{
			FileInputStream fstream = new FileInputStream("filepaths.txt");
			DataInputStream in = new DataInputStream(fstream);
			BufferedReader br = new BufferedReader(new InputStreamReader(in));

			// read file

			Map <String, Integer> PathTree = new TreeMap <String, Integer>();
			String strLine, LocalStringCopy = null, imgstr;


			while ((strLine = br.readLine()) != null)   {
				String[] LocalString = strLine.split("_");
				for (int i=0; i<LocalString.length-1; i++)
					LocalStringCopy = LocalStringCopy.concat(LocalString[i]).concat("_");

				Integer imgnum = Integer.parseInt(LocalString[LocalString.length-1]);
				if (imgnum<10)
					imgstr = "000".concat(imgnum.toString());
				else if(imgnum<100)
					imgstr = "00".concat(imgnum.toString());
				else
					imgstr = "0".concat(imgnum.toString());
				LocalStringCopy =  LocalStringCopy.concat(imgstr).concat(".pgm");
				PathTree.put(LocalStringCopy, 1);
			}
			in.close();


			// write to file
			Writer output = null;
			File file = new File("sorted_filepaths.txt");
			output = new BufferedWriter(new FileWriter(file));
			System.out.println("Your file has been written");  

			for(Map.Entry<String,Integer> entry : PathTree.entrySet()) {
				String key = entry.getKey();
				output.write(key.concat("\n"));
			}
			output.close();

		}catch (Exception e){//Catch exception if any
			System.err.println("Error: " + e.getMessage());
		}
	}
}

