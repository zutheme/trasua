<?php

namespace App\Http\Controllers\Admin;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Products;
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


class ProductsController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    private $main_menu="";
    public function index()
    {
         try {
            $_start_date="";
            $_end_date="";
            $_idcategory="0";
            $_id_post_type="0";
            $_id_status_type="0";
            $_sel_receive = 0;
            $rs_selected = array('_start_date'=>$_start_date,'_end_date'=>$_end_date,'_idcategory'=>$_idcategory,'_id_post_type'=>$_id_post_type,'_id_status_type'=>$_id_status_type,'_sel_receive'=>$_sel_receive);
            $list_selected = json_encode($rs_selected);
            $result = DB::select('call ListProductProcedure(?,?,?,?,?)',array($_start_date,$_end_date, $_idcategory, $_id_post_type, $_id_status_type));
            $products = json_decode(json_encode($result), true);
            return view('admin.product.index',compact('products','list_selected'));

        } catch (\Illuminate\Database\QueryException $ex) {
            $errors = new MessageBag(['error' => $ex->getMessage()]);
            return redirect()->route('admin.product.index')->with('error',$errors);
        }
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        $_namecattype="product";
        //$str = $this->initCategories();
        $str = $this->all_category($_namecattype);
        $statustypes = status_type::all()->toArray();
        $posttypes = PostType::all()->toArray();
        $_namecattype = "product";
        $result = DB::select('call ListParentCatByTypeProcedure(?)',array($_namecattype));
        $categories = json_decode(json_encode($result), true);
        return view('admin.product.create',compact('posttypes','categories','statustypes','str'));
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
        $_idemployee = Auth::id();
        $_idcustomer = '0';$_amount= '0'; $_price='0';$_note =""; $_idstore= '0';$_axis_x='0';$_axis_y='0'; $_axis_z='0'; $_size=''; $_ice_water='0'; $_sugar='0'; $_topping="";
        $message ="";
        $func_global = new func_global();
        try {
            $_namepro = $request->get('title');
            $title_strip = $func_global->stripVN($_namepro);
            $title_strip = preg_replace('/[ ](?=[ ])|[^-_,A-Za-z0-9 ]+/', '', $title_strip);
            $title_strip = strtolower($title_strip); 
            $_slug = preg_replace('/\s+/', '-', $title_strip);
            $_description = $request->get('body');
            $_id_post_type = $request->get('sel_idposttype');
            $_idstatus_type = $request->get('sel_idstatustype');
            $_price = $request->get('price');
            $_short_desc = $request->get('short_desc');
            $_amount = $request->get('amount');
            $validator = Validator::make($request->all(), [
                'title' => 'required', 
                'body' => 'required'
            ]);
            if ($validator->fails()) {
                $errors = $validator->errors();
                return redirect()->route('admin.product.create')->with(compact('errors'));           
            }

            $list_checks = $request->input('list_check');
            $_list_idcat="";
            if($list_checks){
                foreach ($list_checks as $idcategory) {
                  $_list_idcat .= $idcategory.",";
                } 
            }
            $_list_idcat = rtrim($_list_idcat,", ");
            $_thumbnail = "";
             if($request->hasfile('thumbnail')) {
                //foreach($request->file('thumbnail') as $file) {
                    $file = $request->file('thumbnail'); 
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
                    $path_relative .= $filename;
                    $_thumbnail .= "'".$path_relative."','".$name_origin."','".$filename."','".$typefile."';";
                //}
             }
             $_thumbnail = rtrim($_thumbnail,"; ");
            $_list_file = "";
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
                    $path_relative .= $filename;
                    $_list_file .= "'".$path_relative."','".$name_origin."','".$filename."','".$typefile."';";
                }
             }
             $_list_file = rtrim($_list_file,"; ");
            $insertproduct = DB::select('call InsertProductProcedure(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',array($_namepro, $_description, $_short_desc, $_slug, $_id_post_type, $_idcustomer, $_idemployee, $_amount, $_price, $_note, $_idstore, $_axis_x, $_axis_y, $_axis_z, $_size, $_ice_water, $_sugar, $_topping, $_idstatus_type, $_list_idcat, $_list_file,$_thumbnail));
        } catch (\Illuminate\Database\QueryException $ex) {
            $errors = new MessageBag(['error' => $ex->getMessage()]);
            return redirect()->back()->withInput()->withErrors($errors);
        }
        $message = "success,".$_thumbnail;
        return redirect()->route('admin.product.create')->with('success',$message);
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
        $statustypes = status_type::all()->toArray();
        $posttypes = PostType::all()->toArray();
        $rs_catparent = DB::select('call ListcatparentProcedure()');
        $cateparents = json_decode(json_encode($rs_catparent), true);
        $rs_seleted = DB::select('call PostByIdProcedure(?)',array($idpost));
        $post_seleted = json_decode(json_encode($rs_seleted), true);
        //$rs_posts = DB::select('call PostsbyIdProcedure(?)',array($idpost));
        //$posts = json_decode(json_encode($rs_posts), true);
         $posts = posts::find($idpost);
        //return view('admin.product.edit',compact('posts','idpost','posttypes','cateparents','statustypes','post_seleted'));
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
        return redirect()->route('admin.product.index')->with('success',$message); 
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
    //show sub category
    public function all_category($_namecattype) {
        $result = DB::select('call ListAllCatByTypeProcedure(?)',array($_namecattype));
        $categories = json_decode(json_encode($result), true);
        $this->showCategories($categories,0,'');
        return $this->main_menu;
    }
 
    public function categorybyid($_cattype='product',$_idcat=0) {
        $result = DB::select('call ListAllCatByTypeProcedure(?)',array($_cattype));
        $categories = json_decode(json_encode($result), true);
        $str_ul="";$str_li="";
        if($_idcat > 0 ){
           $this->showCategories($categories, $_idcat,'');
           $s_catename = DB::select('call SelRowCategoryByIdProcedure(?)',array($_idcat));
           $r_catename = json_decode(json_encode($s_catename), true);
           foreach ($r_catename as $item) {
               $str_li = '<li><input type="checkbox" name="list_check[]" value="'.$item['idcategory'].'">'.$item['namecat'];
            }
       }else{
           $this->showCategories($categories, 0,'');
       } 
       
        $str_html = '<ul class="list-check">'.$str_li.$this->main_menu."</li></ul>";
        $result = json_decode(json_encode($str_html), true);     
        return response()->json($result); 
    }

    public function showCategories($categories, $idparent = 0, $char = '')
    {
        // LẤY DANH SÁCH CATE CON
        $cate_child = array();
        foreach ($categories as $key => $item)
        {
            // Nếu là chuyên mục con thì hiển thị
            if ($item['idparent'] == $idparent)
            {
                $cate_child[] = $item;
                unset($categories[$key]);
            }
        }
         
        // HIỂN THỊ DANH SÁCH CHUYÊN MỤC CON NẾU CÓ
        if ($cate_child)
        {
            $this->main_menu .= '<ul class="list-check">';
            foreach ($cate_child as $key => $item)
            {
                // Hiển thị tiêu đề chuyên mục
                $this->main_menu .= '<li><input type="checkbox" name="list_check[]" value="'.$item['idcategory'].'">'.$item['namecat'];
                 
                // Tiếp tục đệ quy để tìm chuyên mục con của chuyên mục đang lặp
                $this->showCategories($categories, $item['idcategory'], $char.'|---');
                $this->main_menu .= '</li>';
            }
            $this->main_menu .= '</ul>';
        }
    }
    
}
