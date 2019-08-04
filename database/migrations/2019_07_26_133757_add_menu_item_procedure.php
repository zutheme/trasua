<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class AddMenuItemProcedure extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        DB::unprepared('
            CREATE PROCEDURE AddMenuItemProcedure( IN _idmenu int(11), IN _idcategory int(11), IN _idparent int(11), IN _depth int(11), IN _reorder int(11), IN _trash int(6) )
            BEGIN
               insert into menu_has_cate( idmenu, idcategory, idparent, depth, reorder, trash ) values ( _idmenu, _idcategory, _idparent, _depth, _reorder, _trash);
               select LAST_INSERT_ID() as idmenuhascate;
            END'
        );
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
         DB::unprepared('DROP PROCEDURE IF EXISTS AddMenuItemProcedure');
    }
}
