var request = new XMLHttpRequest();
var google_url = "https://www.google.com/url?q=";
//var url = "http://www.google.com/alerts/feeds/01662123773360489091/17860385030804394525"
request.open('GET', 'xml/data.xml');
request.onreadystatechange = function() {
    if ((request.readyState === 4) && (request.status === 200)) {
        // console.log(request.responseXML);
        console.log(request.responseXML.getElementsByTagName("link")[1].getAttribute("href"));
        if (request.status === 200) {
            var items = request.responseXML.getElementsByTagName("entry");
            var output = '';
            for (var i = 1; i < items.length; i++) {
                output += '<div class="row"><div class="col-xs-12"><h4><a href=' +
                    items[i].getElementsByTagName("link")[0].getAttribute("href") + ' target="_blank">' + items[i].getElementsByTagName("title")[0].firstChild.nodeValue + '</a></h4><p>' +
                    items[i].getElementsByTagName("content")[0].firstChild.nodeValue +
                    '</p></a><p class="pull-right"><span class="label label-default">Afg</span></p><ul class="list-inline"><li><div class="container"><div class="facebook-container" style="margin-left: 200px"><div class="fb-like" data-href=' +
                    items[i].getElementsByTagName("link")[0].getAttribute("href").replace(google_url, '') + ' data-layout="standard" data-action="like" data-show-faces="true" data-share="true"></div></div></div></li></ul></div></div><hr>';
            }
            output += '</div></div><hr>';
            // document.writeln(request.responseText);

            document.getElementById("center_alerts").innerHTML = output;
        }
    }
}
request.send();