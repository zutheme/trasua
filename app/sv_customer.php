<?php
namespace App;
use Illuminate\Database\Eloquent\Model;
class sv_customer extends Model
{
    protected $primaryKey = 'idcustomer';
    protected $fillable = ['firstname','middlename','lastname','email','mobile','address','idcitytown','iddistrict','job','note','created_at','updated_at'];
} ?>
