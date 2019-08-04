<?php

namespace App\Http\Controllers\Admin;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\CategoryType;
use Illuminate\Support\Facades\DB;
class CategoryTypeController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        $cattypes = CategoryType::all()->toArray();
        return view('admin.cattype.index',compact('cattypes'));
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        return view('admin.cattype.create');
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        $this->validate($request,['catnametype'=>'required']);

        $cattype = new CategoryType(['catnametype'=> $request->get('catnametype')]);

        $cattype->save();

        return redirect()->route('admin.cattype.index')->with('success','data added');
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
     public function edit($idcattype)
    {
        $cattype = CategoryType::find($idcattype);

        return view('admin.cattype.edit',compact('cattype','idcattype'));
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $idcattype)
    {
        $this->validate($request,['catnametype'=>'required']);
        //$idcustomer = $CategoryType->idcustomer;
        $cattype = CategoryType::find($idcattype);
        $cattype->catnametype = $request->get('catnametype');
        $cattype->save();

        return redirect()->route('admin.cattype.index')->with('success','data update');
    }
    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
   public function destroy($idcattype)
    {
        $cattype = CategoryType::find($idcattype);

        $cattype->delete();

        return redirect()->route('admin.cattype.index')->with('success','record have deleted');
    }
}
