<?php
namespace App;
use Illuminate\Database\Eloquent\Model;

class Role extends Model
{
    protected $primaryKey = 'idrole';
    protected $fillable = ['name','description','created_at','updated_at'];
}
