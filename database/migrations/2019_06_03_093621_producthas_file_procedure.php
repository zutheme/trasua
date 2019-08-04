<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class ProducthasFileProcedure extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        DB::unprepared('
            CREATE PROCEDURE ProducthasFileProcedure(IN _urlfile VARCHAR(255), IN _name_origin VARCHAR(255), IN _namefile VARCHAR(255), IN _typefile VARCHAR(255),IN _idproduct int(11),IN _hastype varchar(255))
            BEGIN
               DECLARE _idfile INT(11);
               INSERT INTO files(urlfile,name_origin,namefile, typefile) VALUES (_urlfile,_name_origin, _namefile, _typefile);
               set _idfile = LAST_INSERT_ID();
               INSERT INTO producthasfile(idproduct,hastype,idfile) VALUES (_idproduct,_hastype,_idfile);
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
        DB::unprepared('DROP PROCEDURE IF EXISTS ProducthasFileProcedure');
    }
}
