#!/usr/bin/perl -T

use strict;
use warnings;
use CGI qw( :all -utf8 );
use Email::Valid;
use Time::Piece;

print header( -type => 'text/html',
	      -charset => 'utf-8' ) .
	start_html(
	-title => "Registracijos informacija",
	-style => {src => "../css/style1.css"});

# Kliento kontaktinė informacija
my $name = param('Vardas');
my $surname = param('Pavardė');
my $phone = param('Telefono_nr');
my $email = param('El_paštas');

# Vizito informacija
my $service_type = param('Norima_paslauga');
my $master = param('Norimas_meistras');
my $date = param('Data');
my $hour = param('Vizito_laikas');
my $timebefore = param('Laikas_prieš_vizitą');
my $timeafter = param('Laikas_po_vizito');

# Naudojimosi sąlygos ir naujienlaiškis
my $conditions = param('Naudojimosi_sąlygos');
my $newsletter = param('Naujienlaiškis');

# Papildoma informacija
my $other = param('Papildoma_informacija');

# Funkcija, kuri spausdina error pranešimus
sub error_handling{   
        my($error_message) = @_;
	print p($error_message) . end_html();
        exit;
}

# Patikrinimas ar laukeliai nėra tušti
for my $data (param()){
	if(param($data) eq "" & $data ne 'Papildoma_informacija'
		& $data ne 'Laikas_prieš_vizitą'
		& $data ne 'Laikas_po_vizito' & $data ne 'Naujienlaiškis'){
		print p("Prašome užpildyti '$data' laukelį.");
		print end_html();
		exit;
	}
}

#---Kontaktinės informacijos tikrinimas---#

# Vardo validacija
if($name =~ /(^\p{L}+$)/){
	$name = $1;
}
else{
	error_handling("Netinkamas vardo formatas.");
}

# Pavardės validacija
if($surname =~ /(^\p{L}+$)/){
	$surname = $1;
}
else {
	error_handling("Netinkamas pavardės formatas.");
}

# Telefono numerio validacija
if($phone =~ /^(86|\+3706)(\d{7}$)/){
	$phone = $1 . $2;
}
else{
	error_handling("Netinkamas telefono numerio formatas.");
}

# El. pašto validacija
unless(Email::Valid->address($email)){
	error_handling("Netinkamas elektroninio pašto formatas. ");
}


#--- Tikriname ar pasirinktos tinkamos reikšmės---#

# Procedūros pasirinkimai
if(!$service_type){
	error_handling("Nepasirinkta norima procedūra.");
}

use utf8;

unless($service_type eq "Moteriškas kirpimas"
	or $service_type eq "Vyriškas kirpimas"
	or $service_type eq "Vaikų kirpimas (1-12 m.)"
	or $service_type eq "Plaukų dažymas Ombre technika"
	or $service_type eq "Plaukų dažymas Balayage technika"
	or $service_type eq "Šaknų dažymas"
	or $service_type eq "Pilnas plaukų dažymas"
	or $service_type eq "Vestuvinė šukuosena"
	or $service_type eq "Antakių korekcija ir dažymas"
	or $service_type eq "Gelinis nagų lakavimas"
	or $service_type eq "Gelinis nagų priauginimas"
	or $service_type eq "Gelinių nagų korekcija"
	or $service_type eq "Higieninis manikiūras"
	or $service_type eq "Atpalaiduojantis viso kūno masažas"
	or $service_type eq "Klasikinis viso kūno masažas"
	or $service_type eq "Aromaterapinis masažas"
	or $service_type eq "Viso kūno pilingas")
{
	error_handling("Tokios norimos procedūros nėra.");
}


# Meistro pasirinkimai
if(!$master){
	error_handling("Nepasirinktas norimas meistras.");
}

