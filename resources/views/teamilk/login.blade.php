@extends('teamilk.master')

@section('other_styles')
   {{-- <link href="{{ asset('dashboard/vendors/datatables.net-bs/css/dataTables.bootstrap.min.css') }}" rel="stylesheet"> --}}
@stop

@section('content')
<!-- BEGIN: LAYOUT/BREADCRUMBS/BREADCRUMBS-2 -->
<div class="c-layout-breadcrumbs-1 c-subtitle c-fonts-uppercase c-fonts-bold c-bordered c-bordered-both">
	<div class="container">
		<div class="c-page-title c-pull-left">
			<h3 class="c-font-uppercase c-font-sbold"></h3>
			<h4 class="">THÔNG TIN ĐĂNG KÝ</h4>
		</div>
		<ul class="c-page-breadcrumbs c-theme-nav c-pull-right c-fonts-regular">
															<li><a href="shop-customer-account.htm">Đăng nhập</a></li>
			<li>/</li>
															<li class="c-state_active">đăng ký</li>
									
		</ul>
	</div>
</div><!-- END: LAYOUT/BREADCRUMBS/BREADCRUMBS-2 -->
		<!-- BEGIN: PAGE CONTENT -->
		<!-- BEGIN: CONTENT/SHOPS/SHOP-LOGIN-REGISTER-1 -->
