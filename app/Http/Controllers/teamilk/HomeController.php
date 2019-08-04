<?php

namespace App\Http\Controllers\teamilk;

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

class HomeController extends Controller
{
    public function Home()
    {
    	try {
            $_start_date="";
            $_end_date="";
            $_idcategory="0";
            $_id_post_type="0";
            $_id_status_type="0";
            $_sel_receive = 0;
            $_limit = 8;
            $rs_selected = array('_start_date'=>$_start_date,'_end_date'=>$_end_date,'_idcategory'=>$_idcategory,'_id_post_type'=>$_id_post_type,'_id_status_type'=>$_id_status_type,'_sel_receive'=>$_sel_receive);
            $list_selected = json_encode($rs_selected);
            //$qr_banner = DB::select('call ListProductByIdcateProcedure(?,?,?,?,?)',array($_start_date,$_end_date, $_idcategory, $_id_post_type, $_id_status_type));
            //$shop_banner = json_decode(json_encode($qr_banner), true);
            //teamilk
            $qr_teamilk = DB::select('call ListProductByIdcateProcedure(?,?,?,?,?,?)',array($_start_date,$_end_date, $_idcategory, $_id_post_type, $_id_status_type, $_limit));
            $teamilks = json_decode(json_encode($qr_teamilk), true);
            $_limit1 = 4;
            $qr_teamilk1 = DB::select('call ListProductByIdcateProcedure(?,?,?,?,?,?)',array($_start_date,$_end_date, $_idcategory, $_id_post_type, $_id_status_type, $_limit1));
            $teamilks1 = json_decode(json_encode($qr_teamilk1), true);

            $_limit2 = 12;
            $qr_teamilk2 = DB::select('call ListProductByIdcateProcedure(?,?,?,?,?,?)',array($_start_date,$_end_date, $_idcategory, $_id_post_type, $_id_status_type, $_limit2));
            $teamilks2 = json_decode(json_encode($qr_teamilk2), true);

            $qr_popular = DB::select('call RelateProductProcedure');
            $popular = json_decode(json_encode($qr_popular), true);
            return view('teamilk.home',compact('popular','teamilks','teamilks1','teamilks2','list_selected'));
        } catch (\Illuminate\Database\QueryException $ex) {
            $errors = new MessageBag(['error' => $ex->getMessage()]);
            //return redirect()->route('teamilk.home')->with('error',$errors);
             return view('teamilk.home')->with('error',$errors);
        }
    }
}
