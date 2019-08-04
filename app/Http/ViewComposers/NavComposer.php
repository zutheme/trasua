<?php
namespace App\Http\ViewComposers;



class NavComposer
{
    public function compose($view)
    {
        $menu = "main menu 1";
        $view->with('menu', $menu);
    }
}
?>