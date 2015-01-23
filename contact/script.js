$(document).ready(function () {
    $(".button-submit").click(function () {
        $(".button-submit").text("Please wait...");
        $(".button-submit").addClass("disabled");
        $("#form1")[0].submit();
    })
});