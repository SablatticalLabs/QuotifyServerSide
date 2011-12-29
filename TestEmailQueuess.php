<?

$IDS=  MyArray::Column(SQL::Query("select ID from User  ORDER BY ID DESC LIMIT 10000 "),"ID");

echo count($IDS);
foreach($IDS as $ID){
	$User = new User($ID);
	$userType = $User->getType();
	$UserInfo = array();
	$UserInfo['UserID']=$User->ID;
	$UserInfo['userType']=$userType;
	$emailType='Match';
	$UserInfo['emailType']=$emailType;
	
	var_dump($UserInfo);
	
	$numMessagesForToday = IsUserSupposedToGetEmail($UserInfo,$startTime);
	$stats[$numMessagesForToday]++; 
	if( ( $i++ % 10 ) == 0 )
		var_dump($stats);
}


?>