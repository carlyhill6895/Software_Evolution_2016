
public class vigenere {
	public static char encrypt(char letter, int encryptieletter)
	{
		int VAR3 = (int) letter - (int) 'A' +( encryptieletter - (int) 'A');
		VAR3= (VAR3 %26) + (int)'B';
		return (char) VAR3;
	}
}
