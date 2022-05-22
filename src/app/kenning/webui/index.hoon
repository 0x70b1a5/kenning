/-  kenning
/+  rudder

^-  (page:rudder kennings action)

|_  $:  
    =bowl:gall  
    *
    =kennings
  ==  

++  build
  |=  
    $:
      args=(list [key=@t val=@t])
      msg=(unit [gud=? txt=@t])
    ==
  ^-  reply:rudder
  |^  [%page page]
  ++  page
    ^-  manx
    ;html
      ;head
        ;title:"kenning"
        ;style:"form \{ display: inline-block }"
        ;meta(charset "utf-8")
        ;meta(name "viewport", content "width=device-width, initial-scale=1")
      ==
      ;body
        ;+  ?~  msg  :/""
            ?:  gud.u.msg
              ;div#status.green:"{(trip txt.u.msg)}"
            ;div#status.red:"{(trip txt.u.msg)}"
        ;ul 
          ;*  %-  head 
              %^  spin  kennings  0
              |=  [k=ken i=@ud]
              [(kenner k i) +(i)]
        ==
        ;form(method "post")
          ;textarea(name "ken", placeholder "Add a new text to memorize...")
          ;input(type "submit", value "add", name "add")
        ==
          ::;input(type "hidden", name "index", value "{(scow %ud i)}")
      ==
    ==
  ++  kenner
    |=  [k=ken i=@ud]
    ;li
      ;a(href id.k)
        ;{(weld (scag 140 text.k) "...")}
      ==
      ;form(method "post")
        ;input(type "submit", name "del", value "x")
        ;input(type "hidden", name "index", value "{(scow %ud i)}")
      ==
    ==
  --
++  argue
  |=  [headers=header-list:http body=(unit octs)]
  ^-  $@(brief:rudder action)
  =/  args=(map @t @t)
    ?~(body ~ (frisk:rudder q.u.body))
  ?:  &((~(has by args) 'add') (~(has by args) 'ken'))
    [%add text=(~(got by args) 'ken')]
  ?.  &((~(has by args) 'del') (~(has by args) 'index'))
    ~
  ?~  ind=(rush (~(got by args) 'index') dem:ag)
    ~
  ?:  (gte u.ind (lent kennings))
    'index out of range'
  [%del u.ind]
++  final  (alert:rudder 'kenning' build)
