# Change Log

All notable changes to this project will be documented in this file.
(See [Full commit log](./doc/CommitLog) for all changes.)

The format is based on [Keep a Changelog](http://keepachangelog.com/).

## [Unreleased]
### Added
### Changed
### Deprecated
### Removed
### Fixed
### Security


## [v1.0.4] - 2017-03-15

### Added
- http_client: 
	Allow forcing multipart/form-data or application/x-www-form-urlencoded to choose how the form data should be sent.

- HTTP_HEADER: Added put_content_type_utf_8_text_html to HTTP_HEADER . 

- notification_email:
	Improved NOTIFICATION_SMTP_MAILER.make (..) to support user:password@...
	Propage error in notification_chain_mailer.

- Documentation: 
	added section for wsf_html library
	added README files to the examples.

- wsf_html: Added a few html widgets.

- examples: Added an example demonstrating the WSF_FORM component from `wsf_html` library.

### Changed
- WSF_FILE_SYSTEM_HANDLER: Improved the directory index access denied message.

- Documentation/website: 
	Updated documentation to match current source code.
	Moved website from gh-pages branch to /docs folder on master branch.
	Added section for wsf_html library.

- Examples:
	updated, cleaned and improved the `restbucks_CRUD` example.
	reorganized the examples folder.

### Fixed
- httpd and standalone connector:
	Updated code related to force_single_threaded setting to mark it obsolete, and for now, have coherent value 1 vs 0 among the standalone code and the httpd library.

- http_client (EiffelNet implementation):
	Fixed to follow redirection only for redirection http status 3** .

	Fixed http_client EiffelNet implementation when port is not the default one.  - previously the client was not sending the complete `host:port` but only `host` as `host` http header.

- WSF_REQUEST@wsf:
	If PATH_INFO is "/", the percent encoded path info is also "/". No need for complex computation. Note this fixes an issue with libfcgi app not hosted as root url such as "/sub/app.fcgi" on (old) IIS server.

	If PATH_INFO is empty, the percent encoded path info is also empty. No need for complex computation. Note this fixes an issue with libfcgi app not hosted as root url such as "/sub/app.fcgi".

-----------------------------------------------------------------
# Before [v1.0.4]


## Day - 2016-12-06  Jocelyn Fiat  <git@djoce.net>

	Updated wsf_js_widget example ecf files.

	Updated doc workbook ecf files.

	Updated tutorial ecf files to compile with 16.05 and upcoming release.

	Fixed a few compilation issue with 16.11 .

## Day - 2016-12-05  Jocelyn Fiat  <git@djoce.net>

	Disable debug clause for the wsf tests suite. Removed useless dep on EiffelThread

	Fixed compilation of proxy and simple examples. Made the websocket client library scoop capable.

## Day - 2016-12-01  Jocelyn Fiat  <git@djoce.net>

	If the count for put_file_content is not positive (i.e <= 0), do not send anything. Output/log more information for request handling when standalone httpd server has verbose enabled.

	Fixed debug.ecf file from debug example.

	Fixed a few void-safety issue, attribute not initialized before computing agent objects.

	Fixed compilation of desktop app example.

	Fixed potential void-safety issue in descendants related to initialization of router and filter.

	Fixed compilation.

	Removed unwanted files.

	Made library ecf compilable in scoop concurrency mode by default. So ecf files are compilable with 16.05 and 16.11 .

## Day - 2016-11-01  Jocelyn Fiat  <git@djoce.net>

	Made library ecf compilable in scoop concurrency mode by default. Except nino related projects that depends on EiffelThread.

	Made the notification_email library compilable with 16.05 and upcoming 16.11 .

	Fixed wsf_js_widget compilation.

## Day - 2016-10-31  Jocelyn Fiat  <git@djoce.net>

	Use the theoretical version number of EiffelStudio when we inserted new features to EiffelNet.

## Day - 2016-10-25  Jocelyn Fiat  <git@djoce.net>

	Fixed wsf tests project. Added ini config support to simple_file example.

	Updated WGI_OUTPUT_STREAM.put_file_content .

## Day - 2016-10-24  Jocelyn Fiat  <git@djoce.net>

	Fixed expiration, and cache-control: max-age implementation. Also use `FILE.date` instead of `FILE.change_date` (`change_date` is the date of the last status change, quite often same as creation date, while `date` is the last modification date).

	Added `WSF_RESPONSE.put_file_content (f: FILE, a_offset: INTEGER; a_count: INTEGER)` to allow potential future optimization.

## Day - 2016-10-21  Jocelyn Fiat  <git@djoce.net>

	Fixed the EiffelStudio EiffelWeb wizard.

	Added feature to manipulate easily the chain of filters.

## Day - 2016-10-18  Jocelyn Fiat  <git@djoce.net>

	Updated (un)install script to include new network, httpd, and websocket libraries.

	Added connection header related functions.   - WSF_REQUEST.is_keep_alive_http_connection: BOOLEAN   - HTTP_HEADER_MODIFIER.put_connection_keep_alive   - HTTP_HEADER_MODIFIER.put_connection_close In Standalone request handler code, better detection of Connection: keep-alive header.

## Day - 2016-10-15  Jocelyn Fiat  <github@djoce.net>

	Better all-safe.ecf file under wsf/connector .

	Updated to use new standalone option names.

	Fixed void-safety settings on web_socket_protocol.ecf .

	Updated http_client library to benefit from http_network library.

## Day - 2016-10-14  Jocelyn Fiat  <github@djoce.net>

	Fixed ecf to get them compiled.

## Day - 2016-10-14  Jocelyn Fiat  <git@djoce.net>

	The network classes are now under http_network library, thus renamed the header file as ew_network.h .

	Updated simple_ssl example to use directly the standalone connector,    and use the new WSF_STANDALONE_SERVICE_OPTIONS class. Added WSF_STANDALONE_SERVICE to make it easy to use directly.

## Day - 2016-10-14  Jocelyn Fiat  <github@djoce.net>

	Be sure to use ecf custom variable "ssl_enabled" and not the variant "httpd_ssl_enabled" or else. Include again the openssl include folder for EiffelStudio before 16.11, otherwise eif_openssl is not found.

	Reverted a few ecf files from ecf version 1-16-0 to ecf version 1-15-0. Added target "http_network_ssl" to test http_network with ssl support.

	Fixed http_network compilation for EiffelStudio before version 16.11.

## Day - 2016-10-14  Jocelyn Fiat  <git@djoce.net>

	Merged changes related to websocket and restructured httpd, http_ network libraries.

	Updated ws.ini  (for now, keep is_secure False, due to remaining issue with websocket and SSL implementation).

	Accept "yes" or "true" in wsf launcher option boolean values. Set socket_error when network occurs in `read_to_managed_pointer_noexception`.

	Renamed many classes and feature to use "secure" term instead of "ssl". (note, the .ecf are still using the "ssl" terminologie). Provided easy way to set secure settings for Standalone. For wsf launcher boolean option accept "true" or "yes" for True boolean, anything else is False.

## Day - 2016-10-13  Jocelyn Fiat  <git@djoce.net>

	Added websocket examples for the server and client.

	Use socket `.._noexception` functions in websocket networking.

	Added new WSF_STANDALONE_SERVICE_OPTIONS, a descendant of WSF_SERVICE_LAUNCHER_OPTIONS specialized for standalone connectors.

	Do not use `put_readable_string_8_noexception`, and just update `put_string_8_noexception` to accept READABLE_STRING_8.

	Reuse http_network library. Reintroduced HTTPD_STREAM_SOCKET for backward compatibility, and ease of usage. Added websocket libraries (client, and protocol).

## Day - 2016-10-12  Jocelyn Fiat  <git@djoce.net>

	Extracted network socket classes from httpd folder, and created a new library/network/http_network library. Renamed HTTPD_STREAM_SOCKET as HTTP_STREAM_SOCKET. Made http_client (net) library use the new http_network library.

	Moved httpd library from ewsgi/connectors/standalone/lib/httpd to httpd. Reused the http_network library as well inside httpd library.

## Day - 2016-10-12  Jocelyn Fiat  <github@djoce.net>

	Use custom variable `net_ssl_enabled` instead of `httpd_ssl_enabled` for the http_netword lib.

## Day - 2016-10-12  Jocelyn Fiat  <git@djoce.net>

	Implemented chunked Transfer-Encoding in net_http_client. Implemented support for buffer_size and chunk_size for net_http_client.

	Fixed typo in restbuck name.

	Fixed the "wsf_tests" autocase suite, which was wrong for cookies, and other minor changes.

	Added support for debug.ini to debug example.

	Fixed potential issue related to PATH_INFO, and `percent_encoded_path_info` computing , when script name is in different path.

	Fixed issue with input using "Transfer-Encoding: chunked".

## Day - 2016-10-11  Jocelyn Fiat  <git@djoce.net>

	Fixed regression with persistent connection, be sure to keep the `remote_info` data for all successive requests within a same persistent connection.

	Updated desktop_app example with embedded standalone web server.

	Updated desktop application example for scoop concurrency mode.

	Use the `..._noexception` network features in the WGI standalone input and output classes.

	Also check for SOCKET.was_error when accessing the socket data.

## Day - 2016-10-10  Jocelyn Fiat  <github@djoce.net>

	Use `was_error' to get expected behavior on Linux.

	Fixed C compilation on non Windows platform for EiffelStudio until 16.05 . (the required c function are coming with EiffelNet from EiffelStudio 16.11 ).

## Day - 2016-10-10  Jocelyn Fiat  <git@djoce.net>

	Updated deprecated EiffelWeb nino to make it compilable with upcoming EiffelStudio 16.11. Updated various projects to make them up-to-date and compilable with this latest EiffelWeb.

## Day - 2016-10-08  Jocelyn Fiat  <git@djoce.net>

	Improved networking implementation for httpd server and sockets. Use new EiffelNet routines that do not raise exception on error. Made compilable with 16.05 and dev-and-upcoming release 16.11. Fixed various minor issues related to base_url, and added comments.

	Replace Nino by Standalone whenever it is relevant.

## Day - 2016-10-05  Jocelyn Fiat  <git@djoce.net>

	Updated `has_incoming_data` comment.

	Make EiffelWeb standalone easier to debug by using in some locations error instead of exception for network error. - Added C external to use C `recv` feature with error (as opposed to have exception raised on network error).

	Commented the execute_bad_request, since it is not ready and will trigger error most of the time.

## Day - 2016-10-04  Jocelyn Fiat  <git@djoce.net>

	Improve socket management for EiffelWeb standalone connector.

	First attempt to response with bad request message when bad request is detected.

	Added ssl test case for standalone wsf connector.

	Updated workbook, minor changes (removed mention about nino, added libfcgi info).

## Day - 2016-10-02  Jocelyn Fiat  <git@djoce.net>

	Also display SSL information when verbose is enabled for EiffelWeb standalone connector.

## Day - 2016-09-27  Jocelyn Fiat  <git@djoce.net>

	Include wsf_proxy to the installation process.

## Day - 2016-09-27  Jocelyn Fiat  <git@djoce.net>

	Fixed SSL support on the httpd component, and also on the EiffelWeb standalone connector.   - the standalone connector support for SSL, is using certicate files for now (no in-memory support).   - to enable ssl support, set ecf variable `httpd_ssl_enabled=true`.   - added the `simple_ssl` example to demonstrate how to have standalone ssl server.     (be careful when using EiffelNet SSL and the http_client library, disable the libcurl       via ecf variable `libcurl_http_client_disabled=true` )
	Added support for recv timeout to the EiffelWeb standalone connector.
	  - made EiffelWeb compilable with 16.05 and upcoming 16.11.
	    Done via ecfs condition on version to accept EiffelNet with recv_timeout (from 16.11), and without (until 16.05).
	  - adding recv timeout prevents server to hang for ever if a client wait too long to send data.

	Updated various comments.

## Day - 2016-09-26  Jocelyn Fiat  <git@djoce.net>

	Fixed the non void-safe ecf for wsf_proxy.

	Use latest API from http_client using DEFAULT_HTTP_CLIENT, that could use libcurl or EiffelNet depending on the configuration (.ecf).

## Day - 2016-09-19  Jocelyn Fiat  <git@djoce.net>

	Merge branch 'reverse_proxy'

## Day - 2016-08-08  Jocelyn Fiat  <git@djoce.net>

	Replaced host+port by uri (http://remotemachine:port/path). Added support for SSL (https).

## Day - 2016-08-06  Jocelyn Fiat  <git@djoce.net>

	When possible keep ecf location relative within the same EiffelWeb directory structure.

	First step towards SSL support.

## Day - 2016-08-05  Jocelyn Fiat  <git@djoce.net>

	Added a simple reverse proxy handler. - For now, it does not support SSL connection on the target yet. - No external config file support, this is all about coding.

	Revisited WSF_REQUEST.read_input_data* functions: - read_input_data_into_file now accepts a IO_MEDIUM argument instead of just FILE. - cleaned the implementation, and make sure that eventual `raw_input_data` is containing only the raw input data.

	Ignore empty header line.

## Day - 2016-06-24  Jocelyn Fiat  <git@djoce.net>

	Added support for category in ATOM format (input and output).

## Day - 2016-06-22  Jocelyn Fiat  <git@djoce.net>

	Removed unwanted .ecf file.

	Added more application logic for the example.

	Renamed WGI_STANDALONE_CONNECTOR_ACCESS as WGI_STANDALONE_CONNECTOR_EXPORTER. Isolate the websocket implementation in descendant of {WEB_SOCKET_EVENT_I}. Added very simple echo websocket example. + code cleaning.

## Day - 2016-06-21  Jocelyn Fiat  <git@djoce.net>

	Added WSF `standalone_websocket` connector, that provides websocket on top of `standalone` connector.

	Log when a persistent connection is reused. Use anchor type on `{WGI_STANDALONE_CONNECTOR}.configuration` and `{WSF_STANDALONE_SERVICE_LAUNCHER}.connector`. Add access to the socket of standalone input stream from `{WSF_STANDALONE_CONNECTOR_ACCESS}`. Removed a useless redefination in `WSF_EXECUTION`.

## Day - 2016-06-16  Jocelyn Fiat  <git@djoce.net>

	Fixed signature of `{HTTPD_CONFIGURATION_I}.set_ca_key` .

	Make it easier to reuse the http network classes. This is to make it easier for websocket solution to reuse httpd implementation.

## Day - 2016-06-15  Jocelyn Fiat  <git@djoce.net>

	Moved httpd from src to lib, under standalone connector.

	Prepared httpd_stream to be useable for client too. Fixed obsolete tests/dev compilation (mainly to avoid wrong failure reports). added package.iron files.

	Added advanced settings for standalone connector - max_concurrent_connections=100 - keep_alive_timeout=15 - max_tcp_clients=100 - socket_timeout=300 - max_keep_alive_requests=300 And then can be set via the options as well, and via .ini file. Also improved the verbose console output system.

## Day - 2016-06-14  Jocelyn Fiat  <git@djoce.net>

	Using passive regions. Improve connector options mainly for standalone connector. Updated "simple" example to return a timestamp.

## Day - 2016-05-31  Jocelyn Fiat  <github@djoce.net>

	Added libfcgi target, in addition to standalone target for the upload_image example.

	Fixed bad usage of {SOCKET}.socket_ok that resulted in bad behavior on linux.

	Using -lfcgi as external linker flag, rather than /usr/lib/libfcgi.so .
	Note on Ubuntu: apt-get install libfcgi-dev

	Updated link to github pages documentation.

	Fixed link to image or source code in markdown workbook text.

	Updated markdown text to conform strictly to kramdown syntax.

## Day - 2016-05-27  Jocelyn Fiat  <github@djoce.net>

	Updated to kramdown markdown syntax (i.e github). Updated various content and nav links.

## Day - 2016-05-26  Jocelyn Fiat  <github@djoce.net>

	Updated markdown relative links.

	Added readme.md in /doc/. And updated workbook readme.md itself.

## Day - 2016-05-25  Jocelyn Fiat  <git@djoce.net>

	Removed warning about unknown class in export clause.

	updated readme.md to link to workbook.

## Day - 2016-05-20  Colin Adams  <colinpauladams@gmail.com>

	Fix for missing error reporting in WSF_PUT/POST_HELPER

## Day - 2016-05-04  Jocelyn Fiat  <git@djoce.net>

	Updated HTTP_COOKIE implementation  - by default the Cookie does not set max-age and expires, so it defines a Session Cookie.    (max_age and expires attributes are not included in the response)  - set_* and unset_* features to define max_age and expire attributes.  - marked old features as obsolete. Updated test cases.

## Day - 2016-02-03  Jocelyn Fiat  <git@djoce.net>

	Updated EWF Windows tools to install EWF into EiffelStudio source tree.

	Removed useless library declarations.

## Day - 2016-02-02  Jocelyn Fiat  <git@djoce.net>

	Updated package.iron files.

## Day - 2016-01-20  Jocelyn Fiat  <git@djoce.net>

	Do not html escape ' with &apos;
	reason: the named character reference &apos; (the apostrophe, U+0027) was introduced in XML 1.0 but does not appear in HTML. Authors should therefore use &#39; instead of &apos; to work as expected in HTML 4 user agents.

## Day - 2016-01-18  Jocelyn Fiat  <git@djoce.net>

	Eiffel code and ECFs update to support new agent notations.

	Added process_transfer to implement process_file. This way, it is easier to redefine the transfert implementation, or the process_file directly, if needed.

	Eiffel code and ECFs update to support new agent notations. Removed contrib/library/.../json library.

## Day - 2016-01-12  Jocelyn Fiat  <git@djoce.net>

	Improved error library by refactorying the sync as two way propagation. Now one can setup error handler propagation in one way, or two way (sync). The "reset" applies in both way, even if this is a one way propagation to fit current existing usage. Added optional id for the error handlers. Feature renaming according to design changes. Added related autotest cases.

	Better EMAIL.message computing. Send end of input file for stdin mode.

## Day - 2016-01-08  Jocelyn Fiat  <git@djoce.net>

	Fixed Reply-To: implementation in notification mailer. Added helper routines to query additional header, and reset Cc:, and Bcc: values.

## Day - 2015-12-28  Jocelyn Fiat  <git@djoce.net>

	Fixed end_of_input  by using SOCKET.readable.

	Removed uuid in wsf_session ecf files.

	Fixed table item output by appending html attribute for WSF widget table item.

	Made WSF_TABLE a TABLE_ITERABLE.

	Fixed URI mapping with regard to trailing slash handling.

## Day - 2015-12-22  Javier Velilla  <javier.hector@gmail.com>

	Updated workbook
	Added EWF Deployment title

	Updated workbook
	Added deployment document

	Initial commit Deployment file

## Day - 2015-11-05  Jocelyn Fiat  <git@djoce.net>

	removed non void-safe tests.ecf for feeds library

	Comment and code cleaning.

	Fixed various unicode issue related to query and form parameters. (Especially for the multipart/form-data encoding.) Factorized code related to smart parameters computing (handling list , table, ...) in WSF_VALUE_UTILITIES. Fixed an issue with percent_encoded_path_info computation from request_uri. Fixed issue with cookie addition having same cookie name. Fixed unicode support for uploaded file. WSF_STRING is reusing WSF_PERCENT_ENCODER. Use unicode output for WSF_DEBUG_HANDLER. Code cleaning

## Day - 2015-10-19  Jocelyn Fiat  <git@djoce.net>

	Added specific configuration file, so that it is easier to use either libcurl or net implementation.

	Fixed timeout issue due to too many "ready_for_reading". Fixed Connection behavior. Fixed Content-Type settings. Removed condition on POST or PUT, since code also applied to any request methods. Added verbose output implementation.

	Added first support for persistent connection in NET http client implementation. Various improvement related to eventual errors.

	Updated README.md with configuration topics related to libcurl or net disabling. Fixed ssl test by precising insecure ssl.

	Updated a few comments Removed useless NULL_HTTP_CLIENT. Extracted mime code from NET_HTTP_CLIENT_REQUEST.response into specific routine.

	Added https support with Net implementation. Added notion of default HTTP_CLIENT, to be able to build portable code among http client implementation.

	Added null http client for upcoming changes. Refactored NET request implementation.   - fixed potential issue with header conflict.   - simplified, and extract parts of the code into routine.   - Implemented read of chunked Transfer-Encoding   - Fixed potential issue with socket handling. First steps to be able to exclude net or libcurl implementation when using http_client lib. Removed from NET implementation the hack related to PUT and upload data (it was used to workaround an issue with libcurl).

	Added support for chunked transfer-encoding response. Implemented correctly the redirection support for NET_HTTP_CLIENT... Added the possibility to use HTTP/1.0 . Splitted the manual tests that were using during development. First step to redesign and clean the new code.

## Day - 2015-10-19  Florian Jacky  <fjacky@github.com>

	Fixed configuration files

	Fixed configuration files

	config files

	correct password for authentication test

	added remaining features

	now supports sending requests, receiving headers, receiving message text, redirection, agent header, cookies, basic http authorization, sending data using post using url-encoding, sending file as post as data, sending put data

	implemented http authorization, support for redirection and user-agent

	implemented http authorization, support for redirection and user-agent

## Day - 2015-10-19  Jocelyn Fiat  <git@djoce.net>

	Added postcondition to ensure the result of {HTTP_CLIENT_REQUEST}.response is attached. (useless with void-safety compilation, but keep it for non void-safe execution).

	Removed useless redefination of is_equal.

	Fixing http_client.ecf file with correct locations.

	Basic initial Eiffel NET implementation.

	Added skeleton for Eiffel Net implementation of HTTP_CLIENT solution. This is work in progress.

## Day - 2015-10-14  Jocelyn Fiat  <git@djoce.net>

	Added FEED.prune (a_item: FEED_ITEM).

## Day - 2015-10-10  Jocelyn Fiat  <git@djoce.net>

	Make custom error interface more flexible with READABLE_STRING_... instead of STRING_...

## Day - 2015-10-09  Jocelyn Fiat  <git@djoce.net>

	Added feed to xhtml visitor. Updated interfaces, mainly related to date attributes.

## Day - 2015-10-08  Jocelyn Fiat  <git@djoce.net>

	Made HTTP_DATE more flexible and support UTC+0000, GMT+0000 and now also +0000. Added comments.

	Added FEED + FEED operator to merge two feeds. Added FEED sorting routine. Added FEED_ITEM.link: detachable FEED_LINK that represents the main feed link. Comments.

## Day - 2015-10-05  Jocelyn Fiat  <git@djoce.net>

	Fixed compilation of non void-safe feed.ecf

## Day - 2015-09-16  Jocelyn Fiat  <git@djoce.net>

	Updated a few comments. Renamed generator to follow *_FEED_GENERATOR naming. Renamed feed entry as feed item. Made FEED conforms to ITERABLE [FEED_ITEM] for convenience.

## Day - 2015-09-08  Jocelyn Fiat  <git@djoce.net>

	Improved feed library with comments, bug fixes and code factorization.

## Day - 2015-09-07  Jocelyn Fiat  <git@djoce.net>

	Added initial ATOM and RSS feed parser and generator. (work in progress)

## Day - 2015-08-26  jvelilla  <javier.hector@gmail.com>

	Removed support for SSLv3

## Day - 2015-08-26  Jocelyn Fiat  <git@djoce.net>

	Added target "all_stable_with_ssl" to check compilation with ssl enabled.

## Day - 2015-08-24  Jocelyn Fiat  <git@djoce.net>

	Merge branch 'v1'

	Updated installation location of openid and http_authorization in ISE package. Added iron package file for ewsgi.

## Day - 2015-08-06  jvelilla  <javier.hector@gmail.com>

	Fixed typo: Aug instead of Aou.

	Fixed typo: Aug instead of Aou.

## Day - 2015-08-04  Jocelyn Fiat  <git@djoce.net>

	Cosmetic  true -> True

	Fixing `script_url' that wrongly used `path_info' instead of `percent_encoded_path_info'.    (issue on script_url when path info contains unicode character).

	Updated set_value for WSF_FORM_SELECTABLE_INPUT (for example a checkbox). Call the feature set_checked_by_value iff the the current value exist in the list of values, in other case set checked in Flase. If we call set_checked_by_value without filter, previous checked values will be set in False.

	Fixing `script_url' that wrongly used `path_info' instead of `percent_encoded_path_info'.   (issue on script_url when path info contains unicode character).

	Merge remote-tracking branch 'javier/ewf_html_form' into v1

## Day - 2015-07-31  jvelilla  <javier.hector@gmail.com>

	Updated set_value for WSF_FORM_SELECTABLE_INPUT (for example a checkbox). Call the feature set_checked_by_value iff the the current value exist in the list of values, in other case set checked in Flase. If we call set_checked_by_value without filter, previous checked values will be set in False.

## Day - 2015-07-03  Jocelyn Fiat  <git@djoce.net>

	Fixed various compilation issues. Ensure the obsolete/v0 ecf has new UUID.

	Added the possibility to provide the sendmail location in NOTIFICATION_SENDMAIL_MAILER. Added NOTIFICATION_STORAGE_MAILER which allow to store the email in a storage (could be just output, file, database ...) Added SMTP implementation, based on EiffelNet SMTP_PROTOCOL.    note: it is possible to exclude this by setting ecf variable "smtp_notification_email_disabled" to "True"    this way help to manage dependencies, since the Eiffel Net library would not be included neither. Fixed Date header value computation.

## Day - 2015-07-02  Jocelyn Fiat  <git@djoce.net>

	Reverted previous changed related to redefinition of set_status_code which was against existing assertions.

	Updated eiffelstudio locations for EWF libraries.

	Fixed WGI_HTTPD_REQUEST_HANDLER.process_rescue Fixed WGI_STANDALONE_OUTPUT_STREAM.is_available Added WGI_STANDALONE_RESPONSE_STREAM.is_persistent_connection_supported

## Day - 2015-07-01  Jocelyn Fiat  <git@djoce.net>

	Merge branch 'v1' of https://github.com/EiffelWebFramework/EWF into v1

	Fixed compilation of all*-safe.ecf files. Corrected a few comments.

## Day - 2015-06-30  jvelilla  <javier.hector@gmail.com>

	Merge branch 'jvelilla-ewf_v1_workbook' into v1

	Updated workbook: generating response, handling cookies and headers documents.

	Updated workbook form document

	Updated: workbook headers document. Removed: unnecessary files.

	Updated Workbook basic documentation.

	Merge branch 'ewf_v1_workbook' of https://github.com/jvelilla/EWF into ewf_v1_workbook

	Updated basic documentation

## Day - 2015-06-29  Javier Velilla  <javier.hector@gmail.com>

	Update basics.md

## Day - 2015-06-29  jvelilla  <javier.hector@gmail.com>

	Update basic document

## Day - 2015-06-29  Javier Velilla  <javier.hector@gmail.com>

	Update basics.md

	Update basics.md

	Update workbook.md

## Day - 2015-06-29  jvelilla  <javier.hector@gmail.com>

	Update basic document to the new EWF concurrent design

## Day - 2015-06-22  Jocelyn Fiat  <git@djoce.net>

	Improved code related to cookie management (avoid duplicated cookie).

## Day - 2015-06-18  Jocelyn Fiat  <git@djoce.net>

	Synchronized wsf-safe.ecf and wsf.ecf

## Day - 2015-06-17  Jocelyn Fiat  <git@djoce.net>

	Changed the way SSL is supported with standalone connector (httpd lib).   Now by default, SSL is not supported,   and if an application wants the SSL support,   the related .ecf has to set custom variable "httpd_ssl_enabled" to "true"

## Day - 2015-06-16  Jocelyn Fiat  <git@djoce.net>

	Updated workbook Eiffel code to follow new EWF concurrent design.

	Added make_from_execution procedure to ease implementing various use cases.

## Day - 2015-06-14  Jocelyn Fiat  <git@djoce.net>

	Updated ecf from obsolete v0 folder to include the "_v0" suffix in the library names.

## Day - 2015-06-12  Jocelyn Fiat  <git@djoce.net>

	Added wsf_html in the obsolete v0 folder.   mostly because it is also dependent on "wsf", so it has to be using the obsolete v0 ecf.

	Simplified file names, and harmonized with estudio wizards.

	Updated EWF estudio wizard.

	Updated wizard template ecf to take into account current limitation, or known issue related to libcurl and ssl.

## Day - 2015-06-11  Jocelyn Fiat  <git@djoce.net>

	Made compilable without SSL enabled (i.e when variable named "httpd_ssl_disabled" is set to "true")

## Day - 2015-06-10  Jocelyn Fiat  <git@djoce.net>

	Marked most of the *_with_request_methods procedure obsolete by the same feature name without the "_with_request_methods". Added argument passing request methods to feature without the _with_request_methods. Prefer "thread" concurrency for now in examples.

	Added a few example based on the obsolete libraries (v0). Updated the tutorial example. Added WSF_MESSAGE_EXECUTION.

	cosmetic, cleaning.

	Merge branch 'v1'

## Day - 2015-06-08  Jocelyn Fiat  <git@djoce.net>

	Merge branch 'master' into v1

## Day - 2015-06-05  Jocelyn Fiat  <git@djoce.net>

	Fixed various compilation error or warning.

## Day - 2015-05-29  jvelilla  <javier.hector@gmail.com>

	Merge branch 'jvelilla-ewf_wsf_html5'

	Merge branch 'ewf_wsf_html5' of https://github.com/jvelilla/EWF into jvelilla-ewf_wsf_html5

## Day - 2015-05-28  jvelilla  <javier.hector@gmail.com>

	Updated code based on comments

	Updated code based on review

	Updated code inherit from SHARED_HTML_ENCODER instead of creating new objects.

	Updated html5 classes based on review

## Day - 2015-05-22  Jocelyn Fiat  <git@djoce.net>

	Added WSF_FILE_UTILITIES.new_file (p: PATH): detachable G   in order to provide non existing file, but not only for temporary files purpose.

## Day - 2015-05-21  jvelilla  <javier.hector@gmail.com>

	Initial import HTML5 support for attributes and input types. Attributes - Added support for new HTML5 attributes. missing support for : form, list, and multiple attributes.
	Input types: added the all the new input types.

	Added test cases, still in progress.

## Day - 2015-05-18  jvelilla  <javier.hector@gmail.com>

	Moved EWF workbook from ewf_example to EWF main repository.

## Day - 2015-05-12  Jocelyn Fiat  <git@djoce.net>

	Added package.iron for nino library.

	Refactored wsf router dispatching implementation.   Now the path to take into account during dispatching is computed once   in WSF_ROUTER.path_to_dispatch (req: WSF_REQUEST): READABLE_STRING_8   And this function could be redefined in descendant of WSF_ROUTER.

	improved nino port number validation

## Day - 2015-05-07  Jocelyn Fiat  <git@djoce.net>

	Fixed compilation of SSL_TCP_STREAM_SOCKET with recent do_accept changes.

## Day - 2015-05-06  Jocelyn Fiat  <git@djoce.net>

	Updated a few comments.

	Updated readme.

	Added abstraction WSF_ROUTED, and WSF_FILTERED. Added under library/server/obsolete/v0 the previous non concurrent friendly version of EWF/WSF, for backward compatiblity. Removed WSF_CALLBACK_SERVICE and WSF_TO_WGI_SERVICE which are not need with new EWF.

	Fixed typo.

	Fixed a typo.

	Added a few descriptions and comments.

## Day - 2015-05-06  jvelilla  <javier.hector@gmail.com>

	Added feature comments. Added missing postconditions.

	Added descriptions and comments

	Added descriptions and feature comments.

	Added features comments.

	Added Missing Class and feature descriptions. Removed author entry.

## Day - 2015-05-06  Jocelyn Fiat  <git@djoce.net>

	Export request and response from WGI_EXECUTION to itself. Added WSF_FILTERED_ROUTED_SKELETON_EXECUTION

	renamed keep_alive_requested as is_persistent_connection_requested.

	Following the spec, use "keep-alive" and "close" in lowercase for Connection header.

	Better support for HTTP/1.0 and also related to persistent connection.

	Improved support for HTTP/1.0 persistent connection.

	Enable support for persistent connections. (test: works fine with curl -k , but weird behavior with ab -k ...)

	First step to improve a bit error handling related to socket disconnection. Mainly in standalone connector for now.

	Improved the simple_file example with image, and not found message. Use standalone connector in SCOOP concurrency mode.

	Cleaned simple example, and made the standalone target with SCOOP concurrency.

	Updated various indexing notes. Removed a few obsolete classes. Cosmetics

	Added migration note.

	Migrated most of the example and library to new design.

	Implemented support for base url in httpd connector.

	Migrated simple, simple_file and upload_image example. Adapted EWF accordingly.

	Added SCOOP support for WSF. WSF_SERVICE is deeply changed, and addition of WSF_EXECUTION. Todo: code cleaning, removing useless things.

	Support for concurrencies: none, thread and SCOOP

	Finally SCOOP supported.

	Experiment to avoid pseudo sequential execution

	First attempt to use `{NETWORK_STREAM_SOCKET}.accept_to'

	First steps to provide a concurrent compliant EWF connector.

## Day - 2015-05-05  Jocelyn Fiat  <git@djoce.net>

	Renamed a few index.md as README.md

	Renamed Home.md as README.md

	Update doc structure, and fixed a few links.

	Updated mediawiki and markdown link to local pages,   in order to use those files as browseable documentation, and close the github wiki.

	Merge remote-tracking branch 'ewf_wiki/master'

	update README to add google groups info.

## Day - 2015-04-07  Jocelyn Fiat  <git@djoce.net>

	Updated code to remove obsolete call on recent version of json library. Updated upload_image example to use PATH instead of DIRECTORY_NAME or similar. Removed unused local variables.

	Merge branch 'master' of https://github.com/eiffelhub/json

## Day - 2015-03-20  jvelilla  <javier.hector@gmail.com>

	Merge branch 'jvelilla-ewf_cookie'

## Day - 2015-03-19  jvelilla  <javier.hector@gmail.com>

	Updated HTTP_COOKIE, enable to add a cookie with empty value. Added feature to check if a date is valid rcf1123 is_valid_rfc1123_date. Added test cases related to valid cookie dates. Updated wsf_response add_cookie basedo on review comments.

	Updated is_valid_character, using NATURAL_32 as an argument to avoid multiple conversions. Updated add_cookie, added features has_cookie_name and is_cookie line to avoid the use of STRING.split and STRING.start_with.

## Day - 2015-03-17  jvelilla  <javier.hector@gmail.com>

	Updated HTTP_COOKIE class based on comments. Added missing descriptions in test classes

	Added the add_cookie feature Added test cases to check cookies in WSF_RESPONSE- Added mock classes use for test cases.

## Day - 2015-03-13  jvelilla  <javier.hector@gmail.com>

	Updated code based on Jocelyn's comments.

	Added HTTP_COOKIE and test cases. Added WSF_COOKIE class, inherit from HTTP_COOKIE.

## Day - 2015-03-12  Jocelyn Fiat  <git@djoce.net>

	Completed configuration setting to be compilable with recent changes in EiffelNet / NETWORK_STREAM_SOCKET interface.

## Day - 2015-03-11  Jocelyn Fiat  <git@djoce.net>

	fixed location of before_15_01 folder.

## Day - 2015-03-05  Jocelyn Fiat  <git@djoce.net>

	Removed the -safe since now new project should be void-safe

	moved wizard under tools/estudio_wizard

	moved wizard from tools to helpers

	Updated script to install wizard in current EiffelStudio installation.

	Updated the ewf estudio wizard to have a console and a graphical wizard. Usage:  wizard -callback file.cb path-to-rootdir folder.

## Day - 2015-02-18  Jocelyn Fiat  <git@djoce.net>

	Prepare nino ecf to be compilable with upcoming changes in EiffelNet / NETWORK_STREAM_SOCKET interface.    As EiffelNet release is related to EiffelStudio release,    the condition "compiler version <= 15.02) is used,    which means that before for release 15.01 and previous EiffelStudio    releases, the project uses a specific TCP_STREAM_SOCKET, and for    upcoming releases, it will use another version of that class).   (see rev#96640 from eiffelstudio subversion repository)

	Prepare nino ecf to be compilable with upcoming changes in EiffelNet / NETWORK_STREAM_SOCKET interface. (see rev#96640 from eiffelstudio subversion repository)

## Day - 2015-01-08  Jocelyn Fiat  <git@djoce.net>

	Fixed implementation of JSON_PARSER.is_valid_number (STRING): BOOLEAN

## Day - 2014-12-02  Jocelyn Fiat  <git@djoce.net>

	Updated install_ewf.bat to use the new "ecf_tool" from https://svn.eiffel.com/eiffelstudio/trunk/Src/tools/ecf_tool .

	Added more test cases for cookies.

	Completed change on debug handler and filter, to use WSF_DEBUG_INFORMATION.

## Day - 2014-12-01  Jocelyn Fiat  <git@djoce.net>

	Merge branch 'fix_cgi_value' of github.com:jocelyn/EWF

	Added assertions on router helpers, and also agent handler. Closes issue #159

## Day - 2014-11-28  Jocelyn Fiat  <git@djoce.net>

	Fixing issues related to status code.

	Better code for restbucks ORDER_HANDLER related to allowed_cross_origins and last_modified.

## Day - 2014-11-25  Jocelyn Fiat  <git@djoce.net>

	Fixed compilation of restbucks example using the policy driven framework.

	WSF_TRACE_RESPONSE should include "Content-Type: message/http" header Close issue #145

## Day - 2014-11-24  Jocelyn Fiat  <git@djoce.net>

	Fixed issue#157 (WSF_REQUEST.cookies_table does not terminate on cookies without a value, or ending with semi-colon) Added related autotest.

## Day - 2014-11-19  Colin Adams  <colinpauladams@gmail.com>

	Added {WSF_REQUEST}.http_content_encoding

	Issue #154 (documentation error in {WSF_SKELETON_HANDLER}.check_request)

## Day - 2014-11-18  Colin Adams  <colinpauladams@gmail.com>

	issue #149 (Simple CORS support for GET requests in policy-driven framework)

	Issue #150 (VARY header set to header contents rather than heqader name)

	Issue #144 (Add last_modified to WSF_SKELETON_HANDLER)

## Day - 2014-11-17  Jocelyn Fiat  <github@djoce.net>

	Merge pull request #148 from colin-adams/response-code-411
	Policy-driven framework should reject PUT requests that contain a Content-Range header
	
	Close Issue #143

## Day - 2014-11-17  Colin Adams  <colinpauladams@gmail.com>

	Issue #143

## Day - 2014-11-17  Jocelyn Fiat  <git@djoce.net>

	Reintroduced parse_object as obsolete, to avoid breaking existing code.

	Converted ecf file to complete void-safe. Improved JSON_PRETTY_STRING_VISITOR to support STRING_8 or STRING_32 output. Added examples. Added doc in the folder "doc". Updated Readme and other files. Added package.iron file.

## Day - 2014-10-28  Jocelyn Fiat  <git@djoce.net>

	Updated WSF_FILE_UTILITIES with class comment, and avoid having expanded generic class.

## Day - 2014-10-10  Jocelyn Fiat  <git@djoce.net>

	Fixed compilation issue for wsf_js_widget package.

	Fixed compilation for wsf tests.

	fixed compilation of filter example.

## Day - 2014-10-03  Jocelyn Fiat  <github@djoce.net>

	Merge pull request #11 from jocelyn/improved_sept_2014
	Fixed various issue with parsing string (such as \t and related),
	    Implemented escaping of slash '/' only in case of '</' to avoid potential issue with javascript and </script>
	    Many feature renaming to match Eiffel style and naming convention, kept previous feature as obsolete.
	    Restructured the library to make easy extraction of "converter" classes if needed in the future.
	    Marked converters classes as obsolete.
	    Updated part of the code to use new feature names.
	    Updated license and copyright.
	    Updated classes with bottom indexing notes related to copyright and license.

## Day - 2014-10-03  Jocelyn Fiat  <git@djoce.net>

	Ensure backward compatibility for `parse' / `is_parsed'.

## Day - 2014-10-01  Jocelyn Fiat  <github@djoce.net>

	Merge pull request #140 from jvelilla/ewf_router
	Updated WSF_ROUTER, to import an existing router definition.

## Day - 2014-09-30  Jocelyn Fiat  <git@djoce.net>

	Marked converters classes as obsolete.

	Updated license and copyright. Updated classes with bottom indexing notes related to copyright and license.

## Day - 2014-09-24  Jocelyn Fiat  <git@djoce.net>

	Fixed various issue with parsing string (such as \t and related), Implemented escaping of slash '/' only in case of '</' to avoid potential issue with javascript and </script> Many feature renaming to match Eiffel style and naming convention, kept previous feature as obsolete. Restructured the library to make easy extraction of "converter" classes if needed in the future. Updated part of the code to use new feature names.

## Day - 2014-09-18  Olivier Ligot  <oligot@gmail.com>

	Fix filter example: logging filter must be the last one

## Day - 2014-09-17  Olivier Ligot  <oligot@gmail.com>

	Filter example: add fcgi target

	Fix authentication filter: use {HTTP_AUTHORIZATION}.is_basic

## Day - 2014-09-12  jvelilla  <javier.hector@gmail.com>

	Updated WSF_ROUTER.import feature.

## Day - 2014-09-10  jvelilla  <javier.hector@gmail.com>

	Updated WSF_ROUTER, to import an existing router definition.

## Day - 2014-07-11  Olivier Ligot  <oligot@gmail.com>

	Merge remote-tracking branch 'upstream/master'

## Day - 2014-07-08  jvelilla  <javier.hector@gmail.com>

	Merge pull request #9 from Conaclos/working
	Apply pretty tool.

## Day - 2014-07-07  Jocelyn Fiat  <github@djoce.net>

	Merge pull request #139 from jocelyn/widget_integration
	Added custom-template in examples, as a base template to integrate easily other JS widgets.

## Day - 2014-07-07  Jocelyn Fiat  <git@djoce.net>

	Added custom-template in examples, as a base template to integrate easily other JS widgets. Added custom example (based on custom-template project) that demonstrates how to integrate a thirdparty JS component such as d3 within the application using wsf_js_widget.
	Removed various unecessary ecf dependencies.

	Improved comment related to PATH_INFO and stripping multiple slashes sequence to single slash.

## Day - 2014-07-07  Jocelyn Fiat  <github@djoce.net>

	Merge pull request #138 from jocelyn/widget_integration
	Integrated WSF_JS_Widget library provided by Yassin Nasir Hassan and Severin Munger as an ETH student project.
	It was updated to better support Unicode, and other minor changes, this is still under "draft" folder, as it may need various modifications on the interface and implementation.

## Day - 2014-07-07  Jocelyn Fiat  <git@djoce.net>

	Fixed compilation issue related to old usage of modified JSON library.

	Merge branch 'master' of github.com:EiffelWebFramework/EWF into widget_integration

	Move wsf_js_widget library under draft/library/server/wsf_js_widget

## Day - 2014-07-04  Conaclos  <Conaclos>

	Apply pretty print tool.
	Apply on each class in test suite and library.

## Day - 2014-07-04  jvelilla  <javier.hector@gmail.com>

	Merge pull request #8 from Conaclos/working
	Tests - Update syntax and improve implementation

## Day - 2014-07-02  Jocelyn Fiat  <git@djoce.net>

	Replace any multiple slash sequence by a single slash character for PATH_INFO.

## Day - 2014-07-01  Jocelyn Fiat  <git@djoce.net>

	Various changes related to new WSF_DEBUG_INFORMATION and WSF_DEBUG_HANDLER.

	Fixed various issues related to unicode and CGI variables (assuming that CGI variables are utf-8 encoded, and sometime percent encoded). Delayed computation of `value' and `name' from WSF_STRING. Fixed computation of REQUEST_URI when the server does not provide it (this is rare, but possible).    compute it as SERVER_NAME + encoded-PATH_INFO + {? + QUERY_STRING}

## Day - 2014-07-01  jvelilla  <javier.hector@gmail.com>

	Update format

	Created Deployment (markdown)

## Day - 2014-06-30  Conaclos  <Conaclos>

	Add documentation and contracts for domain types.

	Improve converters.
	Replace old syntax with new one and improve
	implementation.

	Syntax update.
	Replace assigment attempt with object test.

## Day - 2014-06-30  Jocelyn Fiat  <git@djoce.net>

	Verbose mode for the WSF_DEBUG_HANDLER.

	Fixed error introduced during refactorying on WSF_DEBUG_FILTER

	Improved the debug example, so that it outputs more information.

	Ensure that PATH_INFO and REQUEST_URI are following the CGI specifications: - PATH_INFO is percent decoded but still utf-8 encoded,   this is available via WGI.path_info and WSF_REQUEST.utf_8_path_info. - Added WSF_REQUEST.percent_encoded_path_info - and WSF_REQUEST.path_info remains the unicode value for PATH_INFO
	Added cgi_variables: WGI_REQUEST_CGI_VARIABLES to have a simple and quick view on CGI variables
	Added execution_variables to be able to iterate on execution variables.
	Added PERCENT_ENCODER.percent_decoded_utf_8_string
	Improved the WSF_DEBUG_HANDLER to provide more information thanks to WSF_DEBUG_INFORMATION object.

## Day - 2014-06-23  Jocelyn Fiat  <github@djoce.net>

	Merge pull request #133 from jocelyn/better_uploading_file
	Improved the uploading of file in regard to temporary filename.

## Day - 2014-06-23  Jocelyn Fiat  <git@djoce.net>

	Raised the void-safety level to "complete" Added comments.

## Day - 2014-06-12  Jocelyn Fiat  <git@djoce.net>

	Fixed library location for http

	Avoid decoding PATH_INFO and PATH_TRANSLATED to follow CGI spec.

	Added example to help debugging EWF This is mainly a kind of echo server .. that return the request information.

## Day - 2014-06-11  Jocelyn Fiat  <git@djoce.net>

	Improved the uploading of file in regard to temporary filename. Avoid to overwrite the same file for concurrent requests uploading the same filename.

## Day - 2014-05-22  Olivier Ligot  <oligot@gmail.com>

	Merge remote-tracking branch 'upstream/master'

## Day - 2014-05-14  Jocelyn Fiat  <github@djoce.net>

	Merge pull request #131 from jocelyn/void-safe
	Make sure to be able to compile in complete void-safe for 14.05 and still compile with 13.11

## Day - 2014-05-14  Jocelyn Fiat  <git@djoce.net>

	Make sure to be able to compile in complete void-safe for 14.05 and still compile with 13.11

	Make sure to be able to compile in complete void-safe for 14.05 and still compile with 13.11

	Merge branch 'master' into void-safe

	Make sure to be able to compile in complete void-safe for 14.05 and still compile with 13.11

## Day - 2014-05-14  Jocelyn Fiat  <github@djoce.net>

	Merge pull request #128 from jocelyn/response_header
	Extracting HTTP_HEADER_BUILDER from HTTP_HEADER
	Improving wsf session usage
	Various unicode related improvement for router and error library.

## Day - 2014-05-14  Jocelyn Fiat  <git@djoce.net>

	Minor change to avoid unecessary conversion from eventual immutable string 8 to string 8.

	Apply recent change on error_handler interface to support unicode error message in response.

	Support for unicode error message for the ERROR_HANDLER.as_string_representation: STRING_32 and as well for debug_output, this avoid unecessary unicode string truncation.

	debug_output can return a string 32, so avoid truncated unicode value by returning a string 32 value for `debug_output' .

	check that cookies data is valid string 8 to follow assertions.

	Replaced notion of session uuid by session id which is more generic (could be a uuid, or something else). Use STRING_TABLE for the implementation of session data container. Added a few missing comments.

	Added comment to explain why conversion to string 8 is safe

	renamed HTTP_HEADER_BUILDER as HTTP_HEADER_MODIFIER

## Day - 2014-04-22  Jocelyn Fiat  <git@djoce.net>

	Updated ecf files toward complete void-safety Added iron package files. Added libfcgi files to compile .lib and .dll on Windows

	Added more tests for uri-template matching, especially with url that contains %2F  i.e the percent encoded slash '/'

	Fixed various Unicode text handling. Moved example folder inside the library, and renamed it "demo" Improved example code.

	Merge branch 'master' of https://github.com/EiffelWebFramework/EWF.wiki

	Merge branch 'master' of https://github.com/eiffelhub/json

	Added support for UTF-8 during decoding. The JSON specification does not require it, but some json encoders are using utf-8 encoding for json encoding. Added related autotest case.

	Be sure to reset `is_https' to False, in case the wsf_request object is reused by the implementation.

	is_https should not rely on REQUEST_SCHEME which may still be "http" for SSL connection.

	better comments.

	Corrected support of https request in `server_url' (and callers). Added query `is_https' to indicate if the request is done via a https connection or not.

## Day - 2014-04-17  Jocelyn Fiat  <github@djoce.net>

	Updated Documentation__Request (markdown)

	Updated Documentation__Request (markdown)

	Updated Documentation__Request (markdown)

## Day - 2014-04-10  Jocelyn Fiat  <git@djoce.net>

	Added an example to embed EWF nino service into a Vision2 desktop application. This is locally consumed via the embedded web browser component.

## Day - 2014-04-09  Jocelyn Fiat  <git@djoce.net>

	Updated encoder library, especially URL encoders to reuse implementation of percent_encoder.e Fixed JSON_ENCODER for %T and related. Updated related autotest cases.

	Moved implementation of WSF_PERCENT_ENCODER into "encoder" library, and added the *partial* variant.

	Improved BASE64 to update has_error when decoding. Added manual tests.

	fixed code for test_url_encoder

	Do not try to read more bytes from input than provided Content-Length value.

	For maintenance filter, response with http status code {HTTP_STATUS_CODE}.service_unavailable

	Fixed all-stable-safe.ecf fusion

	Fixing JSON encoding code to include among other TAB (%T <-> \t)

## Day - 2014-04-08  Jocelyn Fiat  <git@djoce.net>

	Fixed issue with URL_ENCODER encoding (and small optimization)

## Day - 2014-04-02  Jocelyn Fiat  <github@djoce.net>

	Updated Documentation__Request (markdown)

	Updated Documentation__Request (markdown)

	Updated Documentation__Request (markdown)

## Day - 2014-03-26  Jocelyn Fiat  <git@djoce.net>

	Code improvement Cosmetic (comments, names, formatting)

## Day - 2014-03-19  hassany  <ynhwebdev@gmail.com>

	Fix STRING_32 issues

	Add javascript function

## Day - 2014-03-19  severin  <muengers@student.ethz.ch>

	Updated readme

	Added more comments and assertions to all classes; clean up

## Day - 2014-03-18  Jocelyn Fiat  <git@djoce.net>

	Added alias "[]" to `item', to get header value for a header name. Added assigner for `item' to make it easier to add header item without confusing key and value. Better parameter names (more explicit)

## Day - 2014-03-17  Jocelyn Fiat  <git@djoce.net>

	Added comments, used better parameter names.

	Extracting HTTP_HEADER_BUILDER from HTTP_HEADER   to provide useful interface on WSF_RESPONSE,   and make WSF_SESSION easier to use.

## Day - 2014-03-13  Jocelyn Fiat  <git@djoce.net>

	Updated demo_basic example to be easier to read, and demonstrate various scenario.

## Day - 2014-03-12  hassany  <ynhwebdev@gmail.com>

	Extend documentation

## Day - 2014-03-12  severin  <muengers@student.ethz.ch>

	Updated comments and added contracts for core controls in webcontrol

	Merge branch 'widget' of github.com:ynh/EWF into widget

## Day - 2014-03-12  hassany  <ynhwebdev@gmail.com>

	Add file definition

## Day - 2014-03-05  severin  <muengers@student.ethz.ch>

	Added assets to library

	Merge branch 'widget' of github.com:ynh/EWF into widget

	Simplified WSF_EMAIL_VALIDATOR regexp

## Day - 2014-03-05  YNH Webdev  <ynhwebdev@gmail.com>

	Rename WSF_FILE to WSF_FILE_DEFINITION

	Add Basepath

	Change STRING TO STRING_32

## Day - 2014-03-03  Jocelyn Fiat  <github@djoce.net>

	Update README.md

## Day - 2014-03-03  Olivier Ligot  <oligot@gmail.com>

	json: comment '* text=auto' in .gitattributes

## Day - 2014-03-03  Jocelyn Fiat  <git@djoce.net>

	Added a demo application server for basic http autorization

## Day - 2014-02-28  Jocelyn Fiat  <git@djoce.net>

	Removed usage of remote anchor types.

## Day - 2014-02-27  Jocelyn Fiat  <github@djoce.net>

	added anchor link for wiki and jekyl engine

	used <a name=".."></a>  instead of <a name=".."/> form (jekill has trouble with it)

## Day - 2014-02-27  Jocelyn Fiat  <git@djoce.net>

	Merge branch 'master' of https://github.com/eiffelhub/json

	Merge branch 'master' of https://github.com/EiffelWebFramework/EWF.wiki

## Day - 2014-02-26  YNH Webdev  <ynhwebdev@gmail.com>

	Rename progress_source

## Day - 2014-02-24  Jocelyn Fiat  <git@djoce.net>

	Fixed autotests cases compilation of http_authorization library.

	Fixed the ecf to test global compilation of EWF.

## Day - 2014-02-23  YNH Webdev  <ynhwebdev@gmail.com>

	Add class description to validators Rename Wsf_progresssource

	Extend upload demo

	Fix state transition

## Day - 2014-02-21  severin  <muengers@student.ethz.ch>

	Began with class documentation

## Day - 2014-02-11  colin-adams  <colinpauladams@gmail.com>

	Removed warning about not being part of release.

## Day - 2014-02-03  Jocelyn Fiat  <github@djoce.net>

	Updated Home (markdown)

## Day - 2014-02-03  Jocelyn Fiat  <git@djoce.net>

	Udated to highest level of void-safety. Fixed obsolete calls.

## Day - 2014-01-27  Jocelyn Fiat  <git@djoce.net>

	Updated README.md

## Day - 2014-01-26  YNH Webdev  <ynhwebdev@gmail.com>

	Finalize WSF_DYNAMIC_MULTI_CONTROL

	Add dynamic multicontrol

## Day - 2014-01-25  YNH Webdev  <ynhwebdev@gmail.com>

	Image preview

	Fix upload state

## Day - 2014-01-24  Jocelyn Fiat  <git@djoce.net>

	Update restbucksCRUD example to use "crypto" library rather than "eel". Updated readme.md to add curl command to test the server.

	Added PUT processing for image_uploader EWF example.

## Day - 2014-01-12  jvelilla  <javier.hector@gmail.com>

	Udated to highest level of void-safety. Fixed obsolete calls.

## Day - 2014-01-11  severin  <muengers@student.ethz.ch>

	Merge branch 'widget' of github.com:ynh/EWF into widget

## Day - 2014-01-11  YNH Webdev  <ynhwebdev@gmail.com>

	Add set value to value controls

## Day - 2014-01-11  severin  <muengers@student.ethz.ch>

	Included time library to set current date in date picker

## Day - 2014-01-10  severin  <muengers@student.ethz.ch>

	Added ability to form element to get value (for convenience/completion)

## Day - 2014-01-08  severin  <muengers@student.ethz.ch>

	Added ability to show/hide border of form elements

	Small change on date picker control, removed date input

## Day - 2014-01-07  jvelilla  <javier.hector@gmail.com>

	Merge pull request #127 from jvelilla/master
	Fixed error with identity encoding.

	Fixed error with identity encoding.

## Day - 2014-01-07  Jocelyn Fiat  <github@djoce.net>

	Created Documentation__Connector (markdown)

	Updated Documentation (markdown)

	Created Documentation__Router (markdown)

	Updated Documentation _Router (markdown)

	Created Documentation__Response (markdown)

	Created Documentation__Request (markdown)

	Created Documentation _Router (markdown)

	Updated Documentation (markdown)

	Created Documentation__Service (markdown)

	Updated Home (markdown)

	Updated Documentation (markdown)

	Updated Documentation (markdown)

	Updated Documentation (markdown)

	Updated Documentation (markdown)

	Updated Documentation (markdown)

	Updated Documentation (markdown)

	Updated Documentation (markdown)

	Updated Documentation (markdown)

	draft

## Day - 2014-01-06  severin  <muengers@student.ethz.ch>

	Modified datepicker control

## Day - 2014-01-05  severin  <muengers@student.ethz.ch>

	Removed country chooser widget

	fixed js

	modified country and date/time chooser

## Day - 2014-01-04  severin  <muengers@student.ethz.ch>

	Included bootstrap datetimepicker

	Added date chooser widget

	Added precondition in layout control

	Removed add_dropdown methods from navbar, some cleanup in different controls

	ATTENTION: ugly append_attributes added to stateless control, replaces set_attributes -> maybe improve

	Moved set_attributes from BASIC_CONTROL to STATELESS_CONTROL

## Day - 2014-01-03  severin  <muengers@student.ethz.ch>

	Merge branch 'widget' of github.com:ynh/EWF into widget

## Day - 2014-01-02  YNH Webdev  <ynhwebdev@gmail.com>

	Add disable option

	Allow remove

## Day - 2014-01-01  YNH Webdev  <ynhwebdev@gmail.com>

	Add serverside file id to file structure

	Allow detached values

	Demo upload

## Day - 2014-01-01  severin  <muengers@student.ethz.ch>

	Merge branch 'widget' of github.com:ynh/EWF into widget

	Small page control change

## Day - 2014-01-01  YNH Webdev  <ynhwebdev@gmail.com>

	Workin file upload

## Day - 2013-12-31  YNH Webdev  <ynhwebdev@gmail.com>

	Change parameter type

	File upload implementation part1

	Fix dropdown list, clean up actions

## Day - 2013-12-03  Jocelyn Fiat  <git@djoce.net>

	Fixed and improved {WSF_REQUEST}.read_input_data_into_file. Now use the content length to get exactly what is expected from the request. Added check assertion

	Fixed various issues with libfcgi on Linux, mainly related to stdout,stderr,stdin, feof and related. Added `reset' to the libfcgi input stream so that it is possible to reset previous errors.

## Day - 2013-12-02  Jocelyn Fiat  <git@djoce.net>

	For Nino connector, ensured that environment variables are percent-encoded in meta variables.

## Day - 2013-11-20  Jocelyn Fiat  <git@djoce.net>

	fixed compilation of libfcgi tests.

	Accept again detachable argument for HTTP_AUTHORIZATION.make (..) to avoid breaking existing code. Note that HTTP_AUTHORIZATION.http_authorization is now detachable.

	fixed compilation of the filter example

## Day - 2013-11-19  Jocelyn Fiat  <git@djoce.net>

	The "not implemented" response, now also precise the request method.

	http_client: changed some default settings `connect_timeout' and `timeout' to 0 (never timeout) Updated comments

	Fixed compilation of restbucksCRUD for the policy driven framework target.

## Day - 2013-11-18  Jocelyn Fiat  <sandbox.eiffel.com>

	Merge branch 'master' of https://github.com/Eiffel-World/EiffelWebNino

	removed CRLF eol in many files

	merged wiki page changes

	Merge branch 'master' of https://github.com/eiffelhub/json

	native eol

## Day - 2013-11-12  Jocelyn Fiat  <git@djoce.net>

	Fixed wrong assertion related to upload_data and upload_filename in HTTP_CLIENT_REQUEST_CONTEXT .
	Fixed issue #124
	Enable all assertion for the related autotest cases.

## Day - 2013-11-11  YNH Webdev  <ynhwebdev@gmail.com>

	Rename files

## Day - 2013-11-10  YNH Webdev  <ynhwebdev@gmail.com>

	Rename validators, Make forms resizable

	Validate all fields and make regexp stricter

	Fix event handler

	Fix form element control

	Update sample app

	Fix email validation and min and max validator

## Day - 2013-11-09  YNH Webdev  <ynhwebdev@gmail.com>

	Fix slider

	Fix assert path

## Day - 2013-11-08  YNH Webdev  <ynhwebdev@gmail.com>

	Fix rendering issue. Add active class

## Day - 2013-11-08  Jocelyn Fiat  <git@djoce.net>

	Fixed issue with unicode login:password Added EIS info Added testing cases.

	Updated gewf source code to allow custom settings,  and in particular the location of the templates. Fixed compilation of application launcher, and make it more flexible.

## Day - 2013-11-08  jvelilla  <javier.hector@gmail.com>

	Added DEBUG_OUTPUT to JSON_OBJECT

	Updated readme file

	Merge branch 'master' of https://github.com/eiffelhub/json

	Merge pull request #7 from ynh/simplify_json_object
	Simplify the json object by adding type specific put and replace

## Day - 2013-11-08  YNH Webdev  <ynhwebdev@gmail.com>

	Adjust layout control and fix navlist

	Fix autocomplete

	Redesign states and implement generated control_name

## Day - 2013-11-07  jvelilla  <javier.hector@gmail.com>

	Merge branch 'master' of https://github.com/eiffelhub/json

	Updated comments, add DEBUG_OUPUT to JSON_ARRAY.

## Day - 2013-11-07  Jocelyn Fiat  <github@djoce.net>

	cosmetic and indexing note description

## Day - 2013-11-07  jvelilla  <javier.hector@gmail.com>

	Fixed normalized line endings

	Normalize line endings

	Added gitattribute configuration file

## Day - 2013-11-06  YNH Webdev  <ynhwebdev@gmail.com>

	Add stateless widgets

## Day - 2013-11-05  severin  <muengers@student.ethz.ch>

	Fix Layout Control

	Added navlist widget

## Day - 2013-11-05  YNH Webdev  <ynhwebdev@gmail.com>

	Fix project

## Day - 2013-11-05  severin  <muengers@student.ethz.ch>

	Added WSF_LAYOUT_CONTROL

## Day - 2013-11-04  YNH Webdev  <ynhwebdev@gmail.com>

	Fix navbar state problem

## Day - 2013-11-03  YNH Webdev  <ynhwebdev@gmail.com>

	Add item alias

## Day - 2013-11-02  severin  <muengers@student.ethz.ch>

	Fixed js

	Added dropdown control

	Fixed creation procedures (make)

## Day - 2013-10-30  YNH Webdev  <ynhwebdev@gmail.com>

	Fix image sizes

	Fix slider code

## Day - 2013-10-30  severin  <muengers@student.ethz.ch>

	Slider fix

## Day - 2013-10-29  YNH Webdev  <ynhwebdev@gmail.com>

	Fix path

## Day - 2013-10-29  severin  <muengers@student.ethz.ch>

	Merge branch 'widget_slider' into widget
	Conflicts:
		draft/library/wsf_js_widget/kernel/webcontrol/wsf_control.e
		examples/widgetapp/base_page.e

	Fixed WSF_MULTI_CONTROL (wrong order of subcontrols), completed navbar, improved slider

## Day - 2013-10-25  Jocelyn Fiat  <git@djoce.net>

	Fixed WSF_FILE_SYSTEM_HANDLER.process_index (..)

	Added content_negotiation to official EWF release.

## Day - 2013-10-24  Jocelyn Fiat  <git@djoce.net>

	Removed trimmed_string function and callers, and for now, use (left_|right_)adjust

## Day - 2013-10-23  Jocelyn Fiat  <github@djoce.net>

	Merge pull request #83 from jvelilla/master
	Contracts, comments and cosmetic

## Day - 2013-10-23  Jocelyn Fiat  <git@djoce.net>

	Removed trimmed_string function and callers, and for now, use (left_|right_)adjust

## Day - 2013-10-22  jvelilla  <javier.hector@gmail.com>

	Reuse trimmed_string from HTTP_HEADER_UTILITIES. Added description to FITNESS_AND_QUALITY.

## Day - 2013-10-21  jvelilla  <javier.hector@gmail.com>

	Merge branch 'master' of https://github.com/EiffelWebFramework/EWF

## Day - 2013-10-21  Jocelyn Fiat  <github@djoce.net>

	Updated Tasks Roadmap (markdown)

	Updated roadmap (markdown)

	Created roadmap (markdown)

## Day - 2013-10-18  Jocelyn Fiat  <git@djoce.net>

	Merge branch 'content_nego_review'
	Conflicts:
		library/network/protocol/content_negotiation/src/conneg_server_side.e
		library/network/protocol/content_negotiation/src/parsers/common_accept_header_parser.e
		library/network/protocol/content_negotiation/test/conneg_server_side_test.e

	Merge branch 'master' of github.com:EiffelWebFramework/EWF

	Added content_negotiation in "wsf" library

	Minor changes in wsf test cases.

	Reintroduced WSF_SERVICE.to_wgi_service: WGI_SERVICE since it was used in the "WSF" test cases.

	Fixed issue related to {WSF_WGI_DELAYED_HEADER_RESPONSE} and filter response like the logger response wrapper.
	issue#82

	Fixed an issue with one short chunk and empty trailer
	issue#81

	Using the new Content Negotiation library to implement WSF_REQUEST.is_content_type_accepted

	Updated README.md for conneg

	Class renaming for content_negotiation Splitted SERVER_CONTENT_NEGOTIATION in 4 differents classes for each kind of negotiation Changed to use ITERABLE over LIST for supported variants arguments Factorized some code for http parameter parsing such as q=1.0;note="blabla"  and so on Integrated within EWF

## Day - 2013-10-15  Jocelyn Fiat  <git@djoce.net>

	Updated content_negotiation with better class names and feature names. Minor semantic changes in VARIANTS classes Factorized some code in HTTP_ACCEPT_LANGUAGE

## Day - 2013-10-14  Jocelyn Fiat  <git@djoce.net>

	Enabled assertion on content_negotiation during autotests The tests project is now void-safe
	Using force instead of put_left seems to work fine
	  and is better for performance,
	  and no need to check for precondition "not before"

## Day - 2013-10-04  jvelilla  <javier.hector@gmail.com>

	revert previous change

	Assertions turn on.

	Merge pull request #80 from jvelilla/master
	Fixed issue# 79 Bug in CONNEG_SERVER_SIDE

	Fixed issue# 79 Bug in CONNEG_SERVER_SIDE

## Day - 2013-10-02  Jocelyn Fiat  <github@djoce.net>

	Merge pull request #78 from colin-adams/errors
	When custom error is created in check_resource_exists, use it

## Day - 2013-10-01  Colin Adams  <colinpauladams@gmail.com>

	When custom error is created in check_resource_exists, use it

## Day - 2013-09-29  Severin  <severin@random.(none)>

	Test

## Day - 2013-09-28  Olivier Ligot  <oligot@gmail.com>

	Start to write documentation about connectors

## Day - 2013-09-28  YNH Webdev  <ynhwebdev@gmail.com>

	Add codeview

	Fix news datasource

	Fix load state error

	Implement lazy js load wraper

	Load needed libraries dynamically

## Day - 2013-09-27  Severin Münger  <souvarin.m@gmail.com>

	Fixed slider

## Day - 2013-09-27  YNH Webdev  <ynhwebdev@gmail.com>

	Adjust widgetapp

	Create new JSON_OBJECT

	Add boolean

## Day - 2013-09-25  jvelilla  <javier.hector@gmail.com>

	Merge pull request #76 from jvelilla/master
	Fixed Issue #75 CONNEG doesn't handle accept encodings correcty

	Added more scenarios to test accept encoding with identity.

	Fixed Issue #75 CONNEG doesn't handle accept encodings correcty

## Day - 2013-09-25  YNH Webdev  <ynhwebdev@gmail.com>

	Remove remaining `detachable` variables

	Make types attached

	Fix formating

	Rename procedures. Change input type of replace_with_string and put_string

## Day - 2013-09-24  YNH Webdev  <ynhwebdev@gmail.com>

	Simplify the json object by adding type specific put and replace

## Day - 2013-09-24  Jocelyn Fiat  <git@djoce.net>

	Removed unwanted call to RT_DEBUGGER in WSF_DEBUG_HANDLER.
	This line was committed by error.

	Reused string constants from HTTP_HEADER_NAMES

	Added implicit conversion from agent to WSF_URI_TEMPLATE_AGENT_HANDLER Mainly for convenience.

	Use WSF_RESPONSE.put_header_lines (header_object) when possible, instead of put_header_text (header_object.string)

	Added WSF_SELF_DOCUMENTED_AGENT_HANDLER and variants for uri, uri_template, starts_with, ... to provide a way to documentate easily wsf agent handler.

## Day - 2013-09-24  YNH Webdev  <ynhwebdev@gmail.com>

	Merge branch 'widget' of github.com:souvarin/EWF into widget

## Day - 2013-09-24  Jocelyn Fiat  <github@djoce.net>

	Merge pull request #74 from jvelilla/master
	Added description to results classes.
	Removed unnecessary classes
	Clean code: removed feature out, updated corresponding test cases.

## Day - 2013-09-24  Severin Münger  <souvarin.m@gmail.com>

	Moved to draft

	Removed WSF_STATELESS_MULTI_CONTROL

	Changed slider

	Added slider demo

	Added simple image slider widget

## Day - 2013-09-24  YNH Webdev  <ynhwebdev@gmail.com>

	Add table title

	Implement remove

## Day - 2013-09-23  YNH Webdev  <ynhwebdev@gmail.com>

	Stop interval if deleted

	Introduce actions First working modal

## Day - 2013-09-22  YNH Webdev  <ynhwebdev@gmail.com>

	Set url within page class

	Fix confict

	Merge branch 'widget' of github.com:souvarin/EWF into widget_state_redesign
	Conflicts:
		examples/widgetapp/base_page.e

	Implement control isolation

	Restructure callbacks

## Day - 2013-09-22  Severin Münger  <souvarin.m@gmail.com>

	Merge branch 'widget' of github.com:ynh/EWF into widget

	Improved Navbar, changed attribute handling

## Day - 2013-09-22  YNH Webdev  <ynhwebdev@gmail.com>

	Add comments to grid controls

## Day - 2013-09-21  Severin Münger  <souvarin.m@gmail.com>

	Added comments to autocompletion, input, navbar, progressbar, validator, webcontrol. Some more little changes.

## Day - 2013-09-20  YNH Webdev  <ynhwebdev@gmail.com>

	Use append

	Fix tuple

	Make recommended changes - Implicit casting - Use same_string

## Day - 2013-09-20  jvelilla  <javier.hector@gmail.com>

	Added description to results classes. Removed unnecessary class Clean code: removed feature out, updated corresponding test cases.

## Day - 2013-09-20  YNH Webdev  <ynhwebdev@gmail.com>

	Rename clusters to singular names

	Move project to wsf_js_widget

## Day - 2013-09-20  Jocelyn Fiat  <git@djoce.net>

	Renamed `content_negotation' as `content_negotiation'  (fixed typo) Updated .ecf and Eiffel code depending on previous CONNEG

	Integrated changes on content negociation library

## Day - 2013-09-20  ynh  <ynhwebdev@gmail.com>

	Merge pull request #2 from jocelyn/widget_first_review
	Minor changes

## Day - 2013-09-20  Jocelyn Fiat  <git@djoce.net>

	Minor changes  - using http_client library instead of libcurl directly  - using implicit conversion to JSON_STRING to improve code readability  - use ARRAYED_LIST instead of LINKED_LIST .. for performance.  - cosmetic .. but still a lot of feature clauses are missing, comments, assertions ...

## Day - 2013-09-19  jvelilla  <javier.hector@gmail.com>

	Forgot to add class description

	Removed http classes related to http expectations. Updated code based on the code review. Still work in progress

## Day - 2013-09-17  jvelilla  <javier.hector@gmail.com>

	New directory structure (variants, results, parsers) Refactor STRING to READABLE_STRING_8. Clean code, added documentation and EIS references.

	Renamed CONNEG to content_negotiation. Update MIME_PARSER to use HTTP_MEDIA_TYPE.

## Day - 2013-09-16  Jocelyn Fiat  <git@djoce.net>

	Accepts "*" as valid media type (interpreted as */* to be flexible)

## Day - 2013-09-16  jvelilla  <javier.hector@gmail.com>

	Merge branch 'master' of https://github.com/EiffelWebFramework/EWF

## Day - 2013-09-16  Jocelyn Fiat  <git@djoce.net>

	Fixed type having a semicolon in a parameter value such as   "text/plain; param1=%"something;foo=bar%"; param2=%"another-thing%"

## Day - 2013-09-16  jvelilla  <javier.hector@gmail.com>

	Merge branch 'master' of https://github.com/EiffelWebFramework/EWF

## Day - 2013-09-16  Jocelyn Fiat  <git@djoce.net>

	Added autotests to http library in relation with mime type and content type. Fixed an issue with more than one parameter.

## Day - 2013-09-16  jvelilla  <javier.hector@gmail.com>

	Merge branch 'master' of https://github.com/EiffelWebFramework/EWF

## Day - 2013-09-16  YNH Webdev  <ynhwebdev@gmail.com>

	Slow down fetching

## Day - 2013-09-15  Severin Münger  <souvarin.m@gmail.com>

	Fixed progressbar

	Merge branch 'widget' of github.com:ynh/EWF into widget

	Added progress callback

## Day - 2013-09-15  YNH Webdev  <ynhwebdev@gmail.com>

	Make js files local

	Add all countries to flag list Set encoding (Must be changed to UTF-8 in future)

	Rearrange demo Add contact autocompletion

	Create basepage

	Merge branch 'widget_grid' into widget
	Conflicts:
		examples/widgetapp/widget.coffee
		examples/widgetapp/widget.js

	Fix suggestions

## Day - 2013-09-15  Severin Münger  <souvarin.m@gmail.com>

	Small changes

	Added Progress Control

	Added Progress Control

	Included navbar example

## Day - 2013-09-14  YNH Webdev  <ynhwebdev@gmail.com>

	Fix change event

	Remove column from grid

	Style demo pages

	Implement repeater

	Google news example

	- Add event paramenter - Implement Paging control

## Day - 2013-09-13  Severin Münger  <souvarin.m@gmail.com>

	Fixed rendering, added navbar

## Day - 2013-09-13  YNH Webdev  <ynhwebdev@gmail.com>

	Fix path in project

## Day - 2013-09-13  Jocelyn Fiat  <git@djoce.net>

	Merge branch 'master' of github.com:EiffelWebFramework/EWF

	Added PATCH support in http_client, and provided custom_with_upload_data and custom_with_upload_file.

	forget about older version of Eiffel cURL

## Day - 2013-09-13  Severin Münger  <souvarin.m@gmail.com>

	Merge branch 'widget' of github.com:ynh/EWF into widget
	Conflicts:
		library/server/wsf_html/webcontrol/wsf_control.e

	Small changes/fixes

## Day - 2013-09-13  YNH Webdev  <ynhwebdev@gmail.com>

	Fix render function

## Day - 2013-09-13  Severin Münger  <souvarin.m@gmail.com>

	Small fix removed DOCTYPE

	New Control structure

## Day - 2013-09-13  YNH Webdev  <ynhwebdev@gmail.com>

	Merge branch 'widget' of github.com:souvarin/EWF into widget
	Conflicts:
		library/server/wsf_html/wsf_html-safe.ecf

	Add Grid Widget

## Day - 2013-09-12  Severin Münger  <souvarin.m@gmail.com>

	Extended autocompletion with customized templates

	Autocompletion

	Changed structure

## Day - 2013-09-12  oligot  <oligot@gmail.com>

	Created Filter (markdown)

## Day - 2013-09-12  Olivier Ligot  <oligot@gmail.com>

	README.md: Remove dot in the community section

	Added Community section to the README.md file

## Day - 2013-09-09  Jocelyn Fiat  <git@djoce.net>

	Fixing handling of query parameter without value
	Issue#70 https://github.com/EiffelWebFramework/EWF/issues/70

## Day - 2013-09-08  jvelilla  <javier.hector@gmail.com>

	Moved Selenium web driver to WebDriver-Eiffel repository

## Day - 2013-09-07  jvelilla  <javier.hector@gmail.com>

	Merge branch 'master' of https://github.com/EiffelWebFramework/EWF

## Day - 2013-09-06  Severin Münger  <souvarin.m@gmail.com>

	Merge branch 'widget' of github.com:ynh/EWF into widget

## Day - 2013-09-06  YNH Webdev  <ynhwebdev@gmail.com>

	Min/Max validator

## Day - 2013-09-06  Severin Münger  <souvarin.m@gmail.com>

	Merge branch 'widget' of github.com:ynh/EWF into widget
	Conflicts:
		examples/widgetapp/sample_page.e

	Some small changes

## Day - 2013-09-06  YNH Webdev  <ynhwebdev@gmail.com>

	Show server side error in validation box

	Add HTML control

	Small render fix

## Day - 2013-09-06  Jocelyn Fiat  <git@djoce.net>

	fixed compilation of wsf_extension

## Day - 2013-09-06  YNH Webdev  <ynhwebdev@gmail.com>

	Comment js code

	Implement serverside and client side validatation

## Day - 2013-09-06  Jocelyn Fiat  <git@djoce.net>

	Merge branch 'master' of github.com:EiffelWebFramework/EWF

	Added WSF_CUSTOM_HEADER_FILTER which provide a convenient way to add a custom header from a filter. Added to wsf_extension WSF_DEBUG_FILTER and WSF_DEBUG_HANDLER that could be convenient to test specific requests Restructured wsf_extension

	added policy driven license .lic files

	Added WSF_WIDGET_RAW_TEXT to render text via html encoding. Added WSF_WIDGET_COMPOSITE.extend_html_text (READABLE_STRING_8) that should replace the now obsolete "extend_text" Added WSF_WIDGET_COMPOSITE.extend_raw_text (READABLE_STRING_GENERAL), for text that need to be html encoded during html rendering. Made WSF_FORM_RAW_TEXT obsolete.

	removed useless (and unused) function {WSF_SERVICE}.to_wgi_service: WGI_SERVICE

	Fixed bad output

	Used res.put_header_lines (h) rather than res.put_header_text (h.string)

## Day - 2013-09-06  YNH Webdev  <ynhwebdev@gmail.com>

	First working checkbox list

	Merge branch 'widget' of github.com:souvarin/EWF into widget

## Day - 2013-09-06  Severin Münger  <souvarin.m@gmail.com>

	Added checkbox list, modified form validation

## Day - 2013-09-05  YNH Webdev  <ynhwebdev@gmail.com>

	Merge branch 'widget' of github.com:souvarin/EWF into widget

## Day - 2013-09-05  Severin Münger  <souvarin.m@gmail.com>

	Added validators for decimals and mails

	Added Regexp validation (later used for mail, numbers...)

## Day - 2013-09-05  YNH Webdev  <ynhwebdev@gmail.com>

	Fix form and textarea bug

	Merge branch 'widget' of github.com:souvarin/EWF into widget
	Conflicts:
		library/server/wsf_html/webcontrol/wsf_control.e

	Test the new controls

## Day - 2013-09-05  Severin Münger  <souvarin.m@gmail.com>

	Implemented WSF_CHECKBOX_CONTROL, added id attribute to rendering of WSF_CONTROL

## Day - 2013-09-05  YNH Webdev  <ynhwebdev@gmail.com>

	Merge branch 'widget' of github.com:ynh/EWF into widget

	Fix render function

## Day - 2013-09-05  Severin Münger  <souvarin.m@gmail.com>

	Restructured validators, fixed form element rendering

## Day - 2013-09-05  YNH Webdev  <ynhwebdev@gmail.com>

	Fix render function

	Merge branch 'widget' of github.com:souvarin/EWF into widget

	Add bootstrap

## Day - 2013-09-05  Severin Münger  <souvarin.m@gmail.com>

	Implemented WSF_FORM_ELEMENT_CONTROL

	Merge branch 'widget' of github.com:ynh/EWF into widget
	Conflicts:
		library/server/wsf_html/webcontrol/wsf_control.e
		library/server/wsf_html/webcontrol/wsf_text_control.e

	Began with implementation of form handling

## Day - 2013-09-05  YNH Webdev  <ynhwebdev@gmail.com>

	Use render tag

## Day - 2013-09-05  Severin Münger  <souvarin.m@gmail.com>

	Adapted rendering of multi control

	Merge branch 'widget' of github.com:ynh/EWF into widget

	Changed creation procedures

## Day - 2013-09-05  YNH Webdev  <ynhwebdev@gmail.com>

	Generate tag

	Change wsf control

## Day - 2013-09-04  oligot  <oligot@gmail.com>

	Updated Router (markdown)

	Updated Router (markdown)

	Updated Request and response (markdown)

	Updated Request and response (markdown)

	Updated Request and response (markdown)

	Created Router (markdown)

	Updated Connectors (markdown)

	Created Request and response (markdown)

	Created Connectors (markdown)

## Day - 2013-09-04  Olivier Ligot  <oligot@gmail.com>

	Contribute page

## Day - 2013-09-03  Severin Münger  <souvarin.m@gmail.com>

	Added class for TextArea

	Added TextArea

## Day - 2013-09-02  Severin Münger  <souvarin.m@gmail.com>

	forgot to add new files

	Added generalized input control similiar to text

## Day - 2013-08-29  YNH Webdev  <ynhwebdev@gmail.com>

	Only send changes back to client

## Day - 2013-08-28  YNH Webdev  <ynhwebdev@gmail.com>

	Add comments Use Precursor

	Clean up code Simplify event

	Only callback if there is an event attached

	Remove ugly do nothing hack

	Communication in both directions (Text control) Code regrouping

	Fix multi control Use multi control in example

	Comment and reformat coffee script file

	First working callback

## Day - 2013-08-27  Severin Münger  <souvarin.m@gmail.com>

	Added WSF_MULTI_CONTROL to support controls that consist of multiple separate controls.

	Created first working sample page application.

## Day - 2013-08-27  YNH Webdev  <ynhwebdev@gmail.com>

	Remove content length

	Add html body

	Add assigner

	Add post condition

	Move initalize controls

	Pretty Print

	Add a json state to each control

	Fix path

	Page structure

	Test

## Day - 2013-08-27  Severin Münger  <souvarin.m@gmail.com>

	Created widget-project testapp project.

## Day - 2013-08-23  oligot  <oligot@gmail.com>

	Updated Web meeting 2012 09 18 (markdown)

	Updated Useful links (markdown)

	Updated Tasks Roadmap (markdown)

	Updated Projects new suggestions (markdown)

	Updated Projects new suggestions (markdown)

	Updated Projects (markdown)

	Updated Projects (markdown)

	Updated Projects (markdown)

	Updated Projects (markdown)

	Updated Meetings (markdown)

	Updated Home (markdown)

	Updated Home (markdown)

	Updated Home (markdown)

	Updated Home (markdown)

	Updated EWSGI specification (markdown)

	Updated EWSGI specification (markdown)

	Updated EWSGI (markdown)

	Links

	Links

## Day - 2013-08-21  Jocelyn Fiat  <git@djoce.net>

	Updated copyright for policy-driven classes, which is a contribution from Colin Adams.

## Day - 2013-08-21  jvelilla  <javier.hector@gmail.com>

	Merge branch 'master' of https://github.com/jocelyn/EWF

## Day - 2013-08-21  Jocelyn Fiat  <git@djoce.net>

	Merge branch 'master' of https://github.com/EiffelWebFramework/EWF.wiki

## Day - 2013-08-20  Jocelyn Fiat  <git@djoce.net>

	Extracted the policy driven classes into their own library for now "wsf_policy_driven.ecf" Updated the restbucksCRUD example to demonstrate both approaches.

	Moved recent policy-driven classes into "policy" sub folder

	Merge branch 'handler' of github.com:colin-adams/EWF into colin-adams-handler

	Removed WSF_ROUTING_HANDLER.make_with_router (a_router)    It was not used in existing code, and potentially dangerous, if coder reuses router by accident.

## Day - 2013-08-19  Colin Adams  <colinpauladams@gmail.com>

	Added header comment about redefining for extension methods

## Day - 2013-08-16  Colin Adams  <colinpauladams@gmail.com>

	Changed age to max_age

## Day - 2013-08-15  Colin Adams  <colinpauladams@gmail.com>

	Changed comment on execute to check assertion

	Improved comment to ensure_content_exists - take 2

	Improved comment to ensure_content_exists

	Removed empty feature clause

## Day - 2013-08-14  Colin Adams  <colinpauladams@gmail.com>

	Fixed recursion on router bug

## Day - 2013-08-14  colin-adams  <colinpauladams@gmail.com>

	Updated Writing the handlers (markdown)

	Updated Writing the handlers (markdown)

	Updated Writing the handlers (markdown)

	Updated Wsf previous policy (markdown)

## Day - 2013-08-14  Colin Adams  <colinpauladams@gmail.com>

	Further use of constants for execution variables

## Day - 2013-08-13  colin-adams  <colinpauladams@gmail.com>

	Updated Writing the handlers (markdown)

## Day - 2013-08-13  Colin Adams  <colinpauladams@gmail.com>

	Gave symbolic names to execution variables used by the framework

## Day - 2013-08-13  colin-adams  <colinpauladams@gmail.com>

	Updated Writing the handlers (markdown)

## Day - 2013-08-12  Colin Adams  <colinpauladams@gmail.com>

	Added some checks for custom erros being set.

## Day - 2013-08-12  colin-adams  <colinpauladams@gmail.com>

	Updated Writing the handlers (markdown)

	Updated Writing the handlers (markdown)

## Day - 2013-08-12  Colin Adams  <colinpauladams@gmail.com>

	refactored to allow etags to work properly when multiple representations are available

## Day - 2013-08-12  colin-adams  <colinpauladams@gmail.com>

	Updated Using the policy driven framework (markdown)

## Day - 2013-08-08  Colin Adams  <colinpauladams@gmail.com>

	Found another TODO - write_error_response in GET processing

## Day - 2013-08-08  colin-adams  <colinpauladams@gmail.com>

	Updated Using the policy driven framework (markdown)

## Day - 2013-08-08  Colin Adams  <colinpauladams@gmail.com>

	Implemented remaining error response calls

	Errors corrected that were discovered in the course of writing the tutorial

## Day - 2013-08-08  colin-adams  <colinpauladams@gmail.com>

	Updated Writing the handlers (markdown)

	Updated Writing the handlers (markdown)

	Updated Writing the handlers (markdown)

	Updated Writing the handlers (markdown)

## Day - 2013-08-08  Colin Adams  <colinpauladams@gmail.com>

	made deleted into an effective routine

## Day - 2013-08-08  colin-adams  <colinpauladams@gmail.com>

	Updated Writing the handlers (markdown)

## Day - 2013-08-07  colin-adams  <colinpauladams@gmail.com>

	Updated Writing the handlers (markdown)

	Updated Writing the handlers (markdown)

	Updated Writing the handlers (markdown)

	Updated Writing the handlers (markdown)

	Updated Writing the handlers (markdown)

	Created Wsf caching policy (markdown)

	Updated Writing the handlers (markdown)

	Created Wsf previous policy (markdown)

	Updated Writing the handlers (markdown)

	Updated WSF_OPTIONS_POLICY (markdown)

	Updated Writing the handlers (markdown)

	Created WSF_OPTIONS_POLICY (markdown)

	Updated Writing the handlers (markdown)

	Updated Writing the handlers (markdown)

	Updated Writing the handlers (markdown)

	Updated Using the policy driven framework (markdown)

	Created Writing the handlers (markdown)

	Updated Using the policy driven framework (markdown)

	Updated Using the policy driven framework (markdown)

	Created Using the policy driven framework (markdown)

## Day - 2013-08-07  Colin Adams  <colinpauladams@gmail.com>

	Fixes as picked up by code review

## Day - 2013-08-06  Colin Adams  <colinpauladams@gmail.com>

	restbucksCRUD example changed to use policy-driven framework

	Policy-driven URI template handlers

	New routines added to WSF_REQUEST to support ploicy-driven framework

	New routines added to HTTP_HEADER to support ploicy-driven framework

	Add CONNEG to wsf*.ecf to support ploicy-driven framework

## Day - 2013-08-05  jvelilla  <javier.hector@gmail.com>

	Merge pull request #6 from jocelyn/patch20130805
	Enhanced interface of JSON_ARRAY and JSON_OBJECT and new JSON_ITERATOR

## Day - 2013-08-05  Jocelyn Fiat  <git@djoce.net>

	Enhanced interface of JSON_ARRAY and JSON_OBJECT Added JSON_ITERATOR

	removed building the Clib for Eiffel cUrl, since it is not anymore included in EWF.

	Cosmetic (removed commented line and fixed bad indentation)

## Day - 2013-08-05  Jocelyn Fiat  <github@djoce.net>

	Merge pull request #67 from berenddeboer/master
	Remove invariant violation.

## Day - 2013-08-03  Berend de Boer  <berend@pobox.com>

	Remove invariant violation.

## Day - 2013-07-31  Jocelyn Fiat  <github@djoce.net>

	Merge pull request #66 from oligot/fcgi-osx
	FastCGI connector and OS X

## Day - 2013-07-30  Jocelyn Fiat  <github@djoce.net>

	Update README.md

## Day - 2013-07-19  Olivier Ligot  <oligot@gmail.com>

	Fix C compilation when using libfcgi connector on OS X (#65)

## Day - 2013-07-11  jvelilla  <javier.hector@gmail.com>

	Merge pull request #64 from oligot/all-tests
	Tests compile again (fixes #63)

## Day - 2013-07-11  Olivier Ligot  <oligot@gmail.com>

	Tests compile again (fixes #63)

## Day - 2013-07-08  jvelilla  <javier.hector@gmail.com>

	Merge branch 'master' of https://github.com/EiffelWebFramework/EWF
	Conflicts:
		draft/application/cms/README.md
		draft/application/cms/src/cms_session.e
		draft/src/gewf/license.lic
		library/network/http_client/src/expectation/http_client_response_expectation.e

## Day - 2013-07-08  Colin Adams  <colinpauladams@gmail.com>

	Merge branch 'master' into handler pull from upstream

	Merge branch 'master' of github.com:EiffelWebFramework/EWF Routine merge

	prior to merging

## Day - 2013-07-05  Jocelyn Fiat  <git@djoce.net>

	Moved gewf under draft/src/gewf

	added README for gewf

	licensing and copyright

	First working (but limited) tool

	Added first attempt to provide a application builder. For now only trying to have a generic template.
	Do not expect anything working for now, this is just the start of a draft

## Day - 2013-07-04  Jocelyn Fiat  <git@djoce.net>

	Merge branch 'master' of https://github.com/EiffelWebFramework/EWF.wiki

## Day - 2013-07-04  Jocelyn Fiat  <github@djoce.net>

	Updated Doc_Getting_Started (mediawiki)

	Updated Doc_Getting_Started (mediawiki)

	Updated Doc_Getting_Started (mediawiki)

	Updated Doc_Getting_Started (mediawiki)

	Updated Doc_Getting_Started (mediawiki)

	Updated Doc_Index (mediawiki)

	Updated Doc_Index (mediawiki)

	Updated Doc_Index (mediawiki)

	Created Doc_Getting_Started (mediawiki)

	Created Doc_Index (mediawiki)

## Day - 2013-07-02  Jocelyn Fiat  <git@djoce.net>

	Moved the cms component to https://github.com/EiffelWebFramework/cms This is now out of EWF repository.

## Day - 2013-06-28  Jocelyn Fiat  <git@djoce.net>

	improve file system handler to ignore .* *.swp *~ or using FUNCTION to compute the ignore behavior

	Improved Unicode support.

	Ensured that EWF  compiles with 7.2
	(note about ecf version
	   1-10-0 void_safety="all" <-->  1-11-0 void_safety="transitional"
	   1-10-0 void_safety="all" <---  1-11-1 void_safety="all"
	)

## Day - 2013-06-18  jvelilla  <javier.hector@gmail.com>

	Merge branch 'master' of https://github.com/EiffelWebFramework/EWF

## Day - 2013-06-18  Jocelyn Fiat  <git@djoce.net>

	Cosmetic, improve readability of conditions

	Removed wsf_support, which is useless and unused

	Better use append rather than copy here.

	Try to send 500 Internal error when exception reachs this point

## Day - 2013-06-18  jvelilla  <javier.hector@gmail.com>

	Merge branch 'master' of https://github.com/EiffelWebFramework/EWF
	Conflicts:
		draft/application/cms/cms.ecf
		draft/application/cms/example/src/web_cms.e
		draft/application/cms/src/cms_configuration.e
		draft/application/cms/src/cms_default_setup.e
		draft/application/cms/src/cms_service.e
		draft/application/cms/src/cms_setup.e
		draft/application/cms/src/handler/cms_file_system_handler.e
		draft/application/cms/src/kernel/content/format/filters/cms_html_filter.e
		draft/application/cms/src/modules/debug/debug_module.e
		draft/application/cms/src/notification/cms_email.e
		draft/application/cms/src/notification/cms_storage_mailer.e
		draft/application/cms/src/storage/cms_sed_storage.e
		draft/application/cms/src/storage/cms_storage.e
		library/runtime/process/notification_email/notification_external_mailer.e
		tools/bin/ecf_updater.exe

## Day - 2013-06-17  Jocelyn Fiat  <git@djoce.net>

	Updated ecf file as workaround to make autotest works fine.

## Day - 2013-06-13  Jocelyn Fiat  <git@djoce.net>

	Added notification_email library as official EWF lib.

	Unicode support for notification_email library

	Added HTTP_DATE.append_to...string conversion feature Made HTTP_DATE.append_...to...string more flexible by acception STRING_GENERAL,     so it is possible to append to STRING_32 (further more, it avoid potential implicit conversion)

## Day - 2013-06-12  Jocelyn Fiat  <git@djoce.net>

	Removed a few obsolete usages, and benefit from new classes from EiffelStudio >= 7.2

## Day - 2013-06-12  Jocelyn Fiat  <git@djoce.net>

	Updated WGI specification to ease future migration to unicode support.     Use STRING_TABLE, and better interface of READABLE_STRING_GENERAL,     this way the signature are more flexible for unicode keys.
	    Note that for now, unicode environment variables are not correctly supported in WGI
	    especially the value of the variables.
	    Any layer on top of EWGSI suffers from the same issues.

	Better exception handling

	+ code cleaning

## Day - 2013-06-12  Jocelyn Fiat  <git@djoce.net>

	minor optimization avoiding to create temporary string that might be big

	Updated CMS support for unicode.

	Fixing compilation of CMS demo project.

## Day - 2013-06-12  Jocelyn Fiat  <git@djoce.net>

	Better support for unicode path and values.
	Added WSF_REQUEST.percent_encoded_path_info: READABLE_STRING_8
	    to keep url encoded path info, as it is useful for specific component

	The router is now using WSF_REQUEST.percent_encoded_path_info
	    since URI_TEMPLATE are handling URI (and not IRI)
	    this fixes an issue with unicode path parameters.

	This should not break existing code, and this fixes various unicode related issues related
	   to PATH parameter and path info
	   but also any component using file names.

	(required EiffelStudio >= 7.2)

## Day - 2013-06-12  Jocelyn Fiat  <github@djoce.net>

	Merge pull request #60 from oligot/notification
	Extract notification email library from the CMS draft application

## Day - 2013-06-12  Olivier Ligot  <oligot@gmail.com>

	Rename notification to notification_email

	Extract notification library from the CMS draft application
	The new library is located in library/runtime/process/notification.
	This allows to use it apart from the CMS.

## Day - 2013-06-11  jvelilla  <javier.hector@gmail.com>

	merge

	Merge https://github.com/EiffelWebFramework/EWF

## Day - 2013-06-11  Jocelyn Fiat  <git@djoce.net>

	Added HTTP_DATE.make_now_utc for convenience.

## Day - 2013-06-07  Jocelyn Fiat  <git@djoce.net>

	Fixed various void-safety issue with recent compilers.
	Note that EWF does now require EiffelStudio 7.2, and is compiling with 7.3

## Day - 2013-05-31  Jocelyn Fiat  <git@djoce.net>

	Merge branch 'master' of https://github.com/Eiffel-World/EiffelWebNino

	removed unused local variable

## Day - 2013-05-29  jvelilla  <javier.hector@gmail.com>

	Merge branch 'master' of https://github.com/jvelilla/EWF

	Added command POST /session/:sessionId/modifier Initial implementation of KeyBoard. Added Mouse class, but not implemented.

## Day - 2013-05-29  Jocelyn Fiat  <github@djoce.net>

	Merge pull request #10 from oligot/reuseaddr
	Socket: reuse address to resolve the error "address already in use"

## Day - 2013-05-29  Olivier Ligot  <oligot@gmail.com>

	Socket: reuse address to resolve the error "address already in use"
	On Unix, when we stop the server, and then re-start it right away, we get an
	error that the address is already in use:
	http://www.softlab.ntua.gr/facilities/documentation/unix/unix-socket-faq/unix-socket-faq-4.html#ss4.1
	This means that the sockets that were used by the first incarnation of the
	server are still active.

	One way to resolve this is to set the socket option SO_REUSEADDR:
	http://www.softlab.ntua.gr/facilities/documentation/unix/unix-socket-faq/unix-socket-faq-4.html#ss4.5

	Tested on Ubuntu 12.04 LTS

## Day - 2013-05-28  Jocelyn Fiat  <git@djoce.net>

	Improved WGI_INPUT_STREAM.append_to_file (f: FILE; nb: INTEGER)

	update cms style

	Merge branch 'master' of github.com:EiffelWebFramework/EWF

	Added WSF_REQUEST.read_input_data_into_file (FILE)

## Day - 2013-05-27  Jocelyn Fiat  <github@djoce.net>

	Merge pull request #57 from oligot/port
	Use port number 9090 instead of 80

## Day - 2013-05-27  Olivier Ligot  <oligot@gmail.com>

	Use port number 9090 instead of 80
	Port 80 is often already used by standard webservers (Apache, nginx, ...).
	Moreover, on Linux, ports below 1024 can only be opened by root.

## Day - 2013-05-23  jvelilla  <javier.hector@gmail.com>

	Update readme.md

	Update readme.md

	Update readme.md

## Day - 2013-05-22  jvelilla  <javier.hector@gmail.com>

	Updated command_executor Added more examples.

## Day - 2013-05-20  jvelilla  <javier.hector@gmail.com>

	Update find element examples. Improved command executor

## Day - 2013-05-19  jvelilla  <javier.hector@gmail.com>

	Merge https://github.com/EiffelWebFramework/EWF

	Added new selenium locator examples. Fixed find_elements in WEB_DRIVER.

## Day - 2013-05-17  Jocelyn Fiat  <github@djoce.net>

	Merge pull request #56 from oligot/scrollbar
	Fix the CSS so that we don't see the scrollbar

## Day - 2013-05-17  Olivier Ligot  <oligot@gmail.com>

	Fix the CSS so that we don't see the scrollbar
	This commit fixes the CSS so that we don't see the scrollbar anymore.
	It just removes the width: 100% property on the div elements.

## Day - 2013-05-17  Jocelyn Fiat  <github@djoce.net>

	Merge pull request #55 from oligot/suggestion-method
	Display suggestion is now configurable

## Day - 2013-05-17  Olivier Ligot  <oligot@gmail.com>

	Display suggestion is now configurable.
	Commit 665772bda213e838b3c092075a386ee3b846b0be forces to display only
	suggestion for the request's method (this was not the case before).

	This commit allows to configure this behaviour: it keeps the current behaviour
	but also allows to use the other behaviour where the suggestion is displayed
	for each request method (as it was before).

## Day - 2013-05-15  Jocelyn Fiat  <git@djoce.net>

	removed unused local variable

	use EWF_tmp- prefix for temp uploaded file name.

	fixed implementation of WSF_UPLOADED_FILE.append_content_to_string

	Added WSF_UPLOADED_FILE.append_content_to_string (s: STRING) which can be used to get the content of the uploaded file.

	Added a way to customize the place to store temporary uploaded files

	code cleaning

## Day - 2013-05-14  Jocelyn Fiat  <git@djoce.net>

	removed unused local variable

	Added WSF_REQUEST.has_execution_variable (a_name): BOOLEAN Since the related value can be Void.

	Removed unused local variables.

	Merge branch 'master' of https://github.com/EiffelWebFramework/EWF

	Reuse WSF_LAUNCHABLE_SERVICE code as ancestor of WSF_DEFAULT_SERVICE_I Note that this way, it is easy to redefine `launch' in order to customize the launching instruction if needed (thinking about testing...) This might breaks some code since it adds a `launch' feature, but it is easy to fix and unlikely to happen often.

## Day - 2013-05-14  jvelilla  <javier.hector@gmail.com>

	Move expectation classed under a expectation cluster, added a new expectation class for header.

	Added examples find by id, name and class.

## Day - 2013-05-13  jvelilla  <javier.hector@gmail.com>

	Updated selenium WEB_DRIVER_WAIT, the feature until_when now use a predicate. Updated the related example.

## Day - 2013-05-10  jvelilla  <javier.hector@gmail.com>

	Merge branch 'master' of https://github.com/jvelilla/EWF

	Initial implementation of  HTTP RESPONSE EXPECTATIONS. Added a class to test http client with httpbin.org and expectations

## Day - 2013-05-10  Colin Adams  <colinpauladams@gmail.com>

	Merge branch 'master' into handler

## Day - 2013-05-08  jvelilla  <javier.hector@gmail.com>

	Update readme.md

	Updated documentation
	This documentation is based on Selinum http://docs.seleniumhq.org/
	and adapted to the Eiffel implementation.

	Update readme.md

	Update readme.md

	Updated WEB_DRIVER_WAIT class, still need to be improved. Updated Readme and the example

## Day - 2013-05-03  jvelilla  <javier.hector@gmail.com>

	Merge https://github.com/EiffelWebFramework/EWF

	Improve the example, Added a new class WEB_DRIVER_WAIT, still under development. Update web driver, to define time outs.

## Day - 2013-05-03  Jocelyn Fiat  <github@djoce.net>

	Merge pull request #54 from colin-adams/master
	Handle Precondition Failed for If-Match: * when no handler exists for the resource

## Day - 2013-04-30  jvelilla  <javier.hector@gmail.com>

	Added a simple search example. Updated web_driver, use the API as delegation instead of inheritance. Updated web_element class.

## Day - 2013-04-29  jvelilla  <javier.hector@gmail.com>

	Created new classes to represent a web driver. Added Examples, clean code

## Day - 2013-04-24  jvelilla  <javier.hector@gmail.com>

	Completed low level methods, clean code.

	Implemented more commands from REST API JSONWireProtocol Refactor COMMAND_EXECUTOR.

## Day - 2013-04-24  Colin Adams  <colinpauladams@gmail.com>

	merged from master

## Day - 2013-04-23  jvelilla  <javier.hector@gmail.com>

	Added more command from JSONWireProtol.

	Added more commands from the JSONWireProtocol.

## Day - 2013-04-22  Jocelyn Fiat  <git@djoce.net>

	send the file date  for download file response.

	WSF_RESPONSE.put_header_text should use put_raw_header_data (and not append)

	added header helper feature in the context interface
	added HTTP_CLIENT_SESSION.custom (...)
	to support any kind of request methods

## Day - 2013-04-22  jvelilla  <javier.hector@gmail.com>

	Added new classes, implemented more methods from JSONWireProtol API. Added test cases

## Day - 2013-04-17  Colin Adams  <colinpauladams@gmail.com>

	Made changes requested in review

## Day - 2013-04-17  jvelilla  <javier.hector@gmail.com>

	Fixed errors in navigate_to_url command, Fixed url templates in  json_wire_protocol_command. Added test cases to AutoTest

## Day - 2013-04-16  jvelilla  <javier.hector@gmail.com>

	Fixed feature typo, improved commands, added AutoTest

## Day - 2013-04-15  jvelilla  <javier.hector@gmail.com>

	Updated RestAPI commands

	Improved error handling,  implemented more methods from the REST API from Selenium2

## Day - 2013-04-13  Colin Adams  <colinpauladams@gmail.com>

	If-Match implemented in skeleton handler

	If-Match implemented in skeleton handler

## Day - 2013-04-12  jvelilla  <javier.hector@gmail.com>

	Fixed configurations paths

	Initial import Selenium binding

## Day - 2013-04-11  Jocelyn Fiat  <git@djoce.net>

	Fixed HTTP_CLIENT_RESPONSE when dealing with redirection    before it was storing some header in the body.    now we added redirections: ..  which is a list of redirection informations:      - status line      - header      - and eventual redirection body (but at least by default, libcurl does not cache body)
	Enhanced the http_client library to be able to write directly the downloaded data into a file (or as convenient thanks to agent).

## Day - 2013-04-11  Colin Adams  <colinpauladams@gmail.com>

	Merge branch 'master' of git://github.com/colin-adams/EWF

	Fixed Use Proxy response

	Fixed Use Proxy response bug

	Fixed bug in 32/8 bit string existance

	Removed illegal precondition

	Handle Precondition Failed for If-Match: *  where there is no handler for the resource

## Day - 2013-04-10  Jocelyn Fiat  <git@djoce.net>

	Fixed feature comments

	Merge branch 'master' of https://github.com/EiffelWebFramework/EWF

	Fixed HEAD request related issue
	see https://github.com/EiffelWebFramework/EWF/issues/53

## Day - 2013-04-08  Jocelyn Fiat  <github@djoce.net>

	Merge pull request #52 from colin-adams/master
	Bad postcondition for handle_use_proxy

## Day - 2013-04-05  Colin Adams  <colinpauladams@gmail.com>

	Removed incorrect postcondition for handle_use_proxy

## Day - 2013-04-05  Jocelyn Fiat  <git@djoce.net>

	Cosmetic fixed various indentations Removed useless dependencies for ewf_ise_wizard project.

## Day - 2013-03-30  Jocelyn Fiat  <jfiat@eiffel.com>

	fixed name of file with class name

## Day - 2013-03-29  Jocelyn Fiat  <jfiat@eiffel.com>

	fixed typo in default name for maintenance

	Added a maintenance filter

	added WSF_AGENT_FILTER

	more info in debug_output for uploaded file

	better error output for CGI connector

	Added WSF_LAUNCHABLE_SERVICE which use a deferred `launch' feature. This makes it easy to support multiple connectors support

	reuse implementation from WSF_REQUEST to get input data for MIME handlers.

	Added assertion for mime helper

	Do not change tmp_name from WSF_UPLOADED_FILE ... otherwise the file will be removed at the end of the request

	Fixed MIME multipart form data handler And use content-length value if provided.

	check against capacity not count

	be sure we got the full content same as content length

	Added assertion to WSF_UPLOADED_FILE

## Day - 2013-03-28  Jocelyn Fiat  <jfiat@eiffel.com>

	Merge branch 'master' of https://github.com/EiffelWebFramework/EWF

	at this point we have no garantie that the header are sent this can be ensured only at {WGI_RESPONSE}.commit exit.

## Day - 2013-03-27  Jocelyn Fiat  <github@djoce.net>

	Merge pull request #49 from colin-adams/protocol_version
	First attempt at WSF_HTTP_PROTOCOL_VERSION

## Day - 2013-03-27  Colin Adams  <colinpauladams@gmail.com>

	First attempt at WSF_HTTP_PROTOCOL_VERSION

## Day - 2013-03-27  Jocelyn Fiat  <jfiat@eiffel.com>

	Uncommented code to make recognized_methods supported by the method not allowed response.
	Still need to see how to use it and set the recognized methods for the application.

	Removed WSF_URI_*_ROUTER_HELPER and use instead the WSF_URI_*_HELPER_FOR_ROUTED_SERVICE    (the removed class were not in latest release, so this is safe to use the new name) Cosmetic

## Day - 2013-03-27  Jocelyn Fiat  <github@djoce.net>

	Merge pull request #46 from colin-adams/skeleton_router
	Skeleton router
	
	note :
	 - wsf_method_not_allowed_response.e needs deeper review
	 - tidy some helper classes

## Day - 2013-03-27  Colin Adams  <colinpauladams@gmail.com>

	Further changes in response to review comments by Jocelyn

	now all-safe.ecf compiles again

	delete ecf

## Day - 2013-03-27  Jocelyn Fiat  <jfiat@eiffel.com>

	added wsf_html for (un)installation

	Updated all-safe.ecf (add all-stable-safe.ecf that includes only the library, examples and specific draft lib)

	new integration ecf file that includes most of the library .ecf of EWF (note to include non library ecf, the related ecf should have a library_target)

	better use a root class

	corrected null-safe.ecf

## Day - 2013-03-27  Colin Adams  <colinpauladams@gmail.com>

	openid demo fixed

## Day - 2013-03-26  Colin Adams  <colinpauladams@gmail.com>

	merging from upstream - stage 4

	merging from upstream - stage 3

	merging from upstream - stage 2

	merging from upstream - stage 1

	Use class URI

## Day - 2013-03-26  Jocelyn Fiat  <jfiat@eiffel.com>

	fixed compilation

	allow to to set html attribute to the select widget (useful to add code like  onchange="this.form.submit()")

	Moved more components from CMS to wsf_html. This includes WSF_PAGER, and feature in WSF_THEME .. including WSF_API_OPTIONS used to compute url and link.

	Added remove_header_named (a_name)

	Do not use socket_ok .. but readable  (as specified in precondition of read_stream_thread_aware

## Day - 2013-03-25  Jocelyn Fiat  <jfiat@eiffel.com>

	Added self doc to the wsf file system handler Allow to hide the wsf file system handler from self documentation Better description format handling for the self doc

## Day - 2013-03-23  Colin Adams  <colinpauladams@gmail.com>

	Corrected header comment

## Day - 2013-03-22  Jocelyn Fiat  <jfiat@eiffel.com>

	use wsf_html lib in the demo

	removed obsolete call

	added wsf_html-safe.ecf to all-safe.ecf

	restored assertion removed by error

	Extracted the WIDGET and FORM classes out of "cms" component and build the wsf_html library which also include the previous css lib.

	Added WSF_STARTS_WITH_AGENT_HANDLER

	Fixed default status code for redirection response message object.

	Fixed assertion that were broken with recent delayed header response. Changed semantic of put_header_lines and add_header_lines, Now the arguments are iterable of string (i.e the header line)
	The previous features were not used, and were not well named.
	So we removed them, and reused the names for adpated implementation.

## Day - 2013-03-22  Colin Adams  <colinpauladams@gmail.com>

	Merge branch 'master' into skeleton_router

## Day - 2013-03-22  Jocelyn Fiat  <jfiat@eiffel.com>

	Display only suggestion for request's method

	Include cms and css into the all-safe.ecf

	update CMS code due to CMS_CSS_* renaming

	Fixed self documentation when querying documentation related to a specific resource (uri, uri-template, ..) Before it was showing only the first found so if we had   "/foo" GET -> FOO_GET_HANDLER   "/foo" POST -> FOO_POST_HANDLER It was showing only the first, now this is working as expected.

	Moved the *_CSS_* class in their own (draft) library, since they are not CMS specific.

## Day - 2013-03-21  Jocelyn Fiat  <jfiat@eiffel.com>

	Fixing feature comments

## Day - 2013-03-21  Colin Adams  <colinpauladams@gmail.com>

	fix merge conflict from master

## Day - 2013-03-21  Jocelyn Fiat  <jfiat@eiffel.com>

	cosmetic

	Removed WSF_AGENT_HANDLER since it was an artificial notion, as we have no common ancestor for WSF_HANDLER having    execute (req: WSF_REQUEST; res: WSF_RESPONSE)

	cosmetic

	Fixed signature of `set_next' to allow redefinition. Added assertions

	Now WSF_FILTER_HANDLER is a handler and has formal generic G constrained to WSF_HANDLER This eases implementation of potential descendants.

	Added WSF_HANDLER_FILTER_WRAPPER to build a bridge from router to filter.

	Added HTTP_AUTHORIZATION.is_basic: BOOLEAN  query to know if this is a Basic HTTP Authorization.

## Day - 2013-03-21  Jocelyn Fiat  <jfiat@eiffel.com>

	Introduced WSF_ROUTER_SESSION
	This fixes CQS violation from WSF_ROUTER.dispatch_and_return_handler (...): ? WSF_HANDLER
	and related code, and this is more compliant with concurrency.

	In addition, the WSF_ROUTER_SESSION can be enhanced in the future to answer more advanced needs.

## Day - 2013-03-21  Jocelyn Fiat  <jfiat@eiffel.com>

	Fixed WSF_FILE_RESPONSE and WSF_DOWNLOAD_RESPONSE and set the status code to be Ok by default

## Day - 2013-03-20  Colin Adams  <colinpauladams@gmail.com>

	Amedned class header of WSF_METHOD_NOT_ALLOWED_RESPONSE

	Merge branch 'master' into skeleton_router

## Day - 2013-03-19  Jocelyn Fiat  <jfiat@eiffel.com>

	mimic design of WSF_ROUTED_SERVICE for WSF_FILTERED_SERVICE and update the filter example to make it simpler and reuse code.

	updated install and uninstall scripts

	Updated WSF_NOT_IMPLEMENTED_RESPONSE to include the request uri

	added WSF_..._ROUTER_HELPER and made the previous WSF_..._ROUTED_SERVICE obsolete

	WSF_CORS_OPTIONS_FILTER should not inherit from WSF_URI_TEMPLATE_HANDLER

## Day - 2013-03-19  Colin Adams  <colinpauladams@gmail.com>

	added reference to assertion tags in check justiciation

## Day - 2013-03-19  Jocelyn Fiat  <jfiat@eiffel.com>

	Moved all *_CONTEXT_* router related classes into wsf_router_context.ecf library This makes wsf simpler to discover. And advanced context enabled handler, mapping, ... are still available for now in wsf_router_context.ecf library

## Day - 2013-03-19  Jocelyn Fiat  <github@djoce.net>

	Merge pull request #22 from oligot/cors
	Cross-Origin Resource Sharing initial support

	Merge pull request #47 from colin-adams/master
	Ignore Emacs backup files

## Day - 2013-03-19  Colin Adams  <colinpauladams@gmail.com>

	Added emacs backup giles to .gitignore

## Day - 2013-03-18  Jocelyn Fiat  <jfiat@eiffel.com>

	Added deferred WSF_AGENT_HANDLER Added WSF_NOT_IMPLEMENTED_RESPONSE

	Merge branch 'master' of github.com:EiffelWebFramework/EWF

	added small doc on how to include EWF git repo in another git repository

## Day - 2013-03-18  Colin Adams  <colinpauladams@gmail.com>

	refactored for WSF_ROUTED_SKELETON_SERVICE

	prior to refactoring for WSF_ROUTED_SKELETON_SERVICE

	prior to refactoring for WSF_ROUTED_SKELETON_SERVICE

## Day - 2013-03-17  Colin Adams  <colinpauladams@gmail.com>

	Added missing class

	minor polishing

	added contracts and polished forbidden for OPTIONS *

	implemented OPTIONS * except for Allow header

## Day - 2013-03-16  Colin Adams  <colinpauladams@gmail.com>

	Implemented 414 and 503 responses on WSF_ROUTED_SERVICE

	Implemented 503 and 414 responses in WSF_ROUTED_SERVICE

## Day - 2013-03-15  Jocelyn Fiat  <github@djoce.net>

	Merge pull request #44 from colin-adams/master
	Contracts for non-Void-safe users (take 5)

## Day - 2013-03-15  Colin Adams  <colinpauladams@gmail.com>

	Merge branch 'master' of github.com:EiffelWebFramework/EWF

	Sixth round of contracts for non-Void-safe users

## Day - 2013-03-15  Jocelyn Fiat  <github@djoce.net>

	Merge pull request #43 from colin-adams/master
	Contracts for non-Void-safe users (take 4)

## Day - 2013-03-15  Colin Adams  <colinpauladams@gmail.com>

	Merge branch 'master' of github.com:EiffelWebFramework/EWF
	Pulling latest merges of other developers commits.

	Fifth round of contracts for non-Void-safe users

## Day - 2013-03-15  Olivier Ligot  <oligot@gmail.com>

	Merge remote-tracking branch 'upstream/master' into cors

## Day - 2013-03-15  Jocelyn Fiat  <github@djoce.net>

	Merge pull request #42 from colin-adams/master
	Contracts for non-Void-safe users (take 3)

	Merge pull request #28 from jocelyn/flexible_response
	Allow to change status code and header as long as no content is sent.
	Note this includes a change in EWSGI classes related to connector and RESPONSE. This modification was required for request processing termination.

## Day - 2013-03-15  Olivier Ligot  <oligot@gmail.com>

	Merge branch 'cors' of github.com:oligot/EWF into cors

	Fix indentation

	Use features from the flexible_response branch

	Filter example: remove unused libraries in ecf file

	Use new upstrem method put_header_key_values

	Merge remote-tracking branch 'jocelyn/flexible_response' into cors
	Conflicts:
		examples/filter/filter-safe.ecf
		examples/filter/src/filter_server.e
		library/network/protocol/http/src/http_header.e
		library/server/wsf/src/wsf_response.e

## Day - 2013-03-15  Colin Adams  <colinpauladams@gmail.com>

	Fourth round of contracts for non-Void-safe users

	Third iteration of contracts for non-Void-safe users

## Day - 2013-03-14  Jocelyn Fiat  <github@djoce.net>

	Merge pull request #41 from colin-adams/master
	Contracts for non-Void-safe users (take 2)

## Day - 2013-03-14  Colin Adams  <colinpauladams@gmail.com>

	Amended header comment in response to code review of pull-request

	Corrected header comment in response to code review of pull-request

	Merge branch 'master' of github.com:EiffelWebFramework/EWF

	Further contracts for non-Void-safe users

## Day - 2013-03-14  Jocelyn Fiat  <github@djoce.net>

	Merge pull request #40 from colin-adams/master
	Contracts for non-Void-safe users (take 1)

## Day - 2013-03-14  Colin Adams  <colinpauladams@gmail.com>

	used across for assertion

	Response to comments from review "Contracts for non-Void-safe users (take 1)"

	Added non-Void contracts for classes previously flagged by AutoTest

## Day - 2013-03-12  Jocelyn Fiat  <jfiat@eiffel.com>

	Implemented more user friendly WSF_RESPONSE i.e allow to change the status code and the header as long as no content is really sent back to the client
	This requires an addition WGI_RESPONSE, new post_commit_action: PROCEDURE [...]

	Enhanced HTTP_HEADER with new helper features.

## Day - 2013-03-08  Jocelyn Fiat  <jfiat@eiffel.com>

	Made it compilable with 7.1

	Factorized code for checkbox and radio input. Renamed `text' and similar to `title' and similar

	adding back missing uri template library

	Fixed CMS_HTML_FILTER which was buggy and was including the last processed tag even if it was excluded.

	Added support for OpenID identity Added user roles management Improvement CMS_HOOK_FORM_ALTER design. Factorized code into CMS_WIDGET_COMPOSITE Use general notion of CMS_WIDGET (and CMS_FORM allows CMS_WIDGET, and not just CMS_FORM_ITEM) Fixed various CMS_WIDGET traversal, and fixed related issue for CMS forms Fixed CMS_FORM_CHECKBOX_INPUT when no value was set. Added CMS_FORM_DATA.cached_value .. to pass computed values during validation to submit actions (mainly for optimization) Added support for @include=filename  in CMS_CONFIGURATION Added CMS_WIDGET_TABLE as filled version of CMS_WIDGET_AGENT_TABLE (renamed from previous CMS_WIDGET_TABLE) Many improvements to the CMS_FORM design Some improvements to CMS_MODULE ...

	Added `WSF_REQUEST.table_item' to help user get table item with flat name. i.e instead of having  item ("foo").item ("bar"), you can do  table_item ("foo[bar]")

	Added user friendly function to get returned openid attributes

	better have hash table indexed by STRING_32 rather than READABLE_STRING_32 for now

	Use the advanced SED storable to store data on disk (rather than the runtime storable)

## Day - 2013-03-05  Jocelyn Fiat  <github@djoce.net>

	Added WITH_HTML_ATTRIBUTE

## Day - 2013-03-01  Jocelyn Fiat  <jfiat@eiffel.com>

	Added missing file from previous commits.

	added make_with_text_and_css on CMS_WIDGET_TABLE_ITEM

	added notion of site identifier .. applied to the session's cookie name

	Fixed HTTP_IF_MODIFIED_SINCE handling in WSF_FILE_SYSTEM_HANDLER ...

	Enhanced HTTP_DATE with yyyy_mmm_dd output string.

	display a message if the user has no email ... to reset password

	Display the login name, instead of just "My Account"

	Does not accept empty password

	added the notion of site identifier  "site.id" (typically this could be a UUID)

	Merge branch 'master' of https://github.com/EiffelWebFramework/EWF

	Also take into account sublink's permission

	Default permission should be set to False, not to True (the previous code was mainly for debugging)

	Fixed url computing when a `base_url' is provided

## Day - 2013-02-28  Jocelyn Fiat  <jfiat@eiffel.com>

	added CMS widgets demonstration  in DEMO_MODULE

	add CMS_WIDGET_... to ease html page development.

	improved CMS_CSS_STYLE and WITH_CSS_STYLE

	Move draft\library\security\openid under library\security\openid

	Made it also compilable with compiler < 7.2

	Added a version of ISE Library URI modified to be compilable with compiler < 7.2 Fixed openid when redirection is involved Fixed Openid Attribute Exchange implementation  (AX) Added WSF_REQUEST.items_as_string_items: ... for convenience, and ease integration with other components (such as the new openid)

	updated relative path

## Day - 2013-02-27  Jocelyn Fiat  <jfiat@eiffel.com>

	OpenID consumer implementation REQUIRES EiffelStudio 7.2

	First version of OpenID consumer (light implementation)

	Merge branch 'master' of https://github.com/EiffelWebFramework/EWF

	Added a way to call a callback on launched and stopped for Nino connector

	Provided a way to report cURL error code back to http_client, via HTTP_CLIENT_RESPONSE

	Provided `url_encoded_name' on the WSF_VALUE interface

## Day - 2013-02-26  Jocelyn Fiat  <jfiat@eiffel.com>

	prefer 2 append call, rather than create a temp intermediary string object with +

## Day - 2013-02-26  Jocelyn Fiat  <github@djoce.net>

	Use append_to_html  rather than function  to_html: STRING this is mainly to avoid creating useless intermediary strings.

## Day - 2013-02-22  Olivier Ligot  <oligot@gmail.com>

	CORS: respect specification regarding Access-Control-Allow-Headers
	According to the specification, the value of the response header
	Access-Control-Allow-Headers must contain at least all the values of the
	request header Access-Control-Request-Headers to be considered a valid request.
	Before this commit, only the Authorization value was present, which is enough
	for Firefox but not for Chrome.
	This should now work as expected.

## Day - 2013-02-21  Jocelyn Fiat  <jfiat@eiffel.com>

	Added functionalities to CMS_FORM_.. classes

## Day - 2013-02-20  Jocelyn Fiat  <jfiat@eiffel.com>

	Fixing various form urls, that was not taking into account base url

## Day - 2013-02-19  Jocelyn Fiat  <jfiat@eiffel.com>

	Fixed absolute url computing for CMS

	Fixed computation of absolute url ...

	Fixed request new password

	Code cleaning and use HTTP_DATE instead of duplicating code.

## Day - 2013-02-15  Jocelyn Fiat  <jfiat@eiffel.com>

	Now the cms.ini resolves variable ${abc} ... and key is case insensitive

	removed unused local variable

	keep compilable with EiffelStudio <= 7.1

	Refactorying the CMS component, to have an effective CMS_SERVICE, and setup as CMS_SETUP. This way the application is much simpler, no need to implement deferred feature of CMS_SERVICE.

## Day - 2013-02-14  Jocelyn Fiat  <jfiat@eiffel.com>

	Now also display sublinks if link is expanded. Updated theme

	added EIS note documentation link for URI_TEMPLATE

	Fixed register and new password link when the CMS's base dir is not the root /

	Improved CMS PAGER

	Improve CMS_LINK to easily add children

	provide a way to pass style class to sidebars and content blocks

## Day - 2013-02-05  Jocelyn Fiat  <jfiat@eiffel.com>

	Fixed remaining issues with recursion in non flat web forms

	added CMS_FORM_SELECT.select_value_by_text

	fixed is_active by taking into account the query string as well

	cleaning in CMS_CONFIGURATION and added append_to_string (s: STRING)

	remove unwanted console output

## Day - 2013-02-04  Jocelyn Fiat  <jfiat@eiffel.com>

	Reviewed initialization and usage of various CMS_SERVICE urls

	more flexible permission control system ...

	make ANY_CMS_EXECUTION more flexible

	Updated CMS experimental component Fixed various issues with fieldset or similar not traversed

	Fixed implementation of `string_array_item'

## Day - 2013-02-03  oligot  <oligot@gmail.com>

	Add support for Apache logging: done

## Day - 2013-01-31  Jocelyn Fiat  <jfiat@eiffel.com>

	Fixing global EWF compilation

	Fixing global EWF compilation

	Updated CMS code. Separated code to have a lib and an example. Improved design, fixed a few issues related to folder location.
	This is still experimental and require more work to be really friendly to use.

	Added ANSI C date time string format support in HTTP_DATE.

	Fixed HTTP_DATE for GMT+  offset  (integer value)

	Added HTTP_DATE to ease http date manipulation and optimize code rather than using EiffelTime's code facilities. Added autotests to `http' lib.

## Day - 2013-01-30  Jocelyn Fiat  <jfiat@eiffel.com>

	using ARRAYED_LIST rather than LINKED_LIST

## Day - 2013-01-23  Jocelyn Fiat  <jfiat@eiffel.com>

	Removed eel and eapml contrib/library from EWF Since there are available from $ISE_LIBRARY

	Added `append_string_to' to HTTP_HEADER

	Removed useless dependencies on other lib.

## Day - 2013-01-23  Jocelyn Fiat  <github@djoce.net>

	Merge pull request #26 from oligot/no-context
	Use execution_variable instead of context

## Day - 2013-01-23  Olivier Ligot  <oligot@gmail.com>

	Use execution_variable instead of context
	This is mainly to be compatibe with other classes API.

	In a lot of classes, we define methods like this:
	```Eiffel
	 method (req: WSF_REQUEST; res: WSF_RESPONSE)
	    do
	        ...
	    end
	```

	With the context, the signature becomes:
	```Eiffel
	 method (ctx: C; req: WSF_REQUEST; res: WSF_RESPONSE)
	    do
	        ...
	    end
	```

	So, I can't build a filter chain where one filter is with context
	and one is without context (I can't call
	WSF_FILTER.set_next (a_next: WSF_FILTER) with a filter that is a
	descendant of WSF_CONTEXT_HANDLER).

	Moreover, having to play with generic types just to pass some
	data from one filter to another is a bit overkill imho.
	Because this is really what I use contexts for:
	to pass data from one filter to the next one.

	Regarding execution_variable and strong typing, if we want to achieve these,
	I realize we could write a class with one getter and one setter like this:

	```Eiffel
	  class
	    TYPED_DATA

	  feature -- Access

	  user (req: WSF_REQUEST): detachable USER
	    do
	        if attached {USER} req.execution_variable ("user") as l_user then
	            Result := l_user
	        end
	    end

	  feature -- Element change

	  set_user (req: WSF_REQUEST; a_user: USER)
	    do
	        req.set_execution_variable ("user", a_user)
	    end
	```

	Now, I realize this is a major change since the last time we talked about this,
	but at the end, after having played with both, I prefer the one with
	execution_variable.

## Day - 2013-01-22  Jocelyn Fiat  <jfiat@eiffel.com>

	Minor optimization in HTTP_HEADER

## Day - 2013-01-22  Jocelyn Fiat  <github@djoce.net>

	Merge pull request #24 from oligot/header-values
	Added {HTTP_HEADER}.put_header_key_values

## Day - 2013-01-22  Olivier Ligot  <oligot@gmail.com>

	Added {HTTP_HEADER}.put_header_key_values
	This is mainly a refactoring that is useful for an upcoming PR
	regarding CORS (smaller patches are better...)

	Note that this also fixes a small typo where an extra space was
	added when calling {HTTP_HEADER}.put_allow

## Day - 2013-01-22  Jocelyn Fiat  <github@djoce.net>

	Merge pull request #23 from oligot/readonly-ecf
	Filter example: all libraries are now readonly

## Day - 2013-01-22  Olivier Ligot  <oligot@gmail.com>

	Filter example: all libraries are now readonly

## Day - 2013-01-09  Olivier Ligot  <oligot@gmail.com>

	Cross-Origin Resource Sharing initial support
	Initial support for the Cross-Origin Resource Sharing specification.
	This allows JavaScript to make requests across domain boundaries.

	Also reviewed the filter example to get rid of the context and
	the generic classes (we can actually use {WSF_REQUEST}.execution_variable
	and {WSF_REQUEST}.set_execution_variable).

	Links:
	* How to enable server-side: http://enable-cors.org/server.html
	* Specification: http://www.w3.org/TR/cors/
	* Github: http://developer.github.com/v3/#cross-origin-resource-sharing

## Day - 2013-01-07  Jocelyn Fiat  <github@djoce.net>

	Merge pull request #21 from oligot/typo
	Fix a small typo: you are instead of your are

## Day - 2013-01-07  Olivier Ligot  <oligot@gmail.com>

	Fix a small typo: you are instead of your are

## Day - 2012-12-22  Jocelyn Fiat  <jfiat@eiffel.com>

	Added http_authorization which is now needed by example filter.

	minor changes

## Day - 2012-12-21  Jocelyn Fiat  <jfiat@eiffel.com>

	Keep compatibility with 7.1 thus not unicode compliant

	using socket_ok does not sounds ok on linux

## Day - 2012-12-20  Jocelyn Fiat  <jfiat@eiffel.com>

	Use WSF_REQUEST.read_input_data_into (buf)

	added WSF_SUPPORT.environment_item

	Added is_available on HTTP_CLIENT_SESSION mainly to check if libcurl is available.

	Avoid calling ANY.print, prefer io.error.put_string Fixed obsolete calls.

	Merge branch 'master' of https://github.com/Eiffel-World/EiffelWebNino

	removed unused local

	Added support for server_name in nino, and openshift

	updated doc related to git

	Merge branch 'master' of https://github.com/Eiffel-World/EiffelWebNino

	Added support for server name

	updated conneg .ecf

	Added openshift connector classes (for experimentation)

	Added comment to self documentation features

## Day - 2012-12-19  Jocelyn Fiat  <jfiat@eiffel.com>

	Added a few library_target to .ecf to be able to build the tests/all-safe.ecf that enables us to check quickly the compilation state of EWF, and also perform refactorying over many projects.

	Fixed WSF_TRACE_RESPONSE which was overwritting previously prepared content.

	Breaking changes:  added `a_request_methods' argument to WSF_ROUTER_SELF_DOCUMENTATION_HANDLER.mapping_documentation  added similar argument to WSF_ROUTER_SELF_DOCUMENTATION_ROUTER_MAPPING.documentation Renamed WSF_ROUTER_METHODS as WSF_REQUEST_METHODS Enhanced WSF_REQUEST_METHODS with new has_... function Added WSF_ROUTER_VISITOR and WSF_ROUTER_ITERATOR that may be useful to iterate inside the router.    we may improve the implementation of the router using those visitors in the future. Improved the WSF_DEFAULT_RESPONSE to embedded suggested items (typically based on pseudo self documented router)

	Updated documentation output

	Fixed issue in WSF_REQUEST.read_input_data_into when the content is zero Cleaned the WGI_CHUNKED_INPUT_STREAM and provides access to last extension, last trailer, ... Improved WSF_TRACE_RESPONSE to support tracing chunked input back to the client.

	Fixed WSF_RESPONSE chunk transfer implementation   and also the optional extension `a_ext' should now include the ';' Now HTTP_HEADER is an ITERABLE [READABLE_STRING_8]

	changed UUID since this is the same a restbuckCRUD example.

	Fixed various assertions. Improved autotests Added target 'server' to be able to run the server outside the test process.

## Day - 2012-12-18  Jocelyn Fiat  <jfiat@eiffel.com>

	Fixed reading chunked input data When retrieving data block by block, use 8_192 instead of 1_024 (since 1_024 is too small most of the time)

	Fixed sending of chunk, especially the ending where there is an optional Trailer, and a mandatory final CRLF Now put_chunk does not support anymore empty chunk, and thus does not call put_chunk_end if ever it is called with empty chunk content. Fixed the `transfered_content_length' when dealing with chunk transfert encoding

	Added logger response wrapper, this is mainly to be able to save any response message to a file. (debugging purpose)

	Added basic support for "Expect" http header i.e:   WSF_REQUEST.http_expect: detachable READABLE_STRING_8
	Added WSF_REQUEST.request_time_stamp: INTEGER_64

## Day - 2012-12-17  Jocelyn Fiat  <jfiat@eiffel.com>

	fixed autotests compilation

## Day - 2012-12-14  Jocelyn Fiat  <jfiat@eiffel.com>

	Made WSF_REQUEST.is_content_type_accepted safer.

	Added WSF_DEFAULT_*_RESPONSE Fixed the method not allowed by setting the Allow: header

	Improved HTTP_AUTHORIZATION

	Added Authorization and Allow Added is_empty and count

## Day - 2012-12-13  Jocelyn Fiat  <github@djoce.net>

	Merge pull request #16 from colin-adams/master
	Implementation for automatic HEAD and first pass at HTTP 1.1 conformance contracts

## Day - 2012-12-13  Jocelyn Fiat  <jfiat@eiffel.com>

	removed unused local variables

	added code that may be used to avoid breaking compatibility with new Eiffel Studio 7.2 This is experimental for now.

	Added to WSF_REQUEST   - raw_header_data: like meta_string_variable   - read_input_data_into (buf: STRING)   - is_content_type_accepted (a_content_type: READABLE_STRING_GENERAL): BOOLEAN Changed raw_input_data to return IMMUTABLE_STRING_8 Added WSF_METHOD_NOT_ALLOWED_RESPONSE Added WSF_TRACE_RESPONSE to respond TRACE request Now Not_found response return html content if the client accepts, other text/plain Implemented TRACE response, and Method not allowed as implementation of WSF_ROUTED_SERVICE.execute_default

	Fixed WGI_INPUT_STREAM  read_to_string and append_to_string

	Merge branch 'master' of https://github.com/eiffelhub/json

	Added missing "context" classes for uri and starts_with mapping+handler (and helper classes). So that it is address more needs. Factorized code between "context" and non context classes.

## Day - 2012-12-12  Jocelyn Fiat  <github@djoce.net>

	Merge pull request #3 from jvelilla/master
	Fixed documentation URI

	Merge pull request #4 from oligot/fix_json_object_hash_code
	Fix {JSON_OBJECT}.hash_code implementation

	Merge pull request #20 from oligot/fix_fcgi_safe
	use /usr/lib/libfcgi.so instead of /usr/local/lib/libfcgi.so

## Day - 2012-12-12  Olivier Ligot  <oligot@gmail.com>

	use /usr/lib/libfcgi.so instead of /usr/local/lib/libfcgi.so
	This was already fixed in libfcgi.ecf
	(commit 65a998cec398905d7c9100e61cce5c39864796c6)
	This fixes the libfcgi-safe.ecf file

## Day - 2012-12-11  Colin Adams  <colinpauladams@gmail.com>

	Actioned Jocelyns comments re. a_req and a_res

## Day - 2012-12-10  Olivier Ligot  <oligot@gmail.com>

	Fix {JSON_OBJECT}.hash_code implementation
	Don't call {HASH_TABLE}.item_for_iteration when {HASH_TABLE}.off
	Use {HASH_TABLE}.out instead

## Day - 2012-12-10  Jocelyn Fiat  <jfiat@eiffel.com>

	Fixed issue related to vars that are already converted to WSF_TABLE

	Get rid of obsolete scripts (we do not use git submodule anymore, so this is much easier .. for the users)

## Day - 2012-12-08  Colin Adams  <colinpauladams@gmail.com>

	merged from upstream

## Day - 2012-12-07  Jocelyn Fiat  <jfiat@eiffel.com>

	make it compiles with EiffelStudio 7.1 and 7.2

## Day - 2012-12-06  Colin Adams  <colinpauladams@gmail.com>

	Revert do_get_head patch

## Day - 2012-12-05  Jocelyn Fiat  <jfiat@eiffel.com>

	compile all-safe.ecf as windows or unix, even if not on Windows or unix

	corrected null connector ecf files

	Merge branch 'master' of github.com:EiffelWebFramework/EWF

	added tests\all-safe.ecf to compile most of EWF's lib, to quickly check the compilation state

	use libfcgi(-safe).ecf rather than fcgi(-safe).ecf

	Provide a way to log into a file, rather than just console output Minor optimization for WSF_LOGGING_FILTER

	Prepare upcoming support for unicode environment variables

	removed fcgi(-safe).ecf files ... since there renamed libfcgi(-safe).ecf

## Day - 2012-12-05  Olivier Ligot  <oligot@gmail.com>

	ise_wizard Unix shell scripts

	Fix ise_wizard
	* ewf.ini was used instead of template.ecf as configuration file
	* remove initialize_router otherwise the compilation failed
	* remove unused variables

	Logging filter
	The logging filter is now part of EWF core (before it was only available in
	the filter example) and can therefore be reused by others needing it.
	Note that this is a first implementation. It can certainly be improved in
	the future to support more fine grained logging.

## Day - 2012-12-05  Jocelyn Fiat  <jfiat@eiffel.com>

	added tests\all-safe.ecf to compile most of EWF's lib, to quickly check the compilation state

	use libfcgi(-safe).ecf rather than fcgi(-safe).ecf

	Provide a way to log into a file, rather than just console output Minor optimization for WSF_LOGGING_FILTER

	Prepare upcoming support for unicode environment variables

	removed fcgi(-safe).ecf files ... since there renamed libfcgi(-safe).ecf

## Day - 2012-12-05  Jocelyn Fiat  <github@djoce.net>

	Merge pull request #17 from oligot/logging_filter
	Logging filter

## Day - 2012-12-04  Jocelyn Fiat  <github@djoce.net>

	Merge pull request #19 from oligot/ise_wizard_sh
	ise_wizard Unix shell scripts

## Day - 2012-12-04  Olivier Ligot  <oligot@gmail.com>

	ise_wizard Unix shell scripts

## Day - 2012-12-04  Jocelyn Fiat  <github@djoce.net>

	Merge pull request #18 from oligot/fix_ise_wizard
	Fix ise_wizard

## Day - 2012-12-03  Olivier Ligot  <oligot@gmail.com>

	Fix ise_wizard
	* ewf.ini was used instead of template.ecf as configuration file
	* remove initialize_router otherwise the compilation failed
	* remove unused variables

	Logging filter
	The logging filter is now part of EWF core (before it was only available in
	the filter example) and can therefore be reused by others needing it.
	Note that this is a first implementation. It can certainly be improved in
	the future to support more fine grained logging.

## Day - 2012-12-03  Jocelyn Fiat  <jfiat@eiffel.com>

	Fixed various compilation issue with new self documentation Improved the self documentation handler to provide a make_hidden creation procedure

	Merge branch 'master' of github.com:EiffelWebFramework/EWF

	Merge branch 'master' of github.com:EiffelWebFramework/EWF

	updated ecf path

## Day - 2012-11-26  Jocelyn Fiat  <jfiat@eiffel.com>

	Added debug clause to detect in WSF_ROUTER.map_with_request_methods the existing conflicts with similar mapping. Added smart handling of HEAD request. Exported some internal features of WSF_REQUEST and WSF_RESPONSE to respectively WSF_REQUEST_EXPORTER and WSF_RESPONSE_EXPORTER

	added debug_output to WSF_ROUTER_MAPPING

	Avoid using INDEXABLE_ITERATION_CURSOR.is_last

## Day - 2012-11-25  Jocelyn Fiat  <jfiat@eiffel.com>

	Included the library base(-safe).ecf which was forgotten by mistake.

	Fixed compilation due to recent changes from http_client and corrected design.

## Day - 2012-11-24  Colin Adams  <colinpauladams@gmail.com>

	Completed first pass for HTTP 1.1 conformace contracts

	Forced HEAD when GET requested

	First postconditions relating to response codes added

	Added framework for HTTP-conforming contracts

## Day - 2012-11-23  Jocelyn Fiat  <jfiat@eiffel.com>

	Merge branch 'master' of github.com:EiffelWebFramework/EWF

## Day - 2012-11-23  Jocelyn Fiat  <github@djoce.net>

	Update README.md

	Update README.md

## Day - 2012-11-23  Jocelyn Fiat  <jfiat@eiffel.com>

	New design for self documented router. The documentation is built only on demand. A mapping entry can be hidden for the documentation One can change the status code when building itself the WSF_ROUTER_SELF_DOCUMENTATION_MESSAGE

## Day - 2012-11-23  Jocelyn Fiat  <github@djoce.net>

	Update README.md

## Day - 2012-11-23  Jocelyn Fiat  <jfiat@eiffel.com>

	Made encoder and error library compilable with 6.8

## Day - 2012-11-23  Jocelyn Fiat  <github@djoce.net>

	Update README.md

## Day - 2012-11-23  Jocelyn Fiat  <jfiat@eiffel.com>

	Added SHARED_... classes for encoders (html, url, xml, json, ...)

	Do not use {INDEXABLE_ITERATION_CURSOR}.is_last since it is added from EiffelStudio v7.2

	Updated signatures for the self documentated message

	Updated self documentation

	Added WSF_NOT_FOUND_RESPONSE to respond 404 Not found page

	Allow to use WSF_ROUTER_SELF_DOCUMENTATION_MESSAGE without any WSF_ROUTER_SELF_DOCUMENTATION_HANDLER i.e without any specific URL to this self documentation. Added custom value such as header, footer, style css url ...

	Fixed signature of WSF_MIME_HANDLER.handle

	Added WSF_ROUTER.has_item_associated_with_resource and item_associated_with_resource Added WSF_ROUTER_MAPPING.associated_resource Added WSF_ROUTER_SELF_DOCUMENTATION_HANDLER and WSF_ROUTER_SELF_DOCUMENTATION_MESSAGE to provide a self documentation for WSF_ROUTER (for now, only HTML)

	Made WSF_ROUTER_METHODS.new_cursor an INDEXABLE_ITERATION_CURSOR which is richer than just ITERATION_CURSOR

## Day - 2012-11-22  oligot  <oligot@gmail.com>

	Updated Useful links (markdown)

	Created Useful links (markdown)

## Day - 2012-11-21  Jocelyn Fiat  <jfiat@eiffel.com>

	minor change: reuse local variable

	Include the `url' in the http client response. This way, we can get the real url used by the lib, especially when there are query parameters.

## Day - 2012-11-20  Jocelyn Fiat  <jfiat@eiffel.com>

	removed "rest" from readme.md

	Added WSF_ROUTER_ITEM to replace a structure represented with named TUPLE Added debug_output to ease debugging

	Removed pseudo rest library from draft libraries.

## Day - 2012-11-15  Jocelyn Fiat  <jfiat@eiffel.com>

	Updated git tips related to subtree to avoid weird issue when "pulling" subtree which was putting files in wrong locations.

	Merge branch 'master' of https://github.com/eiffelhub/json

	Fixed message for exception_failed_to_convert_to_json Fixed indentation

## Day - 2012-11-15  jvelilla  <javier.hector@gmail.com>

	Update Readme.txt
	Fixed documentation URI

## Day - 2012-10-23  Jocelyn Fiat  <jfiat@eiffel.com>

	Fixed compilation

	Provide `server_url: STRING' that compute the http://server_name:port or https://... using `server_name', `server_port', `server_protocol' and avoid using `http_host' which is not reliable and could be cause of security issue.

	Fixed Date: formatting, follow RFC 1123

## Day - 2012-10-22  Jocelyn Fiat  <jfiat@eiffel.com>

	Added WSF_REQUEST_UTILITY_PROXY, that provides the WSF_REQUEST_UTILITY features to a class that implement request: WSF_REQUEST

	added REST_URI_TEMPLATE_ROUTING_HANDLER

	Added WSF_ROUTING_CONTEXT_HANDLER

	Fixing design of draft rest lib (which is going to be removed soon)

	Do not set default status if a status is already set.

	Using anchor type to create the router this is more flexible for eventual descendants redefining the router

## Day - 2012-10-08  oligot  <oligot@gmail.com>

	Updated Projects new suggestions (markdown)

## Day - 2012-10-08  Jocelyn Fiat  <jfiat@eiffel.com>

	Removed generic parameter in WSF_FILTER_HANDLER, since it is useless and make code heavy

	Removed unwanted commented line

	Updated "filter" example

## Day - 2012-10-04  Jocelyn Fiat  <jfiat@eiffel.com>

	Updated Copyright

	updated copyright

	Updated filter example to demonstrate the use of context.
	(note: this commit is a merged of pull request from Olivier Ligot, and changes from Jocelyn Fiat)

	Fixed compilation for STARTS_WITH_ handler

	Added WSF_RESOURCE_CONTEXT_HANDLER_HELPER

	Added notion of mapping factory, so one can implement a handler without having to implement new_mapping Added filter context handler Added WSF_STARTS_WITH_ROUTING_HANDLER and WSF_URI_ROUTING_HANDLER (in addition to the uri template version)

## Day - 2012-10-03  Jocelyn Fiat  <jfiat@eiffel.com>

	fixed wsf_extension path in filter-safe.ecf file

## Day - 2012-10-02  Jocelyn Fiat  <github@djoce.net>

	Merge pull request #2 from jvelilla/master
	Fix Assignment attempt and wsf_extension path in RestBucksCRUD

## Day - 2012-10-02  jvelilla  <javier.hector@gmail.com>

	Fixed wsf_extension.ecf path, in the example RestBucksCRUD. Replace the assigment attempt with attached syntax

## Day - 2012-10-01  Jocelyn Fiat  <jfiat@eiffel.com>

	Fixed some configuration files (ecf) Fixed various compilation issue Fixed draft rest library (still experimental and should be removed in the future)

## Day - 2012-09-28  Jocelyn Fiat  <jfiat@eiffel.com>

	Merge branch 'master' of github.com:EiffelWebFramework/EWF

	Added initial experimentation of a CMS built with Eiffel

	moved wsf_extension inside wsf/extension as wsf/wsf_extension.ecf added wsf/session as wsf/wsf_session.ecf In descendants of WSF_HANDLER , we can keep the result of new_mapping as WSF_ROUTER_MAPPING

	Merge branch 'master' of github.com:EiffelWebFramework/EWF

## Day - 2012-09-27  Jocelyn Fiat  <jfiat@eiffel.com>

	Fixed wizard generated code with new router design

	Reviewed the semantic of the handler context. Adapted existing code to fit the new router design.

## Day - 2012-09-26  Jocelyn Fiat  <jfiat@eiffel.com>

	Fixed Restbuck examples with new router design

	added missing wsf_routing_filter

## Day - 2012-09-25  Jocelyn Fiat  <jfiat@eiffel.com>

	Applied new ROUTER design to the whole EWF project.

## Day - 2012-09-20  Jocelyn Fiat  <jfiat@eiffel.com>

	Merge branch 'master' of github.com:EiffelWebFramework/EWF

## Day - 2012-09-19  Jocelyn Fiat  <jfiat@eiffel.com>

	Minor implementation changes (feature renaming, ... )

	New ROUTER design, much simpler, less generic, easier to extend, and now one can mix uri map, uri_template map and so on. Update the "tutorial" example.

## Day - 2012-09-19  jocelyn  <github@djoce.net>

	Updated Meetings (markdown)

	Updated Home (markdown)

	Updated Home (markdown)

	Created Meetings (markdown)

	Updated Projects (markdown)

	Updated Projects (markdown)

## Day - 2012-09-18  jocelyn  <github@djoce.net>

	Updated Web meeting 2012 09 18 (markdown)

## Day - 2012-09-18  oligot  <oligot@gmail.com>

	Updated Web meeting 2012 09 18 (markdown)

## Day - 2012-09-18  jocelyn  <github@djoce.net>

	Updated Web meeting 2012 09 18 (markdown)

	Updated Web meeting 2012 09 18 (markdown)

	Updated Web meeting 2012 09 18 (markdown)

## Day - 2012-09-17  oligot  <oligot@gmail.com>

	Updated Web meeting 2012 09 18 (markdown)

## Day - 2012-09-17  jocelyn  <github@djoce.net>

	Updated Web meeting 2012 09 18 (markdown)

## Day - 2012-09-14  oligot  <oligot@gmail.com>

	Created Web meeting 2012 09 18 (markdown)

## Day - 2012-09-13  Jocelyn Fiat  <github@djoce.net>

	Merge pull request #1 from GroupeS/fix_hash_table_converter
	[FIX] Convertion from DS_HASH_TABLE keys to JSON

## Day - 2012-09-12  Olivier Ligot  <oligot@gmail.com>

	[FIX] Indentation

## Day - 2012-09-12  Jocelyn Fiat  <github@djoce.net>

	Merge pull request #2 from oligot/fix_test_compilation
	[FIX] Unknown identifier 'unescaped_string'

## Day - 2012-09-12  Olivier Ligot  <oligot@gmail.com>

	[FIX] Convertion from HASH_TABLE keys to JSON

	Merge branch 'master' into fix_hash_table_converter

	[FIX] Unknown identifier 'unescaped_string'

## Day - 2012-09-11  Jocelyn Fiat  <jfiat@eiffel.com>

	Added general_encoded_string (..) that accepts READABLE_STRING_GENERAL

## Day - 2012-09-10  Jocelyn Fiat  <jfiat@eiffel.com>

	added WSF_VALUE.is_empty: BOOLEAN

	Added `HTML_ENCODER.general_encoded_string (s: READABLE_STRING_GENERAL): STRING_8' (note: probably we should do similar change for all the encoders)

	Fixed issue when applying URI_TEMPLATE result to WSF_REQUEST to populate `path_parameters', now if we have table parameter for `foo[]' .. we ignore any string parameter with same name `foo' Also fixed issue where the encoded name were changed later, since it kept the same string reference. Added `WSF_REQUEST.is_post_request_method: BOOLEAN' and `WSF_REQUEST.is_get_request_method: BOOLEAN' to ease app code

	Added `WSF_TABLE.is_empty: BOOLEAN' Added `WSF_TABLE.as_array_of_string: detachable ARRAY [READABLE_STRING_32]'

	Added put_expires_string (s: STRING) and put_expires_date (dt: DATE_TIME) Better implementation for WSF_FILE_RESPONSE (added last modified, and other caching related info)

## Day - 2012-09-05  Jocelyn Fiat  <github@djoce.net>

	Merge pull request #13 from GroupeS/filter
	Filter: pre-process incoming data and post-process outgoing data

## Day - 2012-09-05  Olivier Ligot  <oligot@gmail.com>

	[FIX] Path to libraries

	Merge remote-tracking branch 'upstream/master' into filter

## Day - 2012-08-31  Jocelyn Fiat  <jfiat@eiffel.com>

	Also convert from STRING_8 to URI_TEMPLATE (not only from READABLE_STRING_8)

## Day - 2012-08-28  Jocelyn Fiat  <jfiat@eiffel.com>

	fixed location of ewf.ini for ISE wizard

	Fixed source code for building and installing the ISE Wizard

## Day - 2012-08-24  Jocelyn Fiat  <jfiat@eiffel.com>

	Merge branch 'master' of github.com:EiffelWebFramework/EWF

## Day - 2012-08-24  oligot  <oligot@gmail.com>

	Add support for Swagger

## Day - 2012-08-24  Jocelyn Fiat  <jfiat@eiffel.com>

	Merge branch 'master' of https://github.com/eiffelhub/json
	Conflicts:
		draft/library/gobo/shared_gobo_ejson.e
		draft/library/kernel/converters/json_converter.e
		draft/library/kernel/converters/json_hash_table_converter.e
		draft/library/kernel/converters/json_linked_list_converter.e
		draft/library/kernel/ejson.e
		draft/library/kernel/shared_ejson.e
		draft/test/autotest/test_suite/json_author_converter.e
		draft/test/autotest/test_suite/json_book_collection_converter.e
		draft/test/autotest/test_suite/json_book_converter.e
		draft/test/autotest/test_suite/test_json_core.e

	Merge branch 'master' of https://github.com/EiffelWebFramework/EWF.wiki
	Conflicts:
		doc/wiki/Home.md

	Merge branch 'master' of https://github.com/EiffelWebFramework/EWF.wiki
	Conflicts:
		doc/wiki/Home.md

## Day - 2012-08-14  jocelyn  <github@djoce.net>

	Updated Projects (markdown)

## Day - 2012-08-13  jocelyn  <github@djoce.net>

	Updated Projects (markdown)

	Updated Projects  Suggestions (markdown)

	Updated Projects   Suggestions (markdown)

	Updated Projects (markdown)

	Updated Projects (markdown)

	Updated Projects   Suggestions (markdown)

	Updated Projects   Suggestions (markdown)

	Updated Projects   Suggestions (markdown)

	Updated Project suggestions (markdown)

	Created Project suggestions (markdown)

	Updated Projects (markdown)

	Updated Projects (markdown)

## Day - 2012-08-10  Olivier Ligot  <oligot@gmail.com>

	[ADD] Filter: pre-process incoming data and post-process outgoing data
	Filters are part of a filter chain, thus following the chain of responsability
	design pattern.
	More information are available in library/server/wsf/src/filter/README.md

## Day - 2012-08-08  Jocelyn Fiat  <jfiat@eiffel.com>

	removed "getest" since it is duplication with autotest (and we use mainly the later for regression testing)

	Added JSON_PRETTY_STRING_VISITOR Added converter for ARRAYED_LIST Fixed STRING_32 to JSON_VALUE issue in ejson.e Added missing new line character at the end of some files. Cosmetic

## Day - 2012-08-02  Olivier Ligot  <oligot@gmail.com>

	[FIX] Convertion from DS_HASH_TABLE keys to JSON
	This is useful when the type of the key is something else than a STRING
	and we have a JSON converter for this type.

## Day - 2012-07-31  jocelyn  <github@djoce.net>

	Updated Projects (markdown)

## Day - 2012-07-30  jocelyn  <github@djoce.net>

	Updated Projects (markdown)

	Updated Projects (markdown)

	Updated Projects (markdown)

	Updated Projects (markdown)

	Updated Projects (markdown)

## Day - 2012-07-27  jocelyn  <github@djoce.net>

	Updated Projects (markdown)

	Created Projects (markdown)

	Updated Home (markdown)

	Updated Home (markdown)

## Day - 2012-07-05  Jocelyn Fiat  <github@djoce.net>

	Update master

## Day - 2012-06-29  Jocelyn Fiat  <jfiat@eiffel.com>

	Merge branch 'master' of github.com:EiffelWebFramework/EWF

	updated to use WSF_STRING.value instead of obsolete WSF_STRING.string

	Merge branch 'master' of https://github.com/eiffelhub/json

	Better code for tutorial example.

	Merge branch 'master' of https://github.com/EiffelWebFramework/EWF.wiki

## Day - 2012-06-29  jocelyn  <github@djoce.net>

	Updated EWSGI specification: difference in main proposals (markdown)

## Day - 2012-06-28  Jocelyn Fiat  <jfiat@eiffel.com>

	cosmetic

	Merge branch 'master' of https://github.com/eiffelhub/json
	Conflicts:
		draft/library/kernel/json_object.e

	Merge branch 'master' of https://github.com/eiffelhub/json
	Conflicts:
		draft/library/kernel/json_object.e

	Added subtree merged in contrib\library\text\parser\json

	Added TABLE_ITERABLE interface to JSON_OBJECT Added JSON_OBJECT.replace (value, key)

## Day - 2012-06-27  Jocelyn Fiat  <jfiat@eiffel.com>

	use svn export instead of svn checkout

## Day - 2012-06-26  Jocelyn Fiat  <jfiat@eiffel.com>

	If library/cURL exists, do not copy cURL to contrib/library/network/cURL

## Day - 2012-06-22  Jocelyn Fiat  <jfiat@eiffel.com>

	Merge branch 'master' of https://github.com/EiffelWebFramework/EWF.wiki

	Added simple console wizard for Eiffel Studio. (It is not very user friendly, this is a first draft) It should be improved in the future (with GUI, ...)

## Day - 2012-06-20  jocelyn  <github@djoce.net>

	Updated Community collaboration (markdown)

	Updated Task json (markdown)

	Updated Tasks Roadmap (markdown)

## Day - 2012-06-20  Jocelyn Fiat  <jfiat@eiffel.com>

	Updated doc/wiki from branch 'master' of https://github.com/EiffelWebFramework/EWF.wiki
	Conflicts:
		doc/wiki/Home.md

	When installing, remove the folder "fonts" from the nino's example

	removed git submodule for contrib/ise_library/cURL  (replaced by git subtree merged)

	fixed path in uninstall_ewf.bat

	Replaced git submodule by subtree merged in contrib/ise_library/cURL

	Replaced git submodule by subtree merged in contrib/library/text/parser/json

## Day - 2012-06-19  Jocelyn Fiat  <jfiat@eiffel.com>

	Fixed typo in linux command line  (should use -option instead of --option )

	Put examples under examples/web/ewf/...

	Fixed typo

	fixed typo in dos batch script

## Day - 2012-06-19  Jocelyn Fiat  <github@djoce.net>

	IfECF_PATH_UPDATER is defined, let's use it to find ecf_updater executable

## Day - 2012-06-18  Jocelyn Fiat  <github@djoce.net>

	put everything under contrib for now, eventually svn checkout missing parts

## Day - 2012-06-18  Jocelyn Fiat  <jfiat@eiffel.com>

	fixed not enought argument for internal shell function (typo..)

	Final version of the install scripts.

	Fixed typo and path separators usage in dos batch scripts

	Install script does the same on Windows and Linux

	improved install_ewf.sh , and removed usage of deleted router.ecf

## Day - 2012-06-15  Jocelyn Fiat  <jfiat@eiffel.com>

	Updated install_ewf.sh

## Day - 2012-06-15  colin-adams  <colin@colina.demon.co.uk>

	Complete.

	Updated Library conneg (markdown)

	Updated Library conneg (markdown)

	Updated Library conneg (markdown)

	Updated Library conneg (markdown)

## Day - 2012-06-15  Jocelyn Fiat  <jfiat@eiffel.com>

	Cleaned up compile_all.ini

	Updated draft library  (consider it as draft quality)

	More flexible signature to allow detachable READABLE_STRING_8

## Day - 2012-06-15  colin-adams  <colin@colina.demon.co.uk>

	Created Library conneg (markdown)

## Day - 2012-06-15  Jocelyn Fiat  <jfiat@eiffel.com>

	updated eel and eapml from more recent versions.

	Moved eel and eapml under the contrib folder.

	Fixing wrong path for ewsgi connector nino (this was introduced recently when we moved folder location)

	added methods_head_get_post and methods_head_get

	Fixed previous commit where nino .ecf path was empty.

## Day - 2012-06-15  colin-adams  <colin@colina.demon.co.uk>

	Updated Tasks Roadmap (markdown)

	Updated Task json (markdown)

## Day - 2012-06-14  jocelyn  <github@djoce.net>

	Updated Home (markdown)

## Day - 2012-06-14  Jocelyn Fiat  <jfiat@eiffel.com>

	Merge branch 'master' of github.com:EiffelWebFramework/EWF

	Updated structure of EWF, applied Now "nino" is under contrib/library/network/server/nino  (as git merge subtree, and not anymore as submodule)

	Fixing issue with HEAD and make_from_iterable

## Day - 2012-06-13  Jocelyn Fiat  <jfiat@eiffel.com>

	Merge remote-tracking branch 'ewf_wiki/master'

## Day - 2012-06-13  jocelyn  <github@djoce.net>

	Updated Home (markdown)

## Day - 2012-06-13  Jocelyn Fiat  <github@djoce.net>

	Update master

## Day - 2012-06-13  Jocelyn Fiat  <jfiat@eiffel.com>

	Added "nino" subtree merged in contrib/library/network/server/nino

	Change structure of EWF, to follow better categorization

	Better script, do not use default folder without asking.

	Added temporary scripts to install EWF on Windows

## Day - 2012-06-11  Jocelyn Fiat  <jfiat@eiffel.com>

	updated script with official git repo

	Adopted convention name and value or values for WSF_VALUE and descendant (WSF_STRING ...)   kept `key' as redirection, and also string as obsolete redirection. Router: provide a way to pass the request methods without using manifest string, thanks to WSF_ROUTER_METHODS   so instead of using manifest array or manifest strings, just create an instance of WSF_ROUTER_METHODS   for convenience, WSF_ROUTER provides a few `methods_...' returning prebuilt WSF_ROUTER_METHODS objects Improved code related to unicode handling in URL, and parameters (before the framework was doing too much)

## Day - 2012-05-30  Jocelyn Fiat  <github@djoce.net>

	Update examples/tutorial/step_4.wiki

	Update examples/tutorial/step_4.wiki

	Update examples/tutorial/step_1.wiki

	Added precompile for step_3

	Sync with json

	Added html encoding facility to WSF_STRING Added WSF_STRING.is_empty Improved HTML_ENCODER to be able to decode a STRING_8 or STRING_32 using general_decoded_string (s) Improved tutorial example Added precompilation for WSF library Cosmetic (removed unused locals)

## Day - 2012-05-28  Jocelyn Fiat  <github@djoce.net>

	Applied recent changes made on EWF Updated copyright

	Now inherit create_router ; but it is still possible to redefine it. Added some wsf_reponse_message for redirection Use "found" for the redirec_now ... Added content to the tutorial

## Day - 2012-05-25  Jocelyn Fiat  <jfiat@eiffel.com>

	Better us OK status for redirection by default

	Merge branch 'master' of github.com:jocelyn/Eiffel-Web-Framework

	Added descriptions to WSF_RESPONSE about .send (mesg) Fixed minor issues in other classes

## Day - 2012-05-25  Jocelyn Fiat  <github@djoce.net>

	Update examples/tutorial/step_3.wiki

	added eiffel code

	cosmetic

	Update examples/tutorial/step_3.wiki

	Update examples/tutorial/step_3.wiki

	Update examples/tutorial/step_1.wiki

	fixed github wikitext usage

	Update examples/tutorial/step_4.wiki

	Update examples/tutorial/step_3.wiki

	Update examples/tutorial/step_2.wiki

	Update examples/tutorial/step_1.wiki

## Day - 2012-05-25  Jocelyn Fiat  <jfiat@eiffel.com>

	Added more content to the tutorial

	Protected export of WSF_RESPONSE_MESSAGE.send_to Added WSF_DEFAULT_RESPONSE_SERVICE Added simple WSF_SERVICE_LAUNCHER_OPTIONS_FROM_INI class to load launch option from ini file.
	Removed a few obsolete features

## Day - 2012-05-25  Jocelyn Fiat  <github@djoce.net>

	Update examples/tutorial/README.wiki

	Update examples/tutorial/README.wiki

## Day - 2012-05-25  Jocelyn Fiat  <jfiat@eiffel.com>

	added skeleton for tutorial_i text

	removed README.md

	Removed to README.wiki

	Merge branch 'master' of github.com:EiffelWebFramework/EWF

	Updated indexing notes started tutorial Sync

## Day - 2012-05-23  Jocelyn Fiat  <github@djoce.net>

	http_client PUT uploaded data is not correctly implemented using libcurl so for now, let's use a real temporary file to use the upload filename implementation

## Day - 2012-05-21  Jocelyn Fiat  <github@djoce.net>

	fixed typo in curl.ecf

## Day - 2012-05-21  Berend de Boer  <berend@pobox.com>

	Do not use 307 but 302 response

## Day - 2012-05-15  Jocelyn Fiat  <github@djoce.net>

	Added presentation of EWF from march 2012

## Day - 2012-05-15  jocelyn  <github@djoce.net>

	Updated Home (markdown)

## Day - 2012-05-15  Jocelyn Fiat  <github@djoce.net>

	misc: script to checkout the source code with svn

	added some git tips in doc

	Added subtree merged in doc/wiki

	Removed submodule doc/wiki

## Day - 2012-05-14  Jocelyn Fiat  <github@djoce.net>

	removed commented lines

	updated ChangeLog

	Rather use (READABLE_)STRING_GENERAL for argument instead of _8 or _32 variant Better design to set the WSF_REQUEST.path_parameters    especially handle the case where the request goes trought more than one route (could be the case when using WSF_ROUTING_HANDLER)

	Updated URI Template to follow official RFC6570

## Day - 2012-05-07  Jocelyn Fiat  <github@djoce.net>

	Reviewed WSF_REQUEST.item (..) and items  to look into Form, Query, and Path (cookie are excluded for security) Added WSF_REQUEST.path_parameter (a_name): detachable WSF_VALUE    - fill path_parameters using `import_raw_path_parameters"      when executing the route    - reset to previous value with reset_path_parameters (..),      just in case the request is executed via severals routes.

## Day - 2012-05-04  Jocelyn Fiat  <github@djoce.net>

	Reverted back to export upload_data and upload_filename to ANY (and related features)

	Removed HTTP_CLIENT_SESSION.post_multipart .. because it was not doing what the name might evoque Restrict export of HTTP_CLIENT_REQUEST_CONTEXT.upload_data and upload_filename (and related) to .._SESSION and .._REQUEST    this is mainly internal data, and is more about implementation than interface

	Now the http_client will send the form parameters urlencoded if this is possible (instead of multipart form data)
	Note for now, the library does not support sending file and form parameters at the same time.

## Day - 2012-05-03  Jocelyn Fiat  <github@djoce.net>

	Fixed typo in .ecf .. curl instead of cURL

	Added geant scripts to compile EWF

	Improved the libcurl implementation of http_client by adding HTTP_CLIENT_SESSION.is_debug: BOOLEAN    if True, this display verbose debug information in console Implemented uploading of file for PUT and POST requests Refactored LIBCURL_HTTP_CLIENT_REQUEST to free used pointer, and also ease extension of the class if needed. Updated cURL library with addition of {CURL_EXTERNALS}.slist_free_all (..)

## Day - 2012-05-02  Jocelyn Fiat  <github@djoce.net>

	do not use implicit conversion from HTTP_CONTENT_TYPE

	Fixed wrong signature should be READABLE_STRING_32 instead of _8

	Also removing the implicit conversion from STRING to HTTP_*_TYPE

	Removed implicit conversion from HTTP_CONTENT_TYPE to STRING_8   because it could be a source of bug due to hidden conversion (and parameters) Applied changes to autotest cases Cosmetic

## Day - 2012-04-30  Jocelyn Fiat  <github@djoce.net>

	Added comments Added `url' to compute the url from base_url, path and query parameters

	Fixed error in URL encoding, according to the RFC3986, space should not be encoded with '+' but with percent encoding.

	Fixed signature issue, the argument `name' should be READABLE_STRING_32

	Code cleaning

	Added specific helper function related to `charset' parameter

## Day - 2012-04-27  Jocelyn Fiat  <github@djoce.net>

	added postcondition status_reason_phrase_unset  to `set_status'

	cosmetic

## Day - 2012-04-13  Jocelyn Fiat  <github@djoce.net>

	Fixed a last minute regression due to removal REQUEST.chunked_input

	Added WSF_ROUTER.pre_route_execution_actions: ACTION_SEQUENCE [like route] This way, one can add logger hook to router, to see which "route" was taken by the request.

	Made WGI_CHUNKED_INPUT_STREAM inherits from WGI_INPUT_STREAM Merged REQUEST.input and REQUEST.chunked_input   Now REQUEST.input handles directly the chunked transfer encoding, or the non chunked. Kept REQUEST.is_chunked_input since it matters that Content-Length is 0 even if there are input (chunked) data.

## Day - 2012-04-12  Jocelyn Fiat  <github@djoce.net>

	Fixed compilation of samples

	Fixed compilation

	Missing commit related to changes on WSF_ROUTER

## Day - 2012-04-12  Jocelyn Fiat  <github@djoce.net>

	Now WGI_RESPONSE.set_status_code (..) has a new argument to pass optional custom reason phrase.    This is a minor breaking change (but prior to the first release, so acceptable)    And then it is now possible to precise a custom reason phrase (useful for 4xx and 5xx response)
	At the WSF_RESPONSE level, the status code is now sent only when the header are sent.
	thus, it is possible to change the status code as long as no header is sent.
	(in the future, we should also try to delay the sending of headers)

	Removed WGI_RESPONSE.put_header_lines (..) which was not used, and WGI is not meant to provide such user friendly features
	Now this is available directly on WSF_RESPONSE

## Day - 2012-04-06  Jocelyn Fiat  <github@djoce.net>

	Merge branch 'master' of github.com:EiffelWebFramework/EWF

	updated to EiffelWebFramework/EWF

	sync with json lib.

	Sync with wiki

	Use https://github.com/EiffelWebFramework/EWF.git as master

## Day - 2012-04-05  Jocelyn Fiat  <github@djoce.net>

	Added `transfered_content_length' to WSF_RESPONSE to provide the information to application This can be used to build logs for instance.

	Relaxed WSF_REDIRECTION_RESPONSE.set_content (.., ..) to allow Void for content type in order to use the one set in header or the default one.

	Removed default handler for WSF_ROUTER Added 	WSF_ROUTE to replace a TUPLE [H, C] 	WSF_ROUTER.route (req): detachable WSF_ROUTE 	WSF_ROUTER.execute_route (a_route, req, res) 	To help usage of Routers Remove WSF_HANDLER_CONTEXT obsolete features. Added comments

## Day - 2012-04-02  Jocelyn Fiat  <github@djoce.net>

	Merge remote-tracking branch 'remotes/eiffelworld/master'

	Merge pull request #10 from oligot/unneeded_precondition
	Unneeded precondition

## Day - 2012-04-02  Olivier Ligot  <oligot@gmail.com>

	[REM] Remove unneeded precondition

	[IMP] Ignore *.swp files

## Day - 2012-04-02  Jocelyn Fiat  <github@djoce.net>

	removed obsolete message.

## Day - 2012-03-27  Olivier Ligot  <oligot@gmail.com>

	[REM] Remove unneeded precondition

	[IMP] Ignore *.swp files

## Day - 2012-03-26  Olivier Ligot  <oligot@gmail.com>

	Merge branch 'master', remote branch 'upstream/master'

## Day - 2012-03-23  Jocelyn Fiat  <github@djoce.net>

	Renamed same_media_type as same_simple_type Added comments

	updated tests.ecf

	Added HTTP_MEDIA_TYPE  (maybe it will just replace the HTTP_CONTENT_TYPE later)   renamed .media_type as .simple_type for now   allow more than one parameters

	Use media_type as replacement for type_and_subtype_string in HTTP_CONTENT_TYPE

	Added class HTTP_CONTENT_TYPE to help manipulation of Content-Type value Now WSF_REQUEST return a HTTP_CONTENT_TYPE if available Adapted WSF_MIME_HANDLER to use this new class Added one manual autotest to test MIME handler

## Day - 2012-03-21  Jocelyn Fiat  <github@djoce.net>

	in WSF_RESPONSE, `put_header' now call `put_header_text' Removed unused local variable

	Fixed very bad mistake where no Result was ever set for WSF_REQUEST.item (..)

## Day - 2012-03-20  Jocelyn Fiat  <github@djoce.net>

	fixed compilation issue  (typo)

	Do not try to compile_all in "dev" folder

	Reverted a previous change, we should not truncated Content-Type after ; In the case of multipart/form-data  the parameter "boundary=" is essential

	Use WSF_DEFAULT_SERVICE for the test echo server

	Fixing compilation of specific example using the WGI connector directly

	Added WSF_SERVICE.to_wgi_service to ease direct integration with existing WGI components

	Relaxed access to `send_to', now it is exported again to avoid breaking existing code.

	remove unused local variable

	WSF_REQUEST.content_type should keep only the relevant part of the content type    and forget about the eventual parameters (charset, name) ...
	  note: it is possible to query meta_string_variable ("CONTENT_TYPE")
	        to get the complete Content-Type header

	Added HTTP_HEADER.(put|add)_content_type_with_parameters (...)

	removed obsolete

	Implemented WSF_RESPONSE.put_error (...) and related Added WSF_RESPONSE.put_character Renamed  WGI_OUTPUT_STREAM.put_character_8 as put_character  to follow style of put_string  (and not put_string_8) Refactored the WSF_DEFAULT_SERVICE_LAUNCHER Added WSF_DEFAULT_SERVICE to be more user friendly Splitted the wsf/default/ libraries to have wsf/connector/... and being able to handle more than one connector in the same application

	Moved mime handler classes under wsf/src/mime/

## Day - 2012-03-19  Jocelyn Fiat  <github@djoce.net>

	removed unwanted rescue clause

	Updating EWSGI specification classes

	Removed WGI_RESPONSE.write (..) Replaced any internal call to WGI_RESPONSE.write () by the associated implementation (i.e  output.put_string (...)  ) Added WGI_OUTPUT_STREAM.put_crlf
	Renamed WSF_RESPONSE.put_response (a_message) as  `send (a_message)'
	WSF_RESPONSE_MESSAGE.send_to (res)  is now exported only to WSF_RESPONSE

## Day - 2012-03-19  Berend de Boer  <berend@pobox.com>

	Avoid another indirection.

## Day - 2012-03-19  Berend de Boer  <berend@pobox.com>

	status must be set, else WGI_SERVICE.execute will report the postcondition violation.
	Conflicts:

		library/server/wsf/router/wsf_handler.e

## Day - 2012-03-19  Berend de Boer  <berend@pobox.com>

	Minor code cleanup/typo fix.

	Move wgi_service spec to its own directory else I get a class conflicts with compile_ise.ecf generated by gexace.

## Day - 2012-03-19  Jocelyn Fiat  <github@djoce.net>

	Improved comment in WSF_RESPONSE.put_response (..) Added WSF_REDIRECTION_RESPONSE class

## Day - 2012-03-19  Jocelyn Fiat  <github@djoce.net>

	Added WSF_RESPONSE_HANDLER based on WSF_RESPONSE_MESSAGE The descendant has to implement the function
	    response (ctx: C; req: WSF_REQUEST): WSF_RESPONSE_MESSAGE

	Added related features and class in WSF_ROUTER to be able to use agent easily.

## Day - 2012-03-19  Jocelyn Fiat  <github@djoce.net>

	Refactored WSF_HANDLER_CONTEXT   - removed path_parameter   - added `item' to include WSF_REQUEST.item   - marked obsolete `parameter'
	The goal is to remove confusion, remove URI_TEMPLATE specific `path_parameter'
	and provide a way to use ctx.item (..) to also include meta variable, query, form, ... items

	Use local variable to speed up access to `input'

## Day - 2012-03-16  Jocelyn Fiat  <github@djoce.net>

	Applied wsf_extension creation, and classes moved from wsf to wsf_extension

	Created wsf_extension, and moved some classes from wsf to wsf_extension    WSF_HANDLER_HELPER    WSF_RESOURCE_HANDLER_HELPER    WSF_HANDLER_ROUTES_RECORDER

	applied removal of HTTP_HEADER.put_status (..)

	Removed HTTP_HEADER.put_status (...)   It is not recommended to send the status code as part of the HTTP Header,   so let's remove this ambiguity and do not encourage EWF user to use it

	Major renaming, adopt the WSF_ prefix for all classes under "wsf", and simplify some class names Removed in WGI_INPUT_STREAM, the assertion "same_last_string_reference" Copyright updates

## Day - 2012-03-13  Jocelyn Fiat  <github@djoce.net>

	Fixed compilation of draft/library/server/request/rest/tests/.. Note the "rest" library will not be maintained since this is not REST.

	precise that library/server/request/router is now part of "wsf" library and not anymore independant library.

## Day - 2012-03-13  Jocelyn Fiat  <github@djoce.net>

	Nino connector:  - fixed issue related to `ready_for_reading'  now use the `try_...' variant  - for now Nino does not support persistent connection, then we have to respond with "Connection: close"
	REQUEST_FILE_SYSTEM_HANDLER:
	 - added not_found_handler and access_denied_handler, so that the user can customize related response

	WSF_REQUEST and WSF_VALUE:
	 - modified how uploaded file are handled, fixed various issues, and added WSF_UPLOADED_FILE (it is a WSF_VALUE)

	WSF_VALUE:
	 - added change_name (a_name: like name)
	 - added url_encoded_name to other WSF_values

	WSF_REQUEST:
	 - added `destroy' to perform end of request cleaning (such as deleting temp uploaded files)
	 - renamed `raw_post_data_recorded' as `raw_input_data_recorded', and related feature
	 - do not store the RAW_POST_DATA in meta variable anymore, but in WSF_REQUEST.raw_input_data is asked

	Added WSF_HTML_PAGE_RESPONSE to help user

	WSF_REPONSE.redirect_... now use "temp_redirect" as default
	  instead of "moved_permanently" which is specific usage

	Removed many obsolete features.

## Day - 2012-02-29  Jocelyn Fiat  <github@djoce.net>

	use https:// url for git submodules

	Added assertions to catch if route mapping does not already exists

## Day - 2012-02-28  Jocelyn Fiat  <github@djoce.net>

	Merging changes from Javier Updated restbucksCRUD example, and related class in wsf/router

	Synchronized with nino and json library

## Day - 2012-02-17  jvelilla  <javier.hector@gmail.com>

	Refactor REQUEST_RESOURCE_HANDLER_HELPER to figure out the transfer encoding: Chunked. Added a new method to retrieve_data independently if the transfer is chunked or not. Updated ORDER_HANLDER to use this new feature. Sync with Jocelyn repo

	Merge branch 'master' of git://github.com/jocelyn/Eiffel-Web-Framework

## Day - 2012-02-16  Jocelyn Fiat  <github@djoce.net>

	Minor correction, to avoid returning 200 as status code, when the client can not connect

## Day - 2012-02-15  Jocelyn Fiat  <github@djoce.net>

	fixed compilation

	sync with cURL library

	Fixed error visitor due to recent signature changes

	renamed (add|remove)_synchronized_handler as (add|remove)_synchronization

	Removed tests target from encoder(-safe).ecf (now there is a tests-safe.ecf in folder tests)

	Fixed ERROR_HANDLER.destroy Fixed and export ERROR_HANDLER.remove_synchronized_handler Added comments Added associated autotests

## Day - 2012-02-14  Jocelyn Fiat  <github@djoce.net>

	Better signature for encoders Split library .ecf and the autotest .ecf

	added postcondition to ensure the body string set to the response, is the same reference this is important, since sometime we just do   rep.set_body (s)   s.append_string ("..")

	Added DEBUG_OUTPUT to ERROR, since this is convenient during debugging

	Added notion of synchronization between error handler this is convenient to integrate two components using their own ERROR_HANDLER (not sharing the same object)

	use WSF_PAGE_RESPONSE, instead of reimplementing it ourself

## Day - 2012-02-13  Jocelyn Fiat  <github@djoce.net>

	added a JSON encoder test case

	Merge pull request #9 from oligot/fix-libfcgi-location
	[FIX] libfcgi.so location

## Day - 2012-02-10  Olivier Ligot  <oligot@gmail.com>

	[FIX] libfcgi.so location
	On Ubuntu 10.04 LTS, libfcgi.so is in /usr/lib instead of /usr/local/lib

## Day - 2012-02-08  Jocelyn Fiat  <github@djoce.net>

	added a case in test_json_encoder

## Day - 2012-02-08  unknown  <jfiat@xp_pro_32.(none)>

	libcurl: Applied a workaround to avoid issue on Win32 (see LIBCURL_HTTP_CLIENT_REQUEST.apply_workaround) Separated the http_client-safe.ecf and test-safe.ecf Added HTTP_CLIENT_SESSION.set_max_redirects Fixed broken test due to formatting trouble.

## Day - 2012-02-08  Jocelyn Fiat  <github@djoce.net>

	fixed http_client tests

## Day - 2012-02-08  jvelilla  <javier.hector@gmail.com>

	Updated content

## Day - 2012-02-07  Jocelyn Fiat  <github@djoce.net>

	Better code to test similar functions but with chunked input

	Improved the WSF_PAGE_RESPONSE to be more flexible and allow to change some values as expected.

	Added support for chunked input data  (see Transfer-Encoding: chunked)

	Added HTTP_HEADER.append_header_object and append_array. This is helpful to "merge" two HTTP_HEADER and provide user friendly features

	Added proxy, at least to make it is possible to use http://fiddler2.com/ to inspect the traffic.

	Merge branch 'master' of https://github.com/jvelilla/Eiffel-Web-Framework

## Day - 2012-02-01  Jocelyn Fiat  <github@djoce.net>

	Fixed wrong code for postcondition on HTTP_HEADER.string
	Patch provided by Paul-G.Crismer

	removed unwanted set_status_code, since we already use put_header to set the status code.

	Eventually fixing trouble with c_strlen being over capacity (added this for testing, and while waiting a fix from EiffelcURL)

	Improved redirect_now_custom to allow custom status code, custom header, and custom content

## Day - 2012-01-31  Jocelyn Fiat  <github@djoce.net>

	Fixed usage of lst[] in web form, now we are url-decoding the name because the [] could escaped... Fixed bad code for assertion related to variable url-encoded name

	added REQUEST_HANDLER_CONTEXT.string_array_path_parameter (...) to help user handling list/array parameters fixed postcondition WSF_REQUEST.set_meta_string_variable ...

## Day - 2012-01-25  Jocelyn Fiat  <github@djoce.net>

	Make sure to return a response Added precondition to check URI_TEMPLATE is valid

## Day - 2012-01-24  Jocelyn Fiat  <github@djoce.net>

	Fixed wrong assertion, status_committed instead of status_set

## Day - 2012-01-23  Jocelyn Fiat  <github@djoce.net>

	Fixed issue with WSF_FILE_RESPONSE not setting the status code Added Last-Modified

	Fixed wrong code for postcondition in unset_orig_path_info

	Removed most of the "retry" in rescue clauses, since it was hidding critical issue. This should be the choice of the application to "retry" on exception, otherwise let the framework handle this in the lower part.
	Better handling of response termination (alias commit)
	Added the notion of "status_committed"

	added "conversion" to ease the use of HTTP_HEADER

## Day - 2012-01-20  Jocelyn Fiat  <github@djoce.net>

	fixed compilation (was not up to date with tests.ecf)

	Corrected remaining issue related to recent addition of REQUEST_ROUTER.make_with_base_url And applied removal of format_name and format_id, and replaced by accepted_format_name, ...

	Do not add again ctx.headers, since it is already "imported" during the creation of Current request (see HTTP_CLIENT_REQUEST.make)

	Removed any "format" related query from router lib, this is too application specific to be there. Better handling of base_url for REQUEST_ROUTER

## Day - 2012-01-19  Jocelyn Fiat  <github@djoce.net>

	separate library .ecf and tests .ecf merged tests .ecf for draft 05 and current implementation

	Fixed WSF_REQUEST.script_url (..) for clean path Added related autotests

## Day - 2012-01-17  Jocelyn Fiat  <github@djoce.net>

	Don't forget to put Content-Length: 0  for redirect without any content

## Day - 2012-01-17  Jocelyn Fiat  <jfiat@eiffel.com>

	export handler from REQUEST_ROUTER

## Day - 2012-01-17  Jocelyn Fiat  <github@djoce.net>

	REQUEST_ROUTER now inherit from ITERABLE [..]

	Send the Status code, as an header line  Status: code reason

	use READABLE_STRING_8 instead of STRING_8

	According to http://www.fastcgi.com/docs/faq.html#httpstatus send the Status code, as an header line  Status: code reason

## Day - 2012-01-16  Jocelyn Fiat  <github@djoce.net>

	Do not send any Status line back to the FastCGI client

## Day - 2012-01-13  Jocelyn Fiat  <github@djoce.net>

	Synchronized with ejson library Cleaned JSON_ENCODER

## Day - 2012-01-12  Jocelyn Fiat  <github@djoce.net>

	Added JSON_ENCODER

## Day - 2012-01-09  Jocelyn Fiat  <github@djoce.net>

	removed obsolete call on `WSF_RESPONSE.write_..' by using the up-to-date `WSF_RESPONSE.put_..'

## Day - 2012-01-06  Jocelyn Fiat  <github@djoce.net>

	HTTP_HEADER: - added put_last_modified              - added RFC1123 http date format helper              - added put_cookie_with_expiration_date as DATE_TIME REQUEST: added `execution_variable' to provide a way to keep object attached to the request          and indexed by a string. A typical usage is a SESSION object

## Day - 2011-12-21  jvelilla  <javier.hector@gmail.com>

	Update examples/restbucksCRUD/readme.md

## Day - 2011-12-18  Jocelyn Fiat  <github@djoce.net>

	added REQUEST.execution_variables ... to provide a solution to store data during request execution could be used for SESSION, or any "shared" data inside the same Request

	applied write_ as put_ renaming to examples

## Day - 2011-12-15  Jocelyn Fiat  <github@djoce.net>

	Use put_ instead of write_

	various minor changes

	use /usr/lib/libfcgi.so instead of /usr/local/lib/libfcgi.so

	Applied renaming from write_ to put_

	Renamed write_ feature as put_

	Fixed stupid mistake in {WGI_NINO_INPUT_SREEAM}.end_of_input

	Fixed typo and missing uri_template reference for draft rest library

	Now the 'router' library is part of 'wsf' Move hello_routed_world under tests/dev since it was not really an example, but more a dev workspace/test

	Made DEFAULT_SERVICE_LAUNCHER more flexible for the user.

## Day - 2011-12-15  jvelilla  <javier.hector@gmail.com>

	Update read_trailer feature.

	Initial implementation of wgi_chunked_input_stream as a wrapper of wgi_input_stream

## Day - 2011-12-14  Jocelyn Fiat  <github@djoce.net>

	Use port 9090 for restbuck server mainly to avoid using 80 or 8080 which are often already used (by current webserver, or even skype, or jenkins, or ...)

	Forgot to add make_and_launch_with_options to the creation procedures

	Added DEFAULT_SERVICE_LAUNCHER.make_and_launch_with_options Added WSF_RESPONSE.redirect_now_with_content (...) Updated hello_routed_world .. mainly example use to test/develop... not really a nice example

## Day - 2011-12-13  Jocelyn Fiat  <github@djoce.net>

	Updated readme on how to get source code

	added head and bottom value in WSF_FILE_RESPONSE, to enable the user to set a head and bottom part easily

## Day - 2011-12-12  Jocelyn Fiat  <github@djoce.net>

	avoid infinite rescue due to internal error or user code not dealing well with socket disconnection

	Removed dotnet target for now

	Merge branch 'master' of github.com:Eiffel-World/Eiffel-Web-Framework

	Fixed http_client autotest code

	Break inheritance from WGI_RESPONSE, since it is not flexible for future improvement.

	Fixed HTTP client callers

	Renamed DEFAULT_SERVICE as DEFAULT_SERVICE_LAUNCHER

	Fixed WSF_FILE_RESPONSE and added WSF_FORCE_DOWNLOAD_RESPONSE

## Day - 2011-12-12  Jocelyn Fiat  <github@djoce.net>

	Merge changes from Javier - update on RESTbuck examples - new example - fixed bad typo in WSF_REQUEST
	Reverted some changes such as
	- http_client_response: keep the headers as a list to handle multiple message-value with same message-name

	Fixed simple and simple_file example
	Improved HTTP_HEADER

	Changed libcurl implementation for http client
	- now the header from the context really overwrite any of the session headers
	- better design which is more strict, and remove any doubt about context's header usage

## Day - 2011-12-12  Jocelyn Fiat  <github@djoce.net>

	Removed any (put|write)_file_content from the WSF_ or WGI_ OUTPUT classes Now DEFAULT_SERVICE has to be created instead of inherited.    - This seems to be better for new user, and this avoid potential conflict and difference when inheriting between the various DEFAULT_SERVICE implementation.    - remember that DEFAULT_SERVICE, is mainly to help the user to build its very first service. Use READABLE_STRING_8 as argument whenever it is possible. Added WSF_RESPONSE_MESSAGE, and WSF_RESPONSE.put_response (a_response_message) Now WSF_RESPONSE inherit from WGI_RESPONSE

## Day - 2011-12-10  jvelilla  <javier.hector@gmail.com>

	Merge branch 'master' of github.com:jvelilla/Eiffel-Web-Framework

	Update restbuck client, create and read an order. Update JSON converter, the id is not important, applied the DRY principle. Update the ORDER_HANDLER to use the meta_string_variable instead of meta_variable from req. Fix, the key in meta_variable_table, use c.key instead of c.item

	Update examples/restbucksCRUD/readme.md

	Merge branch 'master' of github.com:jvelilla/Eiffel-Web-Framework

	Update the restbuck_client, still work in progress. Update restbuck_server, remove unused class in inherit. Update libcurl_http_client_request, to parse context headers before the execution. Update wgi_input_stream, commented precondition.

## Day - 2011-12-09  jvelilla  <javier.hector@gmail.com>

	Update examples/restbucksCRUD/readme.md

	Update examples/restbucksCRUD/readme.md

	Update examples/restbucksCRUD/readme.md

	Update examples/restbucksCRUD/readme.md

	Update examples/restbucksCRUD/readme.md

	Update examples/restbucksCRUD/readme.md

	Update examples/restbucksCRUD/readme.md

	Update examples/restbucksCRUD/readme.md

	Update examples/restbucksCRUD/readme.md

	Update examples/restbucksCRUD/readme.md

	Update examples/restbucksCRUD/readme.md

	Update examples/restbucksCRUD/readme.md

	Update examples/restbucksCRUD/readme.md

	Update examples/restbucksCRUD/readme.md

	Update examples/restbucksCRUD/readme.md

	Update examples/restbucksCRUD/readme.md

## Day - 2011-12-08  jvelilla  <javier.hector@gmail.com>

	Update examples/restbucksCRUD/readme.md

	Updated documentation

	Updated restbucksCRUD documentation

	Added basic two basic examples, refactor rename restbucks to restbucksCRUD

## Day - 2011-12-07  jvelilla  <javier.hector@gmail.com>

	Sync Jocelyn repo

## Day - 2011-12-03  Jocelyn Fiat  <github@djoce.net>

	Update README.md

	Update README.md

	Update README.md

	fixed markdown syntax

## Day - 2011-12-02  Jocelyn Fiat  <github.pub@djoce.net>

	Remove any useless library include from this .ecf we just need default_"connector", router, wsf and http

	Fixed compilation issue for CGI and libFCGI connector due to recent changes in interface  (use READABLE_STRING_8)

## Day - 2011-12-01  Jocelyn Fiat  <github@djoce.net>

	Integrated new system to handle form_parameter, input_data in relation with MIME handling This is not yet clear how to let the user precise its own MIME handler but it is in progress

	fixed remaining issue or useless code to set http environment variable

	Fixed stupid error where we were concatenating ... value by error

	Added WSF_RESPONSE.write_chunk (s: ?READABLE_STRING_8) to help user sending chunk with "Transfer-Encoding: chunked"

	Synchronized with Nino

	Fixed WSF_RESPONSE.redirect* features

	sync with Nino, call to put_readable_string_8

	Synchronized with EiffelWebNino

	relative path for README link

## Day - 2011-12-01  jvelilla  <javier.hector@gmail.com>

	Update library/protocol/CONNEG/README.md

	Update library/protocol/CONNEG/README.md

	Updated Conneg library, added test cases

## Day - 2011-11-30  jvelilla  <javier.hector@gmail.com>

	Fixed minor issue, added test cases to check language negotiation.

	Update conneg library and test cases

## Day - 2011-11-25  Jocelyn Fiat  <github@djoce.net>

	Fixed example due to recent interface changes

	- (WGI|WSF)_RESPONSE(*) renamed write_headers_string as write_header_text - HTTP_HEADER.string does not have the ending CRLFCRLF .. but just CRLF - WGI_RESPONSE.write_header_text has the responsibility to handle the last blank line CRLF (separating the header from the message) - HTTP_HEADER.string does not set anymore a default content type as text/html - added WGI_RESPONSE.write_header_lines (ITERABLE [TUPLE [name,value: READABLE_STRING_8]] mainly as an helper method,    this way the WGI user does not have to know about the CRLF end of line

	Applied recent renaming from WGI_RESPONSE_BUFFER as WGI_RESPONSE

	updated WGI specification

	Added missing wgi_connector

	added "redirect" helper feature to WSF_RESPONSE

	Added `{WGI_REQUEST}.wgi_*' function to WSF_REQUEST

	rename `application' as `service'

	Use HTTP_HEADER instead of WSF_HEADER (WSF_HEADER is kept for convenience and existing code)

	better script to check compilation and tests

	Moved implementation of WSF_HEADER to HTTP_HEADER in the http library

	Simplified EWSGI interfaces Renamed WGI_RESPONSE_BUFFER as WGI_RESPONSE to avoid confusion Removed EWF_HEADER and removed related caller from WGI implementation,    now this is only part of WSF library Added wgi_version, wgi_implementation and wgi_connector to the WGI_REQUEST interface    to give more information to the user Added back WGI_CONNECTOR to WGI specification, mainly because of `{WGI_REQUEST}.wgi_connector'    simplified WGI_CONNECTOR to contain for now only `name' and `version'    if the implementation of connector inherit from WGI_CONNECTOR (recommended)    this might gives more access to the user using a reverse assignment for specific needs    (but this usage is not recommended due to portability issue on other connector) Removed useless connector.ecf since now EWF/WGI library provides the helper classes

## Day - 2011-11-23  Jocelyn Fiat  <github@djoce.net>

	Fixed sample example config file after recent location change for "rest" lib

	Improved run_CI_tests.py and include the compile_all call directly in the python script. If compile_all tool supports  -keep ... let's use it. (recent addition)

	fixed rest(-safe).ecf due to recent location change

	Merge branch 'master' of github.com:Eiffel-World/Eiffel-Web-Framework

	Updated README.md in relation with "rest" lib relocation

	Move "rest" library under "draft/..." since it is more an experiment rather than a real REST library

## Day - 2011-11-21  Jocelyn Fiat  <github@djoce.net>

	Update draft/README.md

	updated Eiffel libfcgi README file

	Merge branch 'master' of github.com:jocelyn/Eiffel-Web-Framework
	Conflicts:
		library/server/libfcgi/Clib/README.md

	Added scripts to help building the libfcgi.dll and .lib from modified source of libfcgi Extracted into "libfcgi" only the files needed to compile the Windows .dll and .lib

	Added scripts to help building the libfcgi.dll and .lib from modified source of libfcgi

	updated README to apply 'ext' renamed as 'contrib'

## Day - 2011-11-18  Jocelyn Fiat  <github@djoce.net>

	fixed compilation for tests.ecf

	fixed typo

	Updated "draft" folder which contain potential future addition to EWF

	Added "draft" folder to contain potential future addition to EWF

	restructured CONNEG library fixed various issue in .ecf files

## Day - 2011-11-18  jvelilla  <javier.hector@gmail.com>

	Initial import CONNEG library, support server side content negotiation.

## Day - 2011-11-17  Jocelyn Fiat  <github@djoce.net>

	Rename "ext" as "contrib" in compile_all.ini as well no need to test the code coming from other projects.

	Renamed "ext" folder as "contrib" folder and reorganized a little bit Renamed any *_APPLICATION as *_SERVICE    mainly because those components    such as WSF_APPLICATION, renamed as WSF_SERVICE    are not always the main application entry, and "service" describe them better Minor implementation change in WSF_REQUEST Cosmetics

## Day - 2011-11-16  Jocelyn Fiat  <github@djoce.net>

	handle last run failure

	Added request method PATCH even if not really used for now, it might in the future

	Do not print command during script execution

	fixed indentation in python script

	Added information output to run_CI_tests.py

	updated run_CI_tests.py

	updated run_CI_tests.py

	updated run_CI_tests.py

	updated run_CI_tests.py

	removed unused local variables

	added a python script to be use inside jenkins CI server (experimental for now)

## Day - 2011-11-14  Jocelyn Fiat  <github@djoce.net>

	cosmetic

	cosmetics

	Added various README.md  (using the markdown syntax)

	updated README with links to sub READM.md

	sync with Eiffel Web Nino

	Added default WSF_APPLICATION for libfcgi connector

	code removal

	Updated libfcgi source code for Windows AND Linux. Cleaning some code and feature clauses.

	Changed the WGI_INPUT_STREAM and WGI_OUTPUT_STREAM interfaces main changes for existing code  `read_stream' is renamed `read_string'

## Day - 2011-11-09  Jocelyn Fiat  <github@djoce.net>

	Added is_request_method (STRING): BOOLEAN to help users

## Day - 2011-11-07  Jocelyn Fiat  <github@djoce.net>

	updated readme with better way to get the source code recursively

## Day - 2011-11-07  Jocelyn Fiat  <jfiat@eiffel.com>

	added script to build archive for download area

## Day - 2011-11-04  Jocelyn Fiat  <github@djoce.net>

	sync with Eiffel Web Nino

	sync with nino and applied changes to connector

	Use recent changes from Nino, to get access to the launched and port information. Quite useful when launching using port=0 to use a random free port. This is great for testing, this way we can run many tests in the same time without any port blocking.

## Day - 2011-11-03  Jocelyn Fiat  <github@djoce.net>

	applied recent changes from Nino

## Day - 2011-11-02  Jocelyn Fiat  <github@djoce.net>

	removed compliance on ewsgi, since now we target WSF applied recent changes related to WSF_VALUE

	Safer interface for WSF_VALUE, when related to STRING value

	sync with submodules

	Merge branch 'master' of git://github.com/Eiffel-World/Eiffel-Web-Framework

	renamed WSF_(.*)_VALUE as WSF_$1

## Day - 2011-10-31  Jocelyn Fiat  <jfiat@eiffel.com>

	Fixed obsolete calls, and compilation error.

	fixed path to cURL.ecf file, using the correct uppercase

	Fixed missing syntax="provisional" , this was preventing compiling with "across" statements

	Better implementation to get http header for http_client, and to get list of header entries by key,value

	Merge branch 'master' of https://github.com/jvelilla/Eiffel-Web-Framework

	updated instructions related to submodules

	Fixed remaining 6.8 vs 7.0 compilation issue related to UTF8_(URL_)ENCODER

	Merge branch 'master' of github.com:Eiffel-World/Eiffel-Web-Framework

	removed unused local variable

## Day - 2011-10-31  Jocelyn Fiat  <github@djoce.net>

	Added convenient features to BASE64    - decode_string_to_buffer (v: STRING; a_buffer: STRING)    - decode_string_to_output_medium (v: STRING; a_output: IO_MEDIUM)

## Day - 2011-10-31  Jocelyn Fiat  <jfiat@eiffel.com>

	removed unused local variable

	Fixed code to be compilable with EiffelStudio 6.8 and 7.0 (due to recent change in UNICODE_CONVERSION) UNICODE_CONVERSION

## Day - 2011-10-28  jvelilla  <javier.hector@gmail.com>

	Added headers to response in HTTP_CLIENT_RESPONSE

## Day - 2011-10-27  Jocelyn Fiat  <jfiat@eiffel.com>

	Merge branch 'master' of github.com:Eiffel-World/Eiffel-Web-Framework

	use '%/123/' syntax, to make sure no editor replace the accentued characters

## Day - 2011-10-27  Jocelyn Fiat  <github@djoce.net>

	removed unwanted .rc

## Day - 2011-10-27  Jocelyn Fiat  <jfiat@eiffel.com>

	Fixed a previously character changes in WSF_REQUEST (related to safe_filename), and modified the implementation to use inspect Fixed the request_content_type computation Cosmetic in REQUEST_RESOURCE_HANDLER_HELPER

	Merge branch 'master' of https://github.com/jvelilla/Eiffel-Web-Framework
	Conflicts:
		library/server/wsf/src/wsf_request.e

	added script to update current git working copy and submodules recursively

	Merge branch 'master' of github.com:jocelyn/Eiffel-Web-Framework

## Day - 2011-10-27  Jocelyn Fiat  <github@djoce.net>

	cosmetic, or minor changes

## Day - 2011-10-27  Jocelyn Fiat  <jfiat@eiffel.com>

	Merge branch 'master' of github.com:Eiffel-World/Eiffel-Web-Framework

## Day - 2011-10-27  jvelilla  <javier.hector@gmail.com>

	Added eel and eapml in EWF libraries. Removed them from gitmodule

## Day - 2011-10-26  jvelilla  <javier.hector@gmail.com>

	Updated  request resource handler. TODO: implement Content-Negotiation

## Day - 2011-10-24  Jocelyn Fiat  <github@djoce.net>

	Start index for list[]=a&list[]=b ... from 1  instead of 0 Stick to Eiffel spirit

	Added visitor patterns to WSF_VALUE Handling UTF-8 unencoding for WSF_VALUE ... Added WSF_TABLE_VALUE to handle list[]=a&list[]=b ...
	Library encoder: added UTF8 facilities

	missing implementation (forgot to uncomment)

## Day - 2011-10-24  jvelilla  <javier.hector@gmail.com>

	Merge remote-tracking branch 'jocelynEWF/master'
	Conflicts:
		examples/restbucks/restbucks-safe.ecf
		examples/restbucks/src/resource/order_handler.e
		library/server/request/router/src/misc/request_resource_handler_helper.e

## Day - 2011-10-23  jvelilla  <javier.hector@gmail.com>

	Added eel and eapml modules

	Update delete method to hanlde method not allowed. Added method not allowed to request resource handler helper class. Update gitmodules

## Day - 2011-10-21  Jocelyn Fiat  <github@djoce.net>

	Applied recent changes on WGI_ and WSF_ Moved classes away from ewsgi, restructured, cleaned

	Continued reducing WGI and move implementation to WSF  (Web Server Framework) Removed many usage of READABLE_STRING_GENERAL in favor to READABLE_STRING_8    to avoid potential nasty issues in user's code URI-template is working only with STRING_8, then changed any _GENERAL or _STRING_32 to _STRING_8

	First try to get a limited WGI_  and use WSF_ as default framework

## Day - 2011-10-21  jvelilla  <javier.hector@gmail.com>

	Update Restbucks example: Conditional GET, PUT. Added a response method to support resource not modified. Added a ETAG_UTILS class to calcule md5_digest. Added ext libs eel and eapml.

## Day - 2011-10-19  Jocelyn Fiat  <github@djoce.net>

	Used object test

	removed useless local variable

## Day - 2011-10-14  Jocelyn Fiat  <github@djoce.net>

	fixed cgi and libfcgi connectors due to recent changes from WGI_APPLICATION

	Removed handling of internal error from WGI_APPLICATION And for now added it into nino connector

	Fixed issue with index in uri template matcher

	Added HTTP_FILE_EXTENSION_MIME_MAPPING Added REQUEST_FILE_SYSTEM_HANDLER to the router library Added file system handler in "hello_routed_world" example

## Day - 2011-10-13  jvelilla  <javier.hector@gmail.com>

	Added handle_resource_conflict_response feature to handle 409 reponse, Cosmetic.

## Day - 2011-10-12  Jocelyn Fiat  <jfiat@eiffel.com>

	Added data and file for post and put request methods

## Day - 2011-10-12  Jocelyn Fiat  <github@djoce.net>

	Using Transfer-Encoding: chunked in example to send response progressively

	sync with submodules

	removed unwanted code

	applied recent changes on HTTP_REQUEST_METHOD_CONSTANTS

## Day - 2011-10-12  Jocelyn Fiat  <jfiat@eiffel.com>

	cosmetic

	Addition to "http" library, separated constants into  - HTTP_MIME_TYPES  - HTTP_HEADER_NAMES  - HTTP_REQUEST_METHODS  - HTTP_STATUS_CODE   (already exists)
	Do not set the "Status" header when using WGI_RESPONSE_BUFFER.write_header (...)
	Cosmetic

## Day - 2011-10-11  Jocelyn Fiat  <jfiat@eiffel.com>

	Merge branch 'master' of https://github.com/jvelilla/Eiffel-Web-Framework Conflicts:	examples/restbucks/src/domain/json_order_converter.e Cosmetics

	Fixed errors recently introduced

	Merge branch 'master' of github.com:Eiffel-World/Eiffel-Web-Framework

	sync with latest JSON

## Day - 2011-10-11  jvelilla  <javier.hector@gmail.com>

	Update order_handler, fix json_order_converter

## Day - 2011-10-11  Jocelyn Fiat  <github@djoce.net>

	Use local curl if compiler is < 7.0.8.7340 otherwise, use ISE_LIBRARY cURL

	Temporary fixed issue of using modified cURL (which is cURL provided with EiffelStudio 7.0) This changes will be reverted in the future

## Day - 2011-10-10  Jocelyn Fiat  <github@djoce.net>

	Updated readme related to mirrored Eiffel cURL library

## Day - 2011-10-10  Jocelyn Fiat  <jfiat@eiffel.com>

	added submodule ext/ise_library/curl  to use the updated Eiffel cURL from ISE.

## Day - 2011-10-10  Jocelyn Fiat  <github@djoce.net>

	cosmetic

## Day - 2011-10-07  Jocelyn Fiat  <jfiat@eiffel.com>

	added http diagrams found on the web

	Added the possibility to specify the supported content types Added FIXME

	Cosmetic

	Added "Date:" helper feature in EWF_HEADER Added license.lic to restbuck example, and mainly copyright to Javier Use HTTP_STATUS_CODES Minor improvements using object tests Cosmetic (indentation, ..)

## Day - 2011-10-06  Jocelyn Fiat  <jfiat@eiffel.com>

	Added a first simple test client to test the restbuck client

	added support for data in POST request

	Merge branch 'master' of https://github.com/jvelilla/Eiffel-Web-Framework

## Day - 2011-10-06  jvelilla  <javier.hector@gmail.com>

	Added REQUEST_RESOURCE_HANDLER_HELPER class to contain common http method behavior. Updated ORDER_HANLDER to use this new class.

## Day - 2011-10-05  Jocelyn Fiat  <github@djoce.net>

	Added `base_url' for REQUEST_ROUTER  (and descendants) Fixed implementation of REST_REQUEST_AGENT_HANDLER to avoid wrong path in inherited routine. Allow to build a URI_TEMPLATE from another URI TEMPLATE,    this way, if later we have more attribute (status or settings) to URI_TEMPLATE,    we'll be able to change the `template' without breaking the settings

	added missing call to pre_execute and post_execute

	Fixed missing http:// in absolute URL

	remove pre_execute, and post_execute, and make process_request frozen this way, the user won't be tempted to redefine feature not being part of pure EWSGI interface.

	better argument name, to precise the timeout is in second also in comment.

## Day - 2011-10-04  Jocelyn Fiat  <github@djoce.net>

	Fixed agent handler for rest library

	Merge branch 'master' of github.com:jocelyn/Eiffel-Web-Framework

	fixed inheritance and precursor bad usage.

## Day - 2011-10-04  Jocelyn Fiat  <jfiat@eiffel.com>

	Merge branch 'master' of github.com:jocelyn/Eiffel-Web-Framework

	Merge branch 'master' of https://github.com/jvelilla/Eiffel-Web-Framework

## Day - 2011-10-03  jvelilla  <javier.hector@gmail.com>

	Updated support for PUT. Now the example support GET, POST, PUT, DELETE.

## Day - 2011-09-28  Jocelyn Fiat  <github@djoce.net>

	fixed compilation for ewsgi/tests/tests.ecf file

	Made WGI_VALUE.name as READABLE_STRING_32 .. otherwise it is a pain to manipulate. Changed return type of meta_variable to be WGI_STRING_VALUE ... since the meta variable can not be anything else. Made sure REQUEST_URI starts with one and only one slash Internal implementation: the _table now compares object Removed SELF variable ... at least for now Be sure to provide a REQUEST_URI even if the underlying connector does not.

	cleaned http_client configuration files

	Added library/library.index

	restructured ewsgi to avoid too many sub cluster

## Day - 2011-09-28  jvelilla  <javier.hector@gmail.com>

	Updated Restbucks examples, handle not method allowed in a better way, added the readme file.

	Merge remote-tracking branch 'jocelynEWF/master'

## Day - 2011-09-26  Jocelyn Fiat  <github@djoce.net>

	fixed compilation of rest example

	fixed typo

	Changed ITERATION_CURSOR [WGI_VALUE] into ITERABLE [WGI_VALUE] for WGI_REQUEST.*parameters* and similar Applied recent changes on EWF_HEADER

## Day - 2011-09-23  Jocelyn Fiat  <jfiat@eiffel.com>

	Updated changelogs.txt sync with nino and doc

## Day - 2011-09-23  Jocelyn Fiat  <github@djoce.net>

	Merge branch 'master' of github.com:jocelyn/Eiffel-Web-Framework

	Added AutoTest simple cases for ewsgi using Nino web server

	Fixing issue with experimental WGI_MULTIPLE_STRING_VALUE Fixed issue with RAW_POST_DATA

	Removed `put_redirection' and replaced by `put_location' Removed useless code in some features

	Use READABLE_STRING(_*) instead of just STRING(_*)

	Added feature to shutdown the Nino http server

	Added error reporting in HTTP_CLIENT_RESPONSE Added missing set_connect_timeout

## Day - 2011-09-23  jvelilla  <javier.hector@gmail.com>

	Added validations.

## Day - 2011-09-22  Jocelyn Fiat  <jfiat@eiffel.com>

	Merge branch 'master' of https://github.com/jvelilla/Eiffel-Web-Framework

## Day - 2011-09-22  Jocelyn Fiat  <github@djoce.net>

	Added code to create an HTTP_AUTHORIZATION from the client side as well. So now we can either interpret an HTTP_AUTHORIZATION  or build one HTTP_AUTHORIZATION
	So far , only Basic auth is supported.

	Made all libraries compilable in any mode (voidsafe or not) Fixed related examples

## Day - 2011-09-22  jvelilla  <javier.hector@gmail.com>

	Initial import, work in progress restbuck example. Only support create a resource

	Merge remote-tracking branch 'jocelynEWF/master'

## Day - 2011-09-21  Jocelyn Fiat  <github@djoce.net>

	Fixed issue where Content-Type and Content-Length were translated into HTTP_CONTENT_TYPE and HTTP_CONTENT_LENGTH instead of just   CONTENT_TYPE and CONTENT_LENGTH

	better assertion to ensure `base' is a valid base url

	synch with Nino

	better return type for http client functions added helper features

## Day - 2011-09-21  jvelilla  <javier.hector@gmail.com>

	Merge remote-tracking branch 'jocelynEWF/master'

## Day - 2011-09-20  Jocelyn Fiat  <github@djoce.net>

	fixed case sensitive path

	missing -safe.ecf config file for http_client

	Now using READABLE_STRING_... type

	Added simple HTTP client. For now the implementation is using Eiffel cURL library. It requires Eiffel cURL coming with next EiffelStudio 7.0 (or from eiffelstudio's repo from rev#87244 )

## Day - 2011-09-16  Jocelyn Fiat  <github@djoce.net>

	Fixed issues in WGI_REQUEST's invariant Fixed issues with guessing the default format for REST handling Fixed issue with .._ROUTING_.. component.

	Fixed issue with uri template router .. it was applying on request_uri instead of path_info now it match on PATH_INFO

	more flexible authenticated query .. on handler, and not anymore on context object

	fixed wrong order in parameter for callers of set_meta_string_variable

	added debug_output to WGI_VALUE

	first version of http authorization .. for now, only basic digest

	added request_handler_routes_recorder to provide an implementation for `REQUEST_HANDLER.on_handler_mapped'

	Added "on_handler_mapped" callback to allow any REQUEST_HANDLER to record the existing routes.

	typo

## Day - 2011-09-16  jvelilla  <javier.hector@gmail.com>

	Merge remote-tracking branch 'jocelynEWF/master'

## Day - 2011-09-15  Jocelyn Fiat  <github@djoce.net>

	minor enhancement of error lib

	Added WGI_MULTIPLE_STRING_VALUE Renamed value as WGI_STRING_VALUE.string Renamed a few classes .._CONTEXT_I  as .._CONTEXT updated example.

	cosmetic

	Merge branch 'master' of git://github.com/Eiffel-World/Eiffel-Web-Framework

## Day - 2011-09-15  Jocelyn Fiat  <jfiat@eiffel.com>

	updated README.md

## Day - 2011-09-14  Jocelyn Fiat  <github@djoce.net>

	Simplified interface of "router" library classes

	applied renaming for rest and router lib

	Reorganized library "server/request/rest"

	some renaming to use _I for the generic classes, and removed the DEFAULT_ prefix for default implementation this should makes things easier for new users

	reorganized router library

	- Adopted deferred WGI_VALUE design for Result type of *_parameter and similar functions - Adopted the ITERATION_CURSOR [WGI_VALUE] design for *_parameters and similar functions - renamed parameter as item - provided helper function to handle "string" value parameters
	Experimental for now.

	better result type  (using READABLE_..)

	sync with nino

## Day - 2011-09-14  jvelilla  <javier.hector@gmail.com>

	Merge remote-tracking branch 'jocelynEWF/master'

## Day - 2011-09-13  Jocelyn Fiat  <jfiat@eiffel.com>

	updated changelogs

## Day - 2011-09-13  Jocelyn Fiat  <github@djoce.net>

	Added first draft for RESTful library note: the interfaces are likely to change in the future

	updated config file and examples

	adding routing handler few renaming

## Day - 2011-09-09  Jocelyn Fiat  <github@djoce.net>

	changing design to use generic instead of anchor types

	make router more easy to inherit from and specialized

	Merge branch 'master' of github.com:jocelyn/Eiffel-Web-Framework

	Added support during match for  {/vars} and also handle cases such as   /foo.{format}{/vars}  or /foo.{format}{?vars} where no literal exists between the uri template expressions

	better type for argument and result (using READABLE_...)

	change to standard default values

## Day - 2011-09-08  jvelilla  <javier.hector@gmail.com>

	Sync to jocelyn EWF master

	Merge remote-tracking branch 'jocelynEWF/master'

	Update

## Day - 2011-09-07  Jocelyn Fiat  <jfiat@eiffel.com>

	sync doc/wiki

	use `resource' as generic name for uri or uri_template

	added changelogs.txt

	Added request methods criteria for the router component. Now one can decide
	map_agent_with_request_methods ("/foo/bar/{bar_id}", agent handle_foo_bar, <<"GET">>)
	(and similar for non agent way)
	This might be useful in pure RESTful environment.

	fixed example .. where we forgot to set the status, and send the header (DbC helped here)

	renamed (un)set_meta_parameter as (un)set_meta_variable

	Missing HTTP_  prefix for header meta variable in REQUEST

## Day - 2011-08-30  Jocelyn Fiat  <jfiat@eiffel.com>

	Changed prefix from EWSGI_ to WGI_ Changed meta variable type to READABLE_STRING_32

## Day - 2011-08-29  Jocelyn Fiat  <jfiat@eiffel.com>

	naming:  meta_variable(s) changed some string type to READABLE_STRING_32 or READABLE_STRING_8 for now regarding Meta variables (need decision here..)

## Day - 2011-08-25  Jocelyn Fiat  <jfiat@eiffel.com>

	changed prefix GW_ into EWF_  for EiffelWebFramework use READABLE_STRING_GENERAL instead of just STRING

	sync wiki doc

	Merge branch 'master' of github.com:jocelyn/Eiffel-Web-Framework
	Conflicts:
		library/server/ewsgi/connectors/nino/src/gw_nino_connector.e
		library/server/ewsgi/ewsgi-safe.ecf

	Merged REQUEST and ENVIRONMENT  into REQUEST renamed ENVIRONMENT_NAMES into META_NAMES better usage of READABLE_STRING_GENERAL, and other strings abstract RESPONSE_BUFFER in implementation of EWSGI for the implementation, inheriting from deferred specification (more to come later)

	Merged REQUEST and ENVIRONMENT  into REQUEST renamed ENVIRONMENT_NAMES into META_NAMES better usage of READABLE_STRING_GENERAL, and other strings for the implementation, inheriting from deferred specification (more to come later)

## Day - 2011-08-24  Jocelyn Fiat  <jfiat@eiffel.com>

	fixing wrong feature usage

## Day - 2011-08-18  Jocelyn Fiat  <jfiat@eiffel.com>

	code cleaning, and prepare for internal review

## Day - 2011-08-04  Jocelyn Fiat  <jfiat@eiffel.com>

	enhanced the ERROR_HANDLER

## Day - 2011-08-02  Jocelyn Fiat  <jfiat@eiffel.com>

	minor improvements on response_as_result code

	cosmetic in config file .ecf

	add "write_headers_string" to RESPONSE_BUFFER

## Day - 2011-08-01  Jocelyn Fiat  <jfiat@eiffel.com>

	sync wiki

	moved ewsgi-full config file under tests (this is mainly for dev purpose, to be able to compile and edit all classes related to ewsgi)

	Tried to reduce gap between both EWSGI proposals Re-adapt the Spec-compliant solution (instead of Lib-compliant solution).   Thus no more 100% deferred interface. Rename EWSGI_RESPONSE into EWSGI_RESPONSE_BUFFER Added in extra/response-as-result/  an copy/paste from the implementation of Paul's proposal (not up to date with Paul's spec). But this is mainly for information and tests. Removed part of the ewsgi/specification interfaces ... to be able to test EWSGI compliant library against the pure specification (experimental). Renamed most of the GW_... into EWSGI_...

## Day - 2011-07-29  Jocelyn Fiat  <jfiat@eiffel.com>

	added http_accept feature to represent "Accept:" HTTP header

	added hello_routed_world example few changes on new `router' library (still in-progress)

	Added first draft for a URI and/or URI-template base request router.

	cosmetic

	Added "flush" to the EWSGI_RESPONSE_STREAM

	Merge branch 'master' of github.com:jocelyn/Eiffel-Web-Framework

	added missing non-void-safe .ecf

	added missing non-void-safe .ecf

## Day - 2011-07-28  Jocelyn Fiat  <jfiat@eiffel.com>

	Fixed various issue with URI template, added corresponding tests

	It seems good convention to also add the "Status:" header

	fix hello world example

	ignore tests/temp

## Day - 2011-07-27  Jocelyn Fiat  <jfiat@eiffel.com>

	added script to test compilations of .ecf in EWF

	Added the possibility to set the "Status" header (different from the status line) in GW_HEADER Renamed EWSGI_RESPONSE as EWSGI_RESPONSE_STREAM to avoid confusion with EWSGI_RESPONSE as stated in Paul's proposal Added default "configuration" (for nino and cgi) to be independant of the connector (at compilation time) Added example implementing Paul's proposal on top of EWSGI

	Added an implementation folder in ewsgi_spec, mainly to provide default implementation just to save the developer of connector some time. changed structured

	added non void-safe configuration files

	restructured specification folders

	Apply prefix renaming from the specification Reduced the number of EWSGI classes

	now use prefix EWSGI_ instead of GW_ for ewsgi specification

	First step to extract the interface of the EWSGI specification into its own library Applied the changes

	removed implementation from APPLICATION , RESPONSE and REQUEST classes

	removed the notion of status from GW_HEADER, since it should not be part of the HTTP header added status setting in GW_RESPONSE added a default implementation for write_status in OUTPUT_STREAM   (it should be moved away in the future) removed any implementation from GW_REQUEST, and put it in GW_REQUEST_IMP

## Day - 2011-07-26  Jocelyn Fiat  <jfiat@eiffel.com>

	replace write_string by write in RESPONSE

	various alternative implementation for response

## Day - 2011-07-25  Jocelyn Fiat  <jfiat@eiffel.com>

	Redesigned the RESPONSE to remove the output stream from the deferred interface Redesigned the uploaded file part to be more object oriented Move some implementation from REQUEST to REQUEST_IMP

	added doc/spec for uri template

## Day - 2011-07-22  Jocelyn Fiat  <jfiat@eiffel.com>

	Fixed issue with matcher

	fixed typo

	Improvement and revert back to support draft 04 (but using custom variable, allow the user to follow draft 05 spec)

	fixing issue with URI TEMPLATE matcher

	Merge branch 'master' of github.com:jocelyn/Eiffel-Web-Framework

	added URI_TEMPLATE_MATCH_RESULT

## Day - 2011-07-21  Jocelyn Fiat  <github@djoce.net>

	sync

	updated README

	updated README

## Day - 2011-07-20  Jocelyn Fiat  <jfiat@eiffel.com>

	added use of URL-encoder to unencode the URL values (to fill the parameters) review design of GW_RESPONSE to hide the output, and remove the header attribute added script_url in REQUEST to help the user build url relative to script_name
	+ cosmetic

	First version of URI Template library as specified by http://tools.ietf.org/html/draft-gregorio-uritemplate-05 (it seems to contains some error in the spec .. or minor incoherences, to double check) The matcher is basic, it does not handle all the details of the string builder, but that seems ok for now.

## Day - 2011-07-18  Jocelyn Fiat  <jfiat@eiffel.com>

	added format and request method constants classes + license file

	added default rescue code on exception rescue

	nicer Eiffel code, let's not try to achieve everything-in-one-line style ...

	restrict creation only by GW_APPLICATION and descendant

	add output helper feature to RESPONSE

	Fixed issue with nino handler and base url

	sync nino and json

## Day - 2011-07-14  Jocelyn Fiat  <jfiat@eiffel.com>

	rename new_request_context by new_request

## Day - 2011-07-13  Jocelyn Fiat  <jfiat@eiffel.com>

	cosmetic

	renamed GW_REQUEST_CONTEXT as GW_REQUEST

	Design change, now we have `req' REQUEST and `res' RESPONSE instead of just `ctx'

	enhanced comment for `execute'

	Make a simple hello world based on nino

## Day - 2011-07-12  Jocelyn Fiat  <jfiat@eiffel.com>

	Added GW_HEADER Added pre_, post_ and rescue_execute for GW_APPLICATION Fixed an unknown class in export clause cosmetic + copyright

## Day - 2011-07-12  Jocelyn Fiat  <github@djoce.net>

	fixed submodule path ... Windows path separator issue..

## Day - 2011-07-12  Jocelyn Fiat  <jfiat@eiffel.com>

	added instruction to get the source code

	First integration of the new GW_ design more centralized on connector, and does not require specific feature on GW_APPLICATION depending on the connector. So this is really more flexible this way, and much easier to write application supporting CGI, FCGI, Nino and so on .. as demonstrated in hello_world
	This is a first version, more will come later, mainly migrating from Eiffel Web Reloaded to this Eiffel Web Framework project.

## Day - 2011-07-08  Jocelyn Fiat  <jfiat@eiffel.com>

	focus on GW_APPLICATION

## Day - 2011-07-07  Jocelyn Fiat  <jfiat@eiffel.com>

	a few renaming better GW_ENVIRONMENT interface

## Day - 2011-07-06  Jocelyn Fiat  <jfiat@eiffel.com>

	updated doc

## Day - 2011-07-05  Jocelyn Fiat  <jfiat@eiffel.com>

	cosmetic, license, copyright

	added doc/wiki (wiki from github)

	First draft for the ewsgi spec

## Day - 2011-06-29  Jocelyn  <github.pub@djoce.net>

	Let's start the Eiffel Web Framework
