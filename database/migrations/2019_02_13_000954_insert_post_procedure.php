<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class InsertPostProcedure extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        DB::unprepared('
            CREATE PROCEDURE InsertPostProcedure(IN _title varchar(255), IN _body text, IN _slug varchar(255), IN _id_post_type int(11), IN _idcategory int(11), IN _id_status_type int(11), IN _processing DECIMAL(6,2), IN _iduser_imp int(11) )
            BEGIN
                INSERT INTO posts(title, body, slug, id_post_type, idcategory) VALUES ( _title, _body, _slug, _id_post_type, _idcategory);
                    SET @_idpost = LAST_INSERT_ID();
                    INSERT INTO impposts(idpost, id_status_type, processing, iduser_imp) VALUES ( @_idpost, _id_status_type, _processing, _iduser_imp);
                    select @_idpost as outidpost;
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
        DB::unprepared('DROP PROCEDURE IF EXISTS InsertPostProcedure');
    }
}
