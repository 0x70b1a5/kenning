/-  kenning, webpage
/+  server, verb, default-agent, dbug
::
/~  webui  (webpage ~ (unit mime))  /app/kenning/webui
::
|%
+$  versioned-state
  $%  state-0
  ==
::
+$  state-0
  $:  [%0 texts=(list ken:kenning)]
  ==
::
+$  card  card:agent:gall
--
::
+$  eyre-id  @ta
--
::
=|  state-0
=*  state  -
::
%-  agent:dbug
%+  verb  |
^-  agent:gall
::
=<
|_  =bowl:gall
+*  this      .
    default   ~(. (default-agent this %|) bowl)
    main      ~(. +> bowl)
::
++  on-init
  ^-  (quip card _this)
  ~&  >  '%kenning initialized successfully'
  =.  state  [%0 *(list ken:kenning)]
  `this
++  on-save   !>(state)
::
++  on-load
  |=  ole=vase
  ^-  (quip card _this)
  =/  old=state-0  !<(state-0 ole)
  [~ this(state old)]
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  ?+  mark  (on-poke:default mark vase)
      %noun
    ?+  q.vase  (on-poke:default mark vase)
        %print-state
      ~&  >>  state
      ~&  >>>  bowl  `this
    ==
    ::
      %kenning-action
    ~&  >  %kenning-action
    =^  cards  state
    (handle-action:main !<(action:kenning vase))
    [cards this]
    ::
      %handle-http-request
    =,  mimes:html
    =+  !<([=eyre-id =inbound-request:eyre] vase)
    ?.  authenticated.inbound-request
      :_  this
      ::TODO  probably put a function for this into /lib/server
      ::      we can't use +require-authorization because we also update state
      %+  give-simple-payload:app:server
        eyre-id
      =-  [[307 ['location' -]~] ~]
      %^  cat  3
        '/~/login?redirect='
      url.request.inbound-request
    ::  parse request url into path and query args
    ::
    =/  ,request-line:server
      (parse-request-line:server url.request.inbound-request)
    ::
    =;  [payload=simple-payload:http caz=(list card) =_state]
      :_  this(state state)
      %+  weld  caz
      %+  give-simple-payload:app:server
        eyre-id
      payload
    ::  405 to all unexpected requests
    ::
    ?.  &(?=(^ site) =('picture' i.site))
      [[[500 ~] `(as-octs 'unexpected route')] ~ state]
    ::
    =/  page=@ta
      ?~  t.site  %index
      i.t.site
    ?:  =(%image page)
      :_  [~ state]
      =;  placeholder
        ?~  picture
          [[200 ['content-type'^'image/svg+xml']~] `placeholder]
        :_  `q.u.picture
        :-  200
        :~  :-  'content-type'   (en-mite p.u.picture)
            :-  'cache-control'  'public, max-age=604800, immutable'
        ==
      ^~
      %-  as-octt
      %-  en-xml:html
      ^-  manx
      ;svg
        =viewport  "0 0 100 100"
        =height    "100"
        =width     "100"
        =version   "1.1"
        =xmlns     "http://www.w3.org/2000/svg"
        ;rect
          =fill    "#ddd"
          =width   "100"
          =height  "100";
        ;text
          =fill  "#777"
          =font-family  "sans-serif"
          =font-weight  "bold"
          =text-anchor  "middle"
          =x            "50%"
          =y            "50%"
          =dy           "0.2em"
          ;+  :/"1:1"
        ==
      ==
    ::
    =;  [[status=@ud out=(unit manx)] caz=(list card) =_state]
      :_  [caz state]
      ^-  simple-payload:http
      :-  :-  status
          ?~  out  ~
          ['content-type'^'text/html']~
      ?~  out  ~
      `(as-octt (en-xml:html u.out))
    ::TODO  mostly copied from pals, dedupe!
    ::
    ?.  (~(has by webui) page)
      [[404 `:/"no such page: {(trip page)}"] ~ state]
    =*  view  ~(. (~(got by webui) page) bowl ~)
    ::
    ::TODO  switch higher up: get never changes state!
    ?+  method.request.inbound-request  [[405 ~] ~ state]
        %'GET'
      :_  [~ state]
      [200 `(build:view args ~)]
    ::
        %'POST'
      ?~  body.request.inbound-request  [[400 `:/"no body!"] ~ state]
      =/  new=(unit (unit mime))
        (argue:view [header-list body]:request.inbound-request)
      ?~  new
        :_  [~ state]
        :-  400
        %-  some
        %+  build:view  args
        `|^'Something went wrong! Did you provide sane inputs?'
      :_  [~ state(picture u.new)]
      :-  200
      %-  some
      (build:view args `&^'Processed succesfully.')  ::NOTE  silent?
    
  ==
++  on-arvo   on-arvo:default
++  on-watch  on-watch:default
++  on-leave  on-leave:default
++  on-peek   on-peek:default
++  on-agent  on-agent:default
++  on-fail   on-fail:default
--
|_  =bowl:gall
++  handle-action
  |=  =action:kenning
  ^-  (quip card _state)
  ?-    -.action
    ::
      %add
    ~&  >>  'addarino'
    =/  kelvin  (lent (split text.action " "))
    =/  id  (lent texts.state)
    =.  texts.state  (weld texts.state ~[[%ken id=id text=text.action kelvin=kelvin]])
    :_  state
    ~[[%give %fact ~[/texts] [%atom !>(texts.state)]]]
    :: 
      %test
    ~&  >>  'testabunga'
    :_  state
    ~[[%give %fact ~[/texts] [%atom !>(texts.state)]]]
    ::
      %get
    ~&  >>  'gettonimo'
    :_  state
    ~[[%give %fact ~[/texts] [%atom !>(texts.state)]]]
    ::
      %browse
    ~&  >>  'browsario'
    ~&  >>>  state
    :_  state
    ~[[%give %fact ~[/texts] [%atom !>(texts.state)]]]
  ==
++  split  :: Split a cord recursively
  |=  [original=(list @t) splitter=(list @t))
  =/  final  `(list (list @t))`~
  |-
    =/  i  (find splitter original)
    ?~  i
      (snoc final original)
    =/  initial  (scag +.i original)
    =/  sequential  (slag +(+.i) original)
    ?~  initial
      $(original sequential)
    =.  final  (snoc final initial)
    $(original sequential)
--