<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class UploadAvatarProcedure extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        DB::unprepared('
            CREATE PROCEDURE UploadAvatarProcedure(in _idprofile int, in _url_avatar varchar(255))
            BEGIN
                update `profile` set url_avatar = _url_avatar where idprofile=_idprofile;
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
        DB::unprepared('DROP PROCEDURE IF EXISTS UploadAvatarProcedure');
    }
}
