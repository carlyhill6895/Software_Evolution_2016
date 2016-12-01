package src;

public class Decoder {
	private  StringBuilder sb = null;
	public Decoder() {
		sb= new StringBuilder();
	}
	public String decoderen(String VAR1, String Codewoord)
	{
		for (int i =0;i<VAR1.length();i++){
			int decodeergetal = (int) VAR1.charAt(i) - (int) Codewoord.charAt(i%Codewoord.length());
			decodeergetal = ((decodeergetal + 26) % 26) + 'A';
			char gedecodeerdeletter = (char) decodeergetal;
			sb.append(gedecodeerdeletter);
		}
		String gedecodeerdetekst = sb.toString();
		return gedecodeerdetekst;
	}
}
