/-  kenning, webpage
/+  server, verb, default-agent, dbug, rudder, kon
::
/~  pages  (page:rudder kennings:kenning action:kenning)  /app/kenning/webui
::
|%
+$  versioned-state
  $%  state-0
      state-1
      state-2
  ==
::
+$  state-0
  $:  [%0 texts=(list ken-0:kenning)]
  ==
+$  state-1
  $:  [%1 texts=(list ken-1:kenning)]
  ==
+$  state-2
  $:  [%2 texts=(list ken:kenning)]
  ==
::
+$  card  card:agent:gall
::
+$  eyre-id  @ta
--
::
=|  state-2
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
  =.  state  [%2 *(list ken:kenning)]
  :_  this
  :~  [%pass /eyre/connect %arvo %e %connect [~ /[dap.bowl]] dap.bowl]
  ==
++  on-save   !>(state)
::
++  on-load
  |=  ole=vase
  ^-  (quip card _this)
  =/  old  !<(versioned-state ole)
  ?-  -.old
    %0  [~ this(state [%1 (turn texts.old zero-to-one:kon)])]
    %1  [~ this(state [%2 (turn texts.old one-to-two:kon)])]
    %2  [~ this(state old)]
  ==
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
      ~&  (snag id.action texts.state)
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
    =/  canon   (snag id.action texts.state)
    =/  answer  (turn (kwords:kon text.canon) nopun:kon)
    =/  submis  (turn (kwords:kon assay.action) nopun:kon)
    =/  errors  (fault submis answer)
    ?~  (lent errors)
      :: on pass, dec kelvin if poss
      =.  errors.canon  `(list @ud)`~
      ?:  =(kelvin.canon 0) 
        :: if already 0, do nothing
        :: ~&  >  'kel not decrememnted'
        (handle-action [%mod ken=canon])
      :: set state to have lower kelvin for our text
      :: ~&  >  'kel decrememnted'
      =.  kelvin.canon  (dec kelvin.canon) 
      (handle-action [%mod ken=canon])
    :: on fail, succ kelvin if poss
    :: ~&  >  'kel incrememnted'
    =.  errors.canon  errors
    =.  kelvin.canon  
      (min (succ kelvin.canon) (word-kount:kon text.canon))
    (handle-action [%mod ken=canon])
      :: add a text to the library
      ::
      %add
    =/  text  text.action
    =/  kelvin  (word-count:kon text)
    =/  id  (lent texts.state)
    =/  title  ?~  (lent title.action)  id  title.action
    =/  kan  (newk:kon id title (kap:kon text) kelvin `(list @ud)`~)
    ?~  (lent texts.state)
      =.  texts.state  (weld texts.state ~[kan])
      :_  state
      ~[[%give %fact ~[/texts] [%atom !>(texts.state)]]]
    ?:  %-  lien  :: don't add dupes
          :-  texts.state
          |=  kon=ken:kenning
          =(text.kan text.kon)
      :_  state
      ~[[%give %fact ~[/texts] [%atom !>(texts.state)]]]
    =.  texts.state  (weld texts.state ~[kan])
    :_  state
    ~[[%give %fact ~[/texts] [%atom !>(texts.state)]]]
  ==
++  fault
|=  [assay=(list @t) canon=(list @t)]
^-  (list @ud)
?:  .=  assay  canon
  ~
=/  errors  `(list @ud)`~
=/  i  0
|-  
?:  |((gte i (lent assay)) (gte i (lent canon)))
  errors 
?:  .=  (snag i assay)  (snag i canon)
  $(i +(i))
$(errors (weld errors ~[i]), i +(i))
--
