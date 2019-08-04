<?php

namespace App\Http\Controllers\teamilk;

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

class MenuHasCateController extends Controller
{
    private $main_menu="";
    public function show_menu() {
        
        $result = DB::select('call ListAllCatByTypeProcedure(?)',array($_cattype));
        $categories = json_decode(json_encode($result), true);
        $str_ul="";$str_li="";
        $this->show_all_menu($categories, 0,'',$_cate_selected);       
        $str_html = '<ul class="list-check">'.$str_li.$this->main_menu."</li></ul>";    
        return $str_html; 
    }

    public function show_all_menu($categories, $idparent = 0, $char = '', $_cate_selected){
        $cate_child = array();
        foreach ($categories as $key => $item) {
            if ($item['idparent'] == $idparent)
            {
                $cate_child[] = $item;
                unset($categories[$key]);
            }
        }
        $list_cat="";       
        if ($cate_child) {
            $this->main_menu .= '<ul class="list-check">';
            foreach ($cate_child as $key => $item){
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
