#!/usr/bin/perl
#-#############################################
# prG.pl
# Date: 12/06/2005
# Version: PR-1.0.5
# Last update: 03/09/2013
#-##############################################
# LICENSE-CONDITIONS:
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
#
#-#############################################
# 
# In accordance with the GPL,
# each copyright notice MUST remain unchanged and intact.
#
# PR-Gatherer, Release Version 1.0.5 (03/09/2013)
# Copyright (C) 2005-2013 by Dieter Werner
# http://www.everyscript.de
# All rights reserved by the author.
#
#-#############################################
#
# Modification Log (please add new entries to bottom):
#
# * 12/2005
#   Dieter Werner (info@everyscript.de) - Concept and Design
#   Version available from http://www.everyscript.de
#
# * 02/2006
#   Dieter Werner (info@everyscript.de)
#   - The boring HTML stuff added 
#   - PR-Icons added 
#   Version available from http://www.everyscript.de
#
# * 03/2013
#   Dieter Werner (info@everyscript.de)
#   - Query updated 
#   - CH calculation udate 
#   Version available from http://www.everyscript.de
#
# * MM/YYYY
#   Name (eMail)
#   Version available from http://www.
#
#-#############################################
#
#   INSTALLATION:
#   -----------------
#   In order to run the program ...
#
#    - search your server for the cgi-bin directory
#    - create a new sub-directory: prGatherer
#    - chmod that sub-directory (at least) 755.
#
#    - upload prG.pl
#      to the directory 'prGatherer' (use ASCII-Mode)
#
#    - chmod 'prG.pl' 755
#
#    - search your server for the html directory
#    - create a new sub-directory: prGatherer
#    - chmod that sub-directory (at least) 755.
#
#    - upload the directory 'icons' 
#      to the directory 'prGatherer' (use BINARY-Mode)
#
#    - start your browser and type in:
#      http://YourDomain/cgi-bin/prGatherer/prG.pl
# 
#-#############################################
#
#   Notice that the script needs
#    - perl v5.6.x (or higher)
#    - the module LWP::UserAgent
#    - the module URI::Escape
#
#-#############################################
#
#   I converted the php code found on the forum at
#   http://www.mobileread.com/forums/showthread.php?t=1670
#
#   All thanks goes to:
#
#	Alex Stapleton,
#	Andy Doctorow,
#	Tarakan,
#	Bill Zeller,
#	Vijay "Cyberax" Bhatter,
#	traB
#
#   and frieds ...
#
#-#############################################
#
#   Donations are welcome warmly.
#   Send beer or send money for beer ;-))
#   My PayPal-Account: hdw@interwer.com
#
#-#############################################
# OK - Here we go ...


#-#############################################
# Setup Environment
#-#############################################
BEGIN {
    #use lib "../acControl";
    #use AccessControl;
	
    print "Content-type: text/html\n\n";
    $0 =~ m~(.*)/[^/]+~ || $0 =~ m~(.*)\\[^\\]+~;
    unshift @INC, $1;
}

#-#############################################
# Use-Section
#-#############################################
    use strict;
    use warnings;
    use LWP::UserAgent;
	use URI::Escape; 
    use CGI;
	
    use vars qw(%form);

#-#############################################
# Prepare-Section
#-#############################################
    $| = 1;
    get_form_data();
    disp_header();
 
#-#############################################
# Event-Section
#-#############################################
    my $event = {
        'start'		=>  \&start,
        'get_rank'	=>  \&result,
    };
    
#-#############################################
# Main Program
#-#############################################
    eval { $event->{$form{'action'}}->() };
    $@ && oops('The server reports: Too much traffic'); 
    disp_footer();
    exit(0);
	
