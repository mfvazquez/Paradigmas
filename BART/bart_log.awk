igawk 

BEGIN{

      OFS="\t"

      FixationScreen = "-"
      ROJitter = "-"
      MakeChoice = "-"
      Outcome = "-"
      
      OldMakeChoice = -1
      
      print "FixationScreen", "ROJitter1", "MakeChoice1", "Outcome";
}

{  

    if ($1 == "FixationScreen.OnsetTime:") FixationScreen = $2;
    else if ($1 == "ROJitter1.OnsetTime:") ROJitter = $2;
    else if ($1 == "MakeChoice1.OnsetTime:") MakeChoice = $2;
    else if ($1 == "Outcome:") Outcome = $2;

	if (MakeChoice == OldMakeChoice && Outcome != "-"){
		MakeChoice = "-";
		Outcome = "-";
	}

	if ($2 == "LogFrame" && 
		(FixationScreen != "-" || ROJitter!= "-" || (MakeChoice!= "-" && Outcome!= "-"))){

		print FixationScreen, ROJitter, MakeChoice, Outcome;

		if (MakeChoice != "-") OldMakeChoice = MakeChoice;

		FixationScreen = "-"
		ROJitter = "-"
		MakeChoice = "-"
		Outcome = "-"
    }
    
}
