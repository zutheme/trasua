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

                    <li class="hide"><span>CSKH: 1900 1768 </span></li>

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

                    <input type="text" name="query" placeholder="Nhập từ khóa..." value="" class="form-control" autocomplete="off">

                    <span class="c-theme-link">&times;</span>

                </form>

                <!-- END: QUICK SEARCH -->  

                <!-- BEGIN: HOR NAV -->

                <!-- BEGIN: LAYOUT/HEADERS/MEGA-MENU -->

            <!-- BEGIN: MEGA MENU -->

            <!-- Dropdown menu toggle on mobile: c-toggler class can be applied to the link arrow or link itself depending on toggle mode -->

           @include('teamilk.menu-master')

            <!-- END: MEGA MENU --><!-- END: LAYOUT/HEADERS/MEGA-MENU -->

<!-- END: HOR NAV -->       

</div>          

<!-- BEGIN: LAYOUT/HEADERS/QUICK-CART -->



        </div>

    </div>

</header>