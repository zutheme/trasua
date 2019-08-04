<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateImppostsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('impposts', function (Blueprint $table) {
            $table->bigIncrements('idimppost');
            $table->bigInteger('idpost')->nullable();
            $table->integer('id_status_type')->nullable();
            $table->decimal('percent_process', 8, 2)->nullable();
            $table->integer('iduser_imp')->nullable();
            $table->integer('idemployee')->nullable();
            $table->string('address_reg')->nullable();
            $table->integer('parent_idpost_imp')->nullable();
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
        Schema::dropIfExists('impposts');
    }
}
