<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class SelCrossProductByIdProcedure extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        DB::unprepared('
            CREATE PROCEDURE SelCrossProductByIdProcedure(IN _idproduct INT(11))
            BEGIN
                 select pd.*,f.urlfile from (select pro.idproduct,(select idfile from producthasfile WHERE hastype="thumbnail" and idproduct = pro.idproduct ORDER BY idproducthasfile desc LIMIT 1) as idfile,pro.idsize,pro.idcolor,imp.price,imp.amount from (select p.* from (SELECT idproduct_cross FROM cross_product WHERE idproduct=_idproduct) as crp left join products as p on p.idproduct = crp.idproduct_cross) as pro join imp_products as imp on pro.idproduct = imp.idproduct) as pd join files f on pd.idfile = f.idfile;
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
        DB::unprepared('DROP PROCEDURE IF EXISTS SelCrossProductByIdProcedure');
    }
}
