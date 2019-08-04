<!--BEGIN: CONTENT/USER/FORGET-PASSWORD-FORM -->
<div class="modal fade c-content-login-form" id="forget-password-form" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content c-square">
            <div class="modal-header c-no-border">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
            </div>
            <div class="modal-body">
                <h3 class="c-font-24 c-font-sbold">Phục hồi mật khẩu</h3>
                <p>Nhập email để phục hồi mật khẩu</p>
                <form>
                    <div class="form-group">
                        <label for="forget-email" class="hide">Email</label>
                        <input type="email" class="form-control input-lg c-square" id="forget-email" placeholder="Email" name="email">
                    </div>
                    <div class="form-group">
                        <button type="submit" class="btn c-theme-btn btn-md c-btn-uppercase c-btn-bold c-btn-square c-btn-login">Xác nhận</button>
                        <a href="javascript:;" class="c-btn-forgot" data-toggle="modal" data-target="#login-form" data-dismiss="modal">Đăng nhập</a>
                    </div>
                </form>
            </div>
            <div class="modal-footer c-no-border">                
                <span class="c-text-account">Bạn chưa có tài khoản ?</span>
                <a href="javascript:;" data-toggle="modal" data-target="#signup-form" data-dismiss="modal" class="btn c-btn-dark-1 btn c-btn-uppercase c-btn-bold c-btn-slim c-btn-border-2x c-btn-square c-btn-signup">Đăng ký ngay!</a>
            </div>
        </div>
    </div>
</div><!-- END: CONTENT/USER/FORGET-PASSWORD-FORM -->
    <!-- BEGIN: CONTENT/USER/SIGNUP-FORM -->
<div class="modal fade c-content-login-form" id="signup-form" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content c-square">
            <div class="modal-header c-no-border">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
            </div>
            <div class="modal-body">
                <h3 class="c-font-24 c-font-sbold">Đăng ký tài khoản</h3>
                <p>Vui lòng điền đầy đủ thông tin sau để tạo tài khoản mới</p>
                <p>
                    @if(isset($error_reg))
                        error {{ $error_reg }}
                    @endif
                </p>
                <form class="frm_quick_register" method="post" action="{{ url('register') }}">
                    {{ csrf_field() }}
                    <div class="form-group">
                        <label for="signup-email" class="hide">Email</label>
                        <input type="email" class="form-control input-lg c-square" placeholder="Email" name="email" required="true">
                    </div>
                    <div class="form-group">
                        <label for="signup-username" class="hide">Điện thoại</label>
                        <input type="text" class="form-control input-lg c-square" placeholder="Điện thoại" name="phone" required="true">
                    </div>
                    <div class="form-group">
                        <label for="signup-fullname" class="hide">Họ</label>
                        <input type="text" class="form-control input-lg c-square" placeholder="Họ" name="lastname">
                    </div>
                    <div class="form-group">
                        <label for="signup-fullname" class="hide">Tên</label>
                        <input type="text" class="form-control input-lg c-square" placeholder="Tên" name="fistname">
                    </div>
                    <div class="form-group">
                        <label for="signup-fullname" class="hide">Mật khẩu</label>
                        <input type="password" class="form-control input-lg c-square" placeholder="Mật khẩu" name="password" required="true">
                    </div>
                    <div class="form-group">
                        <label for="signup-fullname" class="hide">Nhập lại mật khẩu</label>
                        <input type="password" class="form-control input-lg c-square" placeholder="Nhập lại mật khẩu" name="c_password" required="true">
                    </div>
                    <div class="form-group">
                        <button type="submit" class="btn c-theme-btn btn-md c-btn-uppercase c-btn-bold c-btn-square c-btn-login">Xác nhận</button>
                        <a href="javascript:;" class="c-btn-forgot" data-toggle="modal" data-target="#login-form" data-dismiss="modal">Về đăng nhập</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div><!-- END: CONTENT/USER/SIGNUP-FORM -->
    <!-- BEGIN: CONTENT/USER/LOGIN-FORM -->
<div class="modal fade c-content-login-form" id="login-form" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content c-square">
            <div class="modal-header c-no-border">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
            </div>
            <div class="modal-body">
                <h3 class="c-font-24 c-font-sbold">Chào bạn!</h3>
                <p>Chúc bạn có một ngày thật ý nghĩa!</p>
                <form class="login-form" method="post" action="{{ url('postlogin') }}">
                    {{ csrf_field() }}
                    <div class="form-group">
                        <label for="login-email" class="hide">Email</label>
                        <input type="email" class="form-control input-lg c-square login-email" id="login-email" name="email" placeholder="Email">
                    </div>
                    <div class="form-group">
                        <label for="login-password" class="hide">Mật khẩu</label>
                        <input type="password" class="form-control input-lg c-square login-password" id="login-password" name="password" placeholder="Password">
                    </div>
                    <div class="form-group">
                        <div class="c-checkbox">
                            <input type="checkbox" id="login-rememberme" class="c-check" name="c-check">
                            <label for="login-rememberme" class="c-font-thin c-font-17">
                                <span></span>
                                <span class="check"></span>
                                <span class="box"></span>
                                Ghi nhớ
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <button type="submit" class="btn c-theme-btn btn-md c-btn-uppercase c-btn-bold c-btn-square c-btn-login">Đăng nhập</button>
                        <a href="javascript:;" data-toggle="modal" data-target="#forget-password-form" data-dismiss="modal" class="c-btn-forgot">Quên mật khẩu ?</a>
                    </div>
                </form>
            </div>
            <div class="modal-footer c-no-border">                
                <span class="c-text-account">Bạn chưa có tài khoản ?</span>
                <a href="javascript:;" data-toggle="modal" data-target="#signup-form" data-dismiss="modal" class="btn c-btn-dark-1 btn c-btn-uppercase c-btn-bold c-btn-slim c-btn-border-2x c-btn-square c-btn-signup">Đăng ký!</a>
            </div>
        </div>
    </div>
</div><!-- END: CONTENT/USER/LOGIN-FORM -->

    <!-- BEGIN: LAYOUT/SIDEBARS/QUICK-SIDEBAR -->
<nav class="c-layout-quick-sidebar">
    <div class="c-header">
        <button type="button" class="c-link c-close">
        <i class="icon-login"></i>      
        </button>
    </div>
    <div class="c-content">
        <div class="c-section">
            <h3>JANGO DEMOS</h3>
            <div class="c-settings c-demos c-bs-grid-reset-space">  
                
                       
            </div>
        </div>  
        
    </div>
</nav><!-- END: LAYOUT/SIDEBARS/QUICK-SIDEBAR