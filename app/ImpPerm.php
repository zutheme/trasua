<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class ImpPerm extends Model
{
    protected $primaryKey = 'idimp_perm';
    protected $fillable = ['idperm','idrole','iduserimp','created_at','updated_at'];
}
