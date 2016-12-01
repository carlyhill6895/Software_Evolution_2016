import java.io.*;
public class Schermlezer {
	public BufferedReader br = null;
	public Schermlezer (){
		br =  new BufferedReader(new InputStreamReader(System.in));
	}
		public String LeesString (String tekst)
		{
			String VAR1 = "";
			System.out.println(tekst);
			
			try
			{
				VAR1 = br.readLine().toUpperCase();
			}
			catch(Exception e)
			{
				System.out.println("Er is een fout opgetreden, nl.: " + e);
			}
			
			return  VAR1;
		}
	
}
