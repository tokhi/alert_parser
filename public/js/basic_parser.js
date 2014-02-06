$(document).ready(function(){
    $.ajax({
        type: "GET",
        url: "books.xml",
        dataType: "xml",
        success: function(xml) {
            $(xml).find('book').each(function(){
               // var id = $(this).attr('id');
                var title = $(this).find('title').text();
                var description = $(this).find('description').text();
                $('<div class="items" id="link_'+id+'"></div>').html('<a href="#">'+title+'</a>').appendTo('#page-wrap');
                
            });
        }
    });
});