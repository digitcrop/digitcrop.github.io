/* Kolobok Emoticons For Blogger Threaded Comments
 * By Helplogger
 * Url: http://helplogger.blogspot.com
 */
a = document.getElementById('comment-holder');
if (a) {
	b = a.getElementsByTagName("p");
	for (i = 0; i < b.length; i++) {
		if (b.item(i).getAttribute('CLASS') == 'comment-content') { 
_str = _str.replace(/:\)/gi, "<img src='http://1.bp.blogspot.com/-UqwtQ2vN2Kc/U31WSJiAdyI/AAAAAAAABss/V3BRedy4Mr0/s1600/smile3.gif' alt='' class='smiley'/>"); 
b.item(i).innerHTML = _str; 
} 
} 
}
