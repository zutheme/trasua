<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CrossProductHasFileProcedure extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        DB::unprepared('
            CREATE PROCEDURE CrossProductHasFileProcedure(IN _idproduct INT(11), IN _cross_idproduct INT(11), IN _idfile INT(11))
            BEGIN
                insert into cross_product(idproduct,crosstype,idproduct_cross) values(_idproduct,"crosssize",idproduct_cross);
                insert into producthasfile(idproduct,hastype,idfile,status_file) values(_cross_idproduct,"thumbnail",_idfile,1);
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
        DB::unprepared('DROP PROCEDURE IF EXISTS CrossProductHasFileProcedure');
    }
}
