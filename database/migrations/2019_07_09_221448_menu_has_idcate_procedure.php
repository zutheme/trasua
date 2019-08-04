<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class MenuHasIdcateProcedure extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        DB::unprepared("
            CREATE PROCEDURE MenuHasIdcateProcedure(IN _idmenu int(11),IN _idcategory int(11),IN _idparentmenu int(11))
            BEGIN
               insert into menu_has_cate(idmenu,idcategory,idparentmenu) values (_idmenu,_idcategory,_idparentmenu);  
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
        DB::unprepared('DROP PROCEDURE IF EXISTS MenuHasIdcateProcedure');
    }
}
