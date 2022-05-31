/-  kenning, webpage
/+  server, verb, default-agent, dbug, rudder, kennables
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
  ~&  >  'poked'
  ?+  mark  (on-poke:default mark vase)
      %noun
    ~&  >  'noun'
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
    ~&  >>  'handle http'
    =;  out=(quip card:agent:gall _texts.state)
      [-.out this(texts.state +.out)]
    %.
      :+  bowl
        !<(order:rudder vase)
      texts.state
    %:  (steer:rudder _texts.state action:kenning)
      pages
      |=  =trail:rudder  :: a destructured path w a :site path and a file :ext (optional)
      ~&  >>>  trail
      ^-  (unit place:rudder)  :: $place is either a %page or a redirect %away
      ?~  site=(decap:rudder /kenning site.trail)  ~  :: remove '/kenning' from the url
      ~&  >>>  site
      ?+  u.site  ~
      ::route       `[?(%page %away) auth? %page-name]
        ~           `[%page & %index]  :: no trail - index
        [%index ~]  `[%away (snip site.trail)]  :: redirect to /
        [@ ~]       `[%page & %ken]
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

      :: old: 'simple poke' et seq
      :: (fours:rudder texts.state)  :: fallback
      :: |=  act=action:kenning  :: on POST
      :: ^-  $@  brief:rudder  :: ?(failure-msg [success-msg effects updated-data])
      ::     [brief:rudder (list card:agent:gall) _texts.state]
      :: :: ?-  -.act
      :: ::   %add  ``(handle-action:main act)
      :: ::   %get  ``(handle-action:main act)
      :: ::   %browse  ``(handle-action:main act)
      ::   :: %test  ``(handle-action:main act)
      ::   :: %del  ``(oust [index.act 1] texts.state)
      :: :: ==
      ::   ``texts:(handle-action:main act)
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
      :: add a text to the library
      %add
    ~&  >>  'addarino'
    =/  kelvin  (lent (split:kennables text.action " "))
    =/  id  (lent texts.state)
    =.  texts.state  (weld texts.state ~[[%ken id=id text=text.action kelvin=kelvin]])
    :_  state
    ~[[%give %fact ~[/texts] [%atom !>(texts.state)]]]
      :: check your memorized text against the real one 
      %test
    ~&  >>  'testabunga'
    =/  canon  (get id.action)
    ~&  >>  ~[%have assay.action]
    ~&  >>  ~[%need text.canon]
    ?:  =(text.canon assay.action)
      ~&  >  'you did it!'
      :: on pass, dec kelvin if poss
      ?:  =(kelvin.canon 0) 
        :: if already 0, do nothing
        :_  state
        ~[[%give %fact ~[/texts] [%atom !>(texts.state)]]]
      :: set state to have lower kelvin for our text
      =.  kelvin.canon  (dec kelvin.canon) 
      =.  texts.state  (snap texts.state id.action canon) 
      :_  state
      ~[[%give %fact ~[/texts] [%atom !>(texts.state)]]]
    ~&  >  'try again'
    :: on fail, succ kelvin if poss
    ?.  (gte kelvin.canon (lent split:kennables text.canon " "))
      :_  state
      ~[[%give %fact ~[/texts] [%atom !>(texts.state)]]]
    =.  kelvin.canon  (succ kelvin.canon)
    =.  texts.state  (snap texts.state id.action canon)
    :_  state
    ~[[%give %fact ~[/texts] [%atom !>(texts.state)]]]
      :: get text by id
      %get
    ~&  >>  'gettonimo'
    ~&  >>>  (get +.action)
    :_  state
    ~[[%give %fact ~[/texts] [%atom !>(texts.state)]]]
      :: see all texts
      %browse
    ~&  >>  'browsario'
    ~&  >>>  state
    :_  state
    ~[[%give %fact ~[/texts] [%atom !>(texts.state)]]]
      :: delete
      %del
    ~&  >>  'dellissimo'
    =.  texts.state  (oust [id.action 1] texts.state)
    :_  state
    ~[[%give %fact ~[/texts] [%atom !>(texts.state)]]]
  ==
++  get
  |=  [id=@ud]
  (snag id texts.state)
--