<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class UpdateImppostByIdProcedure extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        DB::unprepared('
            CREATE PROCEDURE UpdateImppostByIdProcedure(IN id_imp_post int(11),IN id_post int(11),IN id_category int(11),IN  id_posttype int(11),IN  id_statustype int(11),IN  id_user_imp int(11))
                if (id_imp_post > 0 )  then
                    update impposts set idpost=id_post,idcategory=id_category,id_post_type=id_posttype,id_status_type = id_statustype,iduser_imp = id_user_imp
                    where idimppost = id_imp_post;
                else
                    insert into impposts(idpost,idcategory,id_post_type,id_status_type,iduser_imp) values(id_post,id_category,id_posttype,id_statustype,id_user_imp);
                end if;
            BEGIN
                
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
         DB::unprepared('DROP PROCEDURE IF EXISTS UpdateImppostByIdProcedure');
    }
}
