@extends('teamilk.master')
@section('other_styles')
	<link href="{{ asset('dashboard/vendors/bootstrap-daterangepicker/daterangepicker.css') }}" rel="stylesheet">
    <!-- bootstrap-datetimepicker -->
    <link href="{{ asset('dashboard/vendors/bootstrap-datetimepicker/build/css/bootstrap-datetimepicker.css') }}" rel="stylesheet">
    <link href="{{ asset('dashboard/vendors/cropper/dist/cropper.min.css') }}" rel="stylesheet">
    <link href="{{ asset('assets-tea/css/main-style.css?v=0.0.2') }}" rel="stylesheet" type="text/css">
@stop
@section('content')
	<!-- BEGIN: LAYOUT/BREADCRUMBS/BREADCRUMBS-2 -->
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
	      echo "<script>var birthday='".$birthday."';</script>";
	     $url_avartar_sex = ($sel_sex == 0) ? 'dashboard/production/images/avatar/avatar-female.jpg' : 'dashboard/production/images/avatar/avatar-male.jpg';
	     $url_avatar = (strlen($url_avatar) > 0) ? $url_avatar : $url_avartar_sex; 
	   } ?>
	<div class="c-layout-breadcrumbs-1 c-subtitle c-fonts-uppercase c-fonts-bold c-bordered c-bordered-both">
		<div class="container">
			<div class="c-page-title c-pull-left">
				<h3 class="c-font-uppercase c-font-sbold">Thông tin tài khoản</h3>
				<h4 class="">Chỉnh sửa thông tin </h4>
				@if(isset($error))
					{{ $error }}
				@endif
			</div>
			<ul class="c-page-breadcrumbs c-theme-nav c-pull-right c-fonts-regular">
				{{-- <li class="c-state_active">Jango Components</li>--}}							
			</ul>
		</div>
	</div><!-- END: LAYOUT/BREADCRUMBS/BREADCRUMBS-2 -->
	<div class="container">
			<div class="c-layout-sidebar-menu c-theme ">
			<!-- BEGIN: LAYOUT/SIDEBARS/SHOP-SIDEBAR-DASHBOARD -->
				<div class="c-sidebar-menu-toggler">
					<h3 class="c-title c-font-uppercase c-font-bold">Tài khoản</h3>
					<a href="javascript:;" class="c-content-toggler" data-toggle="collapse" data-target="#sidebar-menu-1">
						<span class="c-line"></span> <span class="c-line"></span> <span class="c-line"></span>
					</a>
				</div>
				<ul class="c-sidebar-menu collapse " id="sidebar-menu-1">
					<li class="c-dropdown c-open">
						<a href="javascript:;" class="c-toggler">Thông tin<span class="c-arrow"></span></a>
						<ul class="c-dropdown-menu">
							<li class="c-active">
								<a href="javascript:void(0);">Bảng chính</a>
							</li>
							<li class="">
								<a href="javascript:void(0);">Chỉnh sửa</a>
							</li>
							<li class="">
								<a href="javascript:void(0);">Lịch sử đặt hàng</a>
							</li>
							<li class="">
								<a href="javascript:void(0)">Địa chỉ</a>
							</li>
							<li class="">
								<a href="javascript:void(0)">Yêu thích</a>
							</li>
						</ul>
					</li>
				</ul><!-- END: LAYOUT/SIDEBARS/SHOP-SIDEBAR-DASHBOARD -->
			</div>
			<div class="c-layout-sidebar-content ">
			<!-- BEGIN: PAGE CONTENT -->
			<div class="c-content-title-1">
	<h3 class="c-font-uppercase c-font-bold">Thông tin tài khoản</h3>
	<div class="c-line-left"></div>
