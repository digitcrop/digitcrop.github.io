/* Kolobok Emoticons For Blogger Threaded Comments
 * By Helplogger
 * Url: http://helplogger.blogspot.com
 */
a = document.getElementById('comment-holder');
if (a) {
	b = a.getElementsByTagName("p");
	for (i = 0; i < b.length; i++) {
		if (b.item(i).getAttribute('CLASS') == 'comment-content') { 
_str = b.item(i).innerHTML.replace(/:\)\)/gi, "<img src='http://2.bp.blogspot.com/-Ph2wxEvy2mc/UTIr8-fdHjI/AAAAAAAABAo/3use2PsPhMA/s1600/taunt.gif' alt='' class='smiley'/>");
_str = _str.replace(/:\)/gi, "<img src='http://1.bp.blogspot.com/-UqwtQ2vN2Kc/U31WSJiAdyI/AAAAAAAABss/V3BRedy4Mr0/s1600/smile3.gif' alt='' class='smiley'/>"); 
b.item(i).innerHTML = _str; 
} 
} 
}
