@extends('admin.dashboard')

@section('other_styles')
      <!-- Custom Theme Style -->
    <link href="{{ asset('dashboard/build/css/custom.min.css') }}" rel="stylesheet">
    <link href="{{ asset('dashboard/production/css/custom.css?v=0.1.9') }}" rel="stylesheet">
@stop
@section('content')
<?php foreach($profile as $row) {
                  $idprofile = $row["idprofile"];
                  $firstname = $row["firstname"];
                  $lastname = $row['lastname'];
                  $middlename = $row['middlename'];
                  $sel_sex = $row['sex'];
                  $birthday = $row['birthday'];
                  $address = $row['address'];
                  $mobile = $row['mobile'];
                  $url_avatar = $row['url_avatar'];
                  //echo "<script> var birthday='".$birthday."'</script>";
               }
               $url_avartar_sex = ($sel_sex == 0) ? 'dashboard/production/images/avatar/avatar-female.jpg' : 'dashboard/production/images/avatar/avatar-male.jpg';
               $url_avatar = (strlen($url_avatar) > 0) ? $url_avatar : $url_avartar_sex; 
               //$name = (strlen($firstname) > 0) ? $firstname : $url_avartar_sex; ?>
<?php $_sel_idposttype = 0; ?>
 <!-- page content -->       
            <div class="page-title">
              <div class="title_left">
                <h3>Tương tác<small> </small></h3>
              </div>

              <div class="title_right">
                <div class="col-md-5 col-sm-5 col-xs-12 form-group pull-right top_search">
                  <div class="input-group">
                    <input type="text" class="form-control" placeholder="Search for...">
                    <span class="input-group-btn">
                      <button class="btn btn-default" type="button">Go!</button>
                    </span>
                  </div>
                </div>
              </div>
            </div>
            
            <div class="clearfix"></div>

            <div class="row">
              <div class="col-md-12">
                <div class="x_panel">
                  <div class="x_title">
                    <h2>&nbsp;</h2>
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
                    @if(isset($detailpost))
                          @foreach($detailpost as $row)
                            <?php $idpostparent = $row['idpost'];
                                  $post = $row['body']; 
                                  $firstname = $row['firstname']; 
                                  $mobile = $row['mobile'];
                                  $email= $row['email'];
                                  $address = $row['address'];
                                  $job = $row['job'];
                                  $birthday = $row['birthday'];
                                  $facebook = $row['facebook'];
                            ?>
                          @endforeach
                        @endif
                    <div class="col-md-9 col-sm-9 col-xs-12">

                      <ul class="stats-overview">
                        <li>
                          <span class="name"> Estimated budget </span>
                          <span class="value text-success"> 2300 </span>
                        </li>
                        <li>
                          <span class="name"> Total amount spent </span>
                          <span class="value text-success"> 2000 </span>
                        </li>
                        <li class="hidden-phone">
                          <span class="name"> Estimated project duration </span>
                          <span class="value text-success"> 20 </span>
                        </li>
                      </ul>
                      <br />

                      {{-- <div id="mainb" style="height:350px;"></div> --}}
                      <div class="detail-post">
                        @if(isset($post))
                      	 {!! $post !!}
                        @endif
                      </div>
                      <div>

                        <h4>Hoạt động gần đây</h4>

                        <!-- end of user messages -->
                        <ul class="messages">
                           @if(isset($activitys))
                              @foreach($activitys as $row)
                              <li>
                                <img src="{{ asset($row['url_avatar']) }}" class="avatar" alt="Avatar">
                                <div class="message_wrapper comment">
                                  <h4 class="heading">{{ $row['lastname']." ".$row['middlename']." ".$row['firstname'] }}</h4>
                                  <blockquote class="message">{{ $row['body']}}</blockquote>
                                  <br />
                                  <p class="url">
                                    <span class="fs1 text-info" aria-hidden="true" data-icon=""></span>
                                    <a href="#">{!! isset($row['icon']) ? $row['icon']:'<i class="fa fa-comments-o"></i>' !!}</i> {{ $row['created_at'] }} </a>
                                  </p>
                                </div>
                              </li>
                              @endforeach
                            @endif
                        </ul>
                      <form method="post" action="{{ url('/admin/customerreg/interactivecustomer') }}">
                        {{ csrf_field() }}
                        <div class="x_panel">
                          <div class="x_title">
                            <h2>&nbsp;</h2>
                            <input type="hidden" name="idpost" value="{{ $idpostparent }}">
                             <input type="hidden" name="idimppost" value="{{ $idimppost }}">
                            @if(isset($post_type_inter))
                              <ul class="nav navbar-right panel_toolbox">
                                @foreach($post_type_inter as $row)
                                  <li>&nbsp;&nbsp;&nbsp;<label>{{ $row['nametype'] }}:&nbsp;</label><input type="radio" class="flat form-control" name="sel_idposttype"  value="{{ $row['idposttype'] }}"/></li>
                                @endforeach
                              </ul> 
                            @endif
                            <div class="clearfix"></div>
                          </div>
                          <div class="x_content">
                            <ul class="messages">
                              <li>
                                <img src="{{ asset($url_avatar) }}" class="avatar" alt="Avatar">
                                <div class="message_wrapper comment">
                                  <textarea name="body" class="resizable_textarea form-control" placeholder="Ghi chú"></textarea>
                                </div>
                              </li>
                            </ul>
                          </div>
                          <ul class="nav navbar-right panel_toolbox">
                              <li><input class="btn btn-default" type="submit" name="submit-info" value="Xác nhận"></li>
                            </ul>
                            @if(isset($errors))
                              {{ $errors }}
                            @endif
                        </div>
                      </form>                 
                        <!-- end of user messages -->
                      </div>


                    </div>

                    <!-- start project-detail sidebar -->
                    <div class="col-md-3 col-sm-3 col-xs-12">

                      <section class="panel">

                        <div class="x_title">
                          <h2>Thông tin khách hàng</h2>
                          <div class="clearfix"></div>
                        </div>
                        <div class="panel-body">
                          <img src="{{ asset('dashboard/production/images/avatar/avatar2.jpg') }}" class="avatars" alt="Avatar">
                          <h3 class="green">{{ $firstname }} </h3>
                          <p></p>
                          <br />

                          <div class="project_detail">
                            <p class="title">Điện thoại</p>
                            <p>{{ $mobile}}</p>
                            <p class="title">Email</p>
                            <p>{{ $email }}</p>
                            <p class="title">Địa chỉ</p>
                            <p>{{ $address }}</p>
                            <p class="title">Công việc</p>
                            <p>{{ $job }}</p>
                            <p class="title">Facebook</p>
                            <p>{{ $facebook }}</p> 
                            <p class="title">Ngày sinh</p>
                            <p>{{ $birthday }}</p>   
                          </div>
                          <br />
                          {{-- <h5>Project files</h5>
                          <ul class="list-unstyled project_files">
                            <li><a href=""><i class="fa fa-file-word-o"></i> Functional-requirements.docx</a>
                            </li>
                            <li><a href=""><i class="fa fa-file-pdf-o"></i> UAT.pdf</a>
                            </li>
                            <li><a href=""><i class="fa fa-mail-forward"></i> Email-from-flatbal.mln</a>
                            </li>
                            <li><a href=""><i class="fa fa-picture-o"></i> Logo.png</a>
                            </li>
                            <li><a href=""><i class="fa fa-file-word-o"></i> Contract-10_12_2014.docx</a>
                            </li>
                          </ul>
                          <br /> --}}

                          <div class="text-center mtop20">
                            <a href="#" class="btn btn-sm btn-primary">Cập nhật</a>
                            {{-- <a href="#" class="btn btn-sm btn-warning"></a> --}}
                          </div>
                        </div>

                      </section>

                    </div>
                    <!-- end project-detail sidebar -->

                  </div>
                </div>
              </div>
            </div>
        <!-- /page content -->
@stop
@section('other_scripts')
    {{-- <script src="{{ asset('dashboard/build/js/custom.min.js') }}"></script> --}}
    <script src="{{ asset('dashboard/vendors/echarts/dist/echarts.min.js') }}"></script>
    <script src="{{ asset('dashboard/build/js/custom.js') }}"></script> 
@stop