<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use Illuminate\Foundation\Auth\AuthenticatesUsers;
use Illuminate\Http\Request;
use App\Http\Requests;
use Validator;
use Auth;
use Illuminate\Support\MessageBag;
class LoginController extends Controller
{
    /*
    |--------------------------------------------------------------------------
    | Login Controller
    |--------------------------------------------------------------------------
    |
    | This controller handles authenticating users for the application and
    | redirecting them to your home screen. The controller uses a trait
    | to conveniently provide its functionality to your applications.
    */
    use AuthenticatesUsers;
    /**
     * Where to redirect users after login.
     *
     * @var string
     */
    protected $redirectTo = '/';
    /**
     * Create a new controller instance.
     *
     * @return void
     */
    public function __construct()
    {
        $this->middleware('guest')->except('logout');
    }
   
    public function logout(){
        Auth::logout();
        return redirect('/');
    }
    public function getLogin()
    {
        if (Auth::check()) {
            $user = Auth::user(); 
            return redirect()->route('teamilk.home')->with('success',$user->name);
        } else {
            return view('teamilk.login');
        }

    }
    public function postLogin(Request $request) {
      $rules = [
        'email' =>'required|email',
        'password' => 'required|min:8'
      ];
      $messages = [
        'email.required' => 'Email là trường bắt buộc',
        'email.email' => 'Email không đúng định dạng',
        'password.required' => 'Mật khẩu là trường bắt buộc',
        'password.min' => 'Mật khẩu phải chứa ít nhất 8 ký tự',
      ];
      $validator = Validator::make($request->all(), $rules, $messages);
      if ($validator->fails()) {
        //return redirect()->back()->withErrors($validator)->withInput();
         //$errors = $validator->errors();
        return redirect('login')->withErrors($validator)->withInput();
      } else {
        $email = $request->input('email');
        $password = $request->input('password');
        if( Auth::attempt(['email' => $email, 'password' =>$password])) {
           $user = Auth::user(); 
           $success['token'] =  $user->createToken('MyApp')->accessToken;
           //return redirect()->intended('dashboard');
           return redirect('/');
           //return redirect()->route('teamilk.index')->with('success',$user->name);
        } else {
          $errors = new MessageBag(['error' => 'Email hoặc mật khẩu không đúng']);
          //return redirect()->back()->withInput()->withErrors($errors);
          // 'custom' => [
          //     'email' => [
          //         'required' => 'We need to know your e-mail address!',
          //     ],
          // ],
          return redirect('login')->with(compact('errors'));
          //return redirect()->route('teamilk.login')->with($errors);
        }
      }
    } 
   //response ajax login
    public function postloginmodal() {
        $input = json_decode(file_get_contents('php://input'),true);  
        $email = $input['login_email'];
        $password = $input['login_password'];
        if( Auth::attempt(['email' => $email, 'password' =>$password])) {
           //$user = Auth::user(); 
           $success['token'] =  $user->createToken('MyApp')->accessToken;
           return redirect('/'); 
           //return redirect()->route('teamilk.home');
           //return response()->json(array('success' => true, 'email' => $email), 200);
        } else {
          $errors = new MessageBag(['error' => 'Email hoặc mật khẩu không đúng']);
          //return redirect()->back()->withInput()->withErrors($errors);
          return response()->json(array('success' => false, 'error' => $errors), 200);
        }
      }
      

}

