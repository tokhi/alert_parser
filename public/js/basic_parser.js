
var request = new XMLHttpRequest();
//var url = "http://www.google.com/alerts/feeds/01662123773360489091/17860385030804394525"
request.open('GET', 'xml/data.xml');
request.onreadystatechange = function() {
    if ((request.readyState===4) && (request.status===200)) {
        console.log(request);
        document.writeln(request.responseText);
    }
}
request.send();
