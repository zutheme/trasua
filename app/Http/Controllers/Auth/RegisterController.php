<?php

namespace App\Http\Controllers\Auth;

use App\User;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use Illuminate\Foundation\Auth\RegistersUsers;
use Illuminate\Foundation\Auth\AuthenticatesUsers;
use Illuminate\Http\Request;
use App\Http\Requests;
use Illuminate\Support\Facades\DB;
use App\profile;
use Auth;
use Illuminate\Support\MessageBag;
class RegisterController extends Controller
{
    /*
    |--------------------------------------------------------------------------
    | Register Controller
    |--------------------------------------------------------------------------
    |
    | This controller handles the registration of new users as well as their
    | validation and creation. By default this controller uses a trait to
    | provide this functionality without requiring any additional code.
    |
    */

    use RegistersUsers;

    /**
     * Where to redirect users after registration.
     *
     * @var string
     */
    protected $redirectTo = '/home';

    /**
     * Create a new controller instance.
     *
     * @return void
     */
    public function __construct()
    {
        $this->middleware('guest');
    }

    /**
     * Get a validator for an incoming registration request.
     *
     * @param  array  $data
     * @return \Illuminate\Contracts\Validation\Validator
     */
    protected function validator(array $data)
    {
        return Validator::make($data, [
            'name' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:users',
            'password' => 'required|string|min:6|confirmed',
        ]);
    }

    /**
     * Create a new user instance after a valid registration.
     *
     * @param  array  $data
     * @return \App\User
     */
    protected function create(array $data)
    {
        return User::create([
            'name' => $data['name'],
            'email' => $data['email'],
            'password' => Hash::make($data['password']),
        ]);
        //Mail::to($data['email'])->send(new WelcomeMail($user));
        return $user;
    }
    public function register(Request $request)
    {
        $validator = Validator::make($request->all(), [ 
            //'name' => 'required', 
            'email' => 'required|email', 
            'password' => 'required', 
            'c_password' => 'required|same:password', 
        ]);
        if ($validator->fails()) { 
            //$error_reg = $validator->errors();
            return redirect('login')->withErrors($validator)->withInput();           
        }
        
        try {
            //$input = $request->all(); 
            $password = $request->input('password');
            $input['name'] = $request->get('firstname');
            $input['email'] = $request->get('email');
            $input['password'] = bcrypt($password); 
            $user = User::create($input); 
            $success['token'] =  $user->createToken('MyApp')->accessToken; 
            $success['name'] =  $user->name;
            $iduser = $user->id;
        } catch (\Illuminate\Database\QueryException $ex) {
            $error_reg = new MessageBag(['error' => $ex->getMessage()]);
            return redirect('login')->with(compact('error_reg'));
        }
        $firstname = $request->get('firstname');
        $middlename = "";
        $lastname = $request->get('lastname');
        $address = $request->get('address');
        $mobile = $request->get('phone');
        $about = "";
        $facebook = "";
        $zalo = "";
        $url_avatar = "";
        DB::select('call CreateProfileProcedure(?,?,?,?,?,?,?,?,?,?)',array($iduser,$firstname,$middlename,$lastname,$address,$mobile,$about,$facebook,$zalo,$url_avatar));
        
        $email = $request->get('email');
        $password = $request->get('password');   
        if( Auth::attempt(['email' => $email, 'password' =>$password])) {
           $user = Auth::user(); 
           $success['token'] =  $user->createToken('MyApp')->accessToken;
           //return redirect()->intended('dashboard');
           return redirect('/');
           //return redirect()->route('teamilk.index')->with('success',$user->name);
        } else {
          $error_reg = new MessageBag(['error' => 'Email hoặc mật khẩu không đúng']);
          //return redirect()->back()->withInput()->withErrors($errors);
          return redirect('login')->with(compact('error_reg'));
          //return redirect()->route('teamilk.login')->with($errors);
        }
    }
}
