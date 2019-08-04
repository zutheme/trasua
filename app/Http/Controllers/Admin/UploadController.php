<?php



namespace App\Http\Controllers\Admin;



use Illuminate\Http\Request;

use App\Http\Controllers\Controller;

use Illuminate\Http\UploadedFile;

use Illuminate\Support\Facades\DB;

use Validator;

use Illuminate\Support\MessageBag;

use Illuminate\Foundation\Auth\AuthenticatesUsers;

use Auth;

use App\Posts;

use App\Impposts;

use App\PostType;

use App\category;

use App\status_type;

use App\files;

use File;

use App\func_global;

class UploadController extends Controller

{

    public function upload(Request $request){

    	$input = json_decode(file_get_contents('php://input'),true);

    	$base64_string = $input['file'];

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

        //$urlpath = public_path($dir . $url); 	

        $errors = "";

        $data = new files;

        $data->urlfile = $path_relative.$filename;

        $data->namefile = $filename;

        $data->typefile = $typefile;     

        if ($data->save()) {

            return response()->json(array('success' => true, 'idfile' => $data->idfile), 200);

        }

       

    }

    public function uploadattach(Request $request){

        $input = json_decode(file_get_contents('php://input'),true);

        $base64_string = $input['file'];

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

        //$urlpath = public_path($dir . $url);  

        $errors = "";

        $data = new files;

        $data->urlfile = $path_relative.$filename;

        $data->namefile = $filename;

        $data->typefile = $typefile;     

        if ($data->save()) {

            return response()->json(array('success' => true, 'idfile' => $data->idfile), 200);

        }
    }

    public function uploadfile(Request $request){

        //$supplier_name = $request->supplier_name;

        $extension = $request->file('file');

        $typefile = $request->file('file')->getClientOriginalExtension(); // getting excel extension

        $dir = 'uploads/';

        $path = base_path($dir . date('Y') . '/'.date('m').'/'.date('d').'/');

        $path_relative = $dir . date('Y') . '/'.date('m').'/'.date('d').'/';

        if(!File::exists($path)) {

            File::makeDirectory($path, 0777, true, true);

        }     

        $filename = date('Ymd').'_'.time().'_'.uniqid().'.'.$typefile;

        $request->file('file')->move($path, $filename);

        $errors = "";

        // $data = new files;

        // $data->urlfile = $path_relative.$filename;

        // $data->namefile = $filename;

        // $data->typefile = $typefile;

        try {

            //DB:raw ,DB::select,DB::statement

            $idinserteds = DB::select('call InsertFilesProcedure(?,?,?,?)',array($path_relative,$filename,$typefile));

            $idinserted = json_decode(json_encode($idinserteds), true);

            return response()->json(array('success' => true, 'id_inserted' => $idinserted ), 200);

        } catch (\Illuminate\Database\QueryException $ex) {

            $errors = new MessageBag(['errorlogin' => $ex->getMessage()]);

            return response()->json(array('error' => true, 'error' => $errors), 200);

        }     

    }

}

