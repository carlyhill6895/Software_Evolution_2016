
import java.io.*;

public class CaesarCipher {

	public static void main(String[] args) {
		String VAR1 = "Z";
		int VAR2 = 3;
		System.out.println("Typ de letters in die ge�ncrypt moet worden en druk op 'Enter'.");
		
		// Zorgt dat je input van het scherm kan lezen.
		BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
		StringBuilder sb = new StringBuilder();
				
		try
		{
			VAR1 = br.readLine();
		}
		catch(Exception e)
		{
			System.out.println("Er is een fout opgetreden, nl.: " + e);
		}
		
		for(int i = 0; i < VAR1.length(); i++)
		{
			VAR1.charAt(i);
			char VAR4 = encrypt(VAR1.charAt(i), VAR2);
			System.out.println("Het ASCII teken is letter: " + VAR4);
			sb.append(VAR4);
		}
		System.out.println(sb);
		
			//System.out.println ("Java Ceasar Encryptie");
			//System.out.println("Deze Ceasar-cipher zal alle letters " + VAR2 + " karakter(s) opschuiven.");
			//System.out.println("Deze letter zal worden ge-encrypt: " + VAR1);
		
			//int character = (int) VAR1;
			//System.out.println("De letter " + VAR1 + " is ACSII character: " + character);
			
		
		
		// System.out.println("Na encryptie (" + VAR1 + '+'  + VAR2 + ") krijgen we ASCII : " + VAR3 );
		
		//char VAR4 = encrypt(VAR1, VAR2);
		//System.out.println("Het ASCII teken is letter: " + VAR4);
	}
	
	public static char encrypt(char letter, int verschuiving)
	{
		int VAR3 = (int) letter - (int) 'A' + verschuiving;
		VAR3= (VAR3 %26) + (int)'A';
		return (char) VAR3;
	}

}
