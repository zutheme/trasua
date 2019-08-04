<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CompleteListOrderProcedure extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        DB::unprepared('
            CREATE PROCEDURE CompleteListOrderProcedure(IN _ordernumber int(11))
            BEGIN
               select  ordpro.*,(select urlfile from files where idfile=ordpro.idfile) as urlfile from (select p.namepro,(select idfile from producthasfile where idproduct = p.idproduct and hastype="thumbnail" ORDER BY idproducthasfile desc limit 1) as idfile, ex.* from (select * from exp_products where ordernumber = _ordernumber) as ex join products as p on ex.idproduct = p.idproduct) as ordpro;  
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
        DB::unprepared('DROP PROCEDURE IF EXISTS CompleteListOrderProcedure');
    }
}
