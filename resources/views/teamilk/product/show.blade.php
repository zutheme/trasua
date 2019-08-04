@extends('teamilk.master')

@section('other_styles')
   {{-- <link href="{{ asset('dashboard/vendors/datatables.net-bs/css/dataTables.bootstrap.min.css') }}" rel="stylesheet"> --}}
   <!-- BEGIN: BASE PLUGINS  -->
			<link href="{{ asset('assets-tea/assets/plugins/cubeportfolio/css/cubeportfolio.min.css') }}" rel="stylesheet" type="text/css">
			<link href="{{ asset('assets-tea/assets/plugins/owl-carousel/assets/owl.carousel.css') }}" rel="stylesheet" type="text/css">
			<link href="{{ asset('assets-tea/assets/plugins/fancybox/jquery.fancybox.css') }}" rel="stylesheet" type="text/css">
			<link href="{{ asset('assets-tea/assets/plugins/slider-for-bootstrap/css/slider.css') }}" rel="stylesheet" type="text/css">
				<!-- END: BASE PLUGINS -->
			<link href="{{ asset('assets-tea/css/custom-product.css?v=0.6.5') }}" rel="stylesheet" type="text/css">
@stop

@section('content')

<!-- BEGIN: LAYOUT/BREADCRUMBS/BREADCRUMBS-2 -->
<div class="c-layout-breadcrumbs-1 c-subtitle c-fonts-uppercase c-fonts-bold c-bordered c-bordered-both">
	<div class="container">
		<div class="c-page-title c-pull-left">
			<h3 class="c-font-uppercase c-font-sbold">{{ $product[0]['namepro'] }}</h3>
			<h4 class="">Page Sub Title Goes Here</h4>
		</div>
		<ul class="c-page-breadcrumbs c-theme-nav c-pull-right c-fonts-regular">
			<li><a href="shop-product-details-2.htm">Product Details 2</a></li>
			<li>/</li>
			<li class="c-state_active">Jango Components</li>
									
		</ul>
	</div>
</div><!-- END: LAYOUT/BREADCRUMBS/BREADCRUMBS-2 -->
		<!-- BEGIN: PAGE CONTENT -->
		<!-- BEGIN: CONTENT/SHOPS/SHOP-PRODUCT-DETAILS-2 -->
