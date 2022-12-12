/-  kenning
/+  rudder, kon

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
  |^  [%page page]
  ++  page
    ^-  manx
    ;html
      ;head
        ;title:"kenning"
        ;meta(charset "utf-8");
        ;meta(name "viewport", content "width=device-width, initial-scale=1");
        ;style: {style:kon}
      ==
      ;body
        ;header
          ;h2:"%kenning"

          Memorize passages of text. Every passage is called a "kenning". 
          
          ;ol
            ;li: Every kenning is assigned a kelvin version based on word count. 
            ;li: You may test your knowledge by filling in the blanks.
            ;li: As kelvin decreases, the number of blanks increases.
            ;li: For large passages, split the text into several kens for best results.
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
                ;th
                  title
                ==
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
                ;td(colspan "4")
                  ;form(method "post")
                    ;input.guess
                      =placeholder  "title"
                      =name         "title";
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
    ;tr.ken
      ;td: {title.k}
      ;td
        ;+  ?~  kelvin.k  ;span.green: {(scow %ud kelvin.k)}
          ;span: {(scow %ud kelvin.k)}
        ;span: /{(scow %ud (word-kount:kon text.k))}
      ==
      ;td: {(clipper (tap:kon text.k) 70)}
      ;td.actions
        ;a.linq(href "kenning/{(scow %ud i)}"):"test"
        ;a.linq(href "kenning/{(scow %ud i)}/edit"):"edit"
        ;form(method "post")
          ;input.linq(type "submit", name "del", value "del");
          ;input(type "hidden", name "index", value "{(scow %ud i)}");
        ==
      ==
    ==
  ++  clipper
    |=  [text=tape chars=@ud]
    ?:  (gth (lent text) chars) 
      (weld (scag chars text) "...") 
    text
  --
++  argue
  |=  [headers=header-list:http body=(unit octs)]
  ^-  $@(brief:rudder action:kenning)
  =/  args=(map @t @t)
    ?~(body ~ (frisk:rudder q.u.body))
  ?:  &((~(has by args) 'add') (~(has by args) 'ken') (~(has by args) 'title'))
    [%add text=(trip (~(got by args) 'ken')) title=(trip (~(got by args) 'title'))]
  ?.  &((~(has by args) 'del') (~(has by args) 'index'))
    ~
  ?~  ind=(rush (~(got by args) 'index') dem:ag)
    ~
  ?:  (gte u.ind (lent kennings))
    'index out of range'
  [%del u.ind]
++  final  (alert:rudder 'kenning' build)
--
