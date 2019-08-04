<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class SelToppingProcedure extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
         DB::unprepared('
            CREATE PROCEDURE SelToppingProcedure(IN _topping varchar(255))
            BEGIN
                 declare _idcategory varchar(255);
                 set _idcategory = (select idcategory FROM categories WHERE shortname="topping" limit 1);
                 select pr.idproduct,pr.namepro,imp.price,imp.amount from (select p.* from  (select idproduct from catehasproduct where idcategory = _idcategory) as catep JOIN products as p on catep.idproduct = p.idproduct) as pr JOIN imp_products as imp on pr.idproduct = imp.idproduct;
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
        DB::unprepared('DROP PROCEDURE IF EXISTS SelToppingProcedure');
    }
}
