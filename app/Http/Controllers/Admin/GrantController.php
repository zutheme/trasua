<?php

namespace App\Http\Controllers\Admin;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Role;
use App\User;
use App\Grant;
use Illuminate\Support\Facades\DB;
use Illuminate\Foundation\Auth\AuthenticatesUsers;
use Auth;
class GrantController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        $result = DB::select('call ListgrantProcedure()');
        $grantperms = json_decode(json_encode($result), true);
        return view('admin.grantperm.index',compact('grantperms'));
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        $roles = Role::all()->toArray();
        $users = user::all()->toArray();
        return view('admin.grantperm.create',compact('roles','users'));
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {          
        $message = "";  
        try {
            $iduserimp = Auth::id();
            $grantperm = new Grant(['idrole' => $request->get('sel_idrole'),'to_iduser' => $request->get('sel_to_iduser'),'by_iduser'=>$iduserimp]);
            $grantperm->save(); 
        } catch (\Illuminate\Database\QueryException $ex) {
            $errors = new MessageBag(['errorlogin' => $ex->getMessage()]);
            return redirect()->back()->withInput()->withErrors($errors);
        } 
        return redirect()->route('admin.grantperm.index')->with('success',"Đã cấp quyền thành công");
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
    public function edit($idgrant)
    {
        $users = user::all()->toArray();
        $roles = Role::all()->toArray();
        $result = DB::select('call ListgrantbyidProcedure(?)',array($idgrant));
        $selected = json_decode(json_encode($result), true);
        return view('admin.grantperm.edit',compact('users','roles','selected','idgrant'));
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $idgrant)
    {
        $byiduser = Auth::id();
        $grant = Grant::find($idgrant);
        $grant->idrole = $request->get('sel_idrole');
        $grant->to_iduser = $request->get('sel_touser');
        $grant->to_iduser = $byiduser;
        $grant->save();
        $message = "Đã cập nhật";
        return redirect()->route('admin.grantperm.index')->with('success',$message);
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($idgrant)
    {
        $grant = Grant::find($idgrant);
        $grant->delete();
        return redirect()->route('admin.grantperm.index')->with('success','record have deleted');
    }
}
