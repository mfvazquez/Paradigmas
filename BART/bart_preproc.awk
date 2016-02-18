

######################################################################
# Preprocesses raw output of E-prime ChangeFrame partBART task
# Josh Brown 7 Jan. 2010
# ISSUES: 
######################################################################

igawk 

BEGIN{

 debug = 0; #set to 1 for debugging, 2 for verbose

OFS="\t"



# initBlockNum = 1; #first block number is 2

 #blockNum = 0; #will take on values 2 to 6

      scanCount = 0;

      cbal = "-"
      subj = "-"
      blockNum = "-"
      HighStakes = "-"

      BalloonNumber = "-"
      InflationNumber = "-"
      CurrentWager = "-"
      LeftRight = "-"
      Choice = "-"
      Outcome = "-"
      TotReward = "-"
      ROJitterDur = "-"

      RTTime = -1;
      RTval = -1;
      #gotAll = 0; #got all fields and ready to print the trial?

      #For some reason, some trials are recorded multiple times in eprime,
      # so need to keep track of them to avoid double entries
      oldSubj=-1; oldBlock=-1; oldBalloon=-1; oldInflation=-1;
}


####################### Patterns #############################


#note:  search string may have trouble with newlines as ^M?
{  
    ######### check for new subject
    if ($1 == "Subject:") {
      if (subj != $2) {  # reset block count if new subj
	#blockNum = 0;
	subj = $2; #blockNum +=1; scanCount = 0;
      }
    }

    if ($1 == "cbal:") cbal = $2

    ######### look for new block, and reset scan count if new
    if ($1 == "Session:") {if ($2 != blockNum) {blockNum = $2; scanCount = 0;}}

    ############ look for scanner pulses
    if ($2 == "SCANNER") {
      if (scanCount == 0) {
	  if (substr($1,1,15)=="WaitScanner.Key") {
	    scanBase = $6;
	    oldScanTime = scanTime;
	    scanTime = $6-scanBase;
	    scanCount++;
	    if (debug > 0) print scanTime, scanCount;
	  }
	  else print "INVALID first scan, not from WaitScanner event!"
      }
    }


    ############ look for task trials
    # use scan time as starting time of scan in which response occurs
    else if ($2 == "USER" && substr($1,1,10)=="MakeChoice" && RTTime < 0) {
      RTTime = $6; RTval = $4; 
      if ($5==2 || $5=="f") {
	LeftRight = "Left"; 
	if (cbal == "LeftInflate") Choice = "Inflate"
	else if (cbal == "RightInflate") Choice = "Stop"
	else Choice = "INVALID"
      }
      else if ($5==3 || $5=="j") {
	LeftRight = "Right";
	if (cbal == "LeftInflate") Choice = "Stop"
	else if (cbal == "RightInflate") Choice = "Inflate"
	else Choice = "INVALID"
      }
      else {LeftRight = "INVALID"; Choice = "INVALID"}
    }
    else if ($1 == "MakeChoice.OnsetTime:") OnsetTime = $2;
    else if ($1 == "BalloonNumber:") BalloonNumber = $2;
    else if ($1 == "InflationNumber:") InflationNumber = $2;
    else if ($1 == "CurrentWager:") CurrentWager = $3;
    else if ($1 == "TotRewardAttrib:") TotReward = $3;
    else if ($1 == "Outcome:" && Outcome == "-") Outcome = $2; #print BalloonNumber, InflationNumber;}
    else if ($1 == "^IROJitterDur:") ROJitterDur = $2;
    #else if (substr($1,1,3) == "ITI") gotAll = 1;
    else if ($2 == "LogFrame" && Outcome != "-"){

      if (RTTime == -1) { # Then error no response; should never happen
        Choice = "ErrNoResp"
	RTTime = OnsetTime; #Start of choice cue
        LeftRight = "-"
        RTTime = "-";
      }
    else if ($1 == "MakeChoice1.OnsetTime:") MakeChoice1 = $2;
    else if ($1 == "FixationScreen.OnsetTime:") FixationScreen = $2;
    else if ($1 == "ROJitter1.OnsetTime:") ROJitter1 = $2;
 
      ############ now have got all info for trial, so dump info
      scanNum = (RTTime - scanBase)/2000  #TR=2000
      RTsec = (RTTime - scanBase)/1000;
      cleanScanNum = int(scanNum+0.5);
      scanStartTime = scanTime/1000;
      cleanScanStartTime = int((RTTime-scanBase)/500+0.5)/2;
      absCleanScanStartTime = cleanScanStartTime+(blockNum-initBlockNum)*480  #blockLen = 480 secs
      absScanNum = cleanScanNum + (blockNum-initBlockNum)*240; #240 scans per block

      if (oldSubj!=subj || oldBlock!=blockNum || oldBalloon!=BalloonNumber || oldInflation!=InflationNumber) {
	
	print subj, blockNum, cleanScanNum, BalloonNumber, InflationNumber, LeftRight, Choice, RTval, RTTime, Outcome, CurrentWager, TotReward, scanNum, absScanNum, scanStartTime, cleanScanStartTime, absCleanScanStartTime, RTsec, ROJitterDur, MakeChoice, ROJitter1, FixationScreen;

      oldSubj=subj; oldBlock=blockNum; oldBalloon=BalloonNumber; oldInflation=InflationNumber;
      }
      ### be sure to reset vars here, to  empty fields:
      BalloonNumber = "-"
      InflationNumber = "-"
      CurrentWager = "-"
      LeftRight = "-"
      Choice = "-"
      Outcome = "-"
      TotReward = "-"
      ROJitterDur = "-"

      RTTime = -1;
      RTval = -1;
      #gotAll = 0;
      
    }
}

END{

  if (debug>0) print "Total scans:  " scanNum
}


