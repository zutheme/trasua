<?php



namespace App\Http\Controllers\Admin;



use App\Http\Controllers\Controller;

use App\sv_post;

use App\sv_customer;

use App\sv_post_type;

use App\category;

use Illuminate\Support\Facades\DB;

use Illuminate\Http\Request;

class SvPostController extends Controller

{

    /**

     * Display a listing of the resource.

     *

     * @return \Illuminate\Http\Response

     */

    public function index()

    {

         //$svposts = sv_post::all()->toArray();

        //$categories = category::all()->toArray();

        $result = DB::table('sv_posts as p')

            ->leftJoin('sv_post_types as t', 'p.id_post_type', '=', 't.id_post_type')

            ->leftJoin('categories as c', 'p.idcategory', '=', 'c.idcategory')

            ->select('p.id_svpost','p.title','p.body','p.url','t.name as type','c.name as category')

            ->get();

        //$categories = $resutl->toArray();

        $svposts = json_decode(json_encode($result), true);      

        return view('admin.svpost.index',compact('svposts'));

    }



    /**

     * Show the form for creating a new resource.

     *

     * @return \Illuminate\Http\Response

     */

    public function create()

    {

        $svposttypes = sv_post_type::all()->toArray();

        $categories = category::all()->toArray();

        return view('admin.svpost.create',compact('svposttypes','categories'));

    }



    /**

     * Store a newly created resource in storage.

     *

     * @param  \Illuminate\Http\Request  $request

     * @return \Illuminate\Http\Response

     */

    public function store(Request $request)

    {

        $this->validate($request,['title'=>'required','body'=>'required','url'=>'required']);

        $svpost = new sv_post(['title' => $request->get('title'),'body' => $request->get('body'),'url'=>$request->get('url'),'id_post_type'=>$request->get('sel_idposttype'),'idcategory'=> $request->get('sel_idcategory')]);

        $svpost->save();

        return redirect()->route('admin.svpost.index')->with('success','data added');

    }



    /**

     * Display the specified resource.

     *

     * @param  int  $id

     * @return \Illuminate\Http\Response

     */

    public function show()

    {

        //

    }



    /**

     * Show the form for editing the specified resource.

     *

     * @param  int  $id

     * @return \Illuminate\Http\Response

     */

    public function edit($id_svpost)

    {

        $svposts = sv_post::find($id_svpost);

        $svposttypes = sv_post_type::all()->toArray();

        $categories = category::all()->toArray();

        $result = DB::table('sv_posts as p')

            ->leftJoin('sv_post_types as t', 'p.id_post_type', '=', 't.id_post_type')

            ->leftJoin('categories as c', 'p.idcategory', '=', 'c.idcategory')

            ->select('t.id_post_type','t.name as type','c.idcategory','c.name as category')

            ->where('p.id_svpost', '=', $id_svpost)

            ->get();

        $selected = json_decode(json_encode($result), true);

        return view('admin.svpost.edit',compact('svposts','id_svpost','svposttypes','categories','selected'));

    }



    /**

     * Update the specified resource in storage.

     *

     * @param  \Illuminate\Http\Request  $request

     * @param  int  $id

     * @return \Illuminate\Http\Response

     */

    public function update(Request $request, $id_svpost)

    {

        $this->validate($request,['title'=>'required','body'=>'required','url'=>'required']);  

        $svpost = sv_post::find($id_svpost);

        $svpost->idcategory = $request->get('sel_idcategory');

        $svpost->title = $request->get('title');

        $svpost->body = $request->get('body');

        $svpost->url = $request->get('url');

        $svpost->id_post_type = $request->get('sel_idposttype');

        $svpost->save();

        return redirect()->route('admin.svpost.index')->with('success','data update');

    }



    /**

     * Remove the specified resource from storage.

     *

     * @param  int  $id

     * @return \Illuminate\Http\Response

     */

    public function destroy($id_svpost)

    {

        //$id_svpost = $sv_post->id_svpost;

        $svpost = sv_post::find($id_svpost);

        $svpost->delete();

        return redirect()->route('admin.svpost.index')->with('success','record have deleted');

    }

    public function makepost(Request $request)

    {

        $svpost = new sv_post;

        $svpost->title = $request->get('title');

        $svpost->body = $request->get('body');

        $svpost->url = $request->get('url');

        $svpost->id_post_type = $request->get('sel_idposttype');

        $svpost->idcategory = $request->get('sel_idcategory');

        $svpost->save();

        $success['id_svpost'] =  $svpost->id_svpost;

        return response()->json($success); 

    }
}

