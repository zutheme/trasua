<?php
namespace App\Http\Controllers\account;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\DB;
use Illuminate\Foundation\Auth\AuthenticatesUsers;
use App\Http\Requests;
use Validator;
use Auth;
use App\user;
use Illuminate\Support\MessageBag;
use Illuminate\Http\UploadedFile;
use App\files;
use File;
class AccountController extends Controller
{
    public function getprofile(Request $request,$iduser) {
    	if (!Auth::check()) {
            //return redirect()->route('admin.adsvcustomer.index')->with('success',$user->name);
           //return redirect('login');
            return view('teamilk.login');
        }
        try {
            $qr_select_profile = DB::select('call SelectProfileProcedure(?)',array($iduser));
            $profile = json_decode(json_encode($qr_select_profile), true);
            $qr_district = DB::select('call SelDicstrictProcedure(1)');
            $rs_district = json_decode(json_encode($qr_district), true);
            $qr_citytown = DB::select('call SelCityTownProcedure()');
            $rs_citytown = json_decode(json_encode($qr_citytown), true);
            $qr_sex = DB::select('call SelSexProcedure()');
            $rs_sex = json_decode(json_encode($qr_sex), true);
            return view('teamilk.account.profile',compact('profile','rs_district','iduser','rs_citytown','rs_sex'));
        } catch (\Illuminate\Database\QueryException $ex) {
            $errors = new MessageBag(['error' => $ex->getMessage()]);
            //return redirect()->route('teamilk.account.profile')->with('error',$errors);
            //return redirect('login');
            return view('teamilk.account.profile')->with('error',$errors);
        }
        
    }
    public function update(Request $request, $iduser)
    {
        $errors = "error";
        try {
            //update profile
            $_idprofile = $request->get('idprofile');
            $_firstname = $request->get('firstname');
            $_lastname = $request->get('lastname');
            $_middlename = $request->get('middlename');
            $_sel_sex = $request->get('sel_sex');
            $_birthday = $request->get('_birthday');
            $_mobile = $request->get('mobile');
            $_address = $request->get('address');
            $_sel_district = $request->get('sel_district');
            $_sel_citytown = $request->get('sel_citytown');
            $qr_update_profile = DB::select('call UpdateProfileProcedure(?,?,?,?,?,?,?,?,?,?)',array($_idprofile,$_firstname,$_lastname,$_middlename,$_sel_sex,$_birthday,$_address,$_mobile,$_sel_citytown,$_sel_district));
            $rs_update_profile = json_decode(json_encode($qr_update_profile), true);
        } catch (\Illuminate\Database\QueryException $ex) {
            $errors = new MessageBag(['error' => $ex->getMessage()]);
            //return redirect()->route('profile/'.$iduser)->with('error',$errors);
             return redirect('profile/'.$iduser)->with(compact($errors));
            //return view('teamilk.account.profile',compact('profile','iduser','errors'));
        }
        $qr_select_profile = DB::select('call SelectProfileProcedure(?)',array($iduser));
        $profile = json_decode(json_encode($qr_select_profile), true);
        $errors = "success";
        //return view('teamilk.account.profile',compact('profile','iduser'));
        //return redirect()->route('profile/'.$iduser)->with(compact('profile','iduser'));
        return redirect('profile/'.$iduser)->with('error',$errors);
    }
    public function changepassword(Request $request,$iduser=1){
        $qr_select_profile = DB::select('call SelectProfileProcedure(?)',array($iduser));
        $profile = json_decode(json_encode($qr_select_profile), true);
        //update profile
        $users = user::find($iduser);
        $old_password = $request->get("old_password");
        $password = $request->get("password");
        $c_password = $request->get("c_password");
        $email = $users->email;
        if( Auth::attempt(['email' => $email, 'password' =>$old_password])) {
            if( $password==$c_password && strlen($password) > 7){
                $password = bcrypt($password); 
                $users->password =  $password;
                $users->save();
                $errorpass = "Mật khẩu mới đã cập nhật";
                return redirect('profile/'.$iduser)->with('pw_changed', $errorpass);
            }
           $errorpass = "Hai trường mật khẩu mới không trùng khớp";
           return redirect('profile/'.$iduser)->with('er_passowrd', $errorpass);
        } else {
          $errorpass = "Mật khẩu cũ không đúng";
         return redirect('profile/'.$iduser)->with('er_passowrd', $errorpass);
          //return view('profile.show',compact('profile','catbytypes','iduser','errorpass'));
        }      
    }
    public function uploadavatar(Request $request,$iduser,$idprofile){
        //if have exist file
        $_idfile = 0;
        $path_relative = "";
        $base64_string =  $request->get("download");                                   
        if($base64_string){
                $orfilename = "";
                $dir = 'uploads/';
                $data = explode( ',', $base64_string );
                $mimeString = $data[0];
                $mimeString = explode( ':', $mimeString);
                $mimeString = explode( ';', $mimeString[1]);
                $extension =  explode( '/', $mimeString[0]);
                $data1 = $data[1];
                $decoded = base64_decode($data1);   
                $typefile = $extension[1];
                $path = base_path($dir . date('Y') . '/'.date('m').'/'.date('d').'/');
                $path_relative = $dir . date('Y') . '/'.date('m').'/'.date('d').'/';
                if(!File::exists($path)) {
                    File::makeDirectory($path, 0777, true, true);
                }     
                $filename = date('Ymd').'_'.time().'_'.uniqid().'.'.$typefile;
                file_put_contents( $path.$filename , $decoded);
                $erroravatar = "no upload";
                try {
                        $path_relative = $path_relative.$filename;
                        $idinserteds = DB::select('call InsertFilesProcedure(?,?,?,?)',array($path_relative,$orfilename,$filename,$typefile));
                        $idinserted = json_decode(json_encode($idinserteds), true);
                        //$_idfile = $idinserted[0]['idfile'];
                        $qr_uploadavatar = DB::select('call UploadAvatarProcedure(?,?)',array($idprofile,$path_relative));
                        //$rs_uploadavatar = json_decode(json_encode($qr_uploadavatar), true);
                        $erroravatar = "Avartar uploaded";
                       return redirect('profile/'.$iduser)->with('uploadavatar', $erroravatar);
                    } catch (\Illuminate\Database\QueryException $ex) {
                        $erroravatar = new MessageBag(['errorlogin' => $ex->getMessage()]);
                        return redirect('profile/'.$iduser)->with('uploadavatar', $erroravatar);
                    }
        }
        //end if have file 
        return redirect('profile/'.$iduser)->with('uploadavatar', $erroravatar);  
    }
}