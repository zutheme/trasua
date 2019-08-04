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
use App\size;
use App\color;
use File;
use App\func_global;

class OrdersManagementController extends Controller
{ 
    public function listorder(Request $request,$_idcategory=0)
    {
         //try {
            $_start_date = $request->get('_start_date');
            $_end_date = $request->get('_end_date');
            if(!isset($_start_date)){
                $_start_date=date("Y-m-d 00:00:00");
            }
            if(!isset($_end_date)){
                $_end_date = date("Y-m-d H:i:s");
            }
            $_id_post_type=0;$_id_status_type=0;$_sel_receive = 0;
            $lists = array('_start_date'=>$_start_date,'_end_date'=>$_end_date,'_idcategory'=>$_idcategory,'_id_post_type'=>$_id_post_type,'_id_status_type'=>$_id_status_type,'_sel_receive'=>$_sel_receive);
            $list_selected = array();
            $list_selected['_start_date'] = $_start_date;
            $list_selected['_end_date'] = $_end_date;
            $list_selected['_idcategory'] = $_idcategory;
            $list_selected['_id_post_type'] = $_id_post_type;
            $list_selected['_id_status_type'] = $_id_status_type;
            $list_selected['_sel_receive'] = $_sel_receive;           
            $qr_orderlist = DB::select('call ListOrderProductProcedure(?,?,?,?,?,?)',array($_start_date,$_end_date, $_idcategory, $_id_post_type, $_id_status_type,$_sel_receive));
            $rs_orderlist = json_decode(json_encode($qr_orderlist), true);
            return View('admin.orderlist.index')->with(compact('rs_orderlist'))->with(compact('list_selected'));
        //} catch (\Illuminate\Database\QueryException $ex) {
            //$errors = new MessageBag(['error' => $ex->getMessage()]);
            //return View('admin.orderlist.index')->with(compact('errors'));
        //}
    }
    public function show($ordernumber)
    {
        $qr_shorttotal = DB::select('call ShortTotalProcedure(?)',array($ordernumber));
        $rs_shortotal = json_decode(json_encode($qr_shorttotal), true);
        $qr_orderproduct = DB::select('call CompleteListOrderProcedure(?)',array($ordernumber));
        $rs_orderproduct = json_decode(json_encode($qr_orderproduct), true);
        return View('admin.orderlist.show')->with(compact('rs_orderproduct','rs_shortotal','ordernumber'));
    }
}
