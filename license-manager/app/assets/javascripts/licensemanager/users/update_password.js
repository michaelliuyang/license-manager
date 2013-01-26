function validateCurrentPwd(){
		var isRight = false;
		$.ajax({
			type: 'POST',
			url: '/users/'+$('#userId').val()+'/validate_password',
			data: 'current_pwd=' + $('#current_pwd').val(),
			async: false,
			success: function(msg){
				if(msg == 'true')
					isRight = true;
			}
		});
		return isRight;
	}
	
	$('form').submit(function(){
		var msg = '';
		var current_pwd = $('#current_pwd').val();
		var new_pwd = $('#new_pwd').val();
	    var confirm_pwd = $('#password_confirmation').val();
		if(current_pwd == "")
			msg = '密码不能为空';
		else if(!validateCurrentPwd())
			msg = '输入的当前密码错误';
		else if(new_pwd == '')
			msg = '密码不能为空';
		else if(new_pwd.length < 6 || new_pwd.length > 20)
			msg = '密码长度为6到20个字符';
		else if(confirm_pwd != new_pwd)
			msg = '两次输入的密码必须相同';
		if(msg != ''){
			$('.block .message p').html(msg);
			$('.block .message').fadeIn('slow');
			return false;
		}
		return true;
	});