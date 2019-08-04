<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class AddProductProcedure extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        DB::unprepared('
            CREATE PROCEDURE AddProductProcedure(IN _idproduct int(11),IN _namestore varchar(255))
            BEGIN
                declare _idstore int;
                set _idstore = (select idcategory from categories where shortname = _namestore);
                insert into exp_products(idproduct,iduser,amount,price,idstore,size,ice_water,sugar,topping) values(_idproduct,_iduser,_amount,_price,_idstore,_size,_ice_water,_sugar,_topping); 
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
        DB::unprepared('DROP PROCEDURE IF EXISTS AddProductProcedure');
    }
}
