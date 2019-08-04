<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Impposts extends Model
{
    protected $primaryKey = 'idimppost';
    protected $fillable = ['idpost','id_status_type','processing','iduser_imp','created_at','updated_at'];
}