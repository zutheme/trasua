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
use App\files;
use File;

class FilesController extends Controller
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
    public function show($id)
    {
        //
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
    public function update(Request $request, $id)
    {
        //
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
    public function uploadDataULR(){

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
        $ab_urlfile = $path.$filename;
        $urlfile = $path_relative.$filename;  
        file_put_contents( $ab_urlfile , $decoded);
        $file = new Files(['urlfile'=> $urlfile,'name_origin'=> "",'namefile'=> $filename,'typefile'=>$typefile]);
        $file->save();
        return response()->json(array('success' => true, 'pathfile' => $urlfile), 200);

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
            $path_relative .= $filename; 
            $idinserteds = DB::select('call InsertFilesProcedure(?,?,?,?)',array($path_relative,$filename,$typefile));

            $idinserted = json_decode(json_encode($idinserteds), true);

            return response()->json(array('success' => true, 'pathfile' => $path_relative ), 200);

        } catch (\Illuminate\Database\QueryException $ex) {

            $errors = new MessageBag(['error' => $ex->getMessage()]);

            return response()->json(array('error' => true, 'error' => $errors), 200);

        }     

    }
}
