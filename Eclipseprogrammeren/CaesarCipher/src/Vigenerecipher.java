
public class Vigenerecipher {
	public static void main(String[] args){
		//BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
		StringBuilder sb = new StringBuilder();
		//de public class en public static void zijn de algemene eisen om een Java-programma
		//in elkaar te zetten, zonder deze werkt het niet. Met import haal je het programma
		//binnen dat tekst in kan lezen, en de functie bf is een functie om tekst in te lezen.
		//De functie sb maakt van verschillende letters een zin, oftewel char->string.
		Schermlezer sl = new Schermlezer();
		
		System.out.println("Java vigenère Cipher");
	
		String VAR1 = sl.LeesString("Geef een tekst op:");
		String VAR2 = sl.LeesString("Geef een encryptiewoord op:");
		for(int i = 0; i < VAR1.length(); i++)
		{
			VAR1.charAt(i);
			char VAR4 = vigenere.encrypt(VAR1.charAt(i), VAR2.charAt(i));
			System.out.println("Letter  " + VAR1.charAt(i)+ ": " +VAR4);
			sb.append(VAR4);
		}
		System.out.println("Output: " + sb);
	}
	

}
