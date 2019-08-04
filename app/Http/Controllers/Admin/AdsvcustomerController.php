<?php
namespace App\Http\Controllers\Admin;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\sv_customer;
use App\sv_post_type;
use App\category;
use Illuminate\Support\Facades\DB;

class AdsvcustomerController extends Controller
{

    /**

     * Display a listing of the resource.

     *

     * @return \Illuminate\Http\Response

     */
    public function index()
    {

        //$svcustomers = sv_customer::all()->toArray();
        //$_namecattype="website";
        //$rs_catbytype = DB::select('call ListAllCatByTypeProcedure(?)',array($_namecattype));
        //$catbytypes = json_decode(json_encode($rs_catbytype), true);

        $svposttypes = sv_post_type::all()->toArray();

        $categories = category::all()->toArray();

        $result = DB::table('sv_customers')

            ->orderBy('idcustomer', 'asc')->take(1000)

            //->select('sv_customers.*')

            ->get();

        //$categories = $resutl->toArray();

        $svcustomers = json_decode(json_encode($result), true);
        return view('admin.adsvcustomer.index',compact('svcustomers','svposttypes','categories'));
        //return view('admin.adsvcustomer.index',compact('svcustomers','svposttypes','categories','catbytypes'));

    }



    /**

     * Show the form for creating a new resource.

     *

     * @return \Illuminate\Http\Response

     */

    public function create()

    {

        return view('admin.adsvcustomer.create');

    }



    /**

     * Store a newly created resource in storage.

     *

     * @param  \Illuminate\Http\Request  $request

     * @return \Illuminate\Http\Response

     */

    public function store(Request $request)

    {

        $this->validate($request,['mobile'=>'required']);



        $svcustomer = new sv_customer(['lastname'=> $request->get('lastname'),



            'firstname' => $request->get('firstname'),'email' => $request->get('email'),'mobile'=>$request->get('mobile'),'address'=>$request->get('address'),'job'=>$request->get('job'),'note'=>$request->get('note')]);



        $svcustomer->save();

        return redirect()->route('admin.adsvcustomer.index')->with('success','data added');

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

    public function edit($idcustomer)

    {

        //$idcustomer = $sv_customer->idcustomer;



        $svcustomer = sv_customer::find($idcustomer);



        return view('admin.adsvcustomer.edit',compact('svcustomer','idcustomer'));

    }



    /**

     * Update the specified resource in storage.

     *

     * @param  \Illuminate\Http\Request  $request

     * @param  int  $id

     * @return \Illuminate\Http\Response

     */

    public function update(Request $request, $idcustomer)

    {

       $this->validate($request,['mobile'=>'required']);



        //$idcustomer = $sv_customer->idcustomer;



        $svcustomer = sv_customer::find($idcustomer);



        $svcustomer->lastname = $request->get('lastname');



        $svcustomer->firstname = $request->get('firstname');



        $svcustomer->email = $request->get('email');



        $svcustomer->mobile = $request->get('mobile');



        $svcustomer->address = $request->get('address');



        $svcustomer->job = $request->get('job');

        $svcustomer->note = $request->get('note');

        $svcustomer->save();

        return redirect()->route('admin.adsvcustomer.index')->with('success','data update');

    }



    /**

     * Remove the specified resource from storage.

     *

     * @param  int  $id

     * @return \Illuminate\Http\Response

     */

    public function destroy($idcustomer)

    {

        //$idcustomer = $sv_customer->idcustomer;

        $svcustomer = sv_customer::find($idcustomer);

        //$svcustomer->delete();

        return redirect()->route('admin.adsvcustomer.index')->with('success','record have deleted');

    }

}

