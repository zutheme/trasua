@extends('admin.dashboard')

@section('other_styles')

    <!-- bootstrap-daterangepicker -->

    <link href="{{ asset('dashboard/vendors/bootstrap-daterangepicker/daterangepicker.css') }}" rel="stylesheet">

    <!-- bootstrap-datetimepicker -->

    <link href="{{ asset('dashboard/vendors/bootstrap-datetimepicker/build/css/bootstrap-datetimepicker.css') }}" rel="stylesheet">

    <!-- Ion.RangeSlider -->

    <link href="{{ asset('dashboard/vendors/normalize-css/normalize.css') }}" rel="stylesheet">

    <link href="{{ asset('dashboard/vendors/ion.rangeSlider/css/ion.rangeSlider.css') }}" rel="stylesheet">

    <link href="{{ asset('dashboard/vendors/ion.rangeSlider/css/ion.rangeSlider.skinFlat.css') }}" rel="stylesheet">

    <!-- Bootstrap Colorpicker -->

    <link href="{{ asset('dashboard/vendors/mjolnic-bootstrap-colorpicker/dist/css/bootstrap-colorpicker.min.css') }}" rel="stylesheet">



    <link href="{{ asset('dashboard/vendors/cropper/dist/cropper.min.css') }}" rel="stylesheet">



    <!-- Custom Theme Style -->

    <link href="{{ asset('dashboard/build/css/custom.min.css') }}" rel="stylesheet">

      <!-- Custom Theme Style -->

    <link href="{{ asset('dashboard/build/css/custom.min.css') }}" rel="stylesheet">

    <link href="{{ asset('dashboard/production/css/custom.css?v=0.1.7') }}" rel="stylesheet">

@stop

