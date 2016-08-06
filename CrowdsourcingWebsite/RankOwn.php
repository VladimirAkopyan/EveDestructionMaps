<?php

if (isset($_POST['victim'])){
	$cause = $_POST['cause'];
	$victim = $_POST['victim'];
	$comments = $_POST['comments'];
	$KillIdUser = trim($_POST['killID']);
	$user_ID = $_POST['user_ID'];
	
	if(isset($_POST['Nranked']))
	{ 
		$Nranked = $_POST['Nranked'];
	}
	else
	{
		$Nranked =0;
	}
	
	/* Write User's selection, kilID and IP*/
	 $handle = fopen ('OWNrecords.txt', 'a');
	fwrite($handle, $user_ID);
	fwrite($handle, ',');
	fwrite($handle, $KillIdUser);
	fwrite($handle, ',');
	fwrite($handle, $victim);
	fwrite($handle, ',');
	fwrite($handle, $cause);
	fwrite($handle, ',');
	fwrite($handle, $comments."\n");
	fclose($handle); 
	$Nranked= $Nranked+1; 
	echo 'Thank you!  You ranked '.$Nranked.' kills so far!'; 
}

?>

<form action = "RankOwn.php" method="POST">
	<br>
	<span style="font-weight: bold;">Instructions: </span>
	To rank your own kills, you must open <a href="https://zkillboard.com/">Zkillboard</a> in a separate window, <br>
	and get KillID of the kill you are ranking. It is different for every kill.
	<br><br>
	Your Character name: <input type="text" name="user_ID" value="<?php echo $user_ID; ?>">
	<br><br>
	KillID: <input type="text" name="killID" >
	
	Victim was fit for: 
	<select name="victim">
		<option>Hauling</option>
		<option>Mining</option>
		<optgroup label="PvE">
			<option>PvE</option>
			<option>Scan-Sites</option>
			<option>Sleepers</option>
		</optgroup><optgroup label="PvP">
			<option>Cloacky</option>
			<option>Tackle</option>
			<option>Cyno</option>
			<option>Normal Battle</option>
			<option>E-War</option>
			<option>Logi</option>
			<option>Capital Warfare</option>
		</optgroup>
		<option>Scanning</option>
		<option>Other</option>
		<option>A Pos</option>
		<option>No idea</option>
	</select>

	</select> and died in/was killed by
		<select name="cause">
		<optgroup label="ScullyDawgs">
			<option>Piracy</option>
			<option>Suicide Attacked</option>
			<option>Concorded</option>

		</optgroup>
		<optgroup label="Honourable">
			<option>Fleet Fight</option>
			<option>Roaming Gang</option>
			<option>Hi-sec War</option>
			<option>Gate Camp</option>
			<option>Siege</option>
			<option>Duel/Solo</option>
		</optgroup>
	</select> 
	<br>
		Comments: 
	<input type="text" name="comments">
	<input type="submit" value="Submit">
	<br>
	<br>
	<br>
	<img style="width: 704px; height: 475px;" alt="Instructions"
	src="http://wildexpress.co.uk/surveytest/Capture.JPG">

	
	
	<input type="hidden" name="Nranked" value="<?php echo $Nranked; ?>" >
</form>


