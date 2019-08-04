<?php

/*

|--------------------------------------------------------------------------

| Web Routes

|--------------------------------------------------------------------------

|

| Here is where you can register web routes for your application. These

| routes are loaded by the RouteServiceProvider within a group which

| contains the "web" middleware group. Now create something great!

|

*/



Route::get('/clear-cache', function() {

    Artisan::call('cache:clear');

    return "Cache is cleared";

});

Route::get('/home', array( 'as' => 'teamilk', 'uses' => 'teamilk\HomeController@home' ));

Route::any('/', array( 'as' => 'teamilk', 'uses' => 'teamilk\HomeController@home' ));

//Route::any('/', ['uses' =>'teamilk\HomeController@home', 'as'=>'teamilk'] );

//Route::get('/', ['uses' =>'teamilk\CategoryController@CategoryBynametype', 'as'=>'admin']);

Route::get('/admin', function () {

	if (Auth::check()) {

	    $user = Auth::user();  

	    return redirect()->route('admin.adsvcustomer.index')->with('success',$user->name);

	    //return view('admin.post.index');

	} else {

		//return route('login');

	    return redirect('admin/login');

	}

});

Route::get('admin/login', ['uses' =>'Admin\LoginController@getLogin', 'as'=>'admin']);

Route::post('admin/login', ['uses' =>'Admin\LoginController@getLogin', 'as'=>'admin']);

//postlogin

Route::get('admin/postLogin', ['uses' =>'Admin\LoginController@postLogin', 'as'=>'admin']);

Route::post('admin/postLogin', ['uses' =>'Admin\LoginController@postLogin', 'as'=>'admin']);

//list product by idcategory

Route::get('teamilk/listproductbyidcate/{_idcategory}/{_id_post_type}/{_id_status_type}/{_limit}', ['uses' =>'teamilk\ProductController@listviewproductbyidcate']);

Route::post('teamilk/listproductbyidcate/{_idcategory}/{_id_post_type}/{_id_status_type}/{_limit}', ['uses' =>'teamilk\ProductController@listviewproductbyidcate']);

//add cart

Route::get('teamilk/shopcart', ['uses' =>'teamilk\ShopCartController@index']);

Route::post('teamilk/shopcart', ['uses' =>'teamilk\ShopCartController@index']);

//add cart

Route::get('teamilk/checkout', ['uses' =>'teamilk\ShopCartController@checkout']);

Route::post('teamilk/checkout', ['uses' =>'teamilk\ShopCartController@checkout']);

//submit checkout

Route::get('teamilk/submitcheckout', ['uses' =>'teamilk\ShopCartController@submitcheckout']);

Route::post('teamilk/submitcheckout', ['uses' =>'teamilk\ShopCartController@submitcheckout']);

//add cart

Route::get('teamilk/complete/{ordernumber}', ['uses' =>'teamilk\ShopCartController@complete']);

Route::post('teamilk/complete/{ordernumber}', ['uses' =>'teamilk\ShopCartController@complete']);

//product

Route::resource('teamilk/product','teamilk\ProductController', array('as'=>'teamilk'));

//user

//oute::post('login', ['uses' => 'Auth\LoginController@getLogin']);

Route::get('login', ['as' => 'login', 'uses' => 'Auth\LoginController@getLogin']);

Route::post('login', ['as' => 'login', 'uses' => 'Auth\LoginController@getLogin']);

Route::get('postlogin', ['as' => 'Auth', 'uses' => 'Auth\LoginController@postLogin']);

Route::post('postlogin', ['as' => 'Auth', 'uses' => 'Auth\LoginController@postLogin']);

Route::get('register', ['as' => 'Auth', 'uses' => 'Auth\RegisterController@register']);

Route::post('register', ['as' => 'Auth', 'uses' => 'Auth\RegisterController@register']);

//login modal

Route::get('teamilk/complete', ['uses' =>'teamilk\ShopCartController@complete']);

Route::post('teamilk/complete', ['uses' =>'teamilk\ShopCartController@complete']);

//login modal

Route::get('loginmodal', 'Auth\LoginController@postloginmodal');

Route::post('loginmodal', 'Auth\LoginController@postloginmodal');



Route::get('logout','Auth\LoginController@logout');

Route::get('signout','Auth\LoginController@signout');

Route::post('signout','Auth\LoginController@signout');

Route::get('profile/{_iduser}', function () {

     if (!Auth::check()) {

     		return redirect('admin/login');

        } 

});

//Route::group(['prefix' => 'admin',  'middleware' => 'auth'], function()

