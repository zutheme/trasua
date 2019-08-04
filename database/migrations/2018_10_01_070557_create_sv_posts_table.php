<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateSvPostsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('sv_posts', function (Blueprint $table) {
            $table->increments('id_svpost');
            $table->integer('idcategory')->nullable();
            $table->string('title')->nullable();
            $table->text('body')->nullable();
            $table->string('url')->nullable();
            $table->integer('id_post_type')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('sv_posts');
    }
}
