<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Grant extends Model
{
    protected $primaryKey = 'idgrant';
    protected $fillable = ['idrole','to_iduser','by_iduser','created_at','updated_at'];
}
