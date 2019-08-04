<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class SellistcategorybyidProcedure extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        DB::unprepared('
            CREATE PROCEDURE SellistcategorybyidProcedure(IN idcat int(11))
            BEGIN
                SELECT c1.idcategory, c1.namecat from categories as c1 where c1.idparent = idcat;
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
        DB::unprepared('DROP PROCEDURE IF EXISTS SellistcategorybyidProcedure');
    }
}
