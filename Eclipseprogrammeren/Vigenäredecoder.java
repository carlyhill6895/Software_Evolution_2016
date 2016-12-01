import java.util.ArrayList;
import java.util.Collections;
public class Vigenèredecoder {
	public static ArrayList<Integer> array = new ArrayList<Integer>();
	public static ArrayList<Integer> grootstegemenedeler = new ArrayList<Integer>();
	public static ArrayList<Double> frequentie = new ArrayList<Double>();
	public static void main(String[] args) {
		Schermlezer sl = new Schermlezer();
		Decoder dc = new Decoder();
		StringBuilder sb= new StringBuilder();
		StringBuilder sb2= new StringBuilder();
		System.out.println("Dit is een vigenèredecoder. Volg de verdere instructies op.");
		String VAR1 = sl.LeesString("Voer de tekst in die gedecodeerd moet worden. In deze tekst kunnen GEEN spaties of leestekens zitten.");
		String VAR2 = sl.LeesString("Voer de taal van de code in ('Engels' of 'Nederlands').");
		String Codewoord = "";
		for (int i=0;i<VAR1.length()-2;i++){
			for (int i2=3; i2<VAR1.length()-2;i2++ ){
				if (VAR1.charAt(i) == VAR1.charAt(i2) && VAR1.charAt(i+1)== VAR1.charAt(i2+1) && VAR1.charAt(i+2)== VAR1.charAt(i2+2)){
					int i3= i2-i;
					if (i3>0){
						System.out.println("Deze combinatie is herhaald in de tekst:"+VAR1.charAt(i)+VAR1.charAt(i+1)+VAR1.charAt(i+2));
						System.out.println("De tekst tussen deze herhalingen in is:" +i3);	
						gemenedeler(i3);
					}
					}	
					else{
						}
			} 
		}
		Collections.sort(array);
		grootstegemenedeler.add(0);
		int choice = 0;
		for (int i = 2;i<=500;i++){
			int count = 0;
			for (int i2=0;i2<array.size();i2++){
				
				if(array.get(i2) == i){
					count =count +1;
				}
			}
				
			if (count>Collections.max(grootstegemenedeler)){
				grootstegemenedeler.add(count);
				choice = i;
			}
			if (count>0){
				System.out.println("Dit is het aantal keer dat er " + i + " tussen de tekst in zit:" + count);
			}
					
		}
		System.out.println("De lengte van het sleutelwoord is: "+ choice);
		int lengthVAR1=VAR1.length();
		double divider=lengthVAR1/choice;
		int extraletter=lengthVAR1%choice;

		if (VAR2.compareTo("NEDERLANDS") == 0){
			for (int i=1;i<=choice;i++){
				double counter =0.0;
				String VAR3="";
				sb= new StringBuilder();
				double freq=0.0;
				frequentie = new ArrayList<Double>();
				
				if (extraletter==0){
					for (int i2=0;i2<(int) divider;i2++){
						int place = (int) (0+(i-1)+ i2*choice);
						sb.append(VAR1.charAt(place));
					}
					VAR3=sb.toString();
					System.out.println("1:" + VAR3);
					for (int i3=65;i3<=90;i3++){
						counter =0.0;
						for( int i4=0; i4<VAR3.length(); i4++ ) {
						    if( VAR3.charAt(i4) == (char) i3 ) {
						        counter++;
						    } 
						}
						freq=(counter/VAR3.length())*100.0;
						frequentie.add(freq);
					}
				}
				if(extraletter<choice&&extraletter>0){
					if (i<extraletter){
						for (int i3=0;i3<((int) divider)+1;i3++){
							int place = (int) (0+(i-1)+ i3*choice);
							sb.append(VAR1.charAt(place));	
						}
						VAR3=sb.toString();
						System.out.println("2:"+ VAR3);
						for (int i3=65;i3<=90;i3++){
							counter =0.0;
							for( int i4=0; i4<VAR3.length(); i4++ ) {
								if( VAR3.charAt(i4) == (char) i3 ) {
									counter++;
								} 
							}
							freq=(counter/VAR3.length())*100.0;
							frequentie.add(freq);
						}
					}
					if (i>=extraletter){
						for (int i2=0;i2<(int) divider;i2++){
							int place = (int) (0+(i-1)+ i2*choice);
							sb.append(VAR1.charAt(place));
						}
						VAR3=sb.toString();
						System.out.println("3:"+ VAR3);
						for (int i3=65;i3<=90;i3++){
							counter =0.0;
							for( int i4=0; i4<VAR3.length(); i4++ ) {
								if( VAR3.charAt(i4) == (char) i3 ) {
									counter++;
								} 
							}
							freq=(counter/VAR3.length())*100.0;
							frequentie.add(freq);
						}
					}
				}
				for (int i5=0;i5<=25;i5++){
					//if (i5 <4){
					// if (frequentie.get(i5)>14.00 && frequentie.get(i5+21)>5.5){
						//int LetterE=i5;
						//char LetterA=(char) (LetterE+21 +(int)'A');
						//sb2.append(LetterA);
					//}
				//}
				//if (i5 >3){
					// if (frequentie.get(i5)>14.00 && frequentie.get(i5-4)>5.5){
						//int LetterE=i5;
						//char LetterA=(char) (LetterE-4 +(int)'A');
						//sb2.append(LetterA);
					//}
				//}
					if (frequentie.get(i5)==Collections.max(frequentie)){
						int LetterE=i5;
						if (LetterE>3){
							char LetterA=(char) (LetterE-4 +(int)'A');
							sb2.append(LetterA);
						}
						if(LetterE<4){
							char LetterA=(char)((LetterE+21)+(int)'A');
							sb2.append(LetterA);
						}
						System.out.println("Dit is de encryptieletter van deel "+i + " van het codewoord: "+sb2);
					}
				}
			}
			Codewoord=sb2.toString();
			System.out.println(Codewoord);
		}
		if (VAR2.compareTo("ENGELS") == 0){
			for (int i=1;i<=choice;i++){
				double counter =0.0;
				String VAR3="";
				sb= new StringBuilder();
				double freq=0.0;
				frequentie = new ArrayList<Double>();
				if (extraletter==0){
					for (int i2=0;i2<(int) divider;i2++){
						int place = (int) (0+(i-1)+ i2*choice);
						sb.append(VAR1.charAt(place));
					}
					VAR3=sb.toString();
					System.out.println("1:" + VAR3);
					for (int i3=65;i3<=90;i3++){
						for( int i4=0; i4<VAR3.length(); i4++ ) {
							counter =0.0;
						    if( VAR3.charAt(i4) == (char) i3 ) {
						        counter++;
						    } 
						}
						freq=(counter/VAR3.length())*100.0;
						frequentie.add(freq);
					}
				}
				if(extraletter<choice&&extraletter>0){
					if (i<extraletter){
						for (int i3=0;i3<((int) divider)+1;i3++){
							int place = (int) (0+(i-1)+ i3*choice);
							sb.append(VAR1.charAt(place));	
						}
						VAR3=sb.toString();
						System.out.println("2:" + VAR3);
						for (int i3=65;i3<=90;i3++){
							counter =0.0;
							for( int i4=0; i4<VAR3.length(); i4++ ) {
								if( VAR3.charAt(i4) == (char) i3 ) {
									counter++;
								} 
							}
							freq=(counter/VAR3.length())*100.0;
							frequentie.add(freq);
						}
					}
					if (i>=extraletter){
						for (int i2=0;i2<(int) divider;i2++){
							int place = (int) (0+(i-1)+ i2*choice);
							sb.append(VAR1.charAt(place));
						}
						VAR3=sb.toString();
						System.out.println("3:" + VAR3);
						for (int i3=65;i3<=90;i3++){
							counter =0.0;
							for( int i4=0; i4<VAR3.length(); i4++ ) {
								if( VAR3.charAt(i4) == (char) i3 ) {
									counter++;
								} 
							}
							freq=(counter/VAR3.length())*100.0;
							frequentie.add(freq);
						}
					}
				}
				for (int i5=0;i5<=25;i5++){
					//if (i5 <4){
					// if (frequentie.get(i5)>10.00 && frequentie.get(i5+21)>6.00){
						//int LetterE=i5;
						//char LetterA=(char) (LetterE+21 +(int)'A');
						//sb2.append(LetterA);
					//}
				//}
				//if (i5 >3){
					// if (frequentie.get(i5)>10.00 && frequentie.get(i5-4)>6.00){
						//int LetterE=i5;
						//char LetterA=(char) (LetterE-4 +(int)'A');
						//sb2.append(LetterA);
					//}
				//}
					if (frequentie.get(i5)==Collections.max(frequentie)){
						int LetterE=i5;
						if (LetterE>3){
							char LetterA=(char) (LetterE-4 +(int)'A');
							sb2.append(LetterA);
						}
						if(LetterE<4){
							char LetterA=(char)((LetterE+21)+(int)'A');
							sb2.append(LetterA);
						}
						System.out.println("Dit is de encryptieletter van deel "+i + " van het codewoord: "+sb2);
					}
				}
			}
			Codewoord=sb2.toString();
			System.out.println(Codewoord);
		}
		dc.decoderen(VAR1,Codewoord);
		
	}
	

		
	

	public static void gemenedeler(int i3 ){
		for(int i=1;i<=i3;i++){
		int i2=	i3% i;
				if(i2==0){
					
					System.out.println("De gemene deler is: " + i);
					array.add(i);
				}
		}
		
	}

}

