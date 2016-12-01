package src;

import java.awt.Color;
import java.awt.Font;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.ArrayList;
import java.util.Collections;

import javax.swing.*;

public class VigenereWindow extends JFrame implements ActionListener {

	private static final long serialVersionUID = 3620355025221733276L;

	/* COMPONENTS */
	JLabel TitleLabel;
	
	JLabel KeyWordLabel;
	JLabel TaalLabel;
	
	JTextArea CipherTextArea;
	
	JTextField KeyWordTextField;
	JTextField TaalTextField;
	
	JButton AnalyseButton;
	
	JButton DecipherButton;
	
	JMenuBar MenuBar;
	
	//// VIGENERE WINDOW ////
	public VigenereWindow(String Title) {
		super(Title);
		
		try {
	        UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
	    } catch (Exception e) {
	    	
	    }
		
		// Window Layout;
		setLayout(null);
		setSize(500, 550);
		setLocation(250, 250);
		
		// Window Icon;
		ImageIcon img = new ImageIcon("encryption-icon.png");
		setIconImage(img.getImage());
		
		// Window Settings;
		setDefaultCloseOperation(EXIT_ON_CLOSE);
		setDefaultLookAndFeelDecorated(true);
		setResizable(false);
		getContentPane( ).setBackground(new Color  (240, 248, 255 ));
		
		// Create Components;
		createComponents();
	}
	
	private void createComponents() {
		JMenu VigenereMenu = new JMenu("Vigenère");
		VigenereMenu.add(new JMenuItem("Nieuw ..."));
		VigenereMenu.add(new JMenuItem("Afsluiten"));

		
		MenuBar = new JMenuBar();
		MenuBar.add(VigenereMenu);
		MenuBar.setSize(500, 25);
		MenuBar.setLocation(0, 0);
		add(MenuBar);
		
		TitleLabel = new JLabel("Gecodeerde Vigenère tekst:(tekst zonder spaties of leestekens)");
		TitleLabel.setSize(500, 15);
		TitleLabel.setLocation(6, 32);
		TitleLabel.setFont(new Font("Arial", Font.PLAIN, 14));
		add(TitleLabel);
		
		CipherTextArea = new JTextArea();
		CipherTextArea.setSize(470, 380);
		CipherTextArea.setLocation(5, 50);
		CipherTextArea.setBorder(BorderFactory.createLineBorder(new Color(205,181,205)));
		CipherTextArea.setLineWrap(true);
        add(CipherTextArea);
	
		KeyWordLabel = new JLabel("Sleutel:");
		KeyWordLabel.setSize(75, 15);
		KeyWordLabel.setLocation(12, 441);
		KeyWordLabel.setFont(new Font("Arial", Font.PLAIN, 11));
		add(KeyWordLabel);
		
		KeyWordTextField = new JTextField();
		KeyWordTextField.setSize(195, 25);
		KeyWordTextField.setLocation(60, 435);
		KeyWordTextField.setBorder(BorderFactory.createLineBorder(new Color(205,181,205)));
		add(KeyWordTextField);
		
		TaalLabel = new JLabel("Taal:(Engels/Nederlands)");
		TaalLabel.setSize(130, 15);
		TaalLabel.setLocation(12, 471);
		TaalLabel.setFont(new Font("Arial", Font.PLAIN, 11));
		add(TaalLabel);
		
		TaalTextField = new JTextField();
		TaalTextField.setSize(195, 25);
		TaalTextField.setLocation(140, 465);
		TaalTextField.setBorder(BorderFactory.createLineBorder(new Color(205,181,205)));
		add(TaalTextField);
		
		AnalyseButton = new JButton("Ontcijfer");
		AnalyseButton.setSize(100, 25);
		AnalyseButton.setLocation(270, 435);
		AnalyseButton.setActionCommand("ontcijfer");
		AnalyseButton.addActionListener(this);
		add(AnalyseButton);
		
		DecipherButton = new JButton("Ontsleutel");
		DecipherButton.setSize(100, 25);
		DecipherButton.setLocation(375, 435);
		DecipherButton.setActionCommand("ontsleutel");
		DecipherButton.addActionListener(this);
		add(DecipherButton);
	}
	//// VIGNERE WINDOW ////
	
	//// ACTION(S) ////
	@Override
	public void actionPerformed(ActionEvent e) {
		if(e.getActionCommand().compareTo("ontcijfer") == 0) {
			this.analyseText();
		}
		else if (e.getActionCommand().compareTo("ontsleutel") == 0) {
			this.decryptText();
		}
		else {
			System.out.println("System Error: No ACTION specified.");
		}
	}
	//// ACTION(S) ////
	
	//// METHOD(S) ////

