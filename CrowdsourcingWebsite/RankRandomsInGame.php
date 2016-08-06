<?php

if (isset($_POST['victim'])){
	$cause = $_POST['cause'];
	$victim = $_POST['victim'];
	$comments = $_POST['comments'];
	$KillIdUser = trim($_POST['KillIdinput']);
	$user_ID = $_SERVER['HTTP_EVE_CHARNAME'];
	
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

$killN = rand(0,1800);
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

	Your Character name: <input type="text" name="user_ID" value="<?php echo $_SERVER['HTTP_EVE_CHARNAME']; ?>">
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


