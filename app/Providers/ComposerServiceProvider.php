<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;
use Illuminate\Support\Facades\View;
use Illuminate\Support\Facades\Auth;
use Illuminate\Foundation\Auth\AuthenticatesUsers;
//use Auth; 
use Validator;
use Illuminate\Support\MessageBag;
use Illuminate\Support\Facades\DB;
// use App\Http\Controllers\ControllerName;
class ComposerServiceProvider extends ServiceProvider
{
    /**
     * Bootstrap services.
     *
     * @return void
     */
    public function boot()
    {
       
        //View::composer(['admin.dashboard','dashboard'], function ($view) {
        View::composer(array('teamilk.master','teamilk.account.profile','teamilk.addcart.check-out','admin.dashboard','admin.topnav','teamilk.menu-master'), function ($view) {
            $_namecattype="website";
            $rs_catbytype = DB::select('call ListAllCatByTypeProcedure(?)',array($_namecattype));
            $catbytypes = json_decode(json_encode($rs_catbytype), true);
            $iduser = Auth::id();
            $qr_select_profile = DB::select('call SelectProfileProcedure(?)',array($iduser));
            $profile = json_decode(json_encode($qr_select_profile), true);
            //list store
            $_namecattype = "store";
            $qr_store = DB::select('call ListAllCatByTypeProcedure(?)',array($_namecattype));
            $stores = json_decode(json_encode($qr_store), true);
            //$_cattype = "product";
            $qr_cat_product = DB::select('call ListAllCatByTypeProcedure(?)',array('product'));
            $rs_cat_product = json_decode(json_encode($qr_cat_product), true);
            //menu
            $idmenu = 1;
            $qr_menu = DB::select('call ListItemCateByIdMenuProcedure(?)',array($idmenu));
            $rs_menu = json_decode(json_encode($qr_menu), true);
            $view->with(compact('stores','catbytypes','profile','iduser','rs_cat_product','rs_menu'));
        });
    }

    /**
     * Register services.
     *
     * @return void
     */
    public function register()
    {
        //
    }
}
