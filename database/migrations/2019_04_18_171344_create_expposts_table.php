<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateExppostsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('expposts', function (Blueprint $table) {
            $table->bigIncrements('idexppost');
            $table->bigInteger('idpost')->nullable();
            $table->integer('id_status_type')->nullable();
            $table->integer('iduser_exp')->nullable();
            $table->integer('idemployee')->nullable();
            $table->string('address_reg')->nullable();
            $table->decimal('percent_process', 8, 2)->nullable();
            $table->integer('parent_idpost_exp')->nullable();
            $table->timestamp('created_at')->default(\DB::raw('CURRENT_TIMESTAMP'));
            $table->timestamp('updated_at')->default(\DB::raw('CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP'));
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('expposts');
    }
}
