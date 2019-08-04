<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class ListPostTypeProcedure extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        DB::unprepared('CREATE PROCEDURE ListPostTypeProcedure(IN _idparent int)
        BEGIN
        IF idparent > 0 THEN
        SELECT id_status_type, name_status_type FROM ListStatusType WHERE idparent=_idparent;
         ELSE
        SELECT id_status_type, name_status_type FROM ListStatusType;
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
        DB::unprepared('DROP PROCEDURE IF EXISTS ListPostTypeProcedure);
    }
}
