<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Permission extends Model
{
    protected $primaryKey = 'idperm';
    protected $fillable = ['name','description','created_at','updated_at'];
}
