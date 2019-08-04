<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class ListAllCatByType extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        DB::unprepared('CREATE PROCEDURE ListAllCatByTypeProcedure(IN _namecattype VARCHAR(255))
        BEGIN
        DECLARE _idcattype INT;
        SET _idcattype = (SELECT idcattype FROM category_types WHERE catnametype = _namecattype);
        IF _idcattype > 0 THEN
        BEGIN
           SELECT * FROM categories WHERE idcattype = _idcattype;
        END; 
        ELSE
        BEGIN
           SELECT * FROM categories;    
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
        DB::unprepared('DROP PROCEDURE IF EXISTS ListAllCatByTypeProcedure');
    }
}
