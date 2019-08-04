@extends('teamilk.master')
@section('other_styles')
   <link href="{{ asset('assets-tea/css/custom-product.css?v=0.8.7') }}" rel="stylesheet" type="text/css">
@stop
@section('content')
<?php 
	$idprofile = 0;$firstname = "";$lastname = "";$middlename = "";$idsex = 0;$birthday="00-00-0000";$address = "";$mobile = "";$email = "";$url_avatar = "";$idcountry = 0;$idprovince = 0;$idcitytown = 0;$iddistrict = 0;$idward = 0;
	if(isset($profile)) {
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
	        echo "<script>var birthday='".$birthday."';</script>";
	     }
	     $url_avartar_sex = ($sel_sex == 0) ? 'dashboard/production/images/avatar/avatar-female.jpg' : 'dashboard/production/images/avatar/avatar-male.jpg';
	     $url_avatar = (strlen($url_avatar) > 0) ? $url_avatar : $url_avartar_sex; 
	   } ?>
<!-- BEGIN: LAYOUT/BREADCRUMBS/BREADCRUMBS-2 -->
<div class="c-layout-breadcrumbs-1 c-subtitle c-fonts-uppercase c-fonts-bold c-bordered c-bordered-both">
	<div class="container">
		<div class="c-page-title c-pull-left">
			<h3 class="c-font-uppercase c-font-sbold">Thanh toán</h3>
			<h4 class="">Vui lòng cung cấp thông tin chi tiết để được phục vụ tốt hơn</h4>
			@if(isset($result))
				{{ $result }}
			@endif
		</div>
		<ul class="c-page-breadcrumbs c-theme-nav c-pull-right c-fonts-regular">
			<li><a href="shop-checkout.htm">Checkout</a></li>
			<li>/</li>
			<li class="c-state_active">Jango Components</li>							
		</ul>
	</div>
