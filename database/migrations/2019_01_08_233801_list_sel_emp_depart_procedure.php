<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class ListSelEmpDepartProcedure extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        DB::unprepared('
            CREATE PROCEDURE ListSelEmpDepartProcedure(IN _iduser int(11))
            BEGIN
                SELECT iddepart_employee, iddepart from depart_employees where iduser=_iduser;
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
        DB::unprepared('DROP PROCEDURE IF EXISTS ListSelEmpDepartProcedure');
    }
}
