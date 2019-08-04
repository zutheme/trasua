<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class SelDepartmentByIdProcedure extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        DB::unprepared('
            CREATE PROCEDURE SelDepartmentByIdProcedure(IN _iddepart int(11))
            BEGIN
                SELECT c1.iddepart, c1.namedepart, c1.idparent, c2.namedepart as parent from (select * from departments where iddepart=_iddepart) as c1 left Join departments as c2 on c1.idparent = c2.iddepart;
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
        DB::unprepared('DROP PROCEDURE IF EXISTS SelDepartmentByIdProcedure');
    }
}
