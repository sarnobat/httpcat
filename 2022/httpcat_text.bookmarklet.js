javascript: if (document.URL.match('.*netgear.rohidekar.com.*')) {
    console.debug('accidental double click');
} else {
    var freetext = prompt("Task name");
    if (freetext != null && freetext.length > 0) {
      window.location.href = 'http://netgear.rohidekar.com/yurl/httpcat_text.html?url=' + encodeURIComponent(document.URL) + '&nodeId=45&freetext=' + encodeURIComponent(freetext);
    }
}