unless($master eq "Bet kuris meistras"
	or $master eq "Ona Kavaliauskaitė"
	or $master eq "Rūta Janauskienė"
	or $master eq "Odeta Alinkaitė"
	or $master eq "Vilija Šabrauskienė"
	or $master eq "Aneta Lasauskaitė"
	or $master eq "Otilija Dambrauskienė"
	or $master eq "Gabija Velinskaitė"
	or $master eq "Goda Gilenovienė"
	or $master eq "Gabrielė Belikovaitė"
	or $master eq "Ernesta Šabrauskaitė"
	or $master eq "Emilija Einovienė"
	or $master eq "Neda Juozapavičiūtė")
{
	error_handling("Tokio meistro pasirinkimo nėra.");
}


# Datos pasirinkimai
if(!$date){
	error_handling("Nepasirinkote norimos vizito datos.");
}

# Tikrinimas ar klientas nepasirinko praėjusios datos
if($date =~ /^\d{4}-\d{2}-\d{2}$/){

	my $today_date = localtime-> strftime('%Y%m%d');
	my $c_date = Time::Piece-> strptime($date, "%Y-%m-%d");
	my $chosen_date = $c_date-> strftime('%Y%m%d');
	
	if($chosen_date < $today_date){
		error_handling("Netinkamas datos pasirinkimas, pasirinkote praėjusią dieną.");
	}
}
else{
	error_handling("Netinkamas datos formatas.");
}


# Laiko pasirinkimai
if(!$hour){
	error_handling("Nepasirinktas norimas procedūros laikas.");
}

if($hour eq "9:00"
	or $hour eq "10:00"
	or $hour eq "11:00"
	or $hour eq "12:00"
	or $hour eq "13:00"
	or $hour eq "14:00"
	or $hour eq "15:00"
	or $hour eq "16:00"
	or $hour eq "17:00"
	or $hour eq "18:00"
	or $hour eq "19:00")
{	
	# Paimame šiandienos datą ir pasirinktą datą 
	my $today_date = localtime-> strftime('%Y%m%d');
        my $c_date = Time::Piece-> strptime($date, "%Y-%m-%d");
        my $chosen_date = $c_date-> strftime('%Y%m%d');
	
	# Paimame dabartinį laiką ir pasirinktą laiką
	my $current_time = localtime -> strftime('%H%M');
	my $c_time = Time::Piece -> strptime($hour, "%H:%M");
	my $chosen_time = $c_time -> strftime('%H%M');
	
	# Jeigu klientas pasirinko šiandienos dieną
	# tikriname ar nepasirinko jau praėjusių valandų
	if($chosen_date == $today_date){
		if($chosen_time < $current_time){
			error_handling("Prašome pasirinkti vėlesnį laiką.");
		}
	}	
}
else {
	error_handling("Tokio laiko pasirinkimo nėra.");
}


# Laiko prieš pasirinkimai
if($timebefore ne ""){
	unless( $timebefore eq "15 minučių prieš nurodytą laiką"
		or $timebefore eq "30 minučių prieš nurodytą laiką"
		or $timebefore eq "45 minučių prieš nurodytą laiką"
		or $timebefore eq "1 valanda prieš nurodytą laiką"
		or $timebefore eq "1 valanda 15 minučių prieš nurodytą laiką"
		or $timebefore eq "1 valanda 30 minučių prieš nurodytą laiką"
		or $timebefore eq "1 valanda 45 minutės prieš nurodytą laiką"
		or $timebefore eq "2 valandos prieš nurodytą laiką"
		or $timebefore eq "Bet kada prieš nurodytą laiką")
	{
	error_handling("Nėra tokio laiko pasirinkimo prieš nurodytą procedūros laiką.");
	}
}


# Laiko po pasirinkimai
if($timeafter ne ""){
	unless($timeafter eq "15 minučių po nurodyto laiko"
		or $timeafter eq "30 minučių po nurodyto laiko"
		or $timeafter eq "45 minutės po nurodyto laiko"
		or $timeafter eq "1 valanda po nurodyto laiko"
		or $timeafter eq "1 valanda 15 minučių po nurodyto laiko"
		or $timeafter eq "1 valanda 30 minučių po nurodyto laiko"
		or $timeafter eq "1 valanda 45 minutės po nurodyto laiko"
		or $timeafter eq "2 valandos po nurodyto laiko"
		or $timeafter eq "Bet kada po nurodyto laiko")
	{
	error_handling("Nėra tokio laiko pasirinkimo po nurodyto procedūros laiko.");
	}
}

