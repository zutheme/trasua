<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class ListDepartParentProcedure extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
         DB::unprepared('
            CREATE PROCEDURE ListDepartParentProcedure()
            BEGIN
                SELECT c1.iddepart, c1.namedepart from departments as c1 where c1.idparent is null;
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
       DB::unprepared('DROP PROCEDURE IF EXISTS ListDepartParentProcedure');
    }
}
