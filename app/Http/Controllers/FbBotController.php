<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\FbBot;
class FbBotController extends Controller
{
    public function hook(Request $request){
    	$tokken = $_REQUEST['hub_verify_token'];
		$hubVerifyToken = 'cloudwaysschool';
		$challange = $_REQUEST['hub_challenge'];
		$accessToken = 'EAACZAAV9bZAzwBAFAtn9KEQqADIE4TF3hkBf3dCP3W6EK80a1PBfdxVQTOWsP8ZAkZAEdkBb6BmUCIqjZBmHAmPjOTMsZAyEzBhWwlURMfOhzDZB0aEnZBBBkygYxSOoo66ZAzCeyMZB3nMiZBHkz4aDNhvMDnqDYV2V3Y1KIbAeZCZAuatjWKS6OEoHl';
		$bot = new FbBot();
		$bot->setHubVerifyToken($hubVerifyToken);
		$bot->setaccessToken($accessToken);
		$bot->verifyTokken($tokken, $challange);
		$message = $bot->readMessage($input);
		$botmessage = $bot->sendMessage($message);
    }
}