# Naudojimosi sąlygomis sutikimas
if(!$conditions){
	error_handling("Nepasirinkta, jog sutinkate su naudojimosi sąlygomis.");
}

unless($conditions eq "Taip"){
	error_handling("Privalote sutikti su naudojimosi sąlygomis.");
}

if($newsletter ne ""){
	unless($newsletter eq "Taip"){
		error_handling("Jei norite sutikti su naujienlaiškiu, prašome pateikti atsakymą - Taip.");
	}
}

# Leidimas naudoti tik tam tikrus simbolius papildomos informacijos lauke
if($other ne ""){
	unless($other =~ /^[\w\s\.,()!?;:"'-]+$/){
		error_handling("Prašome nenaudoti specialių simbolių papildomos informacijos laukelyje.");
	}
}


print h1('Jūsų registracija sėkminga!');
print h3('Artimiausiu metu jūsų registracija bus patvirtinta. Susisieksime su jumis jūsų nurodytu elektroniniu paštu.');
print h2('Jūsų pateikti duomenys:');

# Pateiktos informacijos spausdinimas
if($other ne "" 
	& $timebefore ne ""
	& $timeafter ne ""){
	print table({-class=>'registered'}, 
		"<tr><td>Vardas</td><td>$name</td></tr>".
		"<tr><td>Pavardė</td><td>$surname</td></tr>" . 
		"<tr><td>Telefono nr.</td><td>$phone</td></tr>" . 
 		"<tr><td>El. paštas</td><td>$email</td></tr>" . 
		"<tr><td>Paslauga</td><td>$service_type</td></tr>" . 
		"<tr><td>Meistras</td><td>$master</td></tr>" . 
		"<tr><td>Vizito data</td><td>$date</td></tr>" . 
		"<tr><td>Vizito laikas</td><td>$hour</td></tr>" . 
		"<tr><td>Galimas ankstesnis atvykimas</td><td>$timebefore</td></tr>" . 
		"<tr><td>Galimas vėlesnis atvykimas</td><td>$timeafter</td></tr>" . 
		"<tr><td>Papildoma informacija</td><td>$other</td></tr>"); 
}
if($other ne "" 
	& $timebefore eq ""
	& $timeafter eq ""){
	print table({-class=>'registered'},
                "<tr><td>Vardas</td><td>$name</td></tr>".
                "<tr><td>Pavardė</td><td>$surname</td></tr>" .
                "<tr><td>Telefono nr.</td><td>$phone</td></tr>" . 
                "<tr><td>El. paštas</td><td>$email</td></tr>" .
                "<tr><td>Paslauga</td><td>$service_type</td></tr>" .
                "<tr><td>Meistras</td><td>$master</td></tr>" .
                "<tr><td>Vizito data</td><td>$date</td></tr>" .
                "<tr><td>Vizito laikas</td><td>$hour</td></tr>" . 
                "<tr><td>Papildoma informacija</td><td>$other</td></tr>");
}
if($other ne "" 
	& $timebefore ne ""
	& $timeafter eq ""){
	print table({-class=>'registered'},
                "<tr><td>Vardas</td><td>$name</td></tr>".
                "<tr><td>Pavardė</td><td>$surname</td></tr>" .
                "<tr><td>Telefono nr.</td><td>$phone</td></tr>" . 
                "<tr><td>El. paštas</td><td>$email</td></tr>" .
                "<tr><td>Paslauga</td><td>$service_type</td></tr>" .
                "<tr><td>Meistras</td><td>$master</td></tr>" .
                "<tr><td>Vizito data</td><td>$date</td></tr>" .
                "<tr><td>Vizito laikas</td><td>$hour</td></tr>" . 
                "<tr><td>Galimas ankstesnis atvykimas</td><td>$timebefore</td></tr>" .
                "<tr><td>Papildoma informacija</td><td>$other</td></tr>");
}
if($other ne "" 
	& $timebefore eq ""
	& $timeafter ne ""){
	print table({-class=>'registered'},
                "<tr><td>Vardas</td><td>$name</td></tr>".
                "<tr><td>Pavardė</td><td>$surname</td></tr>" .
                "<tr><td>Telefono nr.</td><td>$phone</td></tr>" . 
                "<tr><td>El. paštas</td><td>$email</td></tr>" .
                "<tr><td>Paslauga</td><td>$service_type</td></tr>" .
                "<tr><td>Meistras</td><td>$master</td></tr>" .
                "<tr><td>Vizito data</td><td>$date</td></tr>" .
                "<tr><td>Vizito laikas</td><td>$hour</td></tr>" . 
                "<tr><td>Galimas vėlesnis atvykimas</td><td>$timeafter</td></tr>" .
                "<tr><td>Papildoma informacija</td><td>$other</td></tr>");
}
if($other eq "" 
	& $timebefore ne ""
	& $timeafter ne "") {	
	print table({-class=>'registered'},
                "<tr><td>Vardas</td><td>$name</td></tr>".
                "<tr><td>Pavardė</td><td>$surname</td></tr>" . 
                "<tr><td>Telefono nr.</td><td>$phone</td></tr>" .
                "<tr><td>El. paštas</td><td>$email</td></tr>" .
                "<tr><td>Paslauga</td><td>$service_type</td></tr>" .
                "<tr><td>Meistras</td><td>$master</td></tr>" .
                "<tr><td>Vizito data</td><td>$date</td></tr>" .
                "<tr><td>Vizito laikas</td><td>$hour</td></tr>" .
                "<tr><td>Galimas ankstesnis atvykimas</td><td>$timebefore</td></tr>" .
                "<tr><td>Galimas vėlesnis atvykimas</td><td>$timeafter</td></tr>");
}
if($other eq ""
	& $timebefore ne "" 
	& $timeafter eq ""){
	print table({-class=>'registered'},
                "<tr><td>Vardas</td><td>$name</td></tr>".
                "<tr><td>Pavardė</td><td>$surname</td></tr>" .
                "<tr><td>Telefono nr.</td><td>$phone</td></tr>" .
                "<tr><td>El. paštas</td><td>$email</td></tr>" .
                "<tr><td>Paslauga</td><td>$service_type</td></tr>" .
                "<tr><td>Meistras</td><td>$master</td></tr>" .
                "<tr><td>Vizito data</td><td>$date</td></tr>" .
                "<tr><td>Vizito laikas</td><td>$hour</td></tr>" .
                "<tr><td>Galimas ankstesnis atvykimas</td><td>$timebefore</td></tr>");
}
if($other eq ""
	& $timebefore eq ""
	& $timeafter ne ""){
	print table({-class=>'registered'},
                "<tr><td>Vardas</td><td>$name</td></tr>".
                "<tr><td>Pavardė</td><td>$surname</td></tr>" .
                "<tr><td>Telefono nr.</td><td>$phone</td></tr>" .
                "<tr><td>El. paštas</td><td>$email</td></tr>" .
                "<tr><td>Paslauga</td><td>$service_type</td></tr>" .
                "<tr><td>Meistras</td><td>$master</td></tr>" .
                "<tr><td>Vizito data</td><td>$date</td></tr>" .
                "<tr><td>Vizito laikas</td><td>$hour</td></tr>" .
                "<tr><td>Galimas vėlesnis atvykimas</td><td>$timeafter</td></tr>");
}
if($other eq ""
	& $timebefore eq ""
	& $timeafter eq ""){
	 print table({-class=>'registered'},
                "<tr><td>Vardas</td><td>$name</td></tr>".
                "<tr><td>Pavardė</td><td>$surname</td></tr>" .
                "<tr><td>Telefono nr.</td><td>$phone</td></tr>" .
                "<tr><td>El. paštas</td><td>$email</td></tr>" .
                "<tr><td>Paslauga</td><td>$service_type</td></tr>" .
                "<tr><td>Meistras</td><td>$master</td></tr>" .
                "<tr><td>Vizito data</td><td>$date</td></tr>" .
                "<tr><td>Vizito laikas</td><td>$hour</td></tr>");
}

print end_html() . "\n";
