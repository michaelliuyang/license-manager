function jarsExist() {
	var isExist = false;
	$.ajax({
		type : 'POST',
		url : '/licenses/exist_jars',
		data : 'version=' + $("select[name='license[version]']").val(),
		async : false,
		success : function(msg) {
			if($.trim(msg) == 'true') {
				isExist = true;
			}
		}
	});
	return isExist;
}

function checkLicense() {
	msg = regLicenseLocalCheck();
	flag = false;
	if($('#license_custom_name').val() == '')
		msg = '客户名称不能为空';
	else if($('#license_user_number').val() == '')
		msg = '最大并发数不能为空';
	else if(!jarsExist())
		msg = 'License路径下没有此版本的jar包';
	if(msg != '') {
		$('.block .message p').html(msg);
		$('.block .message').fadeIn('slow');
	} else {
		$("input[type='checkbox']:disabled").removeAttr('disabled');
		flag = true;
	}
	return flag;
}

function regLicenseLocalCheck() {
	regLocalCheckMac = /[A-F\d]{2}-[A-F\d]{2}-[A-F\d]{2}-[A-F\d]{2}-[A-F\d]{2}-[A-F\d]{2}/i;
	regLocalCheckIp = /^([1-9]|[1-9]\d|1\d{2}|2[0-1]\d|22[0-3])(\.(\d|[1-9]\d|1\d{2}|2[0-4]\d|25[0-5])){3}$/;
	var local_check_type = $("#license_local_check_type").val();
	var str = '';
	if(local_check_type == 'IP_LOCAL_CHECK') 
		str = regLocalCheckIp.test($("#license_local_check").val()) == false ? 'IP地址格式错误' : '';
	else if(local_check_type == 'MAC_LOCAL_CHECK')
		str = regLocalCheckMac.test($("#license_local_check").val()) == false ? 'MAC地址格式错误' : '';
	return str;
}

function changeGjbLevel(){
	var selected = $("#license_gjb_level").val();
	if(selected == '2'){
		$("#doc").removeAttr('checked');
	}else if(selected == '3'){
		$("#doc").attr('checked','checked');
	}
}

function changeVersion(){
	if($("#license_version").val() == '5.5'){
		$("#license_gjb_level option[value='2']").remove();
		$("#license_gjb_level").click();
	}else if($("#license_version").val() == '5.8'){
		if($("#license_gjb_level option[value='2']").length == 0){
			$("#license_gjb_level").prepend("<option value='2'>二级</option>");
		}
	}
}

$(document).ready(function() {
	changeVersion();
	changeGjbLevel();
	$('#license_gjb_level').change(function(){
		changeGjbLevel();
	});
	$('#license_local_check_type').change(function() {
		if($(this).val() == 'NO_LOCAL_CHECK') {
			$('#license_local_check').attr('disabled', 'disabled');
			$('#local_check_p').fadeOut('slow');
		} else {
			var text = $(this).val() == 'IP_LOCAL_CHECK' ? 'IP地址' : 'MAC地址'
			$('#license_local_check').removeAttr('disabled');
			$('#local_check_p label').text(text);
			$('#local_check_p').fadeIn('slow');
		}
	});
	$('#license_version').change(function(){
		changeVersion();
	});
	$('.block form').submit(function() {
		return checkLicense();
	});
});