Route::group(['middleware' => 'auth'], function() {

	//account

	Route::get('profile/{_iduser}', 'account\AccountController@getprofile');

	Route::post('profile/{_iduser}', 'account\AccountController@getprofile');



	Route::get('updateprofile/{_iduser}', 'account\AccountController@update');

	Route::post('updateprofile/{_iduser}', 'account\AccountController@update');



	Route::get('changepassword/{_iduser}', 'account\AccountController@changepassword');

	Route::post('changepassword/{_iduser}', 'account\AccountController@changepassword');



	Route::post('profile/uploadavatar/{iduser}/{idprofile}',['uses' =>'account\AccountController@uploadavatar']);

	Route::get('profile/uploadavatar/{iduser}/{idprofile}',['uses' =>'account\AccountController@uploadavatar']);



	Route::resource('svcustomer','SvCustomerController');

	Route::resource('svposttype','SvPostTypeController');

	//Route::get('svpost/makepost', 'SvPostController@makepost');

	//Route::post('svpost/makepost', 'SvPostController@makepost');

	Route::resource('svpost','SvPostController');

	Route::resource('category','CategoryController');

    Route::resource('admin/aduser' , 'Admin\AduserController', array('as'=>'admin') );

	Route::resource('admin/adsvcustomer' , 'Admin\AdsvcustomerController', array('as'=>'admin') );



	Route::get('admin/category/listcategorybyid', 'Admin\CategoryController@listcatbyidcat');

	Route::post('admin/category/listcategorybyid', 'Admin\CategoryController@listcatbyidcat');



	Route::get('admin/category/catebyidcatetype/{_idcatetype}', 'Admin\CategoryController@category_by_idcatetype');

	Route::post('admin/category/catebyidcatetype/{_idcatetype}', 'Admin\CategoryController@category_by_idcatetype');



	Route::get('admin/categoryby/{_namecattype}', ['uses' =>'Admin\CategoryController@CategoryBynametype', 'as'=>'admin']);

	Route::post('admin/categoryby/{_namecattype}', ['uses' =>'Admin\CategoryController@CategoryBynametype', 'as'=>'admin']);



	Route::get('admin/category/createby/{_namecattype}' , ['uses' =>'Admin\CategoryController@createby', 'as'=>'admin'] );

	Route::post('admin/category/createby/{_namecattype}' , ['uses' =>'Admin\CategoryController@createby', 'as'=>'admin'] );



	Route::get('admin/category/storeby/{_namecattype}' , ['uses' =>'Admin\CategoryController@storeby', 'as'=>'admin'] );

	Route::post('admin/category/storeby/{_namecattype}' , ['uses' =>'Admin\CategoryController@storeby', 'as'=>'admin'] );

	Route::resource('admin/category' , 'Admin\CategoryController', array('as'=>'admin') );



	

	Route::get('admin/menu/hasidcate/{_idmenu}', 'Admin\MenuController@menuhasidcate');

	Route::post('admin/menu/hasidcate/{_idmenu}', 'Admin\MenuController@menuhasidcate');

	Route::resource('admin/menu' , 'Admin\MenuController', array('as'=>'admin') );

	

	Route::get('admin/menu/additem/{_idmenu}', 'Admin\MenuHasCateController@AddMenuItem');

	Route::post('admin/menu/additem/{_idmenu}', 'Admin\MenuHasCateController@AddMenuItem');

	Route::get('admin/menuhascate/bytype/{_namecattype}', 'Admin\MenuHasCateController@catebytype');

	Route::post('admin/menuhascate/bytype/{_namecattype}', 'Admin\MenuHasCateController@catebytype');

	Route::resource('admin/menuhascate' , 'Admin\MenuHasCateController', array('as'=>'admin') );



	Route::get('admin/svpost/makepost', 'Admin\SvPostController@makepost');

	Route::post('admin/svpost/makepost', 'Admin\SvPostController@makepost');

	Route::resource('admin/svpost' , 'Admin\SvPostController', array('as'=>'admin') );



	Route::resource('admin/svposttype' , 'Admin\SvPostTypeController', array('as'=>'admin') );



	//customer register

	Route::get('admin/customerreg/interactive', 'Admin\CustomerRegController@make_interactive');

	Route::post('admin/customerreg/interactive', 'Admin\CustomerRegController@make_interactive');



	Route::get('admin/customerreg/interactivecustomer', ['uses' =>'Admin\CustomerRegController@interactive_customer', 'as'=>'admin']);



	Route::post('admin/customerreg/interactivecustomer', ['uses' =>'Admin\CustomerRegController@interactive_customer', 'as'=>'admin']);



	Route::get('admin/customerreg/listcustomerbydate/{_idcategory}/{_id_post_type}/{_id_status_type}', ['uses' =>'Admin\CustomerRegController@ListCustomerByDate', 'as'=>'admin']);



	Route::post('admin/customerreg/listcustomerbydate/{_idcategory}/{_id_post_type}/{_id_status_type}', ['uses' =>'Admin\CustomerRegController@ListCustomerByDate', 'as'=>'admin']);



	Route::get('admin/customerreg/listcustomerbycat/{_idcategory}/{_id_post_type}/{_id_status_type}', ['uses' =>'Admin\CustomerRegController@ListCustomerByCat', 'as'=>'admin']);

	Route::post('admin/customerreg/listcustomerbycat/{_idcategory}/{_id_post_type}/{_id_status_type}', ['uses' =>'Admin\CustomerRegController@ListCustomerByCat', 'as'=>'admin']);



	//show detail



	Route::get('admin/customerreg/{_idimport}', ['uses' =>'Admin\CustomerRegController@show', 'as'=>'admin']);

	Route::post('admin/customerreg/{_idimport}', ['uses' =>'Admin\CustomerRegController@show', 'as'=>'admin']);



	//end show detail

	Route::resource('admin/customerreg' , 'Admin\CustomerRegController', array('as'=>'admin') );



	//post management

	Route::get('admin/post/listcatbyidcat', 'Admin\CategoryController@listcatbyidcat');

	Route::post('admin/post/listcatbyidcat', 'Admin\CategoryController@listcatbyidcat');

	Route::resource('admin/post' , 'Admin\PostsController', array('as'=>'admin') );

	Route::resource('admin/posttype' , 'Admin\PostTypeController', array('as'=>'admin') );

	Route::resource('admin/cattype' , 'Admin\CategoryTypeController', array('as'=>'admin') );

	Route::resource('admin/statustype' , 'Admin\StatusTypeController', array('as'=>'admin') );



	//upload file



	Route::post('admin/upload' , 'Admin\UploadController@upload');

	Route::get('admin/upload' , 'Admin\UploadController@upload');

	Route::post('admin/uploadfile' , 'Admin\UploadController@uploadfile');

	Route::get('admin/uploadfile' , 'Admin\UploadController@uploadfile');



	Route::post('admin/files/uploaddataurl' , 'Admin\FilesController@uploadDataULR');

	Route::get('admin/files/uploaddataurl' , 'Admin\FilesController@uploadDataULR');

	

	Route::post('admin/files/uploadfile' , 'Admin\FilesController@uploadfile');

	Route::get('admin/files/uploadfile' , 'Admin\FilesController@uploadfile');

	Route::resource('admin/files' , 'Admin\FilesController', array('as'=>'admin'));

	//deparment

	Route::get('admin/department/listdepartmentbyid', 'Admin\DepartmentController@listdepartmentbyid');

	Route::post('admin/department/listdepartmentbyid', 'Admin\DepartmentController@listdepartmentbyid');

	Route::resource('admin/department','Admin\DepartmentController', array('as'=>'admin'));

	//products

	Route::post('admin/producthasfile/delete',['uses' =>'Admin\ProductsController@trash', 'as'=>'admin']);

	Route::get('admin/producthasfile/delete',['uses' =>'Admin\ProductsController@trash', 'as'=>'admin']);



	Route::post('admin/product/categorybyid/{_cattype}/{_idcat}/{_idproduct}',['uses' =>'Admin\ProductsController@categorybyid', 'as'=>'admin']);

	Route::get('admin/product/categorybyid/{_cattype}/{_idcat}/{_idproduct}',['uses' =>'Admin\ProductsController@categorybyid', 'as'=>'admin']);



	Route::post('admin/product/cross/{_idproduct}',['uses' =>'Admin\ProductsController@crossproduct', 'as'=>'admin']);

	Route::get('admin/product/cross/{_idproduct}',['uses' =>'Admin\ProductsController@crossproduct', 'as'=>'admin']);



	Route::resource('admin/product','Admin\ProductsController', array('as'=>'admin'));



	//grant permistion



	Route::resource('admin/roles','Admin\RoleController', array('as'=>'admin'));



	Route::resource('admin/permission','Admin\PermissionController', array('as'=>'admin'));



    Route::resource('admin/impperm','Admin\ImpPermController', array('as'=>'admin'));



    Route::resource('admin/grantperm','Admin\GrantController', array('as'=>'admin'));



    //profile



    Route::post('admin/profile/uploadavatar/{iduser}/{idprofile}',['uses' =>'ProfileController@uploadavatar']);



	Route::get('admin/profile/uploadavatar/{iduser}/{idprofile}',['uses' =>'ProfileController@uploadavatar']);



    Route::get('admin/profile/{iduser}', ['uses' =>'ProfileController@show']);



	Route::post('admin/profile/{iduser}', ['uses' =>'ProfileController@show']);



	Route::get('admin/profile/update/{iduser}', ['uses' =>'ProfileController@update']);

	Route::post('admin/profile/update/{iduser}', ['uses' =>'ProfileController@update']);



	Route::get('admin/profile/changepassword/{iduser}', ['uses' =>'ProfileController@changepassword']);

	Route::post('admin/profile/changepassword/{iduser}', ['uses' =>'ProfileController@changepassword']);



	Route::resource('admin/profile','ProfileController');

	//list order

	Route::post('admin/orderlist/show/{_ordernumber}',['uses' =>'Admin\OrdersManagementController@show']);

	Route::get('admin/orderlist/show/{_ordernumber}',['uses' =>'Admin\OrdersManagementController@show']);



	Route::post('admin/orderlist/{_idstore}',['uses' =>'Admin\OrdersManagementController@listorder']);

	Route::get('admin/orderlist/{_idstore}',['uses' =>'Admin\OrdersManagementController@listorder']);

});