<div class="c-content-box c-size-md c-bg-white">
	<div class="container">
		<div class="c-shop-login-register-1">
			<div class="row">
				<div class="col-md-6">
					<div class="panel panel-default c-panel">
						<div class="panel-body c-panel-body">
							<form class="c-form-login" method="post" action="{{ url('postlogin') }}">
								{{ csrf_field() }}
								<div>
					                @if(isset($errors))
					                  <div class="alert alert-danger">
					                    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>     
									    <div class="error">Mật khẩu hoặc email không đúng</div>
					                  </div>
					                @endif
					              </div>
								<div class="form-group has-feedback">
									<input type="text" class="form-control c-square c-theme input-lg" placeholder="Username" name="email">
									<span class="glyphicon glyphicon-user form-control-feedback c-font-grey"></span>
								</div>
								<div class="form-group has-feedback">
									<input type="password" class="form-control c-square c-theme input-lg" placeholder="Password" name="password">
									<span class="glyphicon glyphicon-lock form-control-feedback c-font-grey"></span>
								</div>
								<div class="row c-margin-t-40">
									<div class="col-xs-8">
										<div class="c-checkbox">
											<input type="checkbox" id="checkbox1-77" class="c-check">
											<label for="checkbox1-77"> <span class="inc"></span>
												<span class="check"></span> <span class="box"></span> Ghi nhớ
											</label>
										</div>
									</div>
									<div class="col-xs-4">
										<button type="submit" class="pull-right btn btn-lg c-theme-btn c-btn-square c-btn-uppercase c-btn-bold">Đăng nhập</button>
									</div>
								</div>
							</form>
						</div>
					</div>
				</div>
				<div class="col-md-6">
					<div class="panel panel-default c-panel">
						<div class="panel-body c-panel-body">
							<div class="c-content-title-1">
								<h3 class="c-left"><i class="icon-user"></i> Chưa có tài khoản?</h3>
								<div class="c-line-left c-theme-bg"></div>
								<p>Hãy đăng ký và đặt hàng online cùng chúng tôi.</p>
								<div>
					                @if($errors->has('c_password'))
									    <div class="error">Mật khẩu không trùng khớp</div>
									@endif
					              </div>
							</div>
							<div class="c-margin-fix">
								<div class="c-checkbox c-toggle-hide" data-object-selector="c-form-register" data-animation-speed="600">
									<input type="checkbox" id="checkbox6-444" class="c-check">
									<label for="checkbox6-444"> <span class="inc"></span> <span class="check"></span>
										<span class="box"></span> Đăng ký ngay! </label>
								</div>
							</div>
							<form class="c-form-register c-margin-t-20" method="post" action="{{ url('register') }}">
								{{ csrf_field() }}
								 
								<div class="form-group">
									<div class="row">
										<div class="col-md-6">
											<label class="control-label">Họ</label>
											<input type="text" class="form-control c-square c-theme" name="lastname" placeholder="">
										</div>
										<div class="col-md-6">
											<label class="control-label">Tên</label>
											<input type="text" class="form-control c-square c-theme" name="firstname" placeholder="">
										</div>
									</div>
								</div>
								<div class="form-group">
									<label class="control-label">Địa chỉ</label>
									<input type="text" class="form-control c-square c-theme" name="address" placeholder="">
								</div>
								<div class="form-group">
									<label class="control-label">Quận</label>
									<select class="form-control c-square c-theme" name="sel_district">
										<option value="0">Chọn ... </option>
										<option value="Quận 1">Quận 1</option>
										<option value="Quận 2">Quận 2</option>
										<option value="Quận 3">Quận 3</option>
										<option value="Quận 4">Quận 4</option>
										<option value="Quận 5">Quận 5</option>
										<option value="Quận 6">Quận 6</option>
										<option value="Quận 7">Quận 7</option>
										<option value="Quận 8">Quận 8</option>
										<option value="Quận 9">Quận 9</option>
										<option value="Quận 10">Quận 10</option>
										<option value="Quận 11">Quận 11</option>
										<option value="Quận 12">Quận 12</option>
										<option value="Tân bình">Tân bình</option>
										<option value="Gò vấp">Gò vấp</option>
										<option value="Bình thạnh">Bình thạnh</option>
										<option value="Phú nhuận">Phú nhuận</option>
										<option value="Tân phú">Tân phú</option>					
										<option value="Bình tân">Bình tân</option>
										<option value="Thủ đức">Thủ đức</option>
									</select>
								</div>
								<div class="form-group">
									<label class="control-label">Tỉnh/Thành</label>
									<select class="form-control c-square c-theme" name="sel_city_provine">
										<option value="0">Chọn ...</option>
										<option value="TP Hồ Chí Minh">TP Hồ Chí Minh</option>
									</select>
								</div>
								
								<div class="row">
									<div class="form-group col-md-6">
										<label class="control-label">Email</label>
										<input type="email" class="form-control c-square c-theme" name="email" placeholder="">
									</div>
									<div class="col-md-6">
										<label class="control-label">Điện thoại</label>
										<input type="tel" class="form-control c-square c-theme" name="phone" placeholder="">
									</div>
								</div>
								<div class="form-group">
									<label class="control-label">Mật khẩu</label>
									<input type="password" class="form-control c-square c-theme" placeholder="" name="password">
								</div>
								<div class="form-group">
									<label class="control-label">Nhập lại mật khẩu</label>
									<input type="password" class="form-control c-square c-theme" placeholder="" name="c_password">
								</div>
								<div class="form-group c-margin-t-40">
									<button type="submit" class="btn btn-lg c-theme-btn c-btn-square c-btn-uppercase c-btn-bold">Đăng ký</button>
								</div>
							</form>
						</div>
					</div>
				</div>
			</div>
			{{-- <div class="row">
				<div class="col-md-12">
					<div class="list-unstyled c-bs-grid-small-space">
						<div class="row">
							<div class="col-md-4 col-sm-4 c-margin-t-10">
								<a class="btn btn-block btn-social c-btn-square c-btn-uppercase btn-md btn-twitter">
									<i class="fa fa-twitter"></i> Sign in with Twitter
								</a>
							</div>
							<div class="col-md-4 col-sm-4 c-margin-t-10">
								<a class="btn btn-block btn-social c-btn-square c-btn-uppercase btn-md btn-facebook">
									<i class="fa fa-facebook"></i> Sign in with Facebook
								</a>
							</div>
							<div class="col-md-4 col-sm-4 c-margin-t-10">
								<a class="btn btn-block btn-social c-btn-square c-btn-uppercase btn-md btn-google">
									<i class="fa fa-google-plus"></i> Sign in with Google
								</a>
							</div>
						</div>
					</div>
				</div>
			</div> --}}
		</div>
	</div>
</div>
<!-- END: CONTENT/SHOPS/SHOP-LOGIN-REGISTER-1 -->
@stop

@section('other_scripts')
    {{-- <script src="{{ asset('dashboard/vendors/datatables.net/js/jquery.dataTables.min.js') }}"></script> --}}
@stop