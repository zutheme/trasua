<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class ListStatusTypeProcedure extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        DB::unprepared('CREATE PROCEDURE ListStatusTypeProcedure(IN _idparent int)
        BEGIN
        IF _idparent > 0 THEN
        BEGIN
           SELECT * FROM status_types WHERE idparent = _idparent;
        END; 
        ELSE
        BEGIN
           SELECT * FROM status_types;    
        END;
        END IF;
        END');
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        DB::unprepared('DROP PROCEDURE IF EXISTS ListStatusTypeProcedure');
    }
}
