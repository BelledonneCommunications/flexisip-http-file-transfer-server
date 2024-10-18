# HTTP File Transfer server

A file transfer server according to Rich Communications Service recommendation : RCC.07 v6.0 section 3.5.4.8 File Transfer via HTTP.

## Features

- Simple PHP script implementing RCC.07 v6.0 section 3.5.4.8 File Transfer via HTTP.
- Automatic cleanup of uploaded files at the end of their validity period (through cron daemon).
- Builtin MD5 or SHA-256 digest authentication against SQL database providing user's paswswords.
- TLS client based authentication possible, provided by http server (apache is recommended).

## Requirements

The server requires a functional web server serving php script located (by default) in */opt/belledonne-communications/share/flexisip-http-file-transfer-server/hft.php*
The server requires writing access to a directory accessible directly through http, located by default in */var/opt/belledonne-communications/flexisip-http-file-transfer-tmp/* It is strongly advised to disable any script execution in this directory.

## Configuration

The configuration file is installed as */etc/flexisip-http-file-transfer-server/flexisip-http-file-transfer-server.conf* . Inline comments in this file provide documentation about available settings. This file is present archived [here](src/flexisip-http-file-transfer-server.conf).
If you modify there the path to the upload directory, you might have to also modify the apache configuration file ( */etc/httpd/conf.d/flexisip-http-file-transfer-server.conf* ).

### Maximum size of files that can be uploaded

The main setting of interest is the maximum size of files that can be uploaded.
It is mainly governed by the PHP limits *upload_max_filesize* and *post_max_size*, which are the hard limits.
These limits can be set globally in /etc/php.ini, or set locally in file sharing server script directory, typically in */opt/belledonne-communications/share/flexisip-http-file-transfer-server/.user.ini*.
A typical .user.ini file to allow up to 512 Mo file would look like this:
`
    upload_max_filesize=512M
    post_max_size=513M
`

A soft limit, that can only be lesser than the php limits, can be set through the *fhft_maximum_file_size_in_MB* property of the configuration file.

The default php limits are used to be very low (2 Mo), which is less than what would be required to send an image for instance.
As a result, the configuration of php settings will be necessary for most use cases.

### User Authentication

Access to the file transfer server can be limited using user authentication.
* Authentication via TLS certificate can be achieved by modifying the apache server configuration and is out of the scope of this server configuration.
* Digest authentication can be enabled in the configuration file, see there for details. Digest auth can be enabled on upload only or on both upload and download. If do not want to enable the digest auth on upload, check the apache configuration file (httpd/conf.d/flexisip-http-file-transfer-server.conf) and enable the alias to allow direct download

## Troubleshooting and logs

Provided that the configuration *fhft_logLevel* is set, logs are written in */var/opt/belledonne-communications/log/flexisip-http-file-transfer.log* .
A default logrotate configuration file is installed to ensure proper rotation of log files.

## Packaging

Please refer to file [README.packaging.md](README.packaging.md) for instructions to generate the rpm/deb packages.