@section('content')

   <!-- page content --> 

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

            <div class="clearfix"></div>

            <div class="row">

              <div class="col-md-12 col-sm-12 col-xs-12">

                <div class="x_panel">

                  <div class="x_title">

                    <h2>Thông tin <small>tài khoản</small></h2>

                    <ul class="nav navbar-right panel_toolbox">

                      <li><a class="collapse-link"><i class="fa fa-chevron-up"></i></a>

                      </li>

                      <li class="dropdown">

                        <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false"><i class="fa fa-wrench"></i></a>

                        <ul class="dropdown-menu" role="menu">

                          <li><a href="#">Settings 1</a>

                          </li>

                          <li><a href="#">Settings 2</a>

                          </li>

                        </ul>

                      </li>

                      <li><a class="close-link"><i class="fa fa-close"></i></a>

                      </li>

                    </ul>

                    <div class="clearfix"></div>

                  </div>

                  <div class="x_content">

                    <div class="col-md-3 col-sm-3 col-xs-12 profile_left">

                      <div class="profile_img">

                        <div id="crop-avatar">

                          <!-- Current avatar -->

                          <img class="img-responsive avatar-view" src="{{ asset($url_avatar) }}" alt="Avatar" title="Change the avatar">

                        </div>

                      </div>

                 

                    </div>

                    <div class="col-md-9 col-sm-9 col-xs-12">
                      @if(\Session::has('error'))
                          <div class="alert alert-danger">
                            <p>{{ \Session::get('error') }}</p>
                          </div>
                        @endif
                        @if(isset($error))
                          <div class="alert alert-danger">
                            <p>{{ $error }}</p>
                          </div>
                        @endif
                      <div class="profile_titles">
                        {{-- url('profile/update/'.$iduser) --}}
                      <form id="demo-form2" method="post" action="{{ action('ProfileController@update',$iduser) }}" data-parsley-validate class="form-horizontal form-label-left">

                        {{ csrf_field() }}

                        <input type="hidden" name="_method" value="PATCH">

                        <input type="hidden" name="idprofile" value="{{ $idprofile }}">

                      <div class="form-group">

                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="first-name">Tên <span class="required">*</span>

                        </label>

                        <div class="col-md-9 col-sm-9 col-xs-12">

                          <input type="text" name="firstname" value="{{ $firstname }}" required="required" class="form-control col-md-7 col-xs-12">

                        </div>

                      </div>

                      <div class="form-group">

                        <label class="control-label col-md-3 col-sm-3 col-xs-12" for="last-name">Họ <span class="required">*</span>

                        </label>

                        <div class="col-md-9 col-sm-9 col-xs-12">

                          <input type="text" name="lastname" value="{{ $lastname }}" required="required" class="form-control col-md-7 col-xs-12">

                        </div>

                      </div>

                      <div class="form-group">

                        <label for="middle-name" class="control-label col-md-3 col-sm-3 col-xs-12">Tên lót</label>

                        <div class="col-md-9 col-sm-9 col-xs-12">

                          <input name="middlename" value="{{ $middlename }}" class="form-control col-md-7 col-xs-12" type="text">

                        </div>

                      </div>

                      <div class="form-group">

                        <label class="control-label col-md-3 col-sm-3 col-xs-12">Giới tính</label>

                        <div class="col-md-9 col-sm-9 col-xs-12">

                          <p></p><label>Nữ:&nbsp;</label><input type="radio" class="flat form-control" name="sel_sex"  value="0" {{ $sel_sex == 0  ? 'checked="" required' : '' }}/>&nbsp;<label>Nam:&nbsp;</label><input type="radio" class="flat form-control" name="sel_sex"  value="1" {{ $sel_sex == 1  ? 'checked="" required' : '' }}/>

                        </div>

                      </div>

                      <div class="form-group">

                        <label class="control-label col-md-3 col-sm-3 col-xs-12">Ngày sinh <span class="required">*</span>

                        </label>

                        <div class="col-md-9 col-sm-9 col-xs-12">

                          <div class="form-group">

                                <div class='input-group date' id='myDatepicker2'>

                                    <input type='text' name="birthday" value="{{ $birthday }}" class="form-control" />

                                    <span class="input-group-addon">

                                       <span class="glyphicon glyphicon-calendar"></span>

                                    </span>

                                </div>

                                 <input type='hidden' name="_birthday" value="{{ $birthday }}" class="form-control" />

                          </div>

                          {{-- <input id="birthday" class="date-picker form-control col-md-7 col-xs-12" required="required" type="text"> --}}

                        </div>

                      </div>

                      <div class="form-group">

                        <label for="middle-name" class="control-label col-md-3 col-sm-3 col-xs-12">Điện thoại</label>

                        <div class="col-md-9 col-sm-9 col-xs-12">

                          <input name="mobile" value="{{ $mobile }}" class="form-control col-md-7 col-xs-12" type="text">

                        </div>

                      </div>

                      <div class="form-group">

                        <label for="middle-name" class="control-label col-md-3 col-sm-3 col-xs-12">Địa chỉ</label>

                        <div class="col-md-9 col-sm-9 col-xs-12">

                          <input name="address" value="{{ $address }}" class="form-control col-md-7 col-xs-12" type="text">

                        </div>

                      </div>         

                      <div class="form-group">

                        <div class="col-md-9 col-sm-9 col-xs-12 col-md-offset-3">

                          <button class="btn btn-primary" type="button">Bỏ qua</button>

                          <button type="submit" class="btn btn-success">Cập nhật</button>

                        </div>

                      </div>

                    </form>

                    </div>

                    <div class="ln_solid"></div>

                      

                      <!--change password-->

                       @if (isset($errorpass))

                              {{ $errorpass }}

                       @endif

                    <div class="profile_titles">

                          <form method="post" action="{{ url('profile/changepassword/'.$iduser) }}" class="form-horizontal form-label-left">

                          {{ csrf_field() }}                     

                          {{-- <input type="hidden" name="_method" value="PATCH"> --}}

                          <div class="form-group">

                            <label class="control-label col-md-3 col-sm-3 col-xs-12">Mật khẩu cũ</label>

                            <div class="col-md-9 col-sm-9 col-xs-12">

                              <input name="old_password" type="password" class="form-control" value="">

                            </div>

                          </div>

                          <div class="form-group">

                            <label class="control-label col-md-3 col-sm-3 col-xs-12">Mật khẩu mới</label>

                            <div class="col-md-9 col-sm-9 col-xs-12">

                              <input name="password" type="password" class="form-control" value="">

                            </div>

                          </div>

                          <div class="form-group">

                            <label class="control-label col-md-3 col-sm-3 col-xs-12">Nhập lại mật khẩu</label>

                            <div class="col-md-9 col-sm-9 col-xs-12">

                             <input name="c_password" type="password" class="form-control" value="">

                            </div>

                          </div>

                          <div class="form-group">

                            <div class="col-md-9 col-sm-9 col-xs-12 col-md-offset-3">

                              <button type="button" class="btn btn-primary">Bỏ qua</button>

                              <button type="submit" class="btn btn-success">Cập nhật</button>

                            </div>

                          </div>



                        </form>

                      </div>

                      <!--end change password-->

                      <div class="ln_solid"></div>

                      <!--avatar-->

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

                              {{-- <div class="btn-group">

                                  <div class="docs-toggles">

                                    <label class="btn btn-primary">

                                      <input type="radio" class="sr-only" id="aspectRatio2" name="aspectRatio" value="1">

                                      <span class="docs-tooltip" data-toggle="tooltip" title="aspectRatio: 1 / 1">

                                        1:1

                                      </span>

                                    </label>

                                  </div>

                              </div> --}}

                              <!-- /.docs-toggles -->

                              <!-- Show the cropped image in modal -->

                              <div class="modal fade docs-cropped" id="getCroppedCanvasModal" aria-hidden="true" aria-labelledby="getCroppedCanvasTitle" role="dialog" tabindex="-1">

                                <div class="modal-dialog">

                                  <div class="modal-content">

                                    <div class="modal-header">

                                      <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>

                                      <h4 class="modal-title" id="getCroppedCanvasTitle">Cropped</h4>

                                    </div>

                                    <div class="modal-body"></div>

                                    <div class="modal-footer">

                                      <form method="post" action="{{ url('profile/uploadavatar/'.$iduser.'/'.$idprofile) }}">

                                        {{ csrf_field() }}

                                        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>

                                       {{--  <a id="download" href="javascript:void(0);"></a> --}}

                                        <input id="download" type="hidden" name="download" value="">

                                        <button type="submit" class="btn btn-primary">Upload</button>

                                      </form>

                                    </div>

                                  </div>

                                </div>

                              </div><!-- /.modal -->

                          </div>

                        </div>

                      </div>

                      <!--end avatar -->

                    </div>

                  </div>

                </div>

              </div>

            </div>



        <!-- /page content -->

