$(document).ready(function () {
    $("#btn").click(function () {
        $.ajax({
            url: '/api/feature',
            data: {
                format: 'json'
            },
            error: function (jqXHR, textStatus, errorThrown) {
                $('#feature').html(textStatus);
            },
            // dataType: 'jsonp',
            success: function (data) {
                console.log(data)
                $("#feature").removeClass('is-danger')
                $("#feature").addClass('is-link')
                $("#feature").html('<b>' + data.feature + '</b></br>' + data.by + '</br><br>' + "Response from: " + data.from);
            },
            type: 'GET'
        })
    })
})
