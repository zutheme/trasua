<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class SelCategorybyIdProcedure extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        DB::unprepared('
            CREATE PROCEDURE SelCategorybyIdProcedure(IN idcat int(11))
            BEGIN
                SELECT c1.idcategory, c1.namecat, c1.idcattype, (select catnametype from category_types where idcattype=c1.idcattype) as catnametype, c1.idparent, c2.namecat as parent from (select * from categories where idcategory=idcat) as c1 left Join categories as c2 on c1.idparent = c2.idcategory;
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
        DB::unprepared('DROP PROCEDURE IF EXISTS SelCategorybyIdProcedure');
    }
}
