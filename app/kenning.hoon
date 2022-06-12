/-  kenning, webpage
/+  server, verb, default-agent, dbug, rudder, kon
::
/~  pages  (page:rudder kennings:kenning action:kenning)  /app/kenning/webui
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
  :_  this
  :~  [%pass /eyre/connect %arvo %e %connect [~ /[dap.bowl]] dap.bowl]
  ==
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
    =^  cards  state
    (handle-action:main !<(action:kenning vase))
    [cards this]
    ::
      %handle-http-request
    =;  out=(quip card:agent:gall _texts.state)
      [-.out this(texts.state +.out)]
    %.
      :+  bowl
        !<(order:rudder vase)
      texts.state
    %:  (steer:rudder _texts.state action:kenning)
      pages
      :: a destructured path w a :site path and a file :ext (optional)
      |=  =trail:rudder  
      ^-  (unit place:rudder)  :: $place is either a %page or a redirect %away
      :: remove '/kenning' from the url
      ?~  site=(decap:rudder /kenning site.trail)  ~  
      ?+  u.site  ~
      ::route        `[?(%page %away) auth? %page-name]
        ~            `[%page & %index]  :: no trail - index
        [%index ~]   `[%away (snip site.trail)]  :: redirect to /
        [@ ~]        `[%page & %ken]
        [@ %edit ~]  `[%page & %edit]
      ==
    ::
      |=  =order:rudder  ::  the "Fallback Function" (takes the full httpreq)
      ^-  [[(unit reply:rudder) (list card:agent:gall)] _texts.state]
      =;  msg=@t  [[`[%code 404 msg] ~] texts.state]
      %+  rap  3
      :~  'couldn\'t find that page, sorry'
      ==
    ::
      |=  act=action:kenning
      ^-  $@(@t [brief:rudder (list card:agent:gall) _texts.state])
      ``texts:(handle-action:main act)
    ==
  ==
::
++  on-arvo
  |=  [=wire =sign-arvo]
  ^-  (quip card _this)
  ?+  sign-arvo  (on-arvo:default wire sign-arvo)
      [%eyre %bound *]
    ~?  !accepted.sign-arvo
      [dap.bowl 'eyre bind rejected!' binding.sign-arvo]
    [~ this]
  ==
::
++  on-watch
  |=  =path
  ^-  (quip card _this)
  ?>  =(our.bowl src.bowl)
  ?+  path  (on-watch:default path)
    [%http-response *]  [~ this]
  ==
::
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
      :: get text by id
      ::
      %get
    :_  state
    ~[[%give %fact ~[/texts] [%atom !>(texts.state)]]]
      :: see all texts
      ::
      %browse
      ~&  texts.state
    :_  state
    ~[[%give %fact ~[/texts] [%atom !>(texts.state)]]]
      :: delete
      ::
      %del
    =.  texts.state  (oust [id.action 1] texts.state)
    :_  state
    ~[[%give %fact ~[/texts] [%atom !>(texts.state)]]]
      :: edit
      ::
      %mod
    =.  texts.state  (snap texts.state id.ken.action ken.action)
    :_  state
    ~[[%give %fact ~[/texts] [%atom !>(texts.state)]]]
      :: check your memorized text against the real one 
      ::
      %test
    =/  canon  (snag id.action texts.state)
    =/  answer  (nospline:kon (nopun:kon (cass (tap:kon text.canon))))
    =/  submis  (nospline:kon (nopun:kon (cass (tap:kon assay.action))))
    ?:  .=  answer  submis
      :: on pass, dec kelvin if poss
      ?:  =(kelvin.canon 0) 
        :: if already 0, do nothing
        :_  state
        ~[[%give %fact ~[/texts] [%atom !>(texts.state)]]]
      :: set state to have lower kelvin for our text
      =.  kelvin.canon  (dec kelvin.canon) 
      (handle-action [%mod ken=canon])
    :: on fail, succ kelvin if poss
    =.  kelvin.canon  
      (min (succ kelvin.canon) (lent (nospline:kon (tap:kon text.canon))))
    (handle-action [%mod ken=canon])
      :: add a text to the library
      ::
      %add
    =/  text  text.action
    =/  splat  (nospline:kon text)
    =/  kelvin  (lent splat)
    =/  id  (lent texts.state)
    =/  kan  [%ken id=id text=(kap:kon text) kelvin=kelvin]
    ?~  (lent texts.state)
      =.  texts.state  (weld texts.state ~[kan])
      :_  state
      ~[[%give %fact ~[/texts] [%atom !>(texts.state)]]]
    ?:  %-  lien  :: don't add dupes
          :-  texts.state
          |=  kon=[@tas id=@ud text=kext:kenning kelvin=@ud]
          =(text.kan text.kon)
      :_  state
      ~[[%give %fact ~[/texts] [%atom !>(texts.state)]]]
    =.  texts.state  (weld texts.state ~[kan])
    :_  state
    ~[[%give %fact ~[/texts] [%atom !>(texts.state)]]]
  ==
--