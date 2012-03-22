function badBrowser(){
	if($.browser.msie && parseInt($.browser.version) <= 6){ return true;}
	
	return false;
}

function getBadBrowser(c_name)
{
	if (document.cookie.length>0)
	{
	c_start=document.cookie.indexOf(c_name + "=");
	if (c_start!=-1)
		{ 
		c_start=c_start + c_name.length+1; 
		c_end=document.cookie.indexOf(";",c_start);
		if (c_end==-1) c_end=document.cookie.length;
		return unescape(document.cookie.substring(c_start,c_end));
		} 
	}
	return "";
}	

function setBadBrowser(c_name,value,expiredays)
{
	var exdate=new Date();
	exdate.setDate(exdate.getDate()+expiredays);
	document.cookie=c_name+ "=" +escape(value) + ((expiredays==null) ? "" : ";expires="+exdate.toGMTString());
}

if(badBrowser() && getBadBrowser('browserWarning') != 'seen' ){
	$(function(){
		$("<div id='browserWarning'>You are using an unsafe & outdated browser. Please update to <a href='http://getfirefox.com'>FireFox</a>, <a href='http://www.opera.com/download/'>Opera</a>, <a href='http://www.apple.com/safari/'>Safari</a> or <a href='http://www.microsoft.com/windows/downloads/ie/getitnow.mspx'>Internet Explorer 7</a>. Thanks!&nbsp;&nbsp;&nbsp;[<a href='#' id='warningClose'>close</a>] </div> ")
			.css({
				backgroundColor: '#ef3e26',
				'width': '100%',
				'border-top': 'solid 1px #000',
				'border-bottom': 'solid 1px #000',
				'text-align': 'center',
				'color': '#ffffff',
				padding:'10px 0px 10px 0px'
			})
			.prependTo("body");
		
		$('#warningClose').click(function(){
			setBadBrowser('browserWarning','seen');
			$('#browserWarning').slideUp('slow');
			return false;
		});
	});	
}
