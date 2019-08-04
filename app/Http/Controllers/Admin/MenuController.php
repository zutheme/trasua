<?php

namespace App\Http\Controllers\Admin;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\DB;
use Illuminate\Foundation\Auth\AuthenticatesUsers;
use Auth;
use App\menu;
use App\category;
use App\CategoryType;
class MenuController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    protected $main_menu = "";
    public function index()
    {
        $qr_menu = DB::select('call ListMenuProcedure()');
        $rs_menu = json_decode(json_encode($qr_menu), true);
        return view('admin.menu.index',compact('rs_menu'));
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        return view('admin.menu.create');
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
            $menu = new menu(['namemenu' => $request->get('namemenu')]);
            $menu->save(); 
        } catch (\Illuminate\Database\QueryException $ex) {
            $errors = new MessageBag(['error' => $ex->getMessage()]);
            return redirect()->back()->withInput()->withErrors($errors);
        } 
        return view('admin.menu.index');
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
    public function edit($idmenu)
    {
        $menus = menu::find($idmenu);
        //$categorybyid = category::find($idcategory);
        $categories = category::all()->toArray();
        $categorytypes = CategoryType::all()->toArray();
        //$result = DB::select('call SelCategorybyIdProcedure(?)',array($idcategory));
        //$selected = json_decode(json_encode($result), true);
        
        return view('admin.menu.edit',compact('menus','categories','categorytypes','idmenu'));
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $idmenu)
    {
        $this->validate($request,['namemenu'=>'required']);
        //$idcustomer = $role->idcustomer;
        $menu = menu::find($idmenu);
        $menu->namemenu = $request->get('namemenu');
        $menu->save();
        return redirect()->route('admin.menu.index')->with('success','data update');
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
    
}
