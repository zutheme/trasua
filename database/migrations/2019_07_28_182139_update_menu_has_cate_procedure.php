<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class UpdateMenuHasCateProcedure extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        DB::unprepared("
            CREATE PROCEDURE UpdateMenuHasCateProcedure(IN _idmenuhascate int(11), IN _idmenu int(11),IN _idcategory int(11), IN _idparent int(11), IN _depth int(11), IN _reorder int(11), IN _trash int(11))
            BEGIN
               update menu_has_cate set idmenu=_idmenu, idcategory = _idcategory, idparent = _idparent, depth = _depth, reorder = _reorder, trash = _trash where idmenuhascate=_idmenuhascate;
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
        DB::unprepared('DROP PROCEDURE IF EXISTS UpdateMenuHasCateProcedure');
    }
}