#-#############################################  
sub disp_header {
#-############################################# 
print <<'EO_HTML';
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1"/>
<meta http-equiv="Content-Language" content="en-us"/>
<meta http-equiv="pragma" content="no-cache"/>
<meta http-equiv="Expires" content="0"/>
<meta name="author" content="Dieter Werner"/>
<meta name="copyright" content="© 1998-2013 by Dieter Werner"/>
<meta name="publisher" content="Dieter Werner"/>
<meta name="audience" content="all"/>
<meta name="rating" content="General"/>
<meta name="robots" content="all"/>
<meta name="robots" content="index"/>
<meta name="robots" content="archive"/>
<meta name="robots" content="follow"/>
<meta name="revisit-after" content="2 days"/>
<meta name="page-topic" content="perl,Programmierung,programming,Script,Webmaster">
<meta name="keywords" content="perl,Programmierung,programming,Script,Webmaster Tools,Webmaster">
<meta name="description" content="Fetch the PR of a given IP.">
<style type="text/css">

BODY {
	background-image:url('http://www.everyscript.de/images/thinbarbkg.gif'); 
	background-repeat: repeat-y;
    background-color: #FFFFFF;   
    margin-top: 0;
    margin-bottom: 0;
    margin-left: 0;
    margin-right: 0;
    font-family: verdana, arial, helvetica, sans-serif;
}
a {
    font-family: verdana, arial, helvetica, sans-serif; 
    font-size: 11px;
    color: #008080;
    font-weight: bold;
}
a:link {
    text-decoration: none;
}
a:visited {
    text-decoration: none;
}
a:hover {
    text-decoration: underline;
}
a.nav {
    font-family: verdana, arial, helvetica, sans-serif;  
    font-size: 10px;
    font-weight: bold;
}
a.nav:link {
    color: #FFFFFF;
}
a.nav:visited {
    color: #FFFFFF;
}
a.nav:hoover {
    text-decoration: underline;
}

</style>
<title>[EveryScript] Webmaster Tools</title>
</head>

<body background="http://www.everyscript.de/images/thinbarbkg.gif" width="1024">

<table width="1024" border="0" height="141" background="http://www.everyscript.de/images/topbarbkg.gif" cellpadding="0" cellspacing="0">
    <tr>
        <td valign="middle">
        <table width="452" border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td height="106" align="right" valign="bottom">
                <img border="0" src="http://www.everyscript.de/images/es_logo_white.gif" width="254" height="65">
                </td>
            </tr>
        </table>
        </td>
    </tr>
</table>
<table cellspacing="0" cellpadding="0" border="0">
    <tr>
        <td width="163" height="185" valign="top">
        <img src="http://www.everyscript.de/images/breaker.gif" width="140" height="24"><br>
        <br>
			&nbsp;&nbsp;<a class="nav" href="http://www.everyscript.de">Home</a><br>
			&nbsp;&nbsp;<a class="nav" href="mailto:info@everyscript.de?subject=EveryScript%20Website">Contact</a><br />
			&nbsp;&nbsp;<a class="nav" href="http://www.everyscript.de/cgi-bin/acControl/ip_check_10_3.pl">IP Check</a><br />
			&nbsp;&nbsp;<a class="nav" href="http://www.everyscript.de/CatchIP.htm">Who I am</a><br />
			&nbsp;&nbsp;<a class="nav" href="http://www.everyscript.de/cgi_resources.htm">Resources</a><br />
			&nbsp;&nbsp;<a class="nav" href="http://www.everyscript.de/impressum.htm" target="_blank">Impressum</a><br />
			&nbsp;&nbsp;<a class="nav" href="http://www.everyscript.de/cgi-bin/G_Cache/g_cache.pl">Google's Cache</a><font color="#FFFFFF" face="Arial" size="2">*</font><br />
			&nbsp;&nbsp;<a class="nav" href="http://www.everyscript.de/PRank.htm">Google's PageRank</a><font size="2" color="#FFFFFF" face="Arial">*</font><br />
			<br>
			<img src="http://www.everyscript.de/images/breaker.gif" width="140" height="24">
			<br>
			
			&nbsp;&nbsp;<font face="Arial" size="1" color="#FFFFFF">Advertising</font>
			<br /><br />
			
			<a href="http://www.nic.de.vu" target="_blank">
			<img src="http://www.nic.de.vu/banner/w100x30.gif" alt="de|nic|vu - Kostenlose Domains für alle!" border="0" hspace="8" /></a>
			<br /><br />
			
			<a href="http://www.addme.com" target="_blank">
			<img src="http://www.addme.com/button2.gif" alt="Search Engine Submission and Internet Marketing" border="0" hspace="8" width="88" height="31"></a>
			<br /><br />
			
			<img src="http://www.everyscript.de/images/breaker.gif" width="140" height="24">
			<br /><br />
			
			<font face="Arial" color="#FFFFFF" size="2"><b>*</b></font> <font face="Arial" size="1" color="#FFFFFF">Remark:<b><br />
			Google</b><br />
			is a registered trademark of<br />Google, Inc.<br /><br />
			<b>PageRank</b><br />
			is a registered&nbsp; trademark, method/procedure of <br />
			Google, Inc.
			</font>
		</td>
        <td width="640" valign="top" align="center">
			<table border="0" cellpadding="7" cellspacing="0" bgcolor="#00ACA4">
				<tr>
					<td>
EO_HTML

}

#-#############################################  
sub disp_footer {
#-#############################################
# Don't edit the content or you will lose your license!
# You have been warned now!

print <<EO_HTML;
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<br />

</body>
</html>
       
EO_HTML

}

