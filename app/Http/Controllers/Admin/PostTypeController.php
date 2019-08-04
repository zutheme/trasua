<?php

namespace App\Http\Controllers\Admin;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\PostType;
use App\category;
use App\CategoryType;
use Illuminate\Support\Facades\DB;
class PostTypeController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        //$rs_posttypes = DB::select('call ListCategoryByTypeProcedure()');
        //$posttypes = json_decode(json_encode($rs_posttypes), true);
        $posttypes = PostType::all()->toArray();
        return view('admin.posttype.index',compact('posttypes'));
    }
    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        $rs_categories = DB::select('call ListAllCategoryProcedure()');
        $categories = json_decode(json_encode($rs_categories), true);
        return view('admin.posttype.create',compact('categories'));
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        $this->validate($request,['nametype'=>'required']);
        $posttype = new PostType(['nametype'=> $request->get('nametype'),'idparent' => $request->get('sel_idcategory')]);
        $posttype->save();
        return redirect()->route('admin.posttype.index')->with('success','data added');
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
    public function edit($idposttype)
    {
        $rs_categories = DB::select('call ListAllCategoryProcedure()');
        $categories = json_decode(json_encode($rs_categories), true);
        $posttype = PostType::find($idposttype);
        return view('admin.posttype.edit',compact('posttype','idposttype','categories'));
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $idposttype)
    {
        $this->validate($request,['nametype'=>'required']);
        //$idcustomer = $posttype->idcustomer;
        $posttype = PostType::find($idposttype);
        $posttype->nametype = $request->get('nametype');
        $posttype->idparent = $request->get('sel_idcategory');
        $posttype->save();

        return redirect()->route('admin.posttype.index')->with('success','data update');
    }
    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
   public function destroy($idposttype)
    {
        $posttype = PostType::find($idposttype);

        $posttype->delete();

        return redirect()->route('admin.posttype.index')->with('success','record have deleted');
    }
}
