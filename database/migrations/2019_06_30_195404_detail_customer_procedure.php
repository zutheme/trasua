<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class DetailCustomerProcedure extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        DB::unprepared('
            CREATE PROCEDURE DetailCustomerProcedure(IN _iduser int(11))
            BEGIN
               select cus.firstname,cus.middlename, cus.lastname,cus.mobile,cus.email, (CONCAT(address,", ",(select namedist from district where iddistrict = cus.iddistrict),", ",(select namecitytown from city_town where idcitytown = cus.idcitytown))) as address from sv_customers as cus where idcustomer = _iduser;  
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
        DB::unprepared('DROP PROCEDURE IF EXISTS DetailCustomerProcedure');
    }
}
