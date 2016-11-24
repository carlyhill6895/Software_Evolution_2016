package test_project;

public class HelloWorld {

	/* ask a number
	 */
	public static void main(String[] args) {
		System.out.println("Hello World");
		System.out.println("Please choose a number between 1 and 5");
		AskQuestion qa = new AskQuestion();
		int number = qa.scanInt();
		if(number < 1){
			System.out.println("Your chosen number is too small...");
		}
		else if(number > 5){
			System.out.println("Your chosen number is too big...");
		}
		else{
			System.out.println("Wow, you are very good at following instructions!");
		}
	}

}
