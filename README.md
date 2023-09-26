# WonderLab-CGI. CGI Perl Program for Website Form Validation

This repository contains a CGI-based Perl program designed to handle form data submitted from a website hosted on an Apache web server. The program is written in both Lithuanian and English languages and focuses on data validation and secure processing.

## Installation
To use this CGI program, follow these steps:

1. **Install Apache Web Server:** If you haven't already, you'll need to install the Apache web server on your virtual machine. You can typically do this using package managers like `apt` or `yum` on Linux distributions.

2. **Clone the Repository:** Clone this repository to your virtual machine where the Apache server is installed.

3. **Configure Apache:** Configure Apache to execute CGI scripts from a specific directory. Add the following lines to your Apache configuration:

   ```apacheconf
   ScriptAlias /cgi-bin/ /path/to/your/repository/cgi-bin/
   <Directory "/path/to/your/repository/cgi-bin/">
       AllowOverride None
       Options +ExecCGI
       AddHandler cgi-script .cgi .pl
       Require all granted
   </Directory>
Make sure to replace /path/to/your/repository with the actual path to your cloned repository. 
Restart Apache: Restart Apache to apply the changes.

## Usage
The CGI program validates form data submitted from the website and returns a response in HTML format. It is designed to handle data in Lithuanian language.

## Security
The CGI program is built with security in mind:
- It operates in "tainted" mode to prevent potentially unsafe data from being processed.
- It detects and reports incomplete or invalid data and provides clear error messages to users.

## Access via curl
You can also access the CGI program using the curl tool from the command line. Here's an example:
```
curl http://127.0.0.1/cgi-bin/form.pl -F Vardas=Rugilė -F Pavardė=Lukšaitė -F Telefono_nr=+37061111111 -F El_paštas=bandymas@gmail.com -F Norima_paslauga="Moteriškas kirpimas" -F Norimas_meistras="Bet kuris meistras" -F Data=2021-11-30 -F Vizito_laikas=9:00 -F Laikas_prieš_vizitą="15 minučių prieš nurodytą laiką" -F Laikas_po_vizito="30 minučių po nurodyto laiko" -F Naudojimosi_sąlygos=Taip -F Naujienlaiškis=Taip
```
Curl usage information can be found on website or in document 'curl_usage.html'.




  