<div class="c-content-box c-size-lg c-overflow-hide c-bg-white">
	<div class="container">
		<div class="c-shop-product-details-2">
			<div class="row">
				<div class="col-md-6">
					<div class="c-product-gallery">
						<div class="c-product-gallery-content">
							@if(isset($product[0]['url_thumbnail']))
								<div class="c-zoom">
									<img src="{{ asset($product[0]['url_thumbnail']) }}">
								</div>
							@endif
							@if(isset($gallery))
								@foreach($gallery as $row)
									<div class="c-zoom">
										<img src="{{ asset($row['urlfile']) }}">
									</div>
								@endforeach
							@endif
						</div>
						<div class="row c-product-gallery-thumbnail">
							@if(isset($product[0]['url_thumbnail']))
								<div class="col-xs-3 c-product-thumb">
									<img src="{{ asset($product[0]['url_thumbnail']) }}">
								</div>
							@endif
							@if(isset($gallery))
								@foreach($gallery as $row)
									<div class="col-xs-3 c-product-thumb">
										<img src="{{ asset($row['urlfile']) }}">
									</div>
								@endforeach
							@endif
						</div>
					</div>
				</div>
				<div class="col-md-6">
					<div class="c-product-meta">
						<div class="c-content-title-1">
							<h3 class="c-font-uppercase c-font-bold">{{ $product[0]['namepro'] }}</h3>
							<div class="c-line-left"></div>
						</div>
						<div class="c-product-badge">
							<div class="c-product-sale">Sale</div>
							<div class="c-product-new">New</div>
						</div>
						<div class="c-product-review">
							<div class="c-product-rating">
								<i class="fa fa-star c-font-red"></i>
								<i class="fa fa-star c-font-red"></i>
								<i class="fa fa-star c-font-red"></i>
								<i class="fa fa-star c-font-red"></i>
								<i class="fa fa-star-half-o c-font-red"></i>
							</div>
							<div class="c-product-write-review">
								<a class="c-font-red" href="#">Đánh giá</a>
							</div>
						</div>
						<div class="c-product-price"><span class="currency">{{ $product[0]['price'] }}</span><span class="vnd"></span></div>
						<div class="plus-topping"><ul class="plus"></ul></div>
						<div class="c-product-short-desc">
							{{ $product[0]['short_desc'] }}
						</div>
						<div class="row c-product-variant">
							<div class="col-sm-12 col-xs-12" style="display: none">
								<p class="c-product-meta-label c-product-margin-1 c-font-uppercase c-font-bold">Size:</p>
								<div class="c-product-size">
									<div class="item">
										<input class="name-product" type="hidden" name="name_product" value="{{ $product[0]['namepro'] }}">
										<input class="cross-thumb" type="hidden" name="cross_thumb" value="{{ asset($product[0]['url_thumbnail']) }}">
										<input class="cross_idproduct" type="hidden" name="cross_idproduct" value="{{ $product[0]['idproduct'] }}" >
										<input class="cross_price" type="hidden" name="cross_price" value="{{ $product[0]['price'] }}" >
										<input class="radio_size" type="radio" name="radio_size" value="{{ $product[0]['idsize'] }}" checked="checked">
										<label class="lb_radio" for="sizeM">{{ $product[0]['_size'] }}</label>
									</div>
									 @foreach($sel_cross_by_idproduct as $row)
										<div class="item">
											<input class="name-product" type="hidden" name="name_product" value="{{ $row['namepro'] }}">
											<input class="cross-thumb" type="hidden" name="cross_thumb" value="{{ asset($row['urlfile']) }}">
											<input class="cross_idproduct" type="hidden" name="cross_idproduct" value="{{ $row['idproduct'] }}">
											<input class="cross_price" type="hidden" name="cross_price" value="{{ $row['price'] }}" >
											<input class="radio_size" type="radio" name="radio_size" value="{{ $row['idsize'] }}" >
											<label class="lb_radio" for="sizeL">{{ $row['size'] }}</label>
										</div>
									@endforeach
								</div>
							</div>
							<div class="col-sm-12 col-xs-12 c-margin-t-20">
								<div class="c-product-topping"> 
									{{-- <p class="c-product-meta-label c-font-uppercase c-font-bold">Món thêm:</p> --}}
									<div class="dropdown">
									    <button class="btn btn-primary btn-lg dropdown-toggle drop-topping" type="button" data-toggle="dropdown">Sản phẩm phụ
									    <span class="caret"></span></button>
									    <ul class="dropdown-menu">
									    	@foreach($sel_topping as $item)
									    		<li><input class="parent-idproduct" type="hidden" name="parent-idproduct" value="0">
									    			<input class="namepro_topping" type="hidden" name="namepro_topping" value="{{ $item['namepro'] }}">
									    			@if(isset($item['url_thumbnail']))
									    				<input class="topping_thumb" type="hidden" name="topping_thumb" value="{{ asset($item['url_thumbnail']) }}">
									    			@else
									    				<input class="topping_thumb" type="hidden" name="topping_thumb" value="{{ asset('assets-tea/images/no_photo.jpg') }}">
									    			@endif
									    			<input class="topping_price" type="hidden" name="topping_price" value="{{ $item['price'] }}">
									    			<input class="list-topping" type="checkbox" name="list_topping" value="{{ $item['idproduct'] }}">&nbsp;&nbsp;<label>{{ $item['namepro'] }}</label></li>
									    	@endforeach
									    </ul>
									 </div>
								</div>
							</div>
						</div>
						<div class="c-product-add-cart c-margin-t-20">
							<div class="row">
								<div class="col-sm-4 col-xs-12">
									<div class="c-input-group c-spinner">
										<p class="c-product-meta-label c-product-margin-2 c-font-uppercase c-font-bold">Số lượng:</p>
									    <input type="text" class="form-control c-item-1 amount" value="1">
									    <div class="c-input-group-btn-vertical">
									    	<button class="btn btn-default btn-up" type="button"><i class="fa fa-caret-up"></i></button>
									    	<button class="btn btn-default btn-down" type="button"><i class="fa fa-caret-down"></i></button>
									    </div>
									</div>
								</div>
								<div class="col-sm-12 col-xs-12 c-margin-t-20">
									<button class="btn c-btn btn-lg c-font-bold c-font-white c-theme-btn c-btn-square c-font-uppercase btn-add-cart">Thêm vào giỏ</button>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div><!-- END: CONTENT/SHOPS/SHOP-PRODUCT-DETAILS-2 -->