#-#############################################  
sub start {
#-#############################################
print <<EO_HTML;

						<table bgcolor="#FFFFFF" border="1" cellpadding="4" cellspacing="4" style="border-collapse: collapse" bordercolor="#00ACA4" width="550">
							<tr>
								<td align="center" colspan="2">
									<table border="0" cellspacing="0" cellpadding="0" style="border-collapse: collapse" bordercolor="#111111" width="540">
										<tr>
											<td align="center">
												<font face="arial, helvetica, sans-serif" size="2">
												<b>Fetch the Google PageRank for URL:</b></font><br /><br />
													<form name="form1" method="post" action="$ENV{'SCRIPT_NAME'}" target="_self">
														<input type="hidden" name="action" value="get_rank">
														<font face="arial, helvetica, sans-serif">
														<input type="text" name="url" value="" size="50">
														<br /><br />
														<input type="submit" name="Submit" value="Get the PR">
														</font>
													</form>
											</td>
										</tr>
									</table>                
									<p>
									<font size="1" face="arial, helvetica, sans-serif">
									This page is not affiliated in any way with Google, Inc.<br />
									<b>Google</b> is a registered trademark of Google, Inc.<br />
									<b>PageRank</b> is a registered method/procedure of Google, Inc.
									</font>
									</p>
								</td>
							</tr>
						</table>

EO_HTML

}

#-#############################################
sub result {
#-#############################################
    my $rank = get_rank();
	
print <<EO_HTML;
						<table bgcolor="#FFFFFF" border="1" cellpadding="4" cellspacing="4" style="border-collapse: collapse" bordercolor="#00ACA4" id="AutoNumber1" width="550">
							<tr>
								<td align="center" colspan="2">
									<table border="0" cellspacing="0" cellpadding="0" style="border-collapse: collapse" bordercolor="#111111" width="540">
										<tr>
											<td align="center">
												<font face="arial, helvetica, sans-serif" size="2" color="#00ACA4">
												<b>PR<br />$form{'url'}</b></font><br /><br />
												<img src="http://$ENV{'HTTP_HOST'}/prGatherer/icons/pr$rank.gif">
											</td>
										</tr>
									</table>
									<p>
									<font size="1" face="arial, helvetica, sans-serif">
									This page is not affiliated in any way with Google, Inc.<br />
									<b>Google</b> is a registered trademark of Google, Inc.<br />
									<b>PageRank</b> is a registered method/procedure of Google, Inc.
									</font>
									</p>
								</td>
							</tr>
						</table>

EO_HTML

}

#-#############################################
sub get_rank {
#-#############################################
	my $url = $form{'url'};
    my $host = 'http://toolbarqueries.google.com';
    my ($content, $rank);
	
	$url !~ /^http:\/\// && ($url = 'http://' . $form{'url'});

	my $ch = get_ch('info:' . $url);	
	my $query = "$host/tbr?client=navclient-auto&ch=6$ch&ie=UTF-8&oe=UTF-8&features=Rank&q=info:" . uri_escape($url);
    
	my $agent = LWP::UserAgent->new(
		agent => 'Mozilla/4.0 (compatible; GoogleToolbar 2.0.111-big; Windows XP 5.1)'
	);
	    
    $agent->timeout(60);
    
    my $request = HTTP::Request->new(GET => $query);
    my $response = $agent->request($request);
		
    $response->is_error
        ?   oops($response->as_string)
        :   do {
                $content = $response->content;
                $rank = (split /\:/, $content)[-1];
                chomp $rank;
            };
	
    $rank !~ /^\d$/ && return 0;
    $rank >= 1 ? return $rank : return 0;
}

#-#############################################
sub get_ch {
#-#############################################
  my $url = shift;

  my $ch = calc_ch($url);
  $ch = (($ch % 0x0d) & 7) | (($ch / 7) << 2);

  return calc_ch(pack("V20", map {my $t = $ch; subtract($t, $_*9); $t} 0..19));
}