@stop



@section('other_scripts')

    <!-- bootstrap-daterangepicker -->

    <script src="{{ asset('dashboard/vendors/moment/min/moment.min.js') }}"></script>

    <script src="{{ asset('dashboard/vendors/bootstrap-daterangepicker/daterangepicker.js') }}"></script>

    <!-- bootstrap-datetimepicker -->    

    <script src="{{ asset('dashboard/vendors/bootstrap-datetimepicker/build/js/bootstrap-datetimepicker.min.js') }}"></script>

    <!-- Ion.RangeSlider -->

    <script src="{{ asset('dashboard/vendors/ion.rangeSlider/js/ion.rangeSlider.min.js') }}"></script>

    <!-- Bootstrap Colorpicker -->

    <script src="{{ asset('dashboard/vendors/mjolnic-bootstrap-colorpicker/dist/js/bootstrap-colorpicker.min.js') }}"></script>

    <!-- jquery.inputmask -->

    <script src="{{ asset('dashboard/vendors/jquery.inputmask/dist/min/jquery.inputmask.bundle.min.js') }}"></script>

    <!-- jQuery Knob -->

    <script src="{{ asset('dashboard/vendors/jquery-knob/dist/jquery.knob.min.js') }}"></script>

    <!-- Cropper -->

    <script src="{{ asset('dashboard/vendors/cropper/dist/cropper.min.js') }}"></script>

    {{-- <script src="{{ asset('dashboard/build/js/custom.min.js') }}"></script> --}}

    <script src="{{ asset('dashboard/vendors/echarts/dist/echarts.min.js') }}"></script>

    <script src="{{ asset('dashboard/build/js/custom.js?v=0.0.8') }}"></script>

    <script src="{{ asset('dashboard/production/js/custom.js?v=0.2.3') }}"></script>

    <script type="text/javascript">

        $('#myDatepicker2').datetimepicker({

            format: 'DD-MM-YYYY'

        });   

    </script>

@stop