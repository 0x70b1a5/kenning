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
    =/  kelvin  (lent (split text.action " "))
    =/  id  (lent texts.state)
    =.  texts.state  (weld texts.state ~[[%ken id=id text=text.action kelvin=kelvin]])
    :_  state
    ~[[%give %fact ~[/texts] [%atom !>(texts.state)]]]
    :: check your memorized text against the real one 
      %test
    ~&  >>  'testabunga'
    =/  assay  (split assay.action " ")
    =/  canon  (snag id.action texts.state)
    ?:  =(canon assay)
      ~&  >  'you did it!'
      :_  state
      ~[[%give %fact ~[/texts] [%atom !>(texts.state)]]]
    ~&  >  'try again'
    :_  state
    ~[[%give %fact ~[/texts] [%atom !>(texts.state)]]]
    :: get text by id
      %get
    ~&  >>  'gettonimo'
    ~&  >>>  (snag +.action texts.state)
    :_  state
    ~[[%give %fact ~[/texts] [%atom !>(texts.state)]]]
    :: see all texts
      %browse
    ~&  >>  'browsario'
    ~&  >>>  state
    :_  state
    ~[[%give %fact ~[/texts] [%atom !>(texts.state)]]]
  ==
++  check  :: compares a list of cords to a list of cords
  :: turns out you can actually just do this with ?=
  :: never mind
  |=  [canon=(list @t) assay=(list @t)]
  ?:  !=((lent assay) (lent canon))
  ~&  >>>  'lengths not equal'
    %.n
  =/  i  0
  |-
    ?:  (gth i (lent canon))
      %.y
    ?:  =((snag i canon) (snag i assay))
      $(i (add 1 i))
    %.n
++  split  :: Split a cord recursively
  |=  [original=(list @t) splitter=(list @t)]
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