<!DOCTYPE HTML>
<html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <!-- Tell the browser to be responsive to screen width -->
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta name="description" content="">
        <meta name="author" content="">
        <meta name="csrf-token" content="{{ csrf_token() }}" />
        <!-- Favicon icon -->
        <link rel="icon" type="image/png" sizes="16x16" href="{{ asset('dashboard/production/images/favicon.png') }}">

        <title>Auto marketing</title>

        <!-- Bootstrap Core CSS -->
        <link href="{{ asset('dashboard/vendors/bootstrap/dist/css/bootstrap.min.css') }}" rel="stylesheet">
        <!-- Custom CSS -->
        <link href="{{ asset('dashboard/vendors/font-awesome/css/font-awesome.min.css') }}" rel="stylesheet">
        <link href="{{ asset('dashboard/vendors/nprogress/nprogress.css') }}" rel="stylesheet">
        <link href="{{ asset('dashboard/vendors/iCheck/skins/flat/green.css') }}" rel="stylesheet" />
        <link href="{{ asset('dashboard/vendors/bootstrap-progressbar/css/bootstrap-progressbar-3.3.4.min.css') }}" rel="stylesheet" />
        <link href="{{ asset('dashboard/vendors/jqvmap/dist/jqvmap.min.css') }}" rel="stylesheet">
        <link href="{{ asset('dashboard/vendors/bootstrap-daterangepicker/daterangepicker.css') }}" rel="stylesheet">
        <link href="{{ asset('dashboard/build/css/custom.min.css') }}" rel="stylesheet">
        <link href="{{ asset('dashboard/production/css/custom.css?v=0.1.2') }}" rel="stylesheet">
        <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
        <!-- WARNING: Respond.js doesn't work if you view the page via file:** -->
        <!--[if lt IE 9]>
        <script src="https:**oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
        <script src="https:**oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
        <![endif]-->
       <!-- Animate.css -->
        <link href="{{ asset('dashboard/vendors/animate.css/animate.min.css') }}" rel="stylesheet">

        @yield('other_styles')

    </head>

    <body class="login">
    <div>
      <a class="hiddenanchor" id="signup"></a>
      <a class="hiddenanchor" id="signin"></a>
      <div class="login_wrapper">
        <div class="animate form login_form">
          <section class="login_content">
            <a href="#"><img src="{{ asset('dashboard/production/images/logo-thienkhue.png') }}"></a>
            <form method="post" action="{{action('Admin\AduserController@login')}}">
              {{ csrf_field() }}
              <h1>Đăng nhập</h1>
              <div>
                <input type="email" name="email" class="form-control" placeholder="E-mail" required="" />
              </div>
              <div>
                <input type="password" name="password" class="form-control" placeholder="Mật khẩu" required="" />
              </div>
              <div>
                <input type="submit" class="btn btn-default submit" value="Xác nhận" />
                <a class="reset_pass" href="#">Quên mật khẩu?</a>
              </div>

              <div class="clearfix"></div>

              <div class="separator">
                {{-- <p class="change_link">New to site?
                  <a href="#signup" class="to_register"> Create Account </a>
                </p> --}}
                @if(count($errors) > 0)
                <div class="alert alert-danger">
                  <ul>
                    @foreach($errors->all() as $error)
                      <li>{{ $error }}</li>
                    @endforeach
                  </ul>
                </div>
                @endif
                <div class="clearfix"></div>
                <br />

                <div>
                  
                  <p>©2016 All Rights Reserved.</p>
                </div>
              </div>
            </form>
          </section>
        </div>

        <div id="register" class="animate form registration_form">
          <section class="login_content">
            <form>
              <h1>Create Account</h1>
              <div>
                <input type="text" class="form-control" placeholder="Username" required="" />
              </div>
              <div>
                <input type="email" class="form-control" placeholder="Email" required="" />
              </div>
              <div>
                <input type="password" class="form-control" placeholder="Password" required="" />
              </div>
              <div>
                <a class="btn btn-default submit" href="index.html">Submit</a>
              </div>

              <div class="clearfix"></div>

              <div class="separator">
                <p class="change_link">Already a member ?
                  <a href="#signin" class="to_register"> Log in </a>
                </p>

                <div class="clearfix"></div>
                <br />

                <div>
                  <h1><i class="fa fa-paw"></i> Gentelella Alela!</h1>
                  <p>©2016 All Rights Reserved. Gentelella Alela! is a Bootstrap 3 template. Privacy and Terms</p>
                </div>
              </div>
            </form>
          </section>
        </div>
      </div>
    </div>
  </body>

</html>