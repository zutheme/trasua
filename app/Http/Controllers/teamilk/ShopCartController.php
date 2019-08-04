<?php

namespace App\Http\Controllers\teamilk;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Products;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\DB;
use App\User; 
use Illuminate\Support\Facades\Auth; 
use Validator;
use Illuminate\Support\MessageBag;
use Illuminate\Foundation\Auth\AuthenticatesUsers;
//use Auth;
use App\Posts;
use App\Impposts;
use App\PostType;
use App\category;
use App\status_type;
use App\files;
use File;
use App\sv_customer;
use App\func_global;

class ShopCartController extends Controller
{
    public function index()
    {
    	$error = "ok";
        return view('teamilk.addcart.shop-cart',compact('error')); 
    }
    public function checkout(){
        $iduser = Auth::id();
        $qr_district = DB::select('call SelDicstrictProcedure(1)');
        $rs_district = json_decode(json_encode($qr_district), true);
        $qr_citytown = DB::select('call SelCityTownProcedure()');
        $rs_citytown = json_decode(json_encode($qr_citytown), true);
        $qr_sex = DB::select('call SelSexProcedure()');
        $rs_sex = json_decode(json_encode($qr_sex), true);
        return view('teamilk.addcart.check-out',compact('rs_district','rs_citytown','rs_sex','iduser')); 
    }
    public function submitcheckout(Request $request){
        $_firsname = $request->get('firstname');
        $_middlename = $request->get('middlename');
        $_lastname = $request->get('lastname');
        $_address = $request->get('address');
        $_iddistrict = $request->get('sel_district');
        $_idcitytown = $request->get('sel_citytown');
        $_email = $request->get('email');
        $_phone = $request->get('phone');
        $_note = $request->get('reci_note');
        $_idcustomer = 0;
        $_iduser_curent = 0;
        $_id_reci_customer = 0;
        if(Auth::id()){
            $_iduser_curent = Auth::id();
        }   
        //check new account
        $_check_new_account = $request->get('check_new_account');
        if($_check_new_account){
            $_password = $request->get('password');
            $validator = Validator::make($request->all(), [ 
            'firstname' => 'required', 
            'email' => 'required|email', 
            'password' => 'required', 
            //'c_password' => 'required|same:password', 
            ]);
            if ($validator->fails()) {
                $errors = $validator->errors();
                return redirect()->route('teamilk.addcart.check-out')->with(compact('errors'));           
            }    
            try {
                //$input = $request->all();
                $input['name'] = $_firsname;
                $input['email'] = $request->get('email');
                $input['password'] = bcrypt($_password); 
                $user = User::create($input); 
                $success['token'] =  $user->createToken('MyApp')->accessToken; 
                //$success['name'] =  $user->name;
                $_iduser_curent = $user->id;
                $creat_profile_pr = DB::select('call CreateProfileProcedure(?,?,?,?,?,?,?,?,?,?,?,?)',array($_iduser_curent,$_firsname,$_middlename,$_lastname,$_address, $_idcitytown, $_iddistrict, $_phone,'','','',''));
                //$profile = json_decode(json_encode($creat_profile_pr), true);
                //$idfile = $profile[0]['idprofile'];   
            } catch (\Illuminate\Database\QueryException $ex) {
                $errors = new MessageBag(['error' => $ex->getMessage()]);
                //return redirect()->route('teamilk.addcart.check-out')->with(compact('errors'));
                return view('teamilk.addcart.check-out',compact('errors'));
            }
        }
        else if( $_iduser_curent == 0){
            $svcustomer = new sv_customer(['firstname'=>$_firsname ,'lastname'=>$_lastname,'email'=>$_email,'mobile'=>$_phone ,'address'=>$_address,'idcitytown'=>$_idcitytown,'iddistrict'=> $_iddistrict,'job'=>'','note'=>$_note]);
            $svcustomer->save();
            $_idcustomer = $svcustomer->idcustomer;
        }  
        //check another address
        $_check_other_address = $request->get('check_other_address');
        if($_check_other_address){
            $_reci_lastname = $request->get('reci_lastname');
            $_reci_middlename = $request->get('reci_middlename');
            $_reci_firstname = $request->get('reci_firstname');
            $_reci_address = $request->get('reci_address');
            $_sel_reci_district = $request->get('sel_reci_district');
            $_sel_reci_citytown = $request->get('sel_reci_citytown');
            $_reci_email = $request->get('reci_email');
            $_reci_phone = $request->get('reci_phone');
            $reci_svcustomer = new sv_customer(['firstname'=>$_reci_firstname ,'lastname'=>$_reci_lastname,'email'=>$_reci_email,'mobile'=>$_reci_phone ,'address'=>$_reci_address,'iddcitytown'=>$_sel_reci_citytown,'iddistrict'=>$_sel_reci_district,'job'=>'','note'=>'']);
            $reci_svcustomer->save();
            $_id_reci_customer = $reci_svcustomer->idcustomer;
        }  
        
        //addcart
        $result = "success";
        $_axis_x = 0; $_axis_y = 0; $_axis_z = 0;
        $_l_idproduct = $request->get('l_idproduct');
        $_l_parent_id = $request->get('l_parent_id');
        $_l_quality = $request->get('l_quality');
        $_l_unit_price = $request->get('l_unit_price');
        $_namestore = "order";
        $ordernumber = 0;
        $count_order = 0;
        foreach( $_l_idproduct as $key => $_idproduct ) {
          $parent_id = $_l_parent_id[$key];
          $quality = $_l_quality[$key];
          $unit_price = $_l_unit_price[$key];
          if($parent_id==0){
            $_note_order = $_note;
          }else {
            $_note_order = "";
          }
          if($count_order == 0 && $parent_id==0){
            $qr_order = DB::select('call OrderProductProcedure(?,?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',array($ordernumber,$_idproduct, $parent_id, $_idcustomer, $_id_reci_customer, $_iduser_curent, $quality, $unit_price, $_note_order, $_namestore, $_axis_x, $_axis_y, $_axis_z, 0));
            $rs_order = json_decode(json_encode($qr_order), true);
            $ordernumber = $rs_order[0]['ordernumber'];
            $qr_update_order = DB::select('call UpdateOrderNumberProcedure(?)',array($ordernumber));
          }else{
            DB::select('call OrderProductProcedure(?,?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',array($ordernumber,$_idproduct, $parent_id, $_idcustomer, $_id_reci_customer, $_iduser_curent, $quality, $unit_price, $_note_order, $_namestore, $_axis_x, $_axis_y, $_axis_z, 0));
          }
          $count_order++;
        }
        $qr_shorttotal = DB::select('call ShortTotalProcedure(?)',array($ordernumber));
        $rs_shortotal = json_decode(json_encode($qr_shorttotal), true);
        $qr_orderproduct = DB::select('call CompleteListOrderProcedure(?)',array($ordernumber));
        $rs_orderproduct = json_decode(json_encode($qr_orderproduct), true);
        //$qr_orderproduct = DB::select('call InfoOrderProductProcedure(?)',array($ordernumber));
        //$rs_orderproduct = json_decode(json_encode($qr_orderproduct), true);
        if($_id_reci_customer > 0) {
            $qr_customer = DB::select('call DetailCustomerProcedure(?)',array($_id_reci_customer));
            $rs_customer = json_decode(json_encode($qr_customer), true); 
        }else if( $_idcustomer > 0){
            $qr_customer = DB::select('call DetailCustomerProcedure(?)',array($_idcustomer));
            $rs_customer = json_decode(json_encode($qr_customer), true); 
        }else if($_iduser_curent > 0){
            $qr_customer = DB::select('call SelectProfileProcedure(?)',array($_iduser_curent));
            $rs_customer = json_decode(json_encode($qr_customer), true); 
        }
        //return redirect('teamilk/complete/'.$ordernumber)->with(compact('ordernumber'));
        return view('teamilk.addcart.checkout-complete',compact('ordernumber','rs_orderproduct','rs_customer','rs_shortotal'));
    }
    public function complete(Request $request,$ordernumber){
        
        $qr_shorttotal = DB::select('call ShortTotalProcedure(?)',array($ordernumber));
        $rs_shortotal = json_decode(json_encode($qr_shorttotal), true);
    	//$qr_orderproduct = DB::select('call CompleteListOrderProcedure(?)',array($ordernumber));
        //$rs_orderproduct = json_decode(json_encode($qr_orderproduct), true);
        $qr_orderproduct = DB::select('call InfoOrderProductProcedure(?)',array($ordernumber));
        $rs_orderproduct = json_decode(json_encode($qr_orderproduct), true);
        if($_id_reci_customer > 0) {
            $qr_customer = DB::select('call DetailCustomerProcedure(?)',array($_id_reci_customer));
            $rs_customer = json_decode(json_encode($qr_customer), true); 
        }else if( $_idcustomer > 0){
            $qr_customer = DB::select('call DetailCustomerProcedure(?)',array($_idcustomer));
            $rs_customer = json_decode(json_encode($qr_customer), true); 
        }else if($_iduser_curent > 0){
            $qr_customer = DB::select('call SelectProfileProcedure(?)',array($_iduser_curent));
            $rs_customer = json_decode(json_encode($qr_customer), true); 
        }
        return view('teamilk.addcart.checkout-complete',compact('rs_orderproduct','rs_customer'));
    }
}
