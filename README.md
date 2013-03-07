DelugeAutotransfer
==================

DelugeAutotransfer is a script for autotransfering completed torrents through Deluge, to your server of choice, matching your favourite regex'es!


Dependencies
------------

* Perl >=5.12
* Net::SMTP::SSL
* YAML::Tiny
* File::Rsync
* File::FTP::Recursive

How do I get started?
---------------------

    $ git clone git://github.com/swordfischer/DelugeAutotransfer.git

Then, you might want to take a look at `config.yml.example` and edit it to your liking.

Let's break that config down:

    logfile: - This is obviously where you want DelugeAutotransfer to log to. Mainly used for debugging purposes, but it's is nice to look at!  
    connections: - This is where there fun begins.  
    Your_Name: - This will be used in the email, saying hello to you, and to uniquely identify your configuration section. Use underscores instead of spaces. I'd put Mickey\_Fischer and the email will contain "Mickey Fischer", neat!  
    email: - your recipient email.  
    method: - ftp or rsync.  
    login: - your remote host login.  
    password: - you remote host password (only used for ftp)  
    host: - your remote hosts name.  
    destination: - This is where the transfers will go, remember the trailing slash!  
    transfer: - This is the greatest section! Here you will list all your lovely regex'es.  
    - Something: - This is the pretty name of your match, it will be used in the email header. Use underscores instead of spaces!  
    match: 'REGEX' - Replace REGEX with an actual regex. If you can't come up with anything, I've heard that .\* matches a ton of stuff!  
    location: 'FOLDER' - This is optional. If you'd like to organize something, you should use this. Keep in mind that rsync only create 1 level of nonexisting folders, relative to your destination:.  

I filled out the config.yml.example with some lovely examples, so be sure to look at it.  

First of, you need to copy your public key to the receiving host (ssh-copy-id <user>@<host>), without password!  
Then you need to setup Deluge with the plugin `Execute`.  
Add an event in Execute  
   
    Event: Torrent Complete
    Command: /path/to/your/script/DelugeAutotransfer.pl

What else?  
You might want to use absolute paths on `line 8` and `line 12` in *DelugeAutotransfer.pl*, until I correct this
Enjoy!  
License
-------
DelugeAutotransfer is licensed under the [MIT License](http://en.wikipedia.org/wiki/MIT_License)  
The full license text is available in [LICENSE.md](https://github.com/swordfischer/DelugeAutotransfer/blob/master/LICENSE.md)  
