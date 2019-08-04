<?php



namespace App\Http\Controllers\Admin;

use App\category;

use App\CategoryType;

use Illuminate\Http\Request;

use App\Http\Controllers\Controller;

use Illuminate\Support\Facades\DB;

use App\status_type;

use App\PostType;

class CategoryController extends Controller

{

    /**

     * Display a listing of the resource.

     *

     * @return \Illuminate\Http\Response

     */

    protected $main_menu = "";

    // public function CategoryController(){

    //     $this->$main_menu = "";

    // }

    public function index()

    {

        $result = DB::select('call ListCategoryProcedure()');

        $categories = json_decode(json_encode($result), true);

        return view('admin.category.index',compact('categories'));

    }



    /**

     * Show the form for creating a new resource.

     *

     * @return \Illuminate\Http\Response

     */

    public function create()

    {

        $categories = category::all()->toArray();

        $categorytypes = CategoryType::all()->toArray();

        return view('admin.category.create',compact('categories','categorytypes'));

    }



    /**

     * Store a newly created resource in storage.

     *

     * @param  \Illuminate\Http\Request  $request

     * @return \Illuminate\Http\Response

     */

    public function store(Request $request)

    {

         $this->validate($request,['namecat'=>'required']);

        $categories = new category(['namecat'=> $request->get('namecat'),'idcattype'=>$request->get('sel_idcattype'),'idparent'=> $request->get('sel_idparent')]);

        $categories->save();

        return redirect()->route('admin.category.index')->with('success','data added');

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

    public function edit($idcategory)
    {
        $categorybyid = category::find($idcategory);
        $categories = category::all()->toArray();
        $categorytypes = CategoryType::all()->toArray();
        $result = DB::select('call SelCategorybyIdProcedure(?)',array($idcategory));
        $selected = json_decode(json_encode($result), true);
        return view('admin.category.edit',compact('categorybyid','categories','idcategory','categorytypes','selected'));
    }



    /**

     * Update the specified resource in storage.

     *

     * @param  \Illuminate\Http\Request  $request

     * @param  int  $id

     * @return \Illuminate\Http\Response

     */

    public function update(Request $request, $idcategory)

    {

        $this->validate($request,['namecat'=>'required']);

        //$idcustomer = $category->idcustomer;

        $category = category::find($idcategory);
      
        $category->namecat = $request->get('namecat');

        $category->idparent = $request->get('sel_idparent');
        $idcattype = $request->get('sel_idcattype');
        $category->idcattype = $idcattype;

        $category->save();
        $cat_name_type = CategoryType::find($idcattype);
        $catnametype = $cat_name_type->catnametype;
        //return redirect()->route('admin.category.index')->with('success','data update');
        return redirect('admin/categoryby/'.$catnametype)->with('success','data update');

    }



    /**

     * Remove the specified resource from storage.

     *

     * @param  int  $id

     * @return \Illuminate\Http\Response

     */

    public function destroy($idcategory)

    {

         $categories = category::find($idcategory);

        $categories->delete();

        return redirect()->route('admin.category.index')->with('success','record have deleted');

    }



    public function listcatbyidcat()

    {

        $input = json_decode(file_get_contents('php://input'),true);

        $idcat = $input['sel_idcategory'];

        $result = DB::select('call SellistcategorybyidProcedure(?)',array($idcat));

        $selected = json_decode(json_encode($result), true);     

        return response()->json($selected); 

    }

    public function CategoryBynametype($_namecattype)

    {

        $statustypes = status_type::all()->toArray();

        $posttypes = PostType::all()->toArray();

        $result = DB::select('call ListAllCatByTypeProcedure(?)',array($_namecattype));

        $categories = json_decode(json_encode($result), true);

        return view('admin.category.index',compact('posttypes','categories','statustypes'));

        //return redirect()->route('admin.category.index')->with(compact('posttypes','categories','statustypes'));

    }

    public function createby($_namecattype)

    {

        //$categories = category::all()->toArray();

        $result = DB::select('call ListAllCatByTypeProcedure(?)',array($_namecattype));

        $categories = json_decode(json_encode($result), true);

        $categorytypes = CategoryType::all()->toArray();

        return view('admin.category.create',compact('categories','categorytypes','_namecattype'));

    }

     public function storeby(Request $request,$_namecattype)

    {

        $this->validate($request,['namecat'=>'required']);

        $category = new category(['namecat'=> $request->get('namecat'),'idcattype'=>$request->get('sel_idcattype'),'idparent'=> $request->get('sel_idparent')]);

        $category->save();

        $result = DB::select('call ListAllCatByTypeProcedure(?)',array($_namecattype));

        $categories = json_decode(json_encode($result), true);

        //return redirect()->route('admin/categoryby/'.$_namecattype)->with(compact('categories'));

         return redirect('admin/categoryby/'.$_namecattype)->with(compact('categories'));

    }

    

    public function initCategories()
    {

        $data = array();

        $index = array();

        $_namecattype = "product";

        $result = DB::select('call ListAllCatByTypeProcedure(?)',array($_namecattype));

        $categories = json_decode(json_encode($result), true);

        foreach ($categories as $row) {

            $idcategory =$row["idcategory"];

            $idparent =$row["idparent"];

            $data[$idcategory]= $row;

            $index[$idparent][]=$idcategory;

        }

       $this->display_tree(0, 0, $index, $data);

       return $this->main_menu;

    }

    public function display_tree($idparent, $level, $index, $data)

    {

        //global $data, $index;

        if (isset($index[$idparent])) {

            foreach ($index[$idparent] as $id) {

                //$id = $value->idcategory;

                $this->main_menu .= str_repeat(" -", ($level*2)) . $data[$id]["namecat"] . "<br>";

                $this->display_tree($id, $level + 1,$index, $data);

            }

        }

    }
    public function category_by_idcatetype($_idcattype){
        //$input = json_decode(file_get_contents('php://input'),true);
        //$_idcattype = $input['idcattype'];
        $qr_catetype = DB::select('call CategoryByIdcatetype(?)',array($_idcattype));
        $rs_catetype = json_decode(json_encode($qr_catetype), true);
        return response()->json($rs_catetype);
    }
    
}

