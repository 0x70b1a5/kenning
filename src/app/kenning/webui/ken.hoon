/-  kenning
/+  rudder, kennables

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
    =/  canon  (split:kennables text.ken " ")
    =/  blanks  (sub (lent canon) kelvin.ken)
    ;html
      ;head
        ;title:"kenning"
        ;meta(charset "utf-8");
        ;meta(name "viewport", content "width=device-width, initial-scale=1");
        ;style: {style:kennables}
      ==
      ;body
        ;+  ?~  msg  :/""
            ?:  gud.u.msg
              ;div#status.green:"{(trip txt.u.msg)}"
            ;div#status.red:"{(trip txt.u.msg)}"
        ;form(method "post")
          ;*  ^-  marl
              %-  head
              %^  spin  canon  0
              |=  [w=(list @t) b=@ud]
              [(field-or-word w b blanks) +(b)]
          ;input(type "hidden", name "id", value (scow %ud num));
          ;input(type "submit", value "submit");
        ==
        ;a(href "/kenning")
          back
        ==
        ;script: {scripts}
      ==
    ==
  ++  field-or-word
    |=  [word=(list @t) index=@ud blanks=@ud]
    ^-  manx
    ?:  (lth index blanks)
      (field word index)
    ;span
      ; {word}
      ;input(type "hidden", name (scow %ud index), value word);
    ==
  ++  field
    |=  [word=(list @t) i=@ud]
    ^-  manx
    ;div.inline
      ;input.guess(type "text", name (scow %ud i), placeholder "...", autofocus "", autocomplete "off");
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
  ~&  >  'received submission:'
  ~&  >  args
  ?.  (~(has by args) 'id')
    ~
  =/  id  (slav %ud (~(got by args) 'id'))
  ?:  (gte id (lent kennings))
    ~
  =/  canon  text:(snag id kennings)
  =/  assay  ""
  =/  i=@ud  0
  |-  :: build the tape representing our submission
  :: at kelvin 0 the last word also gets a " " added ... may want to fix this!
  =/  j  (crip (scow %ud i))
  ?.  &((~(has by args) j) !=(~ (~(got by args) j)))
    :: tail because the below nonsense adds a  space in front
    [%test id=id assay=(tail assay)] 
    :: sorry about this
  %=  $
    assay  (weld assay (weld " " (trip (~(got by args) j))))
    i      +(i)
  ==
    :: (trip (~(got by args) (crip (scow %ud i))))
::
::   ?:  &((~(has by args) 'test') (~(has by args) 'assay'))
::     [%test id=`@ud`(~(got by args) 'id') assay=(trip (~(got by args) 'assay'))]
:: ::
::   ?.  &((~(has by args) 'del') (~(has by args) 'index'))
::     ~
::   ?~  ind=(rush (~(got by args) 'index') dem:ag)
::     ~
::   ?:  (gte u.ind (lent kennings))
::     'index out of range'
::   [%del u.ind]
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
  =/  num  (slav %ud (head (tail decapt)))
  [%next num brief]
--