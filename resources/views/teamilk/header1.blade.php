    <!-- BEGIN: LAYOUT/HEADERS/HEADER-1 -->

<!-- BEGIN: HEADER -->
<header class="c-layout-header c-layout-header-4 c-layout-header-default-mobile" data-minimize-offset="80">

        <div class="c-topbar c-topbar-light c-solid-bg">

        <div class="container">

            <!-- BEGIN: INLINE NAV -->

            <nav class="c-top-menu c-pull-left">

                <ul class="c-icons c-theme-ul">

                    <li><a href="#"><i class="icon-social-twitter"></i></a></li>

                    <li><a href="#"><i class="icon-social-facebook"></i></a></li>

                    <li><a href="#"><i class="icon-social-dribbble"></i></a></li>

                    <li class="hide"><span>Phone: 1900 636 748 </span></li>

                </ul>

            </nav>

            <!-- END: INLINE NAV -->

            <!-- BEGIN: INLINE NAV -->

            <nav class="c-top-menu c-pull-right">

                <ul class="c-links c-theme-ul">

                    <li>@if (Auth::check())

                        <a href="{{ url('/profile/'.Auth::id()) }}">{{ Auth::user()->name }}</a>

                    @else

                    <a href="#">Chào bạn! </a>

                    @endif</li>

                    <li class="c-divider">|</li>

                    <li><a href="#">Hỗ trợ</a></li>

                    <li class="c-divider">|</li>

                    <li><a href="#">Liên hệ</a></li>

                    <li class="c-divider">|</li>

                    <li><a href="#">Hỏi đáp</a></li>

                    @if (Auth::check())

                        <li class="c-divider">|</li>

                        <li><a href="{{ url('/logout') }}"><i class="fa fa-sign-out"></i> Thoát&nbsp;</a></li>

                    @endif

                </ul>

                <ul class="c-ext c-theme-ul">

                    <li class="c-lang dropdown c-last">

                        <a href="#">en</a>

                        <ul class="dropdown-menu pull-right" role="menu">

                            <li class="active"><a href="#">English</a></li>

                            {{-- <li><a href="#">German</a></li>

                            <li><a href="#">Espaniol</a></li>

                            <li><a href="#">Portugise</a></li> --}}

                        </ul>

                    </li>

                    <li class="c-search hide">

                        <!-- BEGIN: QUICK SEARCH -->

                        <form action="#">

                            <input type="text" name="query" placeholder="search..." value="" class="form-control" autocomplete="off">

                            <i class="fa fa-search"></i>

                        </form>

                        <!-- END: QUICK SEARCH -->  

                    </li>

                </ul>

            </nav>

            <!-- END: INLINE NAV -->

        </div>

    </div>

        <div class="c-navbar">

        <div class="container">

            <!-- BEGIN: BRAND -->

            <div class="c-navbar-wrapper clearfix">

                <div class="c-brand c-pull-left">

                    <a href="{{ url('/') }}" class="c-logo">

                        <img src="{{ asset('assets-tea/images/logo/Asset-2@2x.png') }}" alt="JANGO" class="c-desktop-logo">

                        <img src="{{ asset('assets-tea/images/logo/Asset-2@2x.png') }}" alt="JANGO" class="c-desktop-logo-inverse">

                        <img src="{{ asset('assets-tea/images/logo/Asset-2@2x.png') }}" alt="JANGO" class="c-mobile-logo">

                    </a>

                    <button class="c-hor-nav-toggler" type="button" data-target=".c-mega-menu">

                    <span class="c-line"></span>

                    <span class="c-line"></span>

                    <span class="c-line"></span>

                    </button>

                    <button class="c-topbar-toggler" type="button">

                        <i class="fa fa-ellipsis-v"></i>

                    </button>

                    <button class="c-search-toggler" type="button">

                        <i class="fa fa-search"></i>

                    </button>

                    <button onclick="location.href = '{{ url('teamilk/shopcart') }}';"  class="c-cart-toggler" type="button">

                        <i class="icon-handbag"></i> <span class="c-cart-number c-theme-bg">0</span>

                    </button>

                </div>

                <!-- END: BRAND -->             

                <!-- BEGIN: QUICK SEARCH -->

                <form class="c-quick-search" action="#">

                    <input type="text" name="query" placeholder="Type to search..." value="" class="form-control" autocomplete="off">

                    <span class="c-theme-link">&times;</span>

                </form>

                <!-- END: QUICK SEARCH -->  

                <!-- BEGIN: HOR NAV -->

                <!-- BEGIN: LAYOUT/HEADERS/MEGA-MENU -->

            <!-- BEGIN: MEGA MENU -->

            <!-- Dropdown menu toggle on mobile: c-toggler class can be applied to the link arrow or link itself depending on toggle mode -->

            <nav class="c-mega-menu c-pull-right c-mega-menu-dark c-mega-menu-dark-mobile c-fonts-uppercase c-fonts-bold menu-home">

                <ul class="nav navbar-nav c-theme-nav"> 
                        @foreach($rs_menu as $row)
                            {{ $row['idmenuhascate']."," }}
                        @endforeach
                        <li><a href="{{ url('/') }}" class="c-link dropdown-toggle">Trang chủ<span class="c-arrow c-toggler"></span></a></li>

                            <li class="c-menu-type-classic"><a href="javascript:;" class="c-link dropdown-toggle">Sản phẩm<span class="c-arrow c-toggler"></span></a>

                            <ul class="dropdown-menu c-menu-type-classic c-pull-left">
                                @foreach($rs_cat_product as $row)
                                    <li><a href="#">{{ $row['namecat'] }}</a></li>
                                @endforeach
                              </ul>
                                </li>
                                <li>
                                    <a href="javascript:;" class="c-link dropdown-toggle">Chính sách<span class="c-arrow c-toggler"></span></a>                    
                                </li>
                                <li>

                                    <a href="javascript:;" class="c-link dropdown-toggle">Giới thiệu<span class="c-arrow c-toggler"></span></a>                

                                </li>

                                    <li>

                                    <a href="javascript:;" class="c-link dropdown-toggle">Liên hệ<span class="c-arrow c-toggler"></span></a></li>

                            <!-- BEGIN: DESKTOP VERSION OF THE TAB MEGA MENU -->

                            <!-- BEGIN: DESKTOP VERSION OF THE TAB MEGA MENU -->

                            <!-- BEGIN: MOBILE VERSION OF THE TAB MEGA MENU -->

                            <ul class="dropdown-menu c-menu-type-mega c-visible-mobile">
                                <li class="dropdown-submenu">
                                    <a href="javascript:;">Jango Components<span class="c-arrow c-toggler"></span></a>
                                    <div class="dropdown-menu">
                                    </div>
                                </li>
                            </ul>

                            <!-- END: MOBILE VERSION OF THE TAB MEGA MENU -->
                                </li>
                            <li class="c-search-toggler-wrapper">
                                <a href="#" class="c-btn-icon c-search-toggler"><i class="fa fa-search"></i></a>
                            </li>
                            <li class="c-cart-toggler-wrapper">
                                <a href="{{ url('teamilk/shopcart') }}" class="c-btn-icon c-cart-toggler"><i class="icon-handbag c-cart-icon"></i> <span class="c-cart-number c-theme-bg">0</span></a>
                            </li>
                           <li class="user-profile">
                                {{-- <a href="/profile/{{ Auth::id() }}">{{ Auth::user()->name }} --}}
                                @if (Auth::check())
                                    <a href="{{ url('/profile') }}/{{ Auth::id() }}" class="c-btn-border-opacity-04 c-btn btn-no-focus c-btn-header btn btn-sm c-btn-border-1x c-btn-dark c-btn-circle c-btn-uppercase c-btn-sbold "><img src="{{ asset($url_avatar) }}">{{ Auth::user()->name }}</a> 
                                @else
                                <a href="#" data-toggle="modal" data-target="#login-form" class="c-btn-border-opacity-04 c-btn btn-no-focus c-btn-header btn btn-sm c-btn-border-1x c-btn-dark c-btn-circle c-btn-uppercase c-btn-sbold"><i class="icon-user"></i> Đăng nhập</a>
                                @endif
                            </li>
                            <li class="c-quick-sidebar-toggler-wrapper">    

                                <a href="#" class="c-quick-sidebar-toggler">                    

                                    <span class="c-line"></span>

                                    <span class="c-line"></span>

                                    <span class="c-line"></span>

                                </a>

                            </li>

                        </ul>

            </nav>

            <!-- END: MEGA MENU --><!-- END: LAYOUT/HEADERS/MEGA-MENU -->

<!-- END: HOR NAV -->       

</div>          

<!-- BEGIN: LAYOUT/HEADERS/QUICK-CART -->



        </div>

    </div>

</header>