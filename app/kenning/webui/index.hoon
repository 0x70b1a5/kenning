/-  kenning
/+  rudder, kennables

^-  (page:rudder kennings:kenning action:kenning)

|_  $:  
    =bowl:gall  
    *
    =kennings:kenning
  ==  

++  build
  |=  $:
        args=(list [key=@t val=@t])
        msg=(unit [gud=? txt=@t])
      ==
  ^-  reply:rudder
  ~&  >  'built'
  |^  [%page page]
  ++  page
    ^-  manx
    ;html
      ;head
        ;title:"kenning"
        ;meta(charset "utf-8");
        ;meta(name "viewport", content "width=device-width, initial-scale=1");
        ;style: {style:kennables}
      ==
      ;body
        ;header
          ;h2:"%kenning"

          Memorize passages of text. Every passage is called a "kenning". 
          
          ;ol
            ;li: Every kenning is assigned a kelvin version based on word count. 
            ;li: You may test your knowledge by filling in the blanks.
            ;li: As kelvin decreases, the number of blanks increases.
          ==
        ==
        ;main
          ;+  ?~  msg  :/""
              ?:  gud.u.msg
                ;div#status.green:"{(trip txt.u.msg)}"
              ;div#status.red:"{(trip txt.u.msg)}"
          ;table
            ;+  ?~  (lent kennings)  
              ;p
                ;b: There are no kennings yet. 
              ==
            ;thead
              ;tr
                ;th;
                ;th
                  kelvin (max)
                ==
                ;th
                  kenning
                ==
                ;th
                  actions
                ==
              ==
            ==
            ;tbody
              ;*  %-  head 
                  %^  spin  kennings  0
                  |=  [k=ken:kenning i=@ud]
                  [(kenner k i) +(i)]
              ;tr
                ;td(colspan "3")
                  ;form(method "post")
                    ;textarea
                      =name         "ken"
                      =placeholder  "Add a new text to memorize..."
                      =rows         "2"
                      =cols         "40";
                    ;input(type "submit", value "add", name "add");
                  ==
                ==
              ==
            ==
          ==
        ==
        ;footer
          © nunya business ventures llc
        ==
      ==
    ==
  ++  kenner
    |=  [k=ken:kenning i=@ud]
    ;tr
      ;td
        ;form(method "post")
          ;input(type "submit", name "del", value "x");
          ;input(type "hidden", name "index", value "{(scow %ud i)}");
        ==
      ==
      ;td
        ;+  ?~  kelvin.k  ;span.green: {(scow %ud kelvin.k)}
          ;span: {(scow %ud kelvin.k)}
        ;span: /{(scow %ud (lent (split:kennables text.k " ")))}
      ==
      ;td: {(clipper text.k)}
      ;td
        ;a.test(href "kenning/{(scow %ud i)}"): test
      ==
    ==
  ++  clipper
    |=  text=(list @t)
    ?:  (gth (lent text) 140) 
      (weld (scag 140 text) "...") 
    text
  --
++  argue
  |=  [headers=header-list:http body=(unit octs)]
  ^-  $@(brief:rudder action:kenning)
  =/  args=(map @t @t)
    ?~(body ~ (frisk:rudder q.u.body))
  ?:  &((~(has by args) 'add') (~(has by args) 'ken'))
    [%add text=(trip (~(got by args) 'ken'))]
  ?:  (~(has by args) 'browse')
    [%browse ~]
  ?:  &((~(has by args) 'get') (~(has by args) 'id'))
    [%get id=`@ud`(~(got by args) 'id')]
  ?:  &((~(has by args) 'test') (~(has by args) 'id') (~(has by args) 'assay'))
    [%test id=`@ud`(~(got by args) 'id') assay=(trip (~(got by args) 'assay'))]
  ?.  &((~(has by args) 'del') (~(has by args) 'index'))
    ~
  ?~  ind=(rush (~(got by args) 'index') dem:ag)
    ~
  ?:  (gte u.ind (lent kennings))
    'index out of range'
  [%del u.ind]
++  final  (alert:rudder 'kenning' build)
--