<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class PostHasFileProcedure extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        DB::unprepared('
            CREATE PROCEDURE PostHasFileProcedure(IN _idpost int(11),IN _idfile int(11))
            BEGIN
                INSERT INTO post_has_files(idpost,idfile) VALUES (_idpost,_idfile);
                SELECT LAST_INSERT_ID() as idposthasfile;
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
         DB::unprepared('DROP PROCEDURE IF EXISTS PostHasFileProcedure');
    }
}
