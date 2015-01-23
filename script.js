$(document).ready(function() {
	$.preLoadImages("/img/swap1.png","/img/swap2.png");
	$('.show-options').click(function() {
		if ($('.options').is(":visible")) {
			$('.options').slideUp(500);
			$('.show-options-icon').rotate({
				angle: 90,
				animateTo: 0,
                duration: 500
			});
		}
		else {
			$('.options').slideDown(500);
			$('.show-options-icon').rotate({
				angle: 0,
				animateTo: 90,
                duration: 500
			});
		}
	});
	$('.arrow').click(function() {
		var t=$('.text-from').val();
		$('.text-from').val($('.text-to').val());
		$('.text-to').val(t);
	});
	$('.random1').click(function () {
	    $('.random1').addClass("disabled");
	    $.getJSON("random.aspx?rand="+Math.random(), function (data) {
	        $('.text-from').val(data.rand);
	        $('.random1').removeClass("disabled");
	    });
	});
	$('.random2').click(function() {
	    $('.random2').addClass("disabled");
	    $.getJSON("random.aspx?rand="+Math.random(), function (data) {
	        $('.text-to').val(data.rand);
	        $('.random2').removeClass("disabled");
	    });
	});
	$(".button-submit").click(function () {
	    $(".button-submit").text("Please wait...");
	    $(".button-submit").addClass("disabled");
	    $("#form1")[0].submit();
	})
	if ($(".text-from").val()=="") {
		$(".help").hide();
		$(".help").slideDown(1000);
	}
});
$(window).on('pagehide',function() {
	$(".button-submit").text("Go »");
	$(".button-submit").removeClass("disabled");
});