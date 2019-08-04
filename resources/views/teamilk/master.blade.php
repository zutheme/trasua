<!DOCTYPE html>

<!--[if IE 9]> <html lang="en" class="ie9"> <![endif]-->

<!--[if !IE]><!-->

<html lang="en">

<!--<![endif]-->

<!-- BEGIN HEAD -->

<head>

  <meta charset="utf-8">

  <title>Dịch vụ thẩm mỹ viện thiên khuê</title>

  <meta http-equiv="X-UA-Compatible" content="IE=edge">

  <meta content="width=device-width, initial-scale=1.0" name="viewport">

  <meta http-equiv="Content-type" content="text/html; charset=utf-8">

  <meta content="" name="description">

  <meta content="" name="author">

  <meta name="csrf-token" content="{{ csrf_token() }}" />

    <!-- BEGIN GLOBAL MANDATORY STYLES -->

  <link href='http://fonts.googleapis.com/css?family=Roboto+Condensed:300italic,400italic,700italic,400,300,700&amp;subset=all' rel='stylesheet' type='text/css'>

  <link href="{{ asset('assets-tea/assets/plugins/socicon/socicon.css') }}" rel="stylesheet" type="text/css">

  <link href="{{ asset('assets-tea/assets/plugins/bootstrap-social/bootstrap-social.css') }}" rel="stylesheet" type="text/css">   

  <link href="{{ asset('assets-tea/assets/plugins/font-awesome/css/font-awesome.min.css') }}" rel="stylesheet" type="text/css">

  <link href="{{ asset('assets-tea/assets/plugins/simple-line-icons/simple-line-icons.min.css') }}" rel="stylesheet" type="text/css">

  <link href="{{ asset('assets-tea/assets/plugins/animate/animate.min.css') }}" rel="stylesheet" type="text/css">

  <link href="{{ asset('assets-tea/assets/plugins/bootstrap/css/bootstrap.min.css') }}" rel="stylesheet" type="text/css">

  <!-- END GLOBAL MANDATORY STYLES -->



      <!-- BEGIN: BASE PLUGINS  -->

      <link href="{{ asset('assets-tea/assets/plugins/revo-slider/css/settings.css') }}" rel="stylesheet" type="text/css">

      <link href="{{ asset('assets-tea/assets/plugins/revo-slider/css/layers.css') }}" rel="stylesheet" type="text/css">

      <link href="{{ asset('assets-tea/assets/plugins/revo-slider/css/navigation.css') }}" rel="stylesheet" type="text/css">

      <link href="{{ asset('assets-tea/assets/plugins/cubeportfolio/css/cubeportfolio.min.css') }}" rel="stylesheet" type="text/css">

      <link href="{{ asset('assets-tea/assets/plugins/owl-carousel/assets/owl.carousel.css') }}" rel="stylesheet" type="text/css">

      <link href="{{ asset('assets-tea/assets/plugins/fancybox/jquery.fancybox.css') }}" rel="stylesheet" type="text/css">

      <link href="{{ asset('assets-tea/assets/plugins/slider-for-bootstrap/css/slider.css') }}" rel="stylesheet" type="text/css">

        <!-- END: BASE PLUGINS -->

  

  

    <!-- BEGIN THEME STYLES -->

  <link href="{{ asset('assets-tea/assets/demos/default/css/plugins.css') }}" rel="stylesheet" type="text/css">

  <link href="{{ asset('assets-tea/assets/demos/default/css/components.css?v=0.0.4') }}" id="style_components" rel="stylesheet" type="text/css">

  <link href="{{ asset('assets-tea/assets/demos/default/css/themes/default.css') }}" rel="stylesheet" id="style_theme" type="text/css">

  <link href="{{ asset('assets-tea/css/main-style.css?v=0.1.2') }}" rel="stylesheet" type="text/css">

  <!-- END THEME STYLES -->

  <link rel="shortcut icon" href="{{ asset('assets-tea/images/favicon.png') }}">

 {{--  <link rel="shortcut icon" href="favicon.ico"> --}}

   @yield('other_styles')

</head>

{{-- <body class="c-layout-header-fixed c-layout-header-mobile-fixed c-layout-header-fullscreen"> --}}

<body class="c-layout-header-fixed c-layout-header-mobile-fixed c-layout-header-topbar c-layout-header-topbar-collapse">

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

  @include('teamilk.header')

  @include('teamilk.modal')

<!-- BEGIN: PAGE CONTAINER -->

<div class="c-layout-page">

<!-- BEGIN: PAGE CONTENT -->

{{-- @include('teamilk.home') --}}

 @yield('content')

<!-- END: PAGE CONTENT -->

</div>

<!-- END: PAGE CONTAINER -->

 @include('teamilk.footer')

  <!-- BEGIN: LAYOUT/FOOTERS/GO2TOP -->

<div class="c-layout-go2top">

  <i class="icon-arrow-up"></i>

</div>

<script type="text/javascript">

  var url_home = '{{ url('/') }}';

</script>

