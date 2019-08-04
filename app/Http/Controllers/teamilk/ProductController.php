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

class ProductController extends Controller
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
    public function show($idproduct)
    {
        $_namecattype="product";
        $qr_cateselected = DB::select('call SelCateSelectedProcedure(?)',array($idproduct));
        $cate_selected = json_decode(json_encode($qr_cateselected), true);
        $qr_size = DB::select('call SelAllSizeProcedure');
        $size = json_decode(json_encode($qr_size), true);
        $qr_product = DB::select('call DetailByIdProductProcedure(?)',array($idproduct));
        $product = json_decode(json_encode($qr_product), true);
        $_hastype = "gallery";
        $qr_gallery = DB::select('call SelGalleryProcedure(?,?)',array($idproduct,$_hastype));
        $gallery = json_decode(json_encode($qr_gallery), true);
        $qr_relation = DB::select('call RelateProductProcedure');
        $relation = json_decode(json_encode($qr_relation), true);
        $qr_sel_cross_by_idproduct = DB::select('call SelCrossProductByIdProcedure(?)',array($idproduct));
        $sel_cross_by_idproduct = json_decode(json_encode($qr_sel_cross_by_idproduct), true);
        $_topping = "topping";
        $qr_topping = DB::select('call SelToppingProcedure(?)',array($_topping));
        $sel_topping = json_decode(json_encode($qr_topping), true);
        return view('teamilk.product.show',compact('relation','gallery','product','categories','idproduct','sel_cross_by_idproduct','sel_topping'));
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
    //show sub category
    public function change_price_idproduct(){
        $input = json_decode(file_get_contents('php://input'),true);
        $_idproduct = $input['idproduct'];       
        try {
            $qr_price = DB::select('call ChangePriceByIdProductProcedure(?)',array($_idproduct));
            $rs_price = json_decode(json_encode($qr_price), true);     
            return response()->json($rs_price); 
        } catch (\Illuminate\Database\QueryException $ex) {
            $errors = new MessageBag(['error' => $ex->getMessage()]);
            return response()->json($errors); 
        }
    }
    public function listviewproductbyidcate($_idcategory, $_id_post_type, $_id_status_type, $_limit){
        try {
            $qr_lpro = DB::select('call ListViewProductByIdCateProcedure(?,?,?,?)',array($_idcategory, $_id_post_type, $_id_status_type, $_limit));
            $rs_lpro = json_decode(json_encode($qr_lpro), true);     
            //return redirect()->route('teamilk.product.index')->with('error',$errors);
             return view('teamilk.product.index')->with(compact('rs_lpro'));
        } catch (\Illuminate\Database\QueryException $ex) {
            $errors = new MessageBag(['error' => $ex->getMessage()]);
            //return redirect()->route('teamilk.product.index')->with('error',$errors);
            return view('teamilk.product.index')->with('error',$errors);
        }
    }
}
