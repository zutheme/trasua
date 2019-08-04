<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class ListItemCateByIdMenuProcedure extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        DB::unprepared("
            CREATE PROCEDURE ListItemCateByIdMenuProcedure( IN _idmenu int(11))
            BEGIN
               SELECT mnhas.idmenuhascate, mnhas.idmenu,mnhas.idcategory,(select namecat from categories where idcategory = mnhas.idcategory) as namemenu, mnhas.idparent, mnhas.reorder, mnhas.depth, mnhas.trash FROM menu_has_cate as mnhas WHERE idmenu=_idmenu ORDER BY reorder ASC;
            END"
        );
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        DB::unprepared('DROP PROCEDURE IF EXISTS ListItemCateByIdMenuProcedure');
    }
}
