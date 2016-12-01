import java.util.ArrayList;
import java.util.Collections;

public class Jaaa {
	//maak lijsten aan
	public static ArrayList<Integer> array = new ArrayList<Integer>();
	public static ArrayList<Integer> grootstegemenedeler = new ArrayList<Integer>();
	public static ArrayList<Double> frequentie = new ArrayList<Double>();
	public static ArrayList<Double> frequentienl = new ArrayList<Double>();
	public static ArrayList<Double> frequentieen = new ArrayList<Double>();
	public static ArrayList<Double> frequentieverschillen = new ArrayList<Double>();
	public static ArrayList<Double> frequentieverschil = new ArrayList<Double>();
	public static void main(String[] args) {
		//voeg alle engelse en nederlandse frequenties toe aan lijsten
		frequentienl.add(0.0749);
		frequentienl.add(0.0158);
		frequentienl.add(0.0124);
		frequentienl.add(0.0593);
		frequentienl.add(0.1891);
		frequentienl.add(0.0081);
		frequentienl.add(0.0340);
		frequentienl.add(0.0238);
		frequentienl.add(0.0650);
		frequentienl.add(0.0146);
		frequentienl.add(0.0225);
		frequentienl.add(0.0357);
		frequentienl.add(0.0221);
		frequentienl.add(0.1003);
		frequentienl.add(0.0606);
		frequentienl.add(0.0157);
		frequentienl.add(0.00009);
		frequentienl.add(0.0641);
		frequentienl.add(0.0373);
		frequentienl.add(0.0679);
		frequentienl.add(0.0199);
		frequentienl.add(0.0285);
		frequentienl.add(0.0152);
		frequentienl.add(0.0004);
		frequentienl.add(0.00035);
		frequentienl.add(0.0139);

		frequentieen.add(0.0812);
		frequentieen.add(0.0149);
		frequentieen.add(0.0271);
		frequentieen.add(0.0432);
		frequentieen.add(0.1202);
		frequentieen.add(0.0230);
		frequentieen.add(0.0203);
		frequentieen.add(0.0592);
		frequentieen.add(0.0731);
		frequentieen.add(0.0010);
		frequentieen.add(0.0069);
		frequentieen.add(0.0398);
		frequentieen.add(0.0261);
		frequentieen.add(0.0695);
		frequentieen.add(0.0768);
		frequentieen.add(0.0182);
		frequentieen.add(0.0011);
		frequentieen.add(0.0602);
		frequentieen.add(0.0628);
		frequentieen.add(0.0910);
		frequentieen.add(0.0288);
		frequentieen.add(0.0111);
		frequentieen.add(0.0209);
		frequentieen.add(0.0017);
		frequentieen.add(0.0211);
		frequentieen.add(0.0007);
		Schermlezer sl = new Schermlezer();
		Decoder dc = new Decoder();
		StringBuilder sb = new StringBuilder();
		StringBuilder sb2 = new StringBuilder();
		System.out.println("Dit is een vigenèredecoder. Volg de verdere instructies op.");
		String VAR1 = sl.LeesString("Voer de tekst in die gedecodeerd moet worden. In deze tekst kunnen GEEN spaties of leestekens zitten.");
		String VAR2 = sl.LeesString("Voer de taal van de code in ('Engels' of 'Nederlands').");
		String Codewoord = "";
		
		for (int k = 3; k < 6; k++) {//lengte van de substring
			for (int i = 0; i <= VAR1.length() - k; i++) {
				for (int i2 = i + 1; i2 <= VAR1.length() - k; i2++) {
					if (VAR1.substring(i,  i + k).compareTo(VAR1.substring(i2, i2 + k)) == 0) {
						int i3 = i2 - i;//aantal letters tussen de 2 gelijke substrings
						if (i3 > 0) {
							System.out.println("Deze combinatie is herhaald in de tekst:" + VAR1.substring(i, i + k));
							System.out.println("De tekst tussen deze herhalingen in is:" + i3);
							gemenedeler(i3);//zoekt alle delers van de tekst tussen de herhalingen en stopt ze in lijst 'array'
						}
					}
				}
			}
		}
		
		
		Collections.sort(array);//sorteer 'array'van klein naar groot
		grootstegemenedeler.add(0);//voeg eerste getal toe aan grootstegemenedeler
		int choice = 0;
		for (int i = 2; i <= 500; i++) {//waarschijnlijke lengte van sleutel
			int count = 0;
			for (int i2 = 0; i2 < array.size(); i2++) {

				if (array.get(i2) == i) {
					count = count + 1;//tellen hoe vaak elke gemene deler voorkomt in de lijst 'array
				}
			}

			if (count > Collections.max(grootstegemenedeler)) {
				grootstegemenedeler.add(count);
				choice = i;//bij elke grootste telling een nieuwe waarschijnlijke sleutellengte
			}
			if (count > 0) {
				System.out.println("Dit is het aantal keer dat er " + i+ " tussen de tekst in zit:" + count);
			}

		}
		System.out.println("De lengte van het sleutelwoord is: " + choice);

		for (int i = 0; i < choice; i++) {
			double counter = 0.0;
			String VAR3 = "";
			sb = new StringBuilder();
			double freq = 0.0;
			frequentie = new ArrayList<Double>();
			frequentieverschillen=new ArrayList<Double>();
			//maakt nieuwe lijsten en variabelen zodat deze geen gegevens van de vorige loops meer bevatten.
			for (int j = i; j < VAR1.length(); j = j + choice) {
				sb.append(VAR1.charAt(j));
			}
			VAR3 = sb.toString();//maak zinnen van de letters die met één bepaalde letter van het codewoord gecodeerd zijn
			System.out.println(VAR3);

			for (int i3 = 65; i3 <= 90; i3++) {
				counter = 0.0;
				for (int i4 = 0; i4 < VAR3.length(); i4++) {
					if (VAR3.charAt(i4) == (char) i3) {
						counter++;
					}
				}
				freq = (counter / (double) VAR3.length());
				frequentie.add(freq);//bereken de frequentie van alle letters in de zin
			}
			double totaalverschil=0.0;
			for (int i5 = 0; i5 <= 25; i5++) {
				frequentieverschil=new ArrayList<Double>();
				for(int i6=0;i6<=25;i6++){
					if (VAR2.compareTo("NEDERLANDS") == 0){
							frequentieverschil.add((frequentienl.get(i6)-frequentie.get((i6+i5)%26))*(frequentienl.get(i6)-frequentie.get((i6+i5)%26)));
					}
					if(VAR2.compareTo("ENGELS") == 0){
							frequentieverschil.add((frequentieen.get(i6)-frequentie.get((i6+i5)%26))*(frequentieen.get(i6)-frequentie.get((i6+i5)%26)));
					}
				}
				totaalverschil=getsum(frequentieverschil);//bereken de totale verschillen tussen de 2 frequentietabellen
				frequentieverschillen.add(totaalverschil);
			}
			int minimumverschil=0;
			for (int i2 = 0; i2 <= 25; i2++) {
				if (frequentieverschillen.get(i2)==Collections.min(frequentieverschillen)){
					minimumverschil=i2;//Minimumverschil:tabellen liggen dichtst bij elkaar:letter A van codewoord is gelijk aan letter van minimumverschil
					System.out.print(minimumverschil);
				}
			}
			char letterA= (char) (minimumverschil + (int) 'A');
			System.out.println(letterA);
			sb2.append(letterA);	
		}
		Codewoord = sb2.toString();
		System.out.println("Dit is het codewoord: " + Codewoord);

		String gedecodeerdetekst = dc.decoderen(VAR1, Codewoord);
		System.out.println(gedecodeerdetekst);
	}

	public static void gemenedeler(int i3) {
		for (int i = 1; i <= i3; i++) {
			int i2 = i3 % i;
			if (i2 == 0) {

				System.out.println("De gemene deler is: " + i);
				array.add(i);//voeg gemene deler toe aan lijst
			}
		}
	}
	public static double getsum (ArrayList<Double> frequentieverschil){
		double sum=0.0;
		for(int i=0;i<frequentieverschil.size();i++){
			sum=sum+frequentieverschil.get(i);
		}
		return sum;
	}
}
