<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class OrderProductProcedure extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        DB::unprepared('
            CREATE PROCEDURE OrderProductProcedure(IN _idproduct int(11), IN _idcustomer int(11), IN _iduser int(11), IN _amount double(20,0), IN _price double(20,0), IN _note text, IN _idstore int(11), IN _axis_x int(11), IN _axis_y int(11), IN _axis_z int(11), IN _id_status_type int(11))
            BEGIN
                 INSERT into exp_products(idproduct, idcustomer, iduser, amount, price, note, idstore, axis_x, axis_y, axis_z, id_status_type) VALUES(_idproduct, _idcustomer, _iduser, _amount, _price, _note, _idstore, _axis_x, _axis_y, _axis_z, _id_status_type);
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
        DB::unprepared('DROP PROCEDURE IF EXISTS OrderProductProcedure');
    }
}
