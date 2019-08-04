<?php

namespace App\Http\Controllers\teamilk;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;

class CartController extends Controller
{
    public function addcart(){
    	$input = json_decode(file_get_contents('php://input'),true);
        $_idproduct = $input['idproduct'];
        $_namestore = $input['namestore'];
        $qr_additem = DB::select('call AddProductProcedure(?,?)',array($_idproduct,$_namestore));
        $additems = json_decode(json_encode($qr_additem), true);
        return response()->json($additems);
    }
}
