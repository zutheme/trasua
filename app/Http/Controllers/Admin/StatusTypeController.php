<?php

namespace App\Http\Controllers\Admin;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\status_type;
class StatusTypeController extends Controller
{
     /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        $statustypes = status_type::all()->toArray();
        return view('admin.statustype.index',compact('statustypes'));
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        return view('admin.statustype.create');
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        $this->validate($request,['name_status_type'=>'required']);

        $statustype = new status_type(['name_status_type'=> $request->get('name_status_type')]);

        $statustype->save();

        return redirect()->route('admin.statustype.index')->with('success','data added');
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
    public function edit($id_status_type)
    {
        $statustypes = status_type::find($id_status_type);

        return view('admin.statustype.edit',compact('statustypes','id_status_type'));
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $idstatustype)
    {
        $this->validate($request,['name_status_type'=>'required']);
        //$idcustomer = $statustype->idcustomer;
        $statustype = status_type::find($idstatustype);
        $statustype->name_status_type = $request->get('name_status_type');
        $statustype->save();

        return redirect()->route('admin.statustype.index')->with('success','data update');
    }
    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
   public function destroy($idstatustype)
    {
        $statustype = status_type::find($idstatustype);

        $statustype->delete();

        return redirect()->route('admin.statustype.index')->with('success','record have deleted');
    }
}
