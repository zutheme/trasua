<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class menu extends Model
{
    protected $primaryKey = 'idmenu';
    protected $fillable = ['namemenu','created_at','updated_at'];
}
