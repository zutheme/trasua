<?php

namespace App\Http\Controllers;

use App\sv_post_type;
use Illuminate\Http\Request;

class SvPostTypeController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        $svposttypes = sv_post_type::all()->toArray();
        return view('svposttype.index',compact('svposttypes'));
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        return view('svposttype.create');
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
       $this->validate($request,['name'=>'required']);

        $svposttype = new sv_post_type(['name'=> $request->get('name')]);

        $svposttype->save();

        return redirect()->route('svposttype.index')->with('success','data added');
    }

    /**
     * Display the specified resource.
     *
     * @param  \App\sv_post_type  $sv_post_type
     * @return \Illuminate\Http\Response
     */
    public function show(sv_post_type $sv_post_type)
    {
        //
    }
    
    /**
     * Show the form for editing the specified resource.
     *
     * @param  \App\sv_post_type  $sv_post_type
     * @return \Illuminate\Http\Response
     */
    public function edit($id_post_type)
    {
        $svposttype = sv_post_type::find($id_post_type);

        return view('svposttype.edit',compact('svposttype','id_post_type'));
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \App\sv_post_type  $sv_post_type
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $id_post_type)
    {
        $this->validate($request,['name'=>'required']);
        //$idcustomer = $sv_post_type->idcustomer;
        $svposttype = sv_post_type::find($id_post_type);
        $svposttype->name = $request->get('name');
        $svposttype->save();

        return redirect()->route('svposttype.index')->with('success','data update');

    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\sv_post_type  $sv_post_type
     * @return \Illuminate\Http\Response
     */
    public function destroy($id_post_type)
    {
        $svposttype = sv_post_type::find($id_post_type);

        $svposttype->delete();

        return redirect()->route('svposttype.index')->with('success','record have deleted');
    }
}
