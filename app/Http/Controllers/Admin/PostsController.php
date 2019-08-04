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
class PostsController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        $result = DB::select('call ListpostProcedure()');
        $posts = json_decode(json_encode($result), true);
        return view('admin.post.index',compact('posts'));
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        $statustypes = status_type::all()->toArray();
        $posttypes = PostType::all()->toArray();
        $result = DB::select('call ListcatparentProcedure()');
        $categories = json_decode(json_encode($result), true);
        return view('admin.post.create',compact('posttypes','categories','statustypes'));
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        $posttypes = PostType::all()->toArray();
        $idusercurent = Auth::id();
        $func_global = new func_global();
        $message ="";
        try {
            $title = $request->get('title');
            $title = $func_global->stripVN($title);
            $title = preg_replace('/[ ](?=[ ])|[^-_,A-Za-z0-9 ]+/', '', $title);
            $title = strtolower($title); 
            $slug = preg_replace('/\s+/', '-', $title);
            $body = $request->get('body');
            $sel_idposttype = $request->get('sel_idposttype');
            $sel_idstatustype = $request->get('sel_idstatustype');
            $validator = Validator::make($request->all(), [
                'title' => 'required', 
                'body' => 'required'
            ]);
            if ($validator->fails()) {
                $errors = $validator->errors();
                return redirect()->route('admin.post.create')->with(compact('errors'));           
            }
            $list_checks = $request->input('list_check');
            if($list_checks){
                foreach ($list_checks as $idcategory) {
                  //$Impposts = Impposts::create(['idpost' => $idpost,'iduser_imp'=>$idusercurent,'id_status_type'=>$sel_idstatustype]);
                   //$message .= $idcategory;
                  $_idcategory = $idcategory;
                } 
            }
            //$post = new Posts(['title'=> $request->get('title'),'slug'=> $slug,'body'=> $request->get('body'),'idcategory'=>$_idcategory,'id_post_type'=>$sel_idposttype,]);
            //$post->save();
            //$idpost = $post->idpost;
            //$impposts = new Impposts(['idpost'=>$idpost,'id_status_type'=>$sel_idstatustype,'processing'=>$request->get('processing')]);
            $title = $request->get('title');
            $body = $request->get('body');
            $processing = $request->get('processing');
            $insertpost = DB::select('call InsertPostProcedure(?,?,?,?,?,?,?,?)',array($title,$body,$slug,$_idcategory,$sel_idposttype,$sel_idstatustype,$processing,$idusercurent));
            $message ="";
            foreach ($insertpost as $item) {
                        $id_post=$item->outidpost;
                    }
            $message .= $id_post;
            if($request->hasfile('file_attach')) {
                foreach($request->file('file_attach') as $file) {
                    $name_origin = $file->getClientOriginalName();
                    //$file->move(public_path().'/images/', $name);  
                    $typefile = $file->getClientOriginalExtension();
                    $dir = 'uploads/';
                    $path = base_path($dir . date('Y') . '/'.date('m').'/'.date('d').'/');
                    $path_relative = $dir . date('Y') . '/'.date('m').'/'.date('d').'/';
                    if(!File::exists($path)) {
                        File::makeDirectory($path, 0777, true, true);
                    }     
                    $filename = date('Ymd').'_'.time().'_'.uniqid().'.'.$typefile;
                    $file->move($path, $filename);
                    $result = DB::select('call InsertFilesProcedure(?,?,?,?)',array($path_relative,$name_origin,$filename,$typefile));
                    $idfile="";
                    foreach ($result as $item) {
                        $id_file=$item->idfile;
                        $idfile .= $id_file;
                    }
                    //$idinserted = json_decode(json_encode($idinserteds), true);
                    $message .= $idfile.",";
                }
             }
        } catch (\Illuminate\Database\QueryException $ex) {
            $errors = new MessageBag(['errorlogin' => $ex->getMessage()]);
            return redirect()->back()->withInput()->withErrors($errors);
        }
        //$message = $message.",".$title.",".$body.",".$slug.",idpost=".$idpost;
        //return view('admin.post.edit',compact('posttypes','categories','idpost')); 
        return redirect()->route('admin.post.index')->with('success',$message);
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
    public function edit($idpost)
    {
        $statustypes = status_type::all()->toArray();
        $posttypes = PostType::all()->toArray();
        $rs_catparent = DB::select('call ListcatparentProcedure()');
        $cateparents = json_decode(json_encode($rs_catparent), true);
        $rs_seleted = DB::select('call PostByIdProcedure(?)',array($idpost));
        $post_seleted = json_decode(json_encode($rs_seleted), true);
        //$rs_posts = DB::select('call PostsbyIdProcedure(?)',array($idpost));
        //$posts = json_decode(json_encode($rs_posts), true);
         $posts = posts::find($idpost);
        return view('admin.post.edit',compact('posts','idpost','posttypes','cateparents','statustypes','post_seleted'));
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
        $posttypes = PostType::all()->toArray();
        $idusercurent = Auth::id();
        $func_global = new func_global();
        $message ="";
        try {
            $title = $request->get('title');
            $body = $request->get('body');
            $sel_idposttype = $request->get('sel_idposttype');
            $sel_idstatustype = $request->get('sel_idstatustype');
            $validator = Validator::make($request->all(), [
                'title' => 'required', 
                'body' => 'required'
            ]);
            if ($validator->fails()) { 
                $errors = $validator->errors();
                return redirect()->route('admin.post.edit')->with(compact('errors'));           
            }
            $post = posts::find($id);
            $post->title = $title;
            $post->body = $body;
            $post->slug = $request->get('slug');
            $post->save();
            $list_idimppost = $request->input('list_idimppost');
            if($list_idimppost){
                foreach ($list_idimppost as $idimppost) {
                    $imp = explode(',', $idimppost);
                    $idimp = $imp[0];
                    $idcat = $imp[1];
                    if(($idimp > 0)||($idcat > 0)){
                        DB::select('call UpdateImppostByIdProcedure(?,?,?,?,?,?)',array($idimp,$id,$idcat,$sel_idposttype,$sel_idstatustype,$idusercurent));
                    }
                } 
            }
           
        } catch (\Illuminate\Database\QueryException $ex) {
            $errors = new MessageBag(['errorlogin' => $ex->getMessage()]);
            return redirect()->back()->withInput()->withErrors($errors);
        }
        //return view('admin.post.edit',compact('posttypes','categories','idpost')); 
        return redirect()->route('admin.post.index')->with('success',$message); 
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        $post = Posts::find($id);
        $post->delete();
        return redirect()->route('admin.post.index')->with('success','record have deleted');
    }
}
