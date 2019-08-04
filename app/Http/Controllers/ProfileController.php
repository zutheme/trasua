<?php



namespace App\Http\Controllers;



use Illuminate\Http\Request;

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

class ProfileController extends Controller

{

    /**

     * Display a listing of the resource.

     *

     * @return \Illuminate\Http\Response

     */

    public function index()

    {

        //

    }



    /**

     * Show the form for creating a new resource.

     *

     * @return \Illuminate\Http\Response

     */

    public function create()

    {

        //

    }



    /**

     * Store a newly created resource in storage.

     *

     * @param  \Illuminate\Http\Request  $request

     * @return \Illuminate\Http\Response

     */

    public function store(Request $request)

    {

        //

    }



    /**

     * Display the specified resource.

     *

     * @param  int  $id

     * @return \Illuminate\Http\Response

     */

    public function show($iduser)

    {

        try {

            $qr_select_profile = DB::select('call SelectProfileProcedure(?)',array($iduser));

            $profile = json_decode(json_encode($qr_select_profile), true);

            return view('profile.show',compact('profile','iduser'));

        } catch (\Illuminate\Database\QueryException $ex) {

            $errors = new MessageBag(['errorlogin' => $ex->getMessage()]);

            return redirect()->route('profile.show')->with('error',$errors);

        }

        

    }



    /**

     * Show the form for editing the specified resource.

     *

     * @param  int  $id

     * @return \Illuminate\Http\Response

     */

    public function edit($id)

    {

        //

    }



    /**

     * Update the specified resource in storage.

     *

     * @param  \Illuminate\Http\Request  $request

     * @param  int  $id

     * @return \Illuminate\Http\Response

     */

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

            $address = $request->get('address');

            $mobile = $request->get('mobile');

            $qr_update_profile = DB::select('call UpdateProfileProcedure(?,?,?,?,?,?,?,?)',array($_idprofile,$_firstname,$_lastname,$_middlename,$_sel_sex,$_birthday,$address,$mobile));

            $rs_update_profile = json_decode(json_encode($qr_update_profile), true);

        } catch (\Illuminate\Database\QueryException $ex) {

            $errors = new MessageBag(['errorlogin' => $ex->getMessage()]);

            //return redirect()->route('profile/'.$iduser)->with('error',$errors);
             return redirect('profile/'.$iduser)->with('error',$errors);
        }

        $qr_select_profile = DB::select('call SelectProfileProcedure(?)',array($iduser));

        $profile = json_decode(json_encode($qr_select_profile), true);

        return view('profile.show',compact('profile','iduser'));
        //return redirect()->route('profile/'.$iduser)->with(compact('profile','iduser'));
        //return redirect('profile/'.$iduser)->with(compact('profile','iduser','error'));
    }



    /**

     * Remove the specified resource from storage.

     *

     * @param  int  $id

     * @return \Illuminate\Http\Response

     */

    public function destroy($id)

    {

        //

    }

    public function changepassword(Request $request,$iduser="1"){      

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

                $errorpass = "Password has changed";

                return redirect('profile/'.$iduser)->with('status', $errorpass);

            }

           $errorpass = "password is not the same";

           return redirect('profile/'.$iduser)->with('status', $errorpass);

        } else {

          $errorpass = "old password is not correct";

          return redirect('profile/'.$iduser)->with('status', $errorpass);

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

