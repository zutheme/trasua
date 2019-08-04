<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class PostType extends Model
{
    protected $primaryKey = 'idposttype';
    protected $fillable = ['nametype','idparent','created_at','updated_at'];
}