<!-- END: LAYOUT/FOOTERS/GO2TOP -->

  <!-- BEGIN: LAYOUT/BASE/BOTTOM -->

    <!-- BEGIN: CORE PLUGINS -->

  <!--[if lt IE 9]>

  <script src="../../assets/global/plugins/excanvas.min.js"></script> 

  <![endif]-->

  <script src="{{ asset('assets-tea/assets/plugins/jquery.min.js') }}" type="text/javascript"></script>

  <script src="{{ asset('assets-tea/assets/plugins/jquery-migrate.min.js') }}" type="text/javascript"></script>

  <script src="{{ asset('assets-tea/assets/plugins/bootstrap/js/bootstrap.min.js') }}" type="text/javascript"></script>

  <script src="{{ asset('assets-tea/assets/plugins/jquery.easing.min.js') }}" type="text/javascript"></script>

  <script src="{{ asset('assets-tea/assets/plugins/reveal-animate/wow.js') }}" type="text/javascript"></script>

  <script src="{{ asset('assets-tea/assets/demos/default/js/scripts/reveal-animate/reveal-animate.js') }}" type="text/javascript"></script>

  <!-- END: CORE PLUGINS -->

      <!-- BEGIN: LAYOUT PLUGINS -->

      <script src="{{ asset('assets-tea/assets/plugins/revo-slider/js/jquery.themepunch.tools.min.js') }}" type="text/javascript"></script>

      <script src="{{ asset('assets-tea/assets/plugins/revo-slider/js/jquery.themepunch.revolution.min.js') }}" type="text/javascript"></script>

      <script src="{{ asset('assets-tea/assets/plugins/revo-slider/js/extensions/revolution.extension.slideanims.min.js') }}" type="text/javascript"></script>

      <script src="{{ asset('assets-tea/assets/plugins/revo-slider/js/extensions/revolution.extension.layeranimation.min.js') }}" type="text/javascript"></script>

      <script src="{{ asset('assets-tea/assets/plugins/revo-slider/js/extensions/revolution.extension.navigation.min.js') }}" type="text/javascript"></script>

      <script src="{{ asset('assets-tea/assets/plugins/revo-slider/js/extensions/revolution.extension.video.min.js') }}" type="text/javascript"></script>

      <script src="{{ asset('assets-tea/assets/plugins/revo-slider/js/extensions/revolution.extension.parallax.min.js') }}" type="text/javascript"></script>

      <script src="{{ asset('assets-tea/assets/plugins/cubeportfolio/js/jquery.cubeportfolio.min.js') }}" type="text/javascript"></script>

      <script src="{{ asset('assets-tea/assets/plugins/owl-carousel/owl.carousel.min.js') }}" type="text/javascript"></script>

      <script src="{{ asset('assets-tea/assets/plugins/counterup/jquery.waypoints.min.js') }}" type="text/javascript"></script>

      <script src="{{ asset('assets-tea/assets/plugins/counterup/jquery.counterup.min.js') }}" type="text/javascript"></script>

      <script src="{{ asset('assets-tea/assets/plugins/fancybox/jquery.fancybox.pack.js') }}" type="text/javascript"></script>

      <script src="{{ asset('assets-tea/assets/plugins/smooth-scroll/jquery.smooth-scroll.js') }}" type="text/javascript"></script>

      <script src="{{ asset('assets-tea/assets/plugins/typed/typed.min.js') }}" type="text/javascript"></script>

      <script src="{{ asset('assets-tea/assets/plugins/slider-for-bootstrap/js/bootstrap-slider.js') }}" type="text/javascript"></script>

      <script src="{{ asset('assets-tea/assets/plugins/js-cookie/js.cookie.js') }}" type="text/javascript"></script>

        <!-- END: LAYOUT PLUGINS -->

  

      <!-- BEGIN: THEME SCRIPTS -->

      <script src="{{ asset('assets-tea/assets/base/js/components.js') }}" type="text/javascript"></script>

      <script src="{{ asset('assets-tea/assets/base/js/components-shop.js') }}" type="text/javascript"></script>

      <script src="{{ asset('assets-tea/assets/base/js/app.js') }}" type="text/javascript"></script>

      <script>

      $(document).ready(function() {    

        App.init();    

      });

      </script>

      <!-- END: THEME SCRIPTS -->



      <!-- BEGIN: PAGE SCRIPTS -->

        <script src="{{ asset('assets-tea/assets/plugins/isotope/isotope.pkgd.min.js') }}" type="text/javascript"></script>

        <script src="{{ asset('assets-tea/assets/plugins/isotope/imagesloaded.pkgd.min.js') }}" type="text/javascript"></script>

        <script src="{{ asset('assets-tea/assets/plugins/isotope/packery-mode.pkgd.min.js') }}" type="text/javascript"></script>

        <script src="{{ asset('assets-tea/assets/demos/default/js/scripts/pages/isotope-grid.js') }}" type="text/javascript"></script>

      <!-- END: PAGE SCRIPTS -->

    <!-- END: LAYOUT/BASE/BOTTOM -->

     <script src="{{ asset('assets-tea/js/custom.js?v=0.3.6') }}" type="text/javascript"></script>

     <script src="{{ asset('assets-tea/js/menu.js?v=0.0.3') }}" type="text/javascript"></script>
     <!-- Load Facebook SDK for JavaScript -->
        <div id="fb-root"></div>
        <script>
          window.fbAsyncInit = function() {
            FB.init({
              xfbml            : true,
              version          : 'v3.3'
            });
          };

          (function(d, s, id) {
          var js, fjs = d.getElementsByTagName(s)[0];
          if (d.getElementById(id)) return;
          js = d.createElement(s); js.id = id;
          js.src = 'https://connect.facebook.net/vi_VN/sdk/xfbml.customerchat.js';
          fjs.parentNode.insertBefore(js, fjs);
        }(document, 'script', 'facebook-jssdk'));</script>

        <!-- Your customer chat code -->
        {{-- <div class="fb-customerchat"
          attribution=setup_tool
          page_id="253439151750412"
          theme_color="#0082FF"
          logged_in_greeting="Chào anh/chị, Anh chị cần Thiên Khuê hỗ trợ như thế nào a!"
          logged_out_greeting="Chào anh/chị, Anh chị cần Thiên Khuê hỗ trợ như thế nào a!" >
        </div> --}}
    @yield('other_scripts')

    </body>

</html>

