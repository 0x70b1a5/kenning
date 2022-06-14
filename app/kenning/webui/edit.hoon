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
    :: ~&  >>>  ken
    ;html
      ;head
        ;title:"edit ken #{(scow %ud num)}"
        ;meta(charset "utf-8");
        ;meta(name "viewport", content "width=device-width, initial-scale=1");
        ;style: {style:kon}
      ==
      ;body
        ;+  ?~  msg  :/""
            ?:  gud.u.msg
              ;div#status.green:"{(trip txt.u.msg)}"
            ;div#status.red:"{(trip txt.u.msg)}"
        ;h2:"editing kenning #{(scow %ud num)}"
        ;section
          ;a.linq/"/kenning/{(scow %ud num)}":"back"
        ==
        ;section
          ;form(method "post")
            ;div
              ;label: ken
              ;textarea
                  =cols           "40"
                  =rows           "20"
                  =id             "text"
                  =name           "text"
                  =placeholder    "enter your ken..."
                  =autofocus      ""
                  =autocomplete   "off"
                ; {(tap:kon text.ken)}
              ==
            ==
            ;br;
            ;div
              ;label: kelvin
              ;input.guess
                =id            "kelvin"
                =type          "number"
                =min           "0"
                =pattern       "\\d+"
                =name          "kelvin"
                =placeholder   "kelvin manual override"
                =autocomplete  "off"
                =value         (scow %ud kelvin.ken);
              :: ;input
              ::   =type     "checkbox"
              ::   =name     "autokel"
              ::   =id     "autokel"
              ::   =checked  "true";
              :: ; automatic
            ==
            ;input(type "hidden", name "id", value (scow %ud num));
            ;input(type "submit", value "save");
          ==
        ==
        ;script: {scripts}
      ==
    ==
  ++  scripts
  ^~
  %-  trip
  '''
  const k = document.getElementById('kelvin')
  const text = document.getElementById('text')

  text.addEventListener('keyup', e => {
    const newk = e.target.value
      .replace(/(\s|-)+/g, ' ')
      .trim()
      .split(' ')
      .length;

    k.value = newk;
  })
  '''
  --
++  argue  :: called for POST reqs
  |=  [headers=header-list:http body=(unit octs)]
  ^-  $@(brief:rudder action:kenning)  :: error message, or user action
  =/  args=(map @t @t)
    ?~(body ~ (frisk:rudder q.u.body))
  :: ~&  >  args
  ?.  ?&  (~(has by args) 'id') 
          (~(has by args) 'kelvin') 
          (~(has by args) 'text')
      ==
    ~
  =/  id      (slav %ud (~(got by args) 'id'))
  ?:  (gte id (lent kennings))
    (crip "id {(scow %ud id)} is not valid")
  =/  text  (kap:kon (trip (~(got by args) 'text')))
  :: ~&  >>  text
  =/  kelvin  (slav %ud (~(got by args) 'kelvin'))
  =/  kelmax  (word-kount:kon text)
  ?:  (gth kelvin kelmax)
    (crip "maximum kelvin value for this ken is {(scow %ud kelmax)}")
  [%mod ken=[%ken id=id text=text kelvin=kelvin]]
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
  =/  brief  
    ?~  brief  'ken edited successfully.'
      brief
  [%next '' brief]
--