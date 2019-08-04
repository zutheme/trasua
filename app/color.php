<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class color extends Model
{
    protected $primaryKey = 'idcolor';
    protected $fillable = ['value'];
}