<!-- BEGIN: CONTENT/SHOPS/SHOP-PRODUCT-TAB-1 -->
<div class="c-content-box c-size-md c-no-padding">
	<div class="c-shop-product-tab-1" role="tabpanel">
		<div class="container">
			<ul class="nav nav-justified" role="tablist">
				<li role="presentation" class="active">
					<a class="c-font-uppercase c-font-bold" href="#tab-1" role="tab" data-toggle="tab">Mô tả</a>
				</li>
				<li role="presentation">
					<a class="c-font-uppercase c-font-bold" href="#tab-3" role="tab" data-toggle="tab">Đánh giá</a>
				</li>
			</ul>
		</div>
		<div class="tab-content">
			<div role="tabpanel" class="tab-pane fade in active" id="tab-1"> 
				<div class="c-product-desc c-center">
					<div class="container">
						{!! $product[0]['description'] !!}
					</div>
				</div>
			</div>
			<div role="tabpanel" class="tab-pane fade" id="tab-3">
				<div class="container">
					<h3 class="c-font-uppercase c-font-bold c-font-22 c-center c-margin-b-40 c-margin-t-40">Reviews for Warm Winter Jacket</h3>
					<div class="row">
						<div class="col-xs-6">
							<div class="c-user-avatar">
								<img src="{{ asset('assets-tea/assets/base/img/content/avatars/team1.jpg') }}">
							</div>
							<div class="c-product-review-name">
								<h3 class="c-font-bold c-font-24 c-margin-b-5">Steve</h3>
								<p class="c-date c-theme-font c-font-14">July 4, 2015</p>
							</div>
						</div>
						<div class="col-xs-6">
							<div class="c-product-rating c-right">
								<i class="fa fa-star c-font-red"></i>
								<i class="fa fa-star c-font-red"></i>
								<i class="fa fa-star c-font-red"></i>
								<i class="fa fa-star c-font-red"></i>
								<i class="fa fa-star-half-o c-font-red"></i>
							</div>
						</div>
					</div>
					<div class="c-product-review-content">
						<p>
							Lorem ipsum dolor sit amet, consectetuer
							adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore
							magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud
						</p>
					</div>
					<div class="row c-margin-t-40">
						<div class="col-xs-6">
							<div class="c-user-avatar">
								<img src="{{ asset('assets-tea/assets/base/img/content/avatars/team12.jpg') }}">
							</div>
							<div class="c-product-review-name">
								<h3 class="c-font-bold c-font-24 c-margin-b-5">John</h3>
								<p class="c-date c-theme-font c-font-14">July 4, 2015</p>
							</div>
						</div>
						<div class="col-xs-6">
							<div class="c-product-rating c-right">
								<i class="fa fa-star c-font-red"></i>
								<i class="fa fa-star c-font-red"></i>
								<i class="fa fa-star c-font-red"></i>
								<i class="fa fa-star c-font-red"></i>
								<i class="fa fa-star-half-o c-font-red"></i>
							</div>
						</div>
					</div>
					<div class="c-product-review-content">
						<p>
							Lorem ipsum dolor sit amet, consectetuer
							adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore
							magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud
						</p>
					</div>
					<div class="row c-margin-t-40">
						<div class="col-xs-6">
							<div class="c-user-avatar">
								<img src="{{ asset('assets-tea/assets/base/img/content/avatars/team8.jpg') }}">
							</div>
							<div class="c-product-review-name">
								<h3 class="c-font-bold c-font-24 c-margin-b-5">Alice</h3>
								<p class="c-date c-theme-font c-font-14">July 4, 2015</p>
							</div>
						</div>
						<div class="col-xs-6">
							<div class="c-product-rating c-right">
								<i class="fa fa-star c-font-red"></i>
								<i class="fa fa-star c-font-red"></i>
								<i class="fa fa-star c-font-red"></i>
								<i class="fa fa-star c-font-red"></i>
								<i class="fa fa-star-half-o c-font-red"></i>
							</div>
						</div>
					</div>
					<div class="c-product-review-content">
						<p>
							Lorem ipsum dolor sit amet, consectetuer
							adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore
							magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud
						</p>
					</div>
					<div class="row c-product-review-input">
						<h3 class="c-font-bold c-font-uppercase">Submit your Review</h3>
						<p class="c-review-rating-input">Rating:
							<i class="fa fa-star-o"></i>
							<i class="fa fa-star-o"></i>
							<i class="fa fa-star-o"></i>
							<i class="fa fa-star-o"></i>
							<i class="fa fa-star-o"></i>
						</p>
						<textarea></textarea>
						<button class="btn c-btn c-btn-square c-theme-btn c-font-bold c-font-uppercase c-font-white">Submit Review</button>
					</div>
				</div>
			</div>
		</div>
	</div>