	public static ArrayList<Integer> array = new ArrayList<Integer>();
	ArrayList<Integer> grootstegemenedeler = new ArrayList<Integer>();
	ArrayList<Double> frequentie = new ArrayList<Double>();
	ArrayList<Double> frequentienl = new ArrayList<Double>();
	ArrayList<Double> frequentieen = new ArrayList<Double>();
	ArrayList<Double> frequentieverschillen = new ArrayList<Double>();
	ArrayList<Double> frequentieverschil = new ArrayList<Double>();
	public void analyseText() {
		// De variabele 'cipherText' bevat de ingevoerde tekst;
		String Taal=TaalTextField.getText();
		String key="";
		StringBuilder sb = new StringBuilder();
		StringBuilder sb2 = new StringBuilder();
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
		String cipherText = CipherTextArea.getText();
		for (int k = 3; k < 6; k++) {//lengte van de substring
			for (int i = 0; i <= cipherText.length() - k; i++) {
				for (int i2 = i + 1; i2 <= cipherText.length() - k; i2++) {
					if (cipherText.substring(i,  i + k).compareTo(cipherText.substring(i2, i2 + k)) == 0) {
						int i3 = i2 - i;//aantal letters tussen de 2 gelijke substrings
						if (i3 > 0) {
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
				choice = i;//bij elke grootste telling een nieuwe waarschijnlijke sleutellengte, laatste is dus echte sleutellengte
			}
		}

		for (int i = 0; i < choice; i++) {
			double counter = 0.0;
			String VAR3 = "";
			sb = new StringBuilder();
			double freq = 0.0;
			frequentie = new ArrayList<Double>();
			frequentieverschillen=new ArrayList<Double>();

			for (int j = i; j < cipherText.length(); j = j + choice) {
				sb.append(cipherText.charAt(j));//maak een zin met de karakters die met 1 letter gecodeerd zijn
			}
			VAR3 = sb.toString();
			System.out.println(VAR3);

			for (int i3 = 65; i3 <= 90; i3++) {
				counter = 0.0;
				for (int i4 = 0; i4 < VAR3.length(); i4++) {
					if (VAR3.charAt(i4) == (char) i3) {
						counter++;//tel hoe vaak een bepaalde letter in de zin voorkomt
					}
				}
				freq = (counter / (double) VAR3.length());
				frequentie.add(freq);
			}
			double totaalverschil=0.0;
			for (int i5 = 0; i5 <= 25; i5++) {
				frequentieverschil=new ArrayList<Double>();
				for(int i6=0;i6<=25;i6++){
					if (Taal.compareTo("Nederlands") == 0){
							frequentieverschil.add((frequentienl.get(i6)-frequentie.get((i6+i5)%26))*(frequentienl.get(i6)-frequentie.get((i6+i5)%26)));
					}
					if(Taal.compareTo("Engels") == 0){
							frequentieverschil.add((frequentieen.get(i6)-frequentie.get((i6+i5)%26))*(frequentieen.get(i6)-frequentie.get((i6+i5)%26)));
					}
				}
				totaalverschil=getsum(frequentieverschil);//bekijk wat de verschillen zijn per letter en zoek hier het totaalverschil van op
				frequentieverschillen.add(totaalverschil);
			}
			int minimumverschil=0;
			for (int i2 = 0; i2 <= 25; i2++) {
				if (frequentieverschillen.get(i2)==Collections.min(frequentieverschillen)){
					minimumverschil=i2;//kijk welke alfabetten het kleinste verschil hebben
					System.out.print(minimumverschil);
				}
			}
			char letterA= (char) (minimumverschil + (int) 'A');
			System.out.println(letterA);
			sb2.append(letterA);	//zoek de letter op die bij het codewoord hoort en zet deze bij het codewoord
		}
		key = sb2.toString();
		KeyWordTextField.setText(key);
	}
	public static void gemenedeler(int i3) {
		for (int i = 1; i <= i3; i++) {
			int i2 = i3 % i;
			if (i2 == 0) {
				array.add(i);//voeg gemene deler toe aan lijst
			}
		}
	}
	public static double getsum (ArrayList<Double> frequentieverschil){
		double sum=0.0;
		for(int i=0;i<frequentieverschil.size();i++){
			sum=sum+frequentieverschil.get(i);//maak een optelling van alle verschillen bij elkaar
		}
		return sum;
	}
	public void decryptText() {
		// De variabele 'cipherText' bevat de ingevoerde tekst; De variabele 'key' de sleutel;
		Decoder dc = new Decoder();
		String cipherText = CipherTextArea.getText();
		String key = KeyWordTextField.getText();
		String decodedText = dc.decoderen(cipherText, key);
		CipherTextArea.setText(decodedText);
	}
	
}
