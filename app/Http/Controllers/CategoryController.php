<?php
namespace App\Http\Controllers;
use App\category;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
class CategoryController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        //$categories = category::all()->toArray();
        $result = DB::table('categories as c1')
            ->leftJoin('categories as c2', 'c1.idparent', '=', 'c2.idcategory')
            ->select('c1.idcategory', 'c1.name','c2.name as parent')
            ->get();
        //$categories = $resutl->toArray();
        $categories = json_decode(json_encode($result), true);
        return view('category.index',compact('categories'));
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        $categories = category::all()->toArray();
        return view('category.create',compact('categories'));
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
        $categories = new category(['name'=> $request->get('name'),'idparent'=> $request->get('sel_idparent')]);
        $categories->save();
        return redirect()->route('category.index')->with('success','data added');
    }

    /**
     * Display the specified resource.
     *
     * @param  \App\category  $category
     * @return \Illuminate\Http\Response
     */
    public function show($idcategory)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  \App\category  $category
     * @return \Illuminate\Http\Response
     */
    public function edit($idcategory)
    {
        $category = category::find($idcategory);
        $categories = category::all()->toArray();
        return view('category.edit',compact('category','idcategory','categories'));
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \App\category  $category
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $idcategory)
    {
        $this->validate($request,['name'=>'required']);
        //$idcustomer = $category->idcustomer;
        $category = category::find($idcategory);
        $category->name = $request->get('name');
        $category->idparent = $request->get('sel_idparent');
        $category->save();
        return redirect()->route('category.index')->with('success','data update');
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\category  $category
     * @return \Illuminate\Http\Response
     */
    public function destroy($idcategory)
    {
        $categories = category::find($idcategory);
        $categories->delete();
        return redirect()->route('category.index')->with('success','record have deleted');
    }
    
}