</div><!-- END: CONTENT/SHOPS/SHOP-PRODUCT-TAB-1 -->

<!-- BEGIN: CONTENT/SHOPS/SHOP-2-2 -->
<div class="c-content-box c-size-md c-overflow-hide c-bs-grid-small-space">
	<div class="container">
		<div class="c-content-title-4">
			<h3 class="c-font-uppercase c-center c-font-bold c-line-strike"><span class="c-bg-white">Sản phẩm yêu thích</span></h3>
		</div>
		<div class="row">
			<div data-slider="owl">
				<div class="owl-carousel owl-theme c-theme owl-small-space c-owl-nav-center" data-rtl="false" data-items="4" data-slide-speed="8000">
					@if(isset($relation))
						@foreach($relation as $row)
							<div class="item">
								<div class="c-content-product-2 c-bg-white c-border">
									<div class="c-content-overlay">
										@if($row['price_sale_origin'])<div class="c-label c-bg-red c-font-uppercase c-font-white c-font-13 c-font-bold">Khuyến mãi</div>@endif		
										<div class="c-overlay-wrapper">
											<div class="c-overlay-content">
												<a href="{{ action('teamilk\ProductController@show',$row['idproduct']) }}" class="btn btn-md c-btn-grey-1 c-btn-uppercase c-btn-bold c-btn-border-1x c-btn-square">Khám phá</a>
											</div>
										</div>
										<div class="c-bg-img-center-contain c-overlay-object" data-height="height" style="height: 270px; background-image: url({{ asset($row['urlfile']) }}"></div>
									</div>
									<div class="c-info">
										<p class="c-title c-font-18 c-font-slim">{{ $row['namepro'] }}</p>
										<p class="c-price c-font-16 c-font-slim"><span class="currency">{{ $row['price']}}</span><span class="vnd"></span> &nbsp;
											<span class="c-font-16 c-font-line-through c-font-red">@if($row['price_sale_origin'])<span class="currency">{{ $row['price_sale_origin'] }}</span><span class="vnd"></span>@endif</span>
										</p>
									</div>
									<div class="btn-group btn-group-justified" role="group">
										<div class="btn-group c-border-top" role="group">
											<a href="javascript:void(0)" class="btn btn-lg c-btn-white c-btn-uppercase c-btn-square c-font-grey-3 c-font-white-hover c-bg-red-2-hover c-btn-product">Thích</a>
										</div>
										<div class="btn-group c-border-left c-border-top" role="group">
											<a href="{{ action('teamilk\ProductController@show',$row['idproduct']) }}" class="btn btn-lg c-btn-white c-btn-uppercase c-btn-square c-font-grey-3 c-font-white-hover c-bg-red-2-hover c-btn-product">Mua</a>
										</div>
									</div>
								</div>
							</div>
						@endforeach
					@endif
				</div>
			</div>
		</div>
	</div>
</div><!-- END: CONTENT/SHOPS/SHOP-2-2 -->
<div class="modal-cart-form">
  <div class="modal-cart">
    <!-- Modal content -->
    <div class="modal-content-cart">
      <span class="close">&times;</span>
      	<form class="frm-cart">
      		<div class="col-sm-12">
		  		<h3>Sản phẩm đã thêm vào giỏ hàng</h3>
		  	</div>
		  	<div class="col-sm-6 text-center">
		  		<a href="{{ url('/') }}" class="btn btn-default btn-cart-continue">Tiếp tục mua hàng</a>
		  	</div>
		  	<div class="col-sm-6 text-center">
		  		<a href="{{ url('/teamilk/shopcart') }}" class="btn btn-default btn-view-cart">Xem giỏ hàng</a>
		  	</div>
		  	<p><img class="loading" style="display:none;width:30px;" src="{{ asset('dashboard/production/images/loader.gif') }}"></p>	 
		</form>	  	
    </div>
  </div>
</div>  
<!-- END: PAGE CONTENT -->
@stop

@section('other_scripts')
    <!-- BEGIN: PAGE SCRIPTS -->
	<script src="{{ asset('assets-tea/assets/plugins/zoom-master/jquery.zoom.min.js') }}" type="text/javascript"></script>
	<!-- END: PAGE SCRIPTS -->
	<script src="{{ asset('assets-tea/js/custom-product.js?v=1.0.0') }}" type="text/javascript"></script>
@stop