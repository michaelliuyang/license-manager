function initAdmin() {
	if($('#userAdmin').val() == 'true')
		$('#user_is_admin_1').attr('checked', 'checked');
	else
		$('#user_is_admin_0').attr('checked', 'checked');
}

function initLock() {
	if($('#userLock').val() == 'true')
		$('#user_is_lock_1').attr('checked', 'checked');
	else
		$('#user_is_lock_0').attr('checked', 'checked');
}

function userExist() {
	var isExist = false;
	$.ajax({
		type : 'POST',
		url : '/users/exist',
		data : 'login_name=' + $('#user_login_name').val(),
		async : false,
		success : function(msg) {
			if($.trim(msg) == 'exist') {
				isExist = true;
			}
		}
	});
	return isExist;
}

function checkUser() {
	var reg_email = /^([a-zA-Z0-9_-])+@([a-zA-Z0-9_-])+(.[a-zA-Z0-9_-])+/;
	var msg = '';
	var flag = false;
	if($('#user_login_name').val() == "")
		msg = '用户名不能为空';
	else if(userExist())
		msg = '该用户已存在';
	else if($('#user_password').length != 0 && $('#user_password').val() == "")
		msg = '密码不能为空';
	else if($('#user_password').length != 0 && ($('#user_password').val().length < 6 || $('#user_password').val().length > 20))
		msg = '密码长度为6到20个字符';
	else if($('#user_password').length != 0 && ($('#user_password').val() != $('#user_password_confirmation').val()))
		msg = '两次输入的密码必须相同';
	else if($('#user_name').val() == "")
		msg = '姓名不能为空';
	else if(!reg_email.test($('#user_email').val()))
		msg = '电子邮件格式错误';
	if(msg != '') {
		$('.block .message p').html(msg);
		$('.block .message').fadeIn('slow');
	} else {
		flag = true;
	}
	return flag;
}


$('form').submit(function() {
	return checkUser();
});

$(document).ready(function() {
	if($('#userAdmin').length != 0)
		initAdmin();
	if($('#userLock').length != 0)
		initLock();
});