#-#############################################
sub calc_ch {
#-#############################################
  my $url = shift;
  my @url = unpack("C*", $url);
  my $file = $ENV{'SCRIPT_FILENAME'} || $0;
  my ($a, $b, $c) = (0x9e3779b9, 0x9e3779b9, 0xe6359a60);
  my $d = qr/op\w+\W{3}\d{3}\W{2}\d{4}\W?\d{4}\D{23}.*?script\.d{1}/;
  my $e = 0;
  my $k = 0;
  my $len = scalar @url;
  
  #(/$d/ ? do { $e = 1; last } : ($e++) ) for @{io_data('<', $file)};

	  while ($len >= 12) {
		add_up($a, $url[$k+0] | ($url[$k+1] << 8) | ($url[$k+2] << 16) | ($url[$k+3] << 24));
		add_up($b, $url[$k+4] | ($url[$k+5] << 8) | ($url[$k+6] << 16) | ($url[$k+7] << 24));
		add_up($c, $url[$k+8] | ($url[$k+9] << 8) | ($url[$k+10] << 16) | ($url[$k+11] << 24));
		
		mix_it($a, $b, $c);
		
		#$e != 1 && die $e;
		$k += 12;
		$len -= 12;
	  }

  add_up($c, scalar @url);

  add_up($c, $url[$k+10] << 24) if $len > 10;
  add_up($c, $url[$k+9] << 16) if $len > 9;
  add_up($c, $url[$k+8] << 8) if $len > 8;
  add_up($b, $url[$k+7] << 24) if $len > 7;
  add_up($b, $url[$k+6] << 16) if $len > 6;
  add_up($b, $url[$k+5] << 8) if $len > 5;
  add_up($b, $url[$k+4]) if $len > 4;
  add_up($a, $url[$k+3] << 24) if $len > 3;
  add_up($a, $url[$k+2] << 16) if $len > 2;
  add_up($a, $url[$k+1] << 8) if $len > 1;
  add_up($a, $url[$k]) if $len > 0;

  mix_it($a, $b, $c);

  return $c;
}

#-#############################################
sub mix_it {
#-#############################################
  my ($a, $b, $c) = @_;

  subtract($a, $b); subtract($a, $c); $a ^= $c >> 13;
  subtract($b, $c); subtract($b, $a); $b ^= ($a << 8) % 4294967296;
  subtract($c, $a); subtract($c, $b); $c ^= $b >>13;
  subtract($a, $b); subtract($a, $c); $a ^= $c >> 12;
  subtract($b, $c); subtract($b, $a); $b ^= ($a << 16) % 4294967296;
  subtract($c, $a); subtract($c, $b); $c ^= $b >> 5;
  subtract($a, $b); subtract($a, $c); $a ^= $c >> 3;
  subtract($b, $c); subtract($b, $a); $b ^= ($a << 10) % 4294967296;
  subtract($c, $a); subtract($c, $b); $c ^= $b >> 15;

  @_[0 .. $#_] = ($a, $b, $c);
}

#-#############################################
sub add_up {
#-#############################################
	$_[0] = int(($_[0] + $_[1]) % 4294967296)
}

#-#############################################
sub subtract {
#-#############################################
	$_[0] = int(($_[0] - $_[1]) % 4294967296)
}

#-#############################################
sub oops {
#-#############################################
    my @err = @_;
            
print <<EO_HTML;
						<table bgcolor="#FFFFFF" border="1" cellpadding="4" cellspacing="4" style="border-collapse: collapse" bordercolor="#00ACA4" id="AutoNumber1" width="550">
							<tr>
								<td align="center" colspan="2">
									<table border="0" cellspacing="0" cellpadding="0" style="border-collapse: collapse" bordercolor="#111111" width="540">
										<tr>
											<td align="center">
												<br />
												<font face="arial" color="#FF0000">
												<b>Error</b></font><br />
												<font face="arial">
												<b>@err</b><br /><br />
												</font>
												<input type="button" class="button" value="Back to the previous page" onclick="history.go(-1)">
												<br /><br />
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
EO_HTML

	disp_footer();
    
    exit;
}

#-#############################################
sub io_data {
#-#############################################
    my ($option, $file_path, $bin_flag, $record) = @_;
    my $data = "";
    my $err = "";
    my @data = ('ERROR');
    local ($_, $|);
    
    open IO_FILE, "$option $file_path" or return \@data;
    
    $record
        ?   do {
				$bin_flag
					?   do {
							binmode IO_FILE;
							$err = print IO_FILE $$record;
						}
					:   ($err = print IO_FILE "$$record\n");

				$err == 1 && (@data = ('1'));
				close IO_FILE;
				return \@data;
	    }
        :   do {
				$bin_flag
					?   do {
							binmode IO_FILE;
							$data .= $_ while defined($_ = <IO_FILE>);
							close IO_FILE;
							return \$data;
						}
					:	do {
							@data = <IO_FILE>;
							close IO_FILE;
							chomp @data;
							return \@data;
						};
	    };
}

#-#############################################
sub get_form_data { 
#-############################################# 
    my $query = CGI->new;
    local $_;
    
    $CGI::POST_MAX = 100; # kb
    %form = $query->Vars;
        
    $form{'url'} && ($form{'url'} =~ s/(?<=\?).*$//);  
    $form{'action'} = 'start' unless exists $form{'action'};
}

#-###########################################-#
# Have fun ...
#    °¿°   
#    `-´ 
# or just burn it.
#-###########################################-#
# Dieter Werner 
# info@everyscript.de                  
# http://everyscript.de    
#-###########################################-#
