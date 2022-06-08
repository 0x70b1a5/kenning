/-  kenning
/+  rudder, kon

^-  (page:rudder kennings:kenning action:kenning)

|_  [=bowl:gall =order:rudder =kennings:kenning]

++  build  
  |=  [args=(list [key=@t val=@t]) msg=(unit [gud=? txt=@t])]
  ^-  reply:rudder
  |^  [%page page]
  ++  page
    ^-  manx
    =/  ordo  (purse:rudder url.request.order)
    =/  decapt  (decap:rudder /kenning site.ordo)
    =/  num  (slav %ud (head (tail decapt)))
    =/  ken  (snag num kennings)
    =/  words  (nospline:kon text.ken)
    :: at least 1 blank
    ::
    =/  blanks  
      ?:  (lth (lent words) kelvin.ken)
        1
      (max 1 (sub (lent words) kelvin.ken))
    =+  rng=~(. og eny.bowl)
    =^  gaps  rng  
      %^  spin  
        (reap blanks 0)  rng
      |=([n=@ rng=_og] (rads:rng (lent words)))
    ;html
      ;head
        ;title:"ken #{(scow %ud num)}"
        ;meta(charset "utf-8");
        ;meta(name "viewport", content "width=device-width, initial-scale=1");
        ;style: {style:kon}
      ==
      ;body
        ;+  ?~  msg  :/""
            ?:  gud.u.msg
              ;div#status.green:"{(trip txt.u.msg)}"
            ;div#status.red:"{(trip txt.u.msg)}"
        ;h2:"kenning #{(scow %ud num)}, {(scow %ud kelvin.ken)}K"
        ;section
          ;a.linq(href "/kenning"):"back"
          ;a.linq(href "/kenning/{(scow %ud num)}/edit"):"edit"
        ==
        ;section
          ;form(method "post")
            ;*  ^-  marl
                %-  head
                %^  spin  words  0
                |=  [w=tape b=@ud]
                [(field-or-word w b gaps) +(b)]
            ;input(type "hidden", name "id", value (scow %ud num));
            ;br;
            ;input(type "submit", value "submit");
          ==
        ==
        ;script: {scripts}
      ==
    ==
  ++  field-or-word
    |=  [word=tape index=@ud gaps=(list @ud)]
    ^-  manx
    ?~  (find ~[index] gaps)
      ;span
        ; {word}
        ;input(type "hidden", name (scow %ud index), value word);
      ==
    (field word index)
  ++  field
    |=  [word=tape i=@ud]
    ^-  manx
    ;div.inline
      ;input.guess
        =type          "text"
        =name          (scow %ud i)
        =placeholder   "..."
        =autofocus     ""
        =autocomplete  "off";
    ==
  ++  scripts
  ^~
  %-  trip
  '''
  //alert('this works!')
  document.addEventListener('keydown', e => {
    console.log(e)
    if (e.key == ' ') {
      e.preventDefault();
      const inputs = document.getElementsByClassName('guess');
      for (let i in inputs) {
        if (document.activeElement.name == inputs[i].name && +i+1 < inputs.length ) {
          inputs[+i+1].focus();
          break;   
        }
      }
    }
  })
  '''
  --
++  argue  :: called for POST reqs
  |=  [headers=header-list:http body=(unit octs)]
  ^-  $@(brief:rudder action:kenning)  :: error message, or user action
  =/  args=(map @t @t)
    ?~(body ~ (frisk:rudder q.u.body))
  :: ~&  >  args
  ?.  (~(has by args) 'id')
    ~
  =/  id  (slav %ud (~(got by args) 'id'))
  ?:  (gte id (lent kennings))
    ~
  =/  canon  text:(snag id kennings)
  =/  assay  ""
  =/  i=@ud  0
  :: build the tape representing our submission
  |-  
  =/  j  (crip (scow %ud i))
  ?.  &((~(has by args) j) !=(~ (~(got by args) j)))
    [%test id=id assay=assay] 
  =/  word  (trip (~(got by args) j))
  =/  next  ?~  word  ""  
    ?.  (~(has by args) (crip (scow %ud +(i))))  word
      (weld word " ")
  %=  $
    assay  (weld assay next)
    i      +(i)
  ==
++  final
  ::  success=%.y if both +argue and +solve succeeded
  ::  brief might have a status message
  |=  [success=? =brief:rudder]
  ^-  reply:rudder
  :: on error, generic build page
  ?.  success  (build ~ `[| `@t`brief])
  :: on success, re-GET the same page (aka 308) to prevent 'refresh -> re-POST'
  :: %next means re-GET
  =/  ordo  (purse:rudder url.request.order)
  =/  decapt  (decap:rudder /kenning site.ordo)
  =/  num  (head (tail decapt))
  =/  ken  (snag (slav %ud num) kennings)
  :: ~&  >>>  'true'
  :: ~&  >>>  ken
  =/  brief  
    ?~  kelvin.ken
      ?~  brief  '0K baby! you did it!'
        (crip (weld (trip brief) ", also, good job on 0K!"))
      brief
  [%next num brief]
--