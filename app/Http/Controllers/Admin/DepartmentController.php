<?php



namespace App\Http\Controllers\Admin;



use Illuminate\Http\Request;

use App\Http\Controllers\Controller;

use Illuminate\Support\Facades\DB;

use App\Department;

class DepartmentController extends Controller

{

    /**

     * Display a listing of the resource.

     *

     * @return \Illuminate\Http\Response

     */

    public function index()

    {

        $result = DB::select('call ListDepartmentProcedure()');

        $departments = json_decode(json_encode($result), true);

        return view('admin.department.index',compact('departments'));

    }



    /**

     * Show the form for creating a new resource.

     *

     * @return \Illuminate\Http\Response

     */

    public function create()

    {

        $departments = department::all()->toArray();

        return view('admin.department.create',compact('departments'));

    }



    /**

     * Store a newly created resource in storage.

     *

     * @param  \Illuminate\Http\Request  $request

     * @return \Illuminate\Http\Response

     */

    public function store(Request $request)

    {

        $this->validate($request,['namedepart'=>'required']);

        $departments = new Department(['namedepart'=> $request->get('namedepart'),'idparent'=> $request->get('sel_idparent')]);

        $departments->save();

        return redirect()->route('admin.department.index')->with('success','data added');

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

    public function edit($iddepart)

    {

        //$departmentbyid = department::find($iddepart);

        $departments = department::all()->toArray();

        $result = DB::select('call SeldepartmentByIdProcedure(?)',array($iddepart));

        $selected = json_decode(json_encode($result), true);

        return view('admin.department.edit',compact('selected','departments'));

    }



    /**

     * Update the specified resource in storage.

     *

     * @param  \Illuminate\Http\Request  $request

     * @param  int  $id

     * @return \Illuminate\Http\Response

     */

    public function update(Request $request, $iddepart)

    {

        $this->validate($request,['namedepart'=>'required']);

        $department = department::find($iddepart);

        $department->namedepart = $request->get('namedepart');

        $department->idparent = $request->get('sel_idparent');

        $department->save();

        return redirect()->route('admin.department.index')->with('success','data update');

    }



    /**

     * Remove the specified resource from storage.

     *

     * @param  int  $id

     * @return \Illuminate\Http\Response

     */

    public function destroy($iddepart)

    {

        $department = category::find($iddepart);

        $department->delete();

        return redirect()->route('admin.department.index')->with('success','record have deleted');

    }

    public function listdepartmentbyid()

    {

        $input = json_decode(file_get_contents('php://input'),true);

        $iddepart = $input['sel_iddepart'];

        $result = DB::select('call SelListDepartmentByIdProcedure(?)',array($iddepart));

        $selected = json_decode(json_encode($result), true);     

        return response()->json($selected); 

    }

}

