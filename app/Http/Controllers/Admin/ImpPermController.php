<?php

namespace App\Http\Controllers\Admin;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\ImpPerm;
use App\Permission;
use App\Role;
use Illuminate\Support\Facades\DB;
use Illuminate\Foundation\Auth\AuthenticatesUsers;
use Auth;
class ImpPermController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        $result = DB::select('call ListImppermProcedure()');
        $impperms = json_decode(json_encode($result), true);
        return view('admin.impperm.index',compact('impperms'));
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        $permissions = Permission::all()->toArray();
        $roles = Role::all()->toArray();
        return view('admin.impperm.create',compact('permissions','roles'));
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        // $validator = Validator::make($request->all(), [ 
        //     'name' => 'required'
        // ]);
        // if ($validator->fails()) { 
        //     $errors = $validator->errors();
        //     return redirect()->route('admin.impperm.create')->with(compact('errors'));           
        // }
        $input = $request->all();          
        $message = "";  
        try {
            $iduserimp = Auth::id();
            $impperm = new ImpPerm(['idperm' => $request->get('sel_idperm'),'idrole' => $request->get('sel_idrole'),'iduserimp'=>$iduserimp]);
            $impperm->save(); 
        } catch (\Illuminate\Database\QueryException $ex) {
            $errors = new MessageBag(['errorlogin' => $ex->getMessage()]);
            return redirect()->back()->withInput()->withErrors($errors);
        } 
        return redirect()->route('admin.impperm.index')->with('success',"Đã tạo quyền thành công");
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
    public function edit($id_impperm)
    {       
        $permissions = Permission::all()->toArray();
        $roles = Role::all()->toArray();
        $result = DB::select('call ImppermbyidProcedure(?)',array($id_impperm));
        $selected = json_decode(json_encode($result), true);
        return view('admin.impperm.edit',compact('permissions','roles','selected','id_impperm'));
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $id_impperm)
    {
        //$this->validate($request,['sel_idperm'=>'required']);
        $iduserimp = Auth::id();  
        $impperm = ImpPerm::find($id_impperm);
        $impperm->idperm = $request->get('sel_idperm');
        $impperm->idrole = $request->get('sel_idrole');
        $impperm->iduserimp = $iduserimp;
        $impperm->save();
        return redirect()->route('admin.impperm.index')->with('success','data update');
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id_impperm)
    {
        $impperm = ImpPerm::find($id_impperm);
        $impperm->delete();
        return redirect()->route('admin.impperm.index')->with('success','record have deleted');
    }
}
