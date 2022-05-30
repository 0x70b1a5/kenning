/-  kenning
/+  rudder

^-  (page:rudder kennings:kenning action:kenning)

|_  [=bowl:gall =order:rudder =kennings:kenning]

++  build  
  |=  [args=(list [key=@t val=@t]) msg=(unit [gud=? txt=@t])]
  ^-  reply:rudder
  |^  [%page page]
  ++  page
    ^-  manx
    =/  ordo  (trip url.request.order)
    =/  decapt  (decap:rudder "/kenning/" ordo)
    =/  num  (slav %ud (head (tail decapt)))
    =/  ken  (snag num kennings)
    ;html
      ;head
        ;title:"kenning"
        ;meta(charset "utf-8");
        ;meta(name "viewport", content "width=device-width, initial-scale=1");
        ;style:"{(trip style)}"
      ==
      ;body
        ;+  ?~  msg  :/""
            ?:  gud.u.msg
              ;div#status.green:"{(trip txt.u.msg)}"
            ;div#status.red:"{(trip txt.u.msg)}"
        :: ; {(tester text.ken)}
        ;form(method "post")
          ;*  ^-  marl
              %+  spun  (split text.ken " ")
              |=  [w=(list @t) i=@ud]
              [(field w i) +(i)]
        ==
        ;a(href "/kenning")
          back
        ==
      ==
    ==
  ++  field
    |=  [word=(list @t) i=@ud]
    ^-  manx
    ;div
      ;input(type "text", name (scow %ud i));
      ;input(type "hidden", value word);
    ==
  ++  split  :: Split a cord recursively
    |=  [original=(list @t) splitter=(list @t)]
    ^-  (list (list @t))
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
  ++  style
    '''
    form { 
      margin: 0; 
      display: inline-block;
    }
    * {
      box-sizing: border-box;
    }
    '''
  --
++  argue  :: called for POST reqs
  |=  [headers=header-list:http body=(unit octs)]
  ^-  $@(brief:rudder action:kenning)  :: error message, or user action
  =/  args=(map @t @t)
    ?~(body ~ (frisk:rudder q.u.body))
::
  ?:  &((~(has by args) 'test') (~(has by args) 'assay'))
    [%test id=`@ud`(~(got by args) 'id') assay=(trip (~(got by args) 'assay'))]
::
  ?.  &((~(has by args) 'del') (~(has by args) 'index'))
    ~
  ?~  ind=(rush (~(got by args) 'index') dem:ag)
    ~
  ?:  (gte u.ind (lent kennings))
    'index out of range'
  [%del u.ind]
++  final  (alert:rudder 'kenning' build)
--