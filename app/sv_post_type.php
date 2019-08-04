<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class sv_post_type extends Model
{
    protected $primaryKey = 'id_post_type';
    protected $fillable = ['name','created_at','updated_at'];
}
