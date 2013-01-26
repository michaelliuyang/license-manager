$('form').submit(function() {
	login_name = $("#login_name").val();
	password = $("#password").val();
	if(login_name == null || login_name == "") {
		$('.block .message p').html('用户名不能为空');
		$('.block .message').fadeIn('slow');
		return false;
	}
	if(password == null || password == "") {
		$('.block .message p').html('密码不能为空');
		$('.block .message').fadeIn('slow');
		return false;
	}
	if(password.length < 6 || password.length > 20) {
		$('.block .message p').html('密码长度为6到20个字符');
		$('.block .message').fadeIn('slow');
		return false;
	}
	return true;
});
