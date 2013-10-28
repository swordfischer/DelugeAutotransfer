### DelugeAutotransfer
DelugeAutotransfer is a script for autotransferring completed torrents through Deluge, to your server of choice, matching your favourite regex'es!

##### Dependencies

* Perl >=5.12
* YAML::Tiny 
* Net::SMTP::SSL (*If you want to send mails upon completion*)
* File::Rsync (*If you want to use rsync as a transfer method*)
* File::FTP (*If you want to use FTP as a transfer method*)
* File::FTP::Recursive (*If you want to use FTP as a transfer method*)

##### How do I get started?
``` bash
    $ git clone git://github.com/swordfischer/DelugeAutotransfer.git
```
Now, you need to set up your config file
``` bash
    $ cp config.yml.example config.yml
    $ vim config.yml
```
As this is yaml, please watch your start of line spacing and indentation. That is, 2 spaces for each level of configuration.  
First fill out the **logfile** under **general**

``` yaml
    general:
      logfile: '/home/username/DelugeAutotransfer/Torrents.log'
```
Now we need to fill out our connections. We can has many as virtually possible here, so keep your friends happy and add them

``` yaml
    connections:
      MyBestFriend:
        email: 'user@domain.tld'  // This is only needed if you want to send notifications when a transfer completes
        method: 'rsync'  // Choose between RSYNC or FTP
        port: '22'
        login: 'username'  // Username for the connecting user
        password: ''  // This is not needed if you rsync and have copied a public key without a password
        host: 'domain.tld'
        destination: '/home/username/torrents/'
        transfer:
          - I_Would_Love_This_File:  // This is the pretty name of the file we're matching. Underscores are replaced with spaces
              match: '^I\.Would\.Love\.This\.File$'
              location: 'ILOVETHIS' // Optional: If you want to put all I_Would_Live_This_File's in the subdirectory ILOVETHIS
```
You can create multiple connections in the list, one for each friend with his preferences (or each of your servers)

###### Using RSYNC
You need to copy your public key to the receiving host (`ssh-copy-id <user>@<host>`), without password!  

###### Using FTP
Fill out the `login` and `password` field in the **connections** block of the `config.yml`

###### Setting up Deluge
Then you need to setup Deluge with the plugin `Execute`.  
Add an event in Execute  
   
    Event: Torrent Complete
    Command: /path/to/your/script/DelugeAutotransfer.pl

###### Almost Ready!
One final thing you might want to do, is edit line #10, #37, #41 and #45 of DelugeAutotransfer.pl to use Absolute Paths instead of Relative Paths.

Enjoy!  

License
-------
DelugeAutotransfer is licensed under the [MIT License](http://en.wikipedia.org/wiki/MIT_License)  
The full license text is available in [LICENSE.md](https://github.com/swordfischer/DelugeAutotransfer/blob/master/LICENSE.md)  
