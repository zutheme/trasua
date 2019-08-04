<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class ImportProductProcedure extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        DB::unprepared('
            CREATE PROCEDURE ImportProductProcedure (IN _idproduct int(11), IN _idcustomer int(11), IN _idemployee int(11), IN _amount float(8,2), IN _price float(8,2), IN _note text, IN _idstore int(11), IN _axis_x int(11), IN _axis_y int(11), IN _axis_z int(11), IN _size varchar(10), IN _ice_water float(8,2), IN _sugar float(8,2), IN _topping varchar(255), IN _id_status_type int(11))
            BEGIN
                INSERT INTO imp_products(idproduct, idcustomer, idemployee, amount, price, note, idstore, axis_x, axis_y, axis_z, size, ice_water, sugar, topping, status_type) VALUES ( _idproduct, _idcustomer, _idemployee, _amount, _price, _note, _idstore, _axis_x, _axis_y, _axis_z, _size, _ice_water, _sugar, _topping, _id_status_type);             
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
        DB::unprepared('DROP PROCEDURE IF EXISTS ImportProductProcedure');
    }
}
