@extends('teamilk.master')

@section('other_styles')
   {{-- <link href="{{ asset('dashboard/vendors/datatables.net-bs/css/dataTables.bootstrap.min.css') }}" rel="stylesheet"> --}}
   <!-- BEGIN: BASE PLUGINS  -->
			<link href="{{ asset('assets-tea/assets/plugins/cubeportfolio/css/cubeportfolio.min.css') }}" rel="stylesheet" type="text/css">
			<link href="{{ asset('assets-tea/assets/plugins/owl-carousel/assets/owl.carousel.css') }}" rel="stylesheet" type="text/css">
			<link href="{{ asset('assets-tea/assets/plugins/fancybox/jquery.fancybox.css') }}" rel="stylesheet" type="text/css">
			<link href="{{ asset('assets-tea/assets/plugins/slider-for-bootstrap/css/slider.css') }}" rel="stylesheet" type="text/css">
				<!-- END: BASE PLUGINS -->
			<link href="{{ asset('assets-tea/css/custom-product.css?v=0.8.6') }}" rel="stylesheet" type="text/css">
@stop

@section('content')
<!-- BEGIN: LAYOUT/BREADCRUMBS/BREADCRUMBS-2 -->
<div class="c-layout-breadcrumbs-1 c-subtitle c-fonts-uppercase c-fonts-bold c-bordered c-bordered-both">
	<div class="container">
		<div class="c-page-title c-pull-left">
			<h3 class="c-font-uppercase c-font-sbold">Giỏ hàng</h3>
			<h4 class="">Danh sách sản phẩm đã mua</h4>
			@if(isset($error))
				{{-- <h4>{{ $error }}</h4> --}}
			@endif
		</div>
		<ul class="c-page-breadcrumbs c-theme-nav c-pull-right c-fonts-regular">
			<li><a href="shop-product-details-2.htm">Product Details 2</a></li>
			<li>/</li>
			<li class="c-state_active">Jango Components</li>					
		</ul>
	</div>
</div>
<div class="c-content-box c-size-lg all-items">
	<div class="container">
		<div class="c-shop-cart-page-1">
		</div>
	</div>
</div>
 <script type="text/javascript">
	var _url_show = '{{ action('teamilk\ProductController@show',0) }}';
	_url_show = _url_show.substring(0, _url_show.length-1);
	var url_home = '{{ url('/') }}';
	var _url_check_out = '{{ url('/teamilk/checkout') }}';
</script>
<!-- END: PAGE CONTENT -->
<div class="modal-nocart-form">
  <div class="modal-nocart">
    <div class="modal-content-nocart">
      <span class="close">&times;</span>
      	<form class="frm-nocart">
	  		<div class="col-sm-12 text-center">
		  		<h3>Hiên tại, chưa có sản phẩm trong giỏ</h3>
		  	</div>
		  	<div class="col-sm-12 text-center">
		  		<a href="{{ url('/') }}" class="btn btn-default btn-cart-continue">Tiếp tục mua hàng&nbsp;&nbsp;<i class="fa fa-shopping-cart"></i></a>
		  	</div>
		  	<p><img class="loading" style="display:none;width:30px;" src="{{ asset('dashboard/production/images/loader.gif') }}"></p>	 
		</form>	  	
    </div>
  </div>
</div>  
@stop
@section('other_scripts')
    <!-- BEGIN: PAGE SCRIPTS -->
	<script src="{{ asset('assets-tea/assets/plugins/zoom-master/jquery.zoom.min.js') }}" type="text/javascript"></script>
	<!-- END: PAGE SCRIPTS -->
	<script src="{{ asset('assets-tea/js/shop_cart.js?v=1.0.0') }}" type="text/javascript"></script>
@stop