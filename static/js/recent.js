$(document).ready(function(){
    $.ajax({
        type: "GET",
        url: "/api/discuss/recent",
        dataType: "JSON",
        success: function(j){
            jQuery.each(j.discusses, function(i, discuss){
                var item = $('<div class="span3 discuss"></div>');

                var number = $('<h1 class="discuss_id"></h1>');
                number.text('#' + discuss.id);

                var label = $('<h2 class="name"></h2>');
                label.text(discuss.name ? discuss.name : '(noname)');

                var post_by = $('<p></p>');
                post_by.text('by:' + discuss.post_by);

                var description = $('<p></p>');
                description.text(discuss.description);

                var button = $('<button></button>');
                button.attr('class', discuss.name ? 'btn btn-inverse' : 'btn btn-info');
                button.text('See Discuss');
                button.click(function(){
                    location.href = "/discuss/" + discuss.id;
                });

                item.attr('id', 'discuss' + discuss.id);

                item.append(number);
                item.append(label);
                item.append(description);
                item.append(post_by);
                item.append(button);

                $('#recent').append(item);
            });
        }
    });
});
