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
         <!-- Bootstrap -->
        <link href="{{ asset('dashboard/vendors/bootstrap/dist/css/bootstrap.min.css') }}" rel="stylesheet">
        <!-- Font Awesome -->
        <link href="{{ asset('dashboard/vendors/font-awesome/css/font-awesome.min.css') }}" rel="stylesheet">
        <!-- NProgress -->
        <link href="{{ asset('dashboard/vendors/nprogress/nprogress.css') }}" rel="stylesheet">
        <!-- iCheck -->
        <link href="{{ asset('dashboard/vendors/iCheck/skins/flat/green.css') }}" rel="stylesheet">
        <link href="{{ asset('dashboard/production/css/custom-home.css?v=0.0.3') }}" rel="stylesheet">
        @yield('other_styles')
    </head>

    <body class="nav-md">  

    <div class="container body">

      <div class="main_container">

        <div class="col-md-3 left_col">

          <div class="left_col scroll-view">

            <div class="navbar nav_title" style="border: 0;">

              <a href="{{ url('/admin')}}" class="site_title"><i class="fa fa-paw"></i> <span>MGK GROUP</span></a>

            </div>

            <div class="clearfix"></div>
            <?php if(isset($profile)) {
              $sel_sex = 0;
              $url_avatar = "";
              foreach($profile as $row) {
                  $idprofile = $row["idprofile"];
                  $firstname = $row["firstname"];
                  $lastname = $row['lastname'];
                  $middlename = $row['middlename'];
                  $idsex = $row['idsex'];
                  $birthday = $row['birthday'];
                  $address = $row['address'];
                  $mobile = $row['mobile'];
                  $email = $row['email'];
                  $url_avatar = $row['url_avatar'];
                  $idcountry = $row['idcountry'];
                  $idprovince = $row['idprovince'];
                  $idcitytown = $row['idcitytown'];
                  $iddistrict = $row['iddistrict'];
                  $idward = $row['idward'];
               }
               $url_avartar_sex = ($sel_sex == 0) ? 'dashboard/production/images/avatar/avatar-female.jpg' : 'dashboard/production/images/avatar/avatar-male.jpg';
               $url_avatar = (strlen($url_avatar) > 0) ? $url_avatar : $url_avartar_sex; 
             } ?>

            <!-- menu profile quick info -->
            <div class="profile clearfix">
              <div class="profile_pic">
                <a href="{{ url('/admin/profile/')}}/{{ Auth::id() }}"><img src="{{ asset($url_avatar) }}" alt="..." class="img-circle profile_img"></a>
              </div>
              <div class="profile_info">
                <span>Welcome,</span>
                 @if (Auth::check())
                    <h2><a href="{{ url('/admin/profile/')}}/{{ Auth::id() }}">{{ Auth::user()->name }}</a></h2> 
                @endif
              </div>
            </div>
            <!-- /menu profile quick info -->
            <br />

            <!-- sidebar menu -->

            @include('admin.sidebar');

            <!-- /sidebar menu -->
            <!-- /menu footer buttons -->

            <div class="sidebar-footer hidden-small">

              <a data-toggle="tooltip" data-placement="top" title="Settings">

                <span class="glyphicon glyphicon-cog" aria-hidden="true"></span>

              </a>

              <a data-toggle="tooltip" data-placement="top" title="FullScreen">

                <span class="glyphicon glyphicon-fullscreen" aria-hidden="true"></span>

              </a>

              <a data-toggle="tooltip" data-placement="top" title="Lock">

                <span class="glyphicon glyphicon-eye-close" aria-hidden="true"></span>

              </a>

              <a data-toggle="tooltip" data-placement="top" title="Logout" href="login.html">

                <span class="glyphicon glyphicon-off" aria-hidden="true"></span>

              </a>

            </div>

            <!-- /menu footer buttons -->

          </div>

        </div>



        <!-- top navigation -->

        @include('admin.topnav');
        <!-- /top navigation -->
         <!-- page content -->
        <div class="right_col" role="main"> 
             @yield('content')
       </div>
        <!-- /page content -->
        <!-- footer content -->
        <footer>
          <div class="pull-right">
            All rights reserved by<a href="https://zutheme.com">hatazu</a>
          </div>
          <div class="clearfix"></div>
        </footer>
        <!-- /footer content -->
      </div>
    </div>
    <script type="text/javascript">
      var url_home = '{{ url('/') }}';
    </script>
    <!-- jQuery -->
    <script src="{{ asset('dashboard/vendors/jquery/dist/jquery.min.js') }}"></script>
    <!-- Bootstrap -->
    <script src="{{ asset('dashboard/vendors/bootstrap/dist/js/bootstrap.min.js') }}"></script>
    <!-- FastClick -->
    <script src="{{ asset('dashboard/vendors/fastclick/lib/fastclick.js') }}"></script>
    <!-- NProgress -->
    <script src="{{ asset('dashboard/vendors/nprogress/nprogress.js') }}"></script>
    <!-- iCheck -->
    <script src="{{ asset('dashboard/vendors/iCheck/icheck.min.js') }}"></script>
    <script src="{{ asset('dashboard/production/js/currency.js?v=0.0.2') }}"></script>
        @yield('other_scripts')
    </body>
</html>