</div><!-- END: LAYOUT/BREADCRUMBS/BREADCRUMBS-2 -->
		<!-- BEGIN: PAGE CONTENT -->
		<div class="c-content-box c-size-lg">
			<div class="container">
				<form class="c-shop-form-1" method="post" action="{{ url('teamilk/submitcheckout') }}" enctype='application/json'>
					{{ csrf_field() }}
					<div class="row">
						<!-- BEGIN: ADDRESS FORM -->
						<div class="col-md-7 c-padding-20">
							<!-- BEGIN: BILLING ADDRESS -->
							<h3 class="c-font-bold c-font-uppercase c-font-24">Thông tin khách hàng</h3>
							<div class="row">
								<div class="col-md-12">
									@if(isset($error_reg))
										{{ $error_reg }}
									@endif
								</div>
							</div>
							<div class="row">
								<div class="col-md-12">
									<div class="row">
										<div class="form-group col-md-4">
											<label class="control-label">Họ</label>
											<input type="text" class="form-control c-square c-theme" name="lastname" placeholder="" value="{{ $lastname }}">
										</div>
										<div class="form-group col-md-4">
											<label class="control-label">Tên đệm</label>
											<input type="text" class="form-control c-square c-theme" name="middlename" placeholder="" value="{{ $middlename }}">
										</div>
										<div class="col-md-4">
											<label class="control-label">Tên</label>
											<input type="text" class="form-control c-square c-theme" name="firstname" placeholder="" required="true" value="{{ $firstname }}">
										</div>
									</div>
								</div>
							</div>					
							<div class="row">
								<div class="form-group col-md-12">
									<label class="control-label">Địa chỉ</label>
									<input type="text" class="form-control c-square c-theme" name="address" placeholder="" value="{{ $address }}">
								</div>
							</div>
							<div class="row">
								<div class="form-group col-md-12">
									<label class="control-label">Quận</label>
										<select class="form-control c-square c-theme" name="sel_district">
											<option value="0">Chọn ... </option>
											@if(isset($rs_district))
								                  	@foreach($rs_district as $row)
								                		<option value="{{ $row['iddistrict'] }}" {{ $row['iddistrict'] == $iddistrict ? 'selected="selected"' : '' }}>{{ $row['namedist'] }}</option>
													@endforeach
												@endif 
										</select>
								</div>
							</div>
							<div class="row">
								<div class="form-group col-md-12">
									<label class="control-label">Tỉnh/Thành</label>
									<select class="form-control c-square c-theme" name="sel_citytown">
										<option value="0">Chọn ... </option>
										@if(isset($rs_citytown))
							                  	@foreach($rs_citytown as $row)
							                		<option value="{{ $row['idcitytown'] }}" {{ $row['idcitytown'] == $idcitytown ? 'selected="selected"' : '' }}>{{ $row['namecitytown'] }}</option>
												@endforeach
											@endif 		
									</select>
								</div>
							</div>
							<div class="row">
								<div class="form-group col-md-12">
									<div class="row">
										<div class="form-group col-md-6">
											<label class="control-label">Địa chỉ Email</label>
											<input type="email" class="form-control c-square c-theme" name="email" placeholder="" value="{{ $email }}">
										</div>
										<div class="col-md-6">
											<label class="control-label">Điện thoại</label>
											<input type="tel" class="form-control c-square c-theme" name="phone" placeholder="" value="{{ $mobile }}">
										</div>
									</div>
								</div>
							</div>
							@if (!Auth::check())
								<div class="row c-margin-t-15">
									<div class="form-group col-md-12">
										<div class="c-checkbox c-toggle-hide" data-object-selector="c-account" data-animation-speed="600">
											<input type="checkbox" id="checkbox1-77" class="c-check" name="check_new_account">
											<label for="checkbox1-77">
												<span class="inc"></span>
												<span class="check"></span>
												<span class="box"></span>
												Tạo tài khoản mới?
											</label>
										</div>
										<p class="help-block">Nhập thông tin sau để tạo tài khoản. Vui lòng đăng nhập nếu đã có tài khoản.</p>
									</div>
								</div>
								<div class="row c-account">
									<div class="form-group col-md-12">
										<label class="control-label">Mật khẩu</label>
										<input type="password" class="form-control c-square c-theme" name="password" placeholder="">
									</div>
								</div>
								<div class="row c-account">
									<div class="form-group col-md-12">
										<label class="control-label">Nhập lại mật khẩu</label>
										<input type="password" class="form-control c-square c-theme" name="c_password" placeholder="">
									</div>
								</div>
							@endif
							<!-- BILLING ADDRESS -->
							<!-- SHIPPING ADDRESS -->
							<h3 class="c-font-bold c-font-uppercase c-font-24">Địa chỉ giao hàng</h3>
							<div class="row">
								<div class="form-group col-md-12">
									<div class="c-checkbox-inline">
										<div class="c-checkbox c-toggle-hide" data-object-selector="c-shipping-address" data-animation-speed="600">
											<input type="checkbox" id="checkbox6-444" class="c-check" name="check_other_address">
											<label for="checkbox6-444">
												<span class="inc"></span>
												<span class="check"></span>
												<span class="box"></span>
												Vận chuyển đến địa chỉ khác ?
											</label>
										</div>
									</div>
								</div>
							</div>
							<div class="c-shipping-address">
								<div class="row">
									<div class="col-md-12">
										<div class="row">
											<div class="form-group col-md-4">
												<label class="control-label">Họ</label>
												<input type="text" class="form-control c-square c-theme" name="reci_lastname" placeholder="">
											</div>
											<div class="form-group col-md-4">
												<label class="control-label">Tên đệm</label>
												<input type="text" class="form-control c-square c-theme" name="reci_middlename" placeholder="">
											</div>
											<div class="form-group col-md-4">
												<label class="control-label">Tên</label>
												<input type="text" class="form-control c-square c-theme" name="reci_firstname" placeholder="">
											</div>
										</div>
									</div>
								</div>						
								<div class="row">
									<div class="form-group col-md-12">
										<label class="control-label">Địa chỉ</label>
										<input type="text" class="form-control c-square c-theme" placeholder="" name="reci_address">
									</div>
								</div>
								<div class="row">
									<div class="form-group col-md-12">
										<label class="control-label">Quận</label>
										<select class="form-control c-square c-theme" name="sel_reci_district">
											<option value="0">Chọn ... </option>
											@if(isset($rs_district))
								                  	@foreach($rs_district as $row)
								                		<option value="{{ $row['iddistrict'] }}">{{ $row['namedist'] }}</option>
													@endforeach
												@endif 
										</select>
									</div>
								</div>
								<div class="row">
									<div class="form-group col-md-12">
										<label class="control-label">Tỉnh/Thành</label>
										<select class="form-control c-square c-theme" name="sel_reci_citytown">
											<option value="0">Chọn ... </option>
											@if(isset($rs_citytown))
								                  	@foreach($rs_citytown as $row)
								                		<option value="{{ $row['idcitytown'] }}">{{ $row['namecitytown'] }}</option>
													@endforeach
												@endif 		
										</select>
									</div>
								</div>					
								<div class="row">
									<div class="col-md-12">
										<div class="row">
											<div class="form-group col-md-6">
												<label class="control-label">Địa chỉ Email</label>
												<input type="email" class="form-control c-square c-theme" name="reci_email" placeholder="">
											</div>
											<div class="col-md-6">
												<label class="control-label">Điện thoại</label>
												<input type="tel" class="form-control c-square c-theme" name="reci_phone" placeholder="">
											</div>
										</div>
									</div>
								</div>
							</div>
							<!-- SHIPPING ADDRESS -->
							<div class="row">
								<div class="form-group col-md-12">
									<label class="control-label">Ghi chú</label>
									<textarea class="form-control c-square c-theme" rows="3" name="reci_note" placeholder=""></textarea>
								</div>
							</div>
						</div>
						<!-- END: ADDRESS FORM -->
						<!-- BEGIN: ORDER FORM -->
						<div class="col-md-5">
							<div class="c-content-bar-1 c-align-left c-bordered c-theme-border c-shadow">
							<h1 class="c-font-bold c-font-uppercase c-font-24">Đơn hàng</h1>
							<ul class="c-order list-unstyled list_order">
							</ul>
							<ul class="c-order list-unstyled">
								<li class="row">
									<div class="col-md-12">
										<div class="c-radio-list">
											<div class="c-radio">
												<input type="radio" id="radio1" class="c-radio" name="payment" checked="">
												<label for="radio1" class="c-font-bold c-font-20">
													<span class="inc"></span>
													<span class="check"></span>
													<span class="box"></span>
													Thanh toán khi nhận hàng
												</label>
												<p class="help-block">Miễn trả hàng khi đã xác nhận mua hàng, miễn phí vận chuyển trong vòng bán kích 50km.</p>
											</div>
											
										</div>
									</div>
								</li>
								<li class="row c-margin-b-15 c-margin-t-15">
									<div class="form-group col-md-12">
										<div class="c-checkbox">
											<input type="checkbox" id="checkbox1-11" class="c-check">
											<label for="checkbox1-11">
												<span class="inc"></span>
												<span class="check"></span>
												<span class="box"></span>
												Bạn đã đọc và chấp nhận điều kiện, chính sách của chúng tôi
											</label>
										</div>
									</div>
								</li>
								<li class="row">
									<div class="form-group col-md-12" role="group">
										<button type="submit" class="btn btn-lg c-theme-btn c-btn-square c-btn-uppercase c-btn-bold">Xác nhận</button>
										<button type="submit" class="btn btn-lg btn-default c-btn-square c-btn-uppercase c-btn-bold">Bỏ qua</button>
									</div>
								</li>
							</ul>
						</div>
						</div>
						<!-- END: ORDER FORM -->
					</div>
				</form>
			</div>
		</div>  
		<!-- END: PAGE CONTENT -->
<script type="text/javascript">
	var _url_show = '{{ action('teamilk\ProductController@show',0) }}';
	_url_show = _url_show.substring(0, _url_show.length-1);
	var url_home = '{{ url('/') }}';
	var _url_check_out = '{{ url('/teamilk/checkout') }}';
	var _url_complete = '{{ url('/complete') }}';
</script>
@stop
@section('other_scripts')
	<script src="{{ asset('assets-tea/js/checkout.js?v=0.3.5') }}" type="text/javascript"></script>
@stop