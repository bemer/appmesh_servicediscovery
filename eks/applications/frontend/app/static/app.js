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
                $("#feature").html(data.feature + '</br><b>' + data.by + '</b>');
            },
            type: 'GET'
        })
    })
})
