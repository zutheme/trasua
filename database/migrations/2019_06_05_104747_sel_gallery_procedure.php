<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class SelGalleryProcedure extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        DB::unprepared('
            CREATE PROCEDURE SelGalleryProcedure(IN _idproduct int(11),IN _hastype varchar(255))
            BEGIN
                select f.urlfile from (SELECT idfile from producthasfile  where idproduct = _idproduct and hastype = _hastype) as pf join files as f on pf.idfile = f.idfile;
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
        DB::unprepared('DROP PROCEDURE IF EXISTS SelGalleryProcedure');
    }
}
