<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class ListTypeSelectedProcedure extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        DB::unprepared('
            CREATE PROCEDURE ListTypeSelectedProcedure(IN id_post int(11))
            BEGIN
                SELECT p.id_post_type as idposttype,(select nametype from post_types WHERE idposttype = p.id_post_type) as nameposttype,p.idcategory,(SELECT name FROM categories WHERE idcategory = p.idcategory) as namecate FROM posts as p WHERE p.idpost=id_post;
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
        DB::unprepared('DROP PROCEDURE IF EXISTS ListTypeSelectedProcedure');
    }
}