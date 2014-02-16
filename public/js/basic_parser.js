
var request = new XMLHttpRequest();
//var url = "http://www.google.com/alerts/feeds/01662123773360489091/17860385030804394525"
request.open('GET', 'xml/data.xml');
request.onreadystatechange = function() {
    if ((request.readyState===4) && (request.status===200)) {       
       // console.log(request.responseXML);
        console.log(request.responseXML.getElementsByTagName("link")[1].getAttribute("href"));
       if(request.status ===200){
            var items = request.responseXML.getElementsByTagName("entry");
            var output = '<ul>';
            for(var i=1;i<items.length;i++){
                output+='<li><a href='+items[i].getElementsByTagName("link")[0].getAttribute("href")+'>'
                +items[i].getElementsByTagName("title")[0].firstChild.nodeValue+'</a></li>';
            }
            output+='</ul>';
           // document.writeln(request.responseText);
           document.getElementById("update").innerHTML = output;
      }
    }
}
request.send();
