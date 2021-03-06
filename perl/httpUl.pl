#!/usr/bin/perl -w
#Ce script sert à lancer un test http upload
		#Définition des bibliothèques utilisées 
	#-----------------------------------------------------------------------------------------	
use strict;
use warnings;
use 5.012;
use CGI;
use URI::Escape;
use Carp; 
my $cgi = new CGI;
use utf8; 
 use HTML::Entities;
print "Content-Type: text/html \n\n";
use IO::Socket::INET;

#-----------------------------------------------------------------------------------------	
		#Définition des constantes utilsée
	#-----------------------------------------------------------------------------------------	

use constant false => 0;
use constant true  => 1;
#-----------------------------------------------------------------------------------------	
		#Définition des variables
	#-----------------------------------------------------------------------------------------	

my $param = $cgi->{param};
my $lab = $cgi->param('lab');

my $OptionH1 = $cgi->param('OptionH1');
my $OptionH1Text = $cgi->param('OptionH1Text');

my $OptionH2 = $cgi->param('OptionH2');
my $OptionH2Text = $cgi->param('OptionH2Text');

my $OptionChemin = $cgi->param('OptionChemin');
my $OptionCheminText = $cgi->param('OptionCheminText');

my $OptionM1 = $cgi->param('OptionM1');

my $OptionM100 = $cgi->param('OptionM100');

my $OptionG1 = $cgi->param('OptionG1');

my $Optionother = $cgi->param('Optionother');
my $file = $cgi->param('file');

my $Interface = $cgi->param('Interface');

my $value;
my $Options ;
my $size=0;
#-----------------------------------------------------------------------------------------	
		#Récupération des options du test
	#-----------------------------------------------------------------------------------------	

$Options = "wget -T 5 --post-file=\"/opt/lampp/htdocs/Qostrouble/Ul/";

if ($OptionH1 eq 'true') 
{
$Options = $Options . " --http-user=$OptionH1Text";
}

if ($OptionH2 eq 'true') 
{
$Options = $Options . " --http-password=$OptionH2Text";
}

if ($OptionM1 eq 'true') 
{
$Options = $Options . "1M\"";
}

if ($OptionM100 eq 'true') 
{
$Options = $Options . "100M\"";
}

if ($OptionG1 eq 'true') 
{
$Options = $Options . "1G\"";
}

if ($Optionother eq 'true') 
{
$Options = $Options . "$file\"";
}
if ($OptionChemin eq 'true') 
{
$Options = $Options . ' "' . "$lab$OptionCheminText" . 'm"' . " 2";
}
else
{
$Options = $Options . ' "' . "$lab" . 'm"' . " 2";
}


$Options = $Options . ' "' . "$lab" . 'm"' . " 2";

my $socket;
my $serverdata;
my $clientdata;
#-----------------------------------------------------------------------------------------	
		#Ouverture du port de communication avec le script serveur qui est chargé du lancement des tests
	#-----------------------------------------------------------------------------------------
$socket = new IO::Socket::INET (
  PeerHost => '127.0.0.1',
  PeerPort => '0160',
  Proto => 'tcp',
) or die "$!\n";


my $var = "";
#-----------------------------------------------------------------------------------------	
		#Envois de la commande avec les options
	#-----------------------------------------------------------------------------------------
print $socket "$Options";
shutdown($socket, 1);



$var = <$socket>; 
       
#-----------------------------------------------------------------------------------------	
		#Fermeture de la socket
	#-----------------------------------------------------------------------------------------


$socket->close();
 #-----------------------------------------------------------------------------------------	
		#Récupération des résultats du fichier temporaire et envois au Javascript
	#-----------------------------------------------------------------------------------------
my $filename = '/opt/lampp/htdocs/Qostrouble/resultats/tmp';
open(my $fh, '<:encoding(UTF-8)', $filename)
  or die "Could not open file '$filename' $!";
while (my $row = <$fh>) {
  chomp $row;
  print "$row\n";
}


$cgi->header('text/plain;charset=UTF-8');


