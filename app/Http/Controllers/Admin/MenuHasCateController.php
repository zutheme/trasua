<?php

namespace App\Http\Controllers\Admin;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\DB;
use Illuminate\Foundation\Auth\AuthenticatesUsers;
use Auth;
use App\menu;
use Validator;
use Illuminate\Support\MessageBag;
use App\category;
use App\CategoryType;
class MenuHasCateController extends Controller {
    /**
     * Display a listing of the resource.
     *
         * @return \Illuminate\Http\Response
     */
    private $main_menu="";
    public function index(Request $request,$idmenu=1)
    {
        $qr_menu = DB::select('call ListMenuProcedure()');
        $rs_menu = json_decode(json_encode($qr_menu), true);
        $categories = category::all()->toArray();
        $categorytypes = CategoryType::all()->toArray();
        $list = array();
        $qr_list_cate = DB::select('call ListItemCateByIdMenuProcedure(?)',array($idmenu));
        $rs_list_cate = json_decode(json_encode($qr_list_cate), true);
        return view('admin.menuhascate.index')->with(compact('rs_menu','categorytypes','categories','list','idmenu','rs_list_cate'));
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create() 
    {
        $qr_menu = DB::select('call ListMenuProcedure()');
        $rs_menu = json_decode(json_encode($qr_menu), true);
        //$qr_menu = DB::select('call ListMenuProcedure()');
        //$rs_menu = json_decode(json_encode($qr_menu), true);
        return view('admin.menuhascate.create')->with(compact('rs_menu'));
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        $idmenu = $request->get('_idmenu');
        $obj_json = $request->get('obj_add_cate');
        //$qr_menu = DB::select('call ListMenuProcedure()');
        //$rs_menu = json_decode(json_encode($qr_menu), true);
        $arr_json = json_decode($obj_json, true);
        $list ="insert into menu_has_cate(idmenu,idcategory,idparent,depth,reorder,trash) values ";
        foreach($arr_json as $mydata) {
             $list .= "(".$idmenu.",".$mydata['idcategory'].",".$mydata['idparent'].",".$mydata['depth'].",".$mydata['reorder'].",".$mydata['trash']."),";
        }
        $list = substr($list, 0, -1);
        $message = "";  
        try {
            $qr_menu = DB::select('call CreateMenuHasIdCateProcedure(?)',array($list));
            $rs_menu = json_decode(json_encode($qr_menu), true);
        } catch (\Illuminate\Database\QueryException $ex) {
            //$errors = new MessageBag(['error' => $ex->getMessage()]);
            //return redirect()->route('admin.menuhascate.index')->with('error',$errors); 
        }  
        //return redirect()->route('admin.menuhascate.index')->with('success',$list);
        return redirect()->action('Admin\MenuHasCateController@index', ['idmenu' => $idmenu])->with('success',$list);
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
        
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $idmenu=1)
    {
        //$idmenu = $request->get('_idmenu');
        $obj_json = $request->get('objmenu');
        $arr_json = json_decode($obj_json, true);
        $list ="";
        $message = "";  
        try {
            foreach($arr_json as $mydata) {
                $_idmenuhascate =$mydata['idmenuhascate'];$_idcategory=$mydata['idcategory'];$_idparent=$mydata['idparent']; $_depth=$mydata['depth']; $_reorder=$mydata['reorder']; $_trash=$mydata['trash'];
                $qr_menu = DB::select('call UpdateMenuHasCateProcedure(?,?,?,?,?,?,?)',array($_idmenuhascate,$idmenu,$_idcategory,$_idparent, $_depth, $_reorder, $_trash));
                $rs_menu = json_decode(json_encode($qr_menu), true);
            }
        } catch (\Illuminate\Database\QueryException $ex) {
            $errors = new MessageBag(['error' => $ex->getMessage()]);
            return redirect()->route('admin.menuhascate.index')->with('error',$errors); 
        }  
        //return redirect()->route('admin.menuhascate.index')->with('success',$list);
        return redirect()->action('Admin\MenuHasCateController@index', ['idmenu' => $idmenu])->with('success',$list);
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
    public function AddMenuItem(Request $request,$_idmenu)
    {
        $input = json_decode(file_get_contents('php://input'),true);
        $_idcategory = $input['idcategory'];
        //$namemenu = $input['namemenu'];
        $_idparent = $input['idparent'];
        $_depth = $input['depth'];
        $_trash = $input['trash'];
        $_reorder = 0;
        $qr_menu = DB::select('call AddMenuItemProcedure(?,?,?,?,?,?)',array($_idmenu, $_idcategory, $_idparent, $_depth, $_reorder, $_trash));
        $rs_menu = json_decode(json_encode($qr_menu), true);
        $idmenuhascate = $rs_menu[0]['idmenuhascate'];
        return response()->json(array('success' => true, 'idmenuhascate' => $idmenuhascate), 200);
        //return redirect()->action('Admin\MenuHasCateController@index', ['idmenu' => $idmenu])->with('success',$list);
    }
    public function menuhasidcate(Request $request,$idmenu)
    {
        $idparentmenu = $request->get('sel_idparentmenu');
        $idcategory = $request->get('sel_idcategory');
        $qr_menu = DB::select('call MenuHasIdcateProcedure(?,?,?)',array($idmenu,$idcategory,$idparentmenu));
        $rs_menu = json_decode(json_encode($qr_menu), true);
        return redirect('admin/menu/'.$idmenu.'/edit')->with('success');
    }

    //show sub category
    public function catebytype($_idcatetype) {
        $qr_catebytype = DB::select('call ListAllCateByIdcatetype(?)',array($_idcatetype));
        $categories = json_decode(json_encode($qr_catebytype), true);
        $this->showCategories($categories,0);
        $result =  $this->main_menu;
        return response()->json(array('success' => true, 'result' => $result), 200);
    }
 
    public function showCategories($categories, $idparent = 0){
        $cate_child = array();
        foreach ($categories as $key => $item) {
            if ($item['idparent'] == $idparent){
                $cate_child[] = $item;
                unset($categories[$key]);
            }
        }
        $list_cat="";       
        if($cate_child) {
            $this->main_menu .= '<ul class="list-check">';
            foreach ($cate_child as $key => $item){
                $this->main_menu .= '<li><input class="array-parent" type="hidden" value="'.$idparent.'">';
                $this->main_menu .= '<input class="array-check" type="checkbox" value="'.$item['idcategory'].'"><label>'.$item['namecat'].'</label>';
                $this->showCategories($categories, $item['idcategory']);
                $this->main_menu .= '</li>';
            }
            $this->main_menu .= '</ul>';
        }
    }
    public function show_menu() {
        
        $result = DB::select('call ListAllCatByTypeProcedure(?)',array($_cattype));
        $categories = json_decode(json_encode($result), true);
        $str_ul="";$str_li="";
        $this->show_all_menu($categories, 0,'',$_cate_selected);       
        $str_html = '<ul class="list-check">'.$str_li.$this->main_menu."</li></ul>";    
        return $str_html; 
    }

    public function show_all_menu($categories, $idparent = 0, $char = '', $_cate_selected)
    {
        $cate_child = array();
        foreach ($categories as $key => $item)
        {
            if ($item['idparent'] == $idparent)
            {
                $cate_child[] = $item;
                unset($categories[$key]);
            }
        }
        $list_cat="";       
        if ($cate_child)
        {
            $this->main_menu .= '<ul class="list-check">';
            foreach ($cate_child as $key => $item)
            {
                // Hiển thị tiêu đề chuyên mục
                $this->main_menu .= '<li><input type="checkbox" name="list_check[]" value="'.$item['idcategory'].'">'.$item['namecat'].":".$list_cat;
                // Tiếp tục đệ quy để tìm chuyên mục con của chuyên mục đang lặp
                $this->show_all_menu($categories, $item['idcategory'], $char.'|---', $_cate_selected);
                $this->main_menu .= '</li>';
            }
            $this->main_menu .= '</ul>';
        }
    }
}
