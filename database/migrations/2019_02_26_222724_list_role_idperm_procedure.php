<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class ListRoleIdpermProcedure extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        DB::unprepared('
            CREATE PROCEDURE ListRoleIdpermProcedure(IN id_perm int(11))
            BEGIN
                select r.idrole, r.name, p.idimp_perm, p.idrole as id_role from roles as r LEFT join (select * from imp_perms where idperm=id_perm) as p on r.idrole=p.idrole;
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
        DB::unprepared('DROP PROCEDURE IF EXISTS ListRoleIdpermProcedure');
    }
}
