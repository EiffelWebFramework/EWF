## Participants

* Jocelyn Fiat
* Berend de Boer
* Olivier Ligot
* Javier Velilla
* Emmanuel Stapf

## Information

### When ?
* Tuesday 18th of september, 19:00 - 20:00 UTC/GMT time (see 3rd time in http://www.doodle.com/8v2sekiyebp4dpyh)

### Where ?
Web meeting using webex

* Short url: http://goo.gl/wBz11
* Long url: https://eiffel.webex.com/eiffel/j.php?ED=211265702&UID=0&PW=NZWNiMjBiZWIz&RT=MiMyMA%3D%3D 
* Related Google group topic: https://groups.google.com/d/topic/eiffel-web-framework/A7ADPAT3nj8/discussion

## Agenda

* Current status of EWF
 * Focus on new design for the router system, and take decision
   * decide if this replace the previous system, 
   * or if this is provided as another solution (we would then have 2 routers system).
   * It might be possible to implement the previous uri and uri-template router with the new design, and mark them obsolete, this would avoid breaking existing code, but if no-one ask for it, no need to spend time doing it.
 * Current activities
   * Technology forecasting about REST, Hypermedia API, Collection/JSON, HAL, ...
   * Building a CMS framework inspired by Drupal, and using EWF
   * Libraries in-progress or draft: OAuth (consumer), Google API, Github API, Template engine, Wikitext parser, CMS (including sub libraries which will be part of EWF, such as session handling, mailer, ...)
   * Documentation
 * Remaining issues
   * Review design in relation to concurrency, and provide example demonstrating concurrency with EWF
   * Review design to allow easier extension/customization of EWF, such as using its own MIME handlers.
 * Demo for a CMS built with EWF (inspired by Drupal)
* Future tasks
 * [graphviz-server](https://github.com/EiffelWebFramework/graphviz-server)
 * Improving Eiffel Web Nino: to support persistent connection, and better concurrency design.
 * Provide friendly components to generate HTML (DHTML, HTML5, ...), (coders do not want to learn HTML and CSS)
* Users feedback, suggestions and requests
 * ...
* Next meeting

## Materials

## Minutes