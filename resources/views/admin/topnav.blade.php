<?php //foreach($profile as $row) {
        //$idprofile = $row["idprofile"];
        //$firstname = $row["firstname"];
        //$lastname = $row['lastname'];
        //$middlename = $row['middlename'];
        //$sel_sex = $row['sex'];
        //$birthday = $row['birthday'];
        //$address = $row['address'];
        //$mobile = $row['mobile'];
        //$url_avatar = $row['url_avatar'];
        //echo "<script> var birthday='".$birthday."'</script>";
     //}
     //$url_avartar_sex = ($sel_sex == 0) ? 'dashboard/production/images/avatar/avatar-female.jpg' : 'dashboard/production/images/avatar/avatar-male.jpg';
     //$url_avatar = (strlen($url_avatar) > 0) ? $url_avatar : $url_avartar_sex; ?>
<div class="top_nav">

          <div class="nav_menu">

            <nav>

              <div class="nav toggle">

                <a id="menu_toggle"><i class="fa fa-bars"></i></a>

              </div>



              <ul class="nav navbar-nav navbar-right">

                <li class="">

                  <a href="javascript:;" class="user-profile dropdown-toggle" data-toggle="dropdown" aria-expanded="false">

                    <img src="{{ asset($url_avatar) }}" alt=""> 

                    @if (Auth::check()) 

                     {{ Auth::user()->name }} 

                    @endif

                    <span class=" fa fa-angle-down"></span>

                  </a>

                  <ul class="dropdown-menu dropdown-usermenu pull-right">

                    <li><a href="/profile/{{ Auth::id() }}"> Tài khoản</a></li>

                    <li>

                      <a href="javascript:;">

                        <span class="badge bg-red pull-right">50%</span>

                        <span>Settings</span>

                      </a>

                    </li>

                    <li><a href="javascript:;">Help</a></li>

                    @if (Auth::check()) 

                      <li><a href="{{ url('/logout') }}"><i class="fa fa-sign-out pull-right"></i> Log Out</a></li> 

                    @endif

                   

                  </ul>

                </li>



                <li role="presentation" class="dropdown">

                  <a href="javascript:;" class="dropdown-toggle info-number" data-toggle="dropdown" aria-expanded="false">

                    <i class="fa fa-envelope-o"></i>

                    <span class="badge bg-green">6</span>

                  </a>

                  <ul id="menu1" class="dropdown-menu list-unstyled msg_list" role="menu">

                    <li>

                      <a>

                        <span class="image"><img src="{{ asset($url_avatar) }}" alt="Profile Image" /></span>

                        <span>

                          <span>John Smith</span>

                          <span class="time">3 mins ago</span>

                        </span>

                        <span class="message">

                          Film festivals used to be do-or-die moments for movie makers. They were where...

                        </span>

                      </a>

                    </li>

                    <li>

                      <a>

                        <span class="image"><img src="{{ asset('dashboard/production/images/img.jpg') }}" alt="Profile Image" /></span>

                        <span>

                          <span>John Smith</span>

                          <span class="time">3 mins ago</span>

                        </span>

                        <span class="message">

                          Film festivals used to be do-or-die moments for movie makers. They were where...

                        </span>

                      </a>

                    </li>

                    <li>

                      <a>

                        <span class="image"><img src="{{ asset('dashboard/production/images/img.jpg') }}" alt="Profile Image" /></span>

                        <span>

                          <span>John Smith</span>

                          <span class="time">3 mins ago</span>

                        </span>

                        <span class="message">

                          Film festivals used to be do-or-die moments for movie makers. They were where...

                        </span>

                      </a>

                    </li>

                    <li>

                      <a>

                        <span class="image"><img src="{{ asset('dashboard/production/images/img.jpg') }}" alt="Profile Image" /></span>

                        <span>

                          <span>John Smith</span>

                          <span class="time">3 mins ago</span>

                        </span>

                        <span class="message">

                          Film festivals used to be do-or-die moments for movie makers. They were where...

                        </span>

                      </a>

                    </li>

                    <li>

                      <div class="text-center">

                        <a>

                          <strong>See All Alerts</strong>

                          <i class="fa fa-angle-right"></i>

                        </a>

                      </div>

                    </li>

                  </ul>

                </li>

              </ul>

            </nav>

          </div>

        </div>