</div>
{{-- <form class="c-shop-form-1"> --}}
	<!-- BEGIN: ADDRESS FORM -->
	<div class="c-shop-form-1">
		<!-- BEGIN: BILLING ADDRESS -->
		@if(\Session::has('error'))      
            <p>{{ \Session::get('error') }}</p>         
        @endif
	<form class="info" method="post" action="{{ url('updateprofile/'.$iduser) }}">
		{{ csrf_field() }}
		<input type="hidden" name="idprofile" value="{{ $idprofile }}">
		<div class="row">
			<div class="col-md-12">
				<div class="row">
					<div class="form-group col-md-4">
						<label class="control-label">Họ</label>
						<input type="text" class="form-control c-square c-theme" placeholder="" value="{{ $lastname }}" name="lastname">
					</div>
					<div class="form-group col-md-4">
						<label class="control-label">Tên đệm</label>
						<input type="text" class="form-control c-square c-theme" placeholder="" value="{{ $middlename }}" name="middlename">
					</div>
					<div class="form-group col-md-4">
						<label class="control-label">Tên</label>
						<input type="text" class="form-control c-square c-theme" placeholder="" value="{{ $firstname }}" name="firstname">
					</div>
				</div>
			</div>
		</div>
		<div class="row">
			<div class="form-group col-md-12">
				<label class="control-label">Địa chỉ</label>
				<input type="text" class="form-control c-square c-theme" placeholder="" value="{{ $address }}" name="address">
			</div>
		</div>
		<div class="row">
			<div class="form-group col-md-6">
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
			<div class="form-group col-md-6">
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
			<div class="form-group col-md-6">
				<label class="control-label">Ngày sinh</label>
				{{-- <input type="text" class="form-control c-square c-theme" value="{{ $birthday }}" name="birthday"> --}}
				<div class='input-group date' id='myDatepicker2'>
                    <input type='text' name="birthday" value="{{ $birthday }}" class="form-control" />
						<span class="input-group-addon">
						 <span class="glyphicon glyphicon-calendar"></span>
						</span>
				 </div>
				<input type='hidden' name="_birthday" value="{{ $birthday }}" class="form-control" />
			</div>
			<div class="form-group col-md-6">
				<label class="control-label">Giới tính</label>
				<select class="form-control c-square c-theme" name="sel_sex">
					<option value="0">Chọn ... </option>
					@if(isset($rs_sex))
		                  	@foreach($rs_sex as $row)
		                		<option value="{{ $row['idsex'] }}" {{ $row['idsex'] == $idsex ? 'selected="selected"' : '' }}>{{ $row['namesex'] }}</option>
							@endforeach
						@endif 		
				</select>
			</div>
		</div>
		
		<div class="row">
			<div class="col-md-12">
				<div class="row">
					<div class="form-group col-md-6">
						<label class="control-label">Email</label>
						<input type="email" class="form-control c-square c-theme" placeholder="Email" value="{{ $email }}" name="email">
					</div>
					<div class="col-md-6">
						<label class="control-label">Điện thoại</label>
						<input type="text" class="form-control c-square c-theme" placeholder="Điện thoại" value="{{ $mobile }}" name="mobile">
					</div>
				</div>
			</div>
		</div>
		<div class="row">
			<div class="form-group col-md-12" role="group">
					<button type="submit" class="btn btn-lg c-theme-btn c-btn-square c-btn-uppercase c-btn-bold">Xác nhận</button>
					<button type="button" class="btn btn-lg btn-default c-btn-square c-btn-uppercase c-btn-bold">Bỏ qua</button>
			</div>
		</div>
	</form>
		<!-- END: BILLING ADDRESS -->
		<!-- BEGIN: PASSWORD -->
		<h3 class="c-font-uppercase c-font-sbold">Thay đổi mật khẩu</h3>
		@if(\Session::has('er_passowrd'))
          <div class="alert alert-danger">
            <p>{{ \Session::get('er_passowrd') }}</p>
          </div>
        @endif
        @if(\Session::has('pw_changed'))
          <div class="alert alert-success">
            <p>{{ \Session::get('pw_changed') }}</p>
          </div>
        @endif
		<form class="change-password" method="post" action="{{ url('changepassword/'.$iduser) }}">
			{{ csrf_field() }}
			<div class="row">
				<div class="form-group col-md-12">
					<label class="control-label">Mật khẩu cũ</label>
					<input type="password" class="form-control c-square c-theme" placeholder="" name="old_password">
				</div>
			</div>
			<div class="row">
				<div class="form-group col-md-12">
					<label class="control-label">Mật khẩu mới</label>
					<input type="password" class="form-control c-square c-theme" placeholder="" name="password">
				</div>
			</div>
			<div class="row">
				<div class="form-group col-md-12">
					<label class="control-label">Nhập lại mật khẩu</label>
					<input type="password" class="form-control c-square c-theme" placeholder="" name="c_password">
					<p class="help-block"></p>
				</div>
			</div>
			<div class="row">
				<div class="form-group col-md-12" role="group">
					<button type="submit" class="btn btn-lg c-theme-btn c-btn-square c-btn-uppercase c-btn-bold">Xác nhận</button>
					<button type="button" class="btn btn-lg btn-default c-btn-square c-btn-uppercase c-btn-bold">Bỏ qua</button>
				</div>
			</div>
		</form>
		<!--avatar-->
		<div class="row">
        @if (session('uploadavatar'))
          <div class="alert alert-success">
              {{ session('uploadavatar') }}
          </div>
        @endif                 
        <div class="cropper">
          <div class="row">
            <div class="col-md-12">
              <div class="img-container">
                <img id="image" src="{{ asset($url_avatar) }}" alt="Picture">
              </div>
            </div>
            
          </div>
          <div class="row">
            <div class="col-md-12 docs-buttons">
              <!-- <h3 class="page-header">Toolbar:</h3> -->
             <div class="btn-group">                   
                <label class="btn btn-primary btn-upload" for="inputImage" title="Upload image file">
                  <input type="file" class="sr-only" id="inputImage" name="file" accept="image/*">
                  <span class="docs-tooltip" data-toggle="tooltip" title="Import image with Blob URLs">
                    <span class="fa fa-upload"></span>
                  </span>
                </label>
              </div>
              <div class="btn-group">
                <button type="button" class="btn btn-primary" data-method="zoom" data-option="0.1" title="Zoom In">
                  <span class="docs-tooltip" data-toggle="tooltip" title="$().cropper(&quot;zoom&quot;, 0.1)">
                    <span class="fa fa-search-plus"></span>
                  </span>
                </button>
                <button type="button" class="btn btn-primary" data-method="zoom" data-option="-0.1" title="Zoom Out">
                  <span class="docs-tooltip" data-toggle="tooltip" title="$().cropper(&quot;zoom&quot;, -0.1)">
                    <span class="fa fa-search-minus"></span>
                  </span>
                </button>
              </div>      
              <div class="btn-group btn-group-crop">
                <button type="button" class="btn btn-primary" data-method="getCroppedCanvas">
                  <span class="docs-tooltip" data-toggle="tooltip" title="$().cropper(&quot;getCroppedCanvas&quot;)">
                    Cắt ảnh
                  </span>
                </button>
            
              </div>
             
              <!-- Show the cropped image in modal -->
              <div class="modal fade docs-cropped" id="getCroppedCanvasModal" aria-hidden="true" aria-labelledby="getCroppedCanvasTitle" role="dialog" tabindex="-1">
                <div class="modal-dialog">
                  <div class="modal-content">
                    <div class="modal-header">
                      <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                      <h4 class="modal-title" id="getCroppedCanvasTitle">Đã cắt</h4>
                    </div>
                    <div class="modal-body cropped-image"></div>
                    <div class="modal-footer">
                      <form method="post" action="{{ url('profile/uploadavatar/'.$iduser.'/'.$idprofile) }}">
                        {{ csrf_field() }}
                        <button type="button" class="btn btn-default" data-dismiss="modal">Đóng</button>
                       {{--  <a id="download" href="javascript:void(0);"></a> --}}
                        <input id="download" type="hidden" name="download" value="">
                        <button type="submit" class="btn btn-primary">Cập nhật</button>
                      </form>
                    </div>
                  </div>
                </div>
              </div><!-- /.modal -->
          </div>
        </div>
      </div>
  	</div>
      <!--end avatar -->
		<!-- END: PASSWORD -->
		
	</div>
	<!-- END: ADDRESS FORM -->
			
<!-- END: PAGE CONTENT -->
			</div>
		</div>
		
@stop
@section('other_scripts')
<!-- bootstrap-daterangepicker -->

    <script src="{{ asset('dashboard/vendors/moment/min/moment.min.js') }}"></script>

    <script src="{{ asset('dashboard/vendors/bootstrap-daterangepicker/daterangepicker.js') }}"></script>

    <!-- bootstrap-datetimepicker -->    

    <script src="{{ asset('dashboard/vendors/bootstrap-datetimepicker/build/js/bootstrap-datetimepicker.min.js') }}"></script>

	<script src="{{ asset('dashboard/vendors/cropper/dist/cropper.min.js') }}"></script>
	<script src="{{ asset('dashboard/production/js/custom.js?v=0.2.5') }}"></script>
	<script src="{{ asset('dashboard/build/js/custom.js?v=0.0.8') }}"></script>
	<script type="text/javascript">

        $('#myDatepicker2').datetimepicker({

            format: 'DD-MM-YYYY'

        });   

    </script>
@stop