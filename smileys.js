a = document.getElementById('comment-holder');
if (a) {
	b = a.getElementsByTagName("p");
	for (i = 0; i < b.length; i++) {
		if (b.item(i).getAttribute('CLASS') == 'comment-content') { 
_str = b.item(i).innerHTML.replace(/:d/gi, "<img src='http://4.bp.blogspot.com/-lhTywmMZ58E/UTI04kjJ3WI/AAAAAAAABDY/qNgtijEr_E8/s1600/biggrin.gif' alt='' class='smiley'/>");   
_str = _str.replace(/:\)/gi, "<img src='http://1.bp.blogspot.com/-081QtoL7NXw/U32Q1OyivqI/AAAAAAAABt8/AJMQ6_G81zM/s1600/xxxxx.png' alt='' class='smiley'/>"); 
_str = _str.replace(/:\(/gi, "<img src='http://2.bp.blogspot.com/-XSBJ7zBZKZs/UTIrT-hMYyI/AAAAAAAABAY/6B26_8Ttwj4/s1600/sad.gif' alt='' class='smiley'/>"); 
_str = _str.replace(/-\y\)/gi, "<img src='http://1.bp.blogspot.com/-M38ua6B8t-s/U32KPkUChvI/AAAAAAAABtg/rBh4IVbQexs/s1600/like.png' alt='' class='smiley'/>"); 
b.item(i).innerHTML = _str; 
} 
} 
}
