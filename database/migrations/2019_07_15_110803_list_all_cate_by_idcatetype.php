<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class ListAllCateByIdcatetype extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        DB::unprepared("
            CREATE PROCEDURE ListAllCateByIdcatetype(IN _idcatetype int(11))
            BEGIN
               IF _idcatetype > 0 THEN
                    BEGIN
                       SELECT c.idcategory, c.shortname, c.namecat, _namecattype as catnametype, c.idparent, (select namecat from categories WHERE idcategory = c.idparent) as parent FROM categories as c WHERE idcattype = _idcatetype;
                    END; 
                ELSE
                    BEGIN
                       SELECT c.* FROM categories as c;    
                    END;
                END IF;  
            END"
        );
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        DB::unprepared('DROP PROCEDURE IF EXISTS ListAllCateByIdcatetype');
    }
}
