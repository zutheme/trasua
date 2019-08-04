<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class ListgrantbyidProcedure extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        DB::unprepared('
            CREATE PROCEDURE ListgrantbyidProcedure(IN id_grant int(11))
            BEGIN
                SELECT r.idrole, r.name as namerole, g.to_iduser,(select name from users where id = g.to_iduser) as touser, g.by_iduser,(select name from users where id = g.by_iduser) as byuser FROM (select * from grants where idgrant = id_grant) as g LEFT join roles as r on g.idrole = r.idrole;
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
        DB::unprepared('DROP PROCEDURE IF EXISTS ListgrantbyidProcedure');
    }
}
