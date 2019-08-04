<?php



namespace App\Http\Controllers;



use App\sv_customer;
use App\sv_post_type;
use App\category;
use Illuminate\Http\Request;

class SvCustomerController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        $svcustomers = sv_customer::all()->toArray();
        $svposttypes = sv_post_type::all()->toArray();
        $categories = category::all()->toArray();
        return view('svcustomer.index',compact('svcustomers','svposttypes','categories'));
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        return view('svcustomer.create');

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

        return redirect()->route('svcustomer.index')->with('success','data added');

    }

    

    /**

     * Display the specified resource.

     *

     * @param  \App\sv_customer  $sv_customer

     * @return \Illuminate\Http\Response

     */

    public function show(sv_customer $sv_customer)

    {

        //

    }



    /**

     * Show the form for editing the specified resource.

     *

     * @param  \App\sv_customer  $sv_customer

     * @return \Illuminate\Http\Response

     */

    public function edit($idcustomer)

    {

        //$idcustomer = $sv_customer->idcustomer;

        $svcustomer = sv_customer::find($idcustomer);

        return view('svcustomer.edit',compact('svcustomer','idcustomer'));

    }



    /**

     * Update the specified resource in storage.

     *

     * @param  \Illuminate\Http\Request  $request

     * @param  \App\sv_customer  $sv_customer

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

        return redirect()->route('svcustomer.index')->with('success','data update');

    }



    /**

     * Remove the specified resource from storage.

     *

     * @param  \App\sv_customer  $sv_customer

     * @return \Illuminate\Http\Response

     */

    public function destroy($idcustomer)
    {
        //$idcustomer = $sv_customer->idcustomer;
        $svcustomer = sv_customer::find($idcustomer);
        $svcustomer->delete();
        return redirect()->route('svcustomer.index')->with('success','record have deleted');

    }

}

