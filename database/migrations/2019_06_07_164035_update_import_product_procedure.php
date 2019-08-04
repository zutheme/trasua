<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class UpdateImportProductProcedure extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        DB::unprepared('
            CREATE PROCEDURE UpdateImportProductProcedure(IN _idimp int(11), IN _idproduct int(11), IN _idcustomer int(11), IN _idemployee int(11), IN _amount float(8,2), IN _price float(8,2), IN _note text, IN _idstore int(11), IN _axis_x int(11), IN _axis_y int(11), IN _axis_z int(11), IN _size varchar(10), IN _ice_water float(8,2), IN _sugar float(8,2), IN _topping varchar(255), IN _id_status_type int(11))
            BEGIN
                update imp_products set idproduct = _idproduct, idcustomer=_idcustomer, idemployee = _idemployee, amount = _amount, price = _price, note = _note, idstore = _idstore, axis_x = _axis_x, axis_y = _axis_y, axis_z = _axis_z, size = _size, ice_water = _ice_water, sugar = _sugar, topping = _topping, id_status_type = _id_status_type where idimp = _idimp;
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
        DB::unprepared('DROP PROCEDURE IF EXISTS UpdateImportProductProcedure');
    }
}
