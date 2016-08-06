<?php

if (isset($_POST['victim'])){
	$cause = $_POST['cause'];
	$victim = $_POST['victim'];
	$comments = $_POST['comments'];
	$KillIdUser = trim($_POST['KillIdinput']);
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
	 $handle = fopen ('records.txt', 'a');
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

$killN = rand(0,4000);
$count = 0;

$readin = file('ToRank.txt');
foreach($readin as $fname){
	$count++;
	
	if($count == $killN)
	{
		$killID = $fname;
		break;
	}
}
$KILLURL = 'http://zkillboard.com/detail/'.$killID.'/';
?>

<form action = "RankRandoms.php" method="POST">
	<br>

	Your Character name: <input type="text" name="user_ID" value="<?php echo $user_ID; ?>">
	<br>
	Victim was fit for: 
	<select name="victim">
		<option>Hauling</option>
		<option>Mining</option>
		<optgroup label="PvE">
			<option>PvE</option>
			<option>Scan-Sites</option>
			<option>Sleepers</option>
		</optgroup><optgroup label="PvP">
			<option>PvP Generic</option>
			<option>Cloacky</option>
			<option>Tackle</option>
			<option>Cyno</option>
			<option>E-War</option>
			<option>Logi</option>
			<option>Capital Warfare</option>
		</optgroup>
		<option>Scanning</option>
		<option>Other</option>
		<option>A Pos</option>
	</select> 

	</select> and died in/was killed by
		<select name="cause">
		<optgroup label="ScullyDawgs">
			<option>Piracy</option>
			<option>Suicide Attack</option>
			<option>Concord</option>
			<option>Epic Fail</option>
		</optgroup>
		<optgroup label="Honourable">
			<option>Fleet Fight</option>
			<option>Camp/Gang</option>
			<option>Hi-sec War</option>
			<option>Siege</option>
			<option>Duel/Solo</option>
		</optgroup>
		
	</select> 
		Comments: 
	<input type="text" name="comments">
	<input type="submit" value="Submit">
	<br>
	<br>
	<br>
	<div style="text-align: center;"><iframe
	src= <?php echo $KILLURL; ?> height="700"
	width="100%">
	</iframe>
	
	
	<tr><td> <input type="hidden" name="KillIdinput" value="<?php echo $killID; ?>" ></td></tr>
	<input type="hidden" name="Nranked" value="<?php echo $Nranked; ?>" >
</form>


