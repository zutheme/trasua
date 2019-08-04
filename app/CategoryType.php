<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class CategoryType extends Model
{
    protected $primaryKey = 'idcattype';
    protected $fillable = ['catnametype','created_at','updated_at'];
}
