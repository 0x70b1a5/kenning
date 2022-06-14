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
    =/  kount  (word-kount:kon text.ken)
    :: at least 1 blank
    ::
    =/  blanks  
      ?:  (lth kount kelvin.ken)
        1
      (max 1 (sub kount kelvin.ken))
    =/  gaps  (get-gaps blanks text.ken)
    :: ~&  >>>  gaps
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
        ;h2
          ;span:"kenning #"
          ;span#kid:"{(scow %ud num)}"
          ; , 
          ;span#k:"{(scow %ud kelvin.ken)}"
          ; K
          ;span#arrow;
        ==
        ;section
          ;a.linq(href "/kenning"):"back"
          ;a.linq(href "/kenning/{(scow %ud num)}/edit"):"edit"
        ==
        ;section
          ;form(id "test", method "post")
            ;*  ^-  marl
                %-  head
                %^  spin  text.ken  0
                |=  [w=khar:kenning b=@ud]
                ?@  w  
                  ?~  w  [;x; b]
                  [(field-or-word w b gaps) +(b)]
                ?-  -.w  
                  %ace  [;x; b]
                  %gap  [;br; b]
                  %hep  [;span:"-" b]
                ==
            ;input(type "hidden", name "id", value (scow %ud num));
            ;br;
            ;input(type "submit", value "submit", id "submit");
          ==
        ==
        ;script: {scripts}
      ==
    ==
  ++  field-or-word
    |=  [word=@t index=@ud gaps=(list [@tas @ud])]
    ^-  manx
    ?~  (find ~[[%gap index]] gaps)
      ;span
        ; {(trip word)}
        ;input(type "hidden", name (scow %ud index), value (trip word));
      ==
    (field word index)
  ++  field
    |=  [word=@t i=@ud]
    ^-  manx
    ;div.inline
      ;input
        =class         "guess w{(scow %ud (lent (trip word)))}"
        =type          "text"
        =name          (scow %ud i)
        :: =placeholder   "..."
        =autofocus     ""
        =autocomplete  "off";
    ==
  ++  get-gaps
    |=  [n=@ud orig=kext:kenning]
    ^-  (list [@tas @ud])
    =/  max  (word-kount:kon orig)
    =+  rng=~(. og eny.bowl)
    =/  range  (reap n 0)
    =/  uniqs  `(list [@tas @ud])`~
    =/  i  0
    :: ~&  >>>  max
    :: ~&  >>>  n
    |-
    ?:  (gte i 10.000) :: don't infinite
      uniqs
    =.  i  +(i)
    ?:  (gte (lent uniqs) n)
      uniqs
    =^  proposal  rng  (rads:rng max)
    :: ~&  >>  proposal
    ?~  (find ~[[%gap proposal]] uniqs) :: if it's unique
      =/  k  (snag proposal (kwords:kon orig))
      :: ~&  >  (snag proposal orig)
      ?~  k  $(uniqs uniqs) :: khar is null in kext - try again
      ?^  k  $(uniqs uniqs) :: khar is a non-text token - try again
      $(uniqs (weld ~[[%gap proposal]] uniqs))
    $(uniqs uniqs) :: khar is not unique - try again
  ++  scripts
    ^~
    %-  trip
    '''
    //alert('this works!')
    const form = document.getElementById('test');
    form.addEventListener('submit', e => {
      const inputs = document.getElementsByTagName('input');
      const anpats = [];
      for (let i in inputs) {
        // do it backwards, with unshift
        //   so that below, we always focus the first empty
        if (+i || ((+i) === 0)) anpats.unshift(inputs[i]);
      }
      for (let i in anpats) {
        if (+i && !anpats[i].value) {
          e.preventDefault();
          anpats[i].classList.add('red');
          anpats[i].focus();
        }
      }
    });

    document.addEventListener('keydown', e => {
      // console.log(e);
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

      if (e.key == 'Backspace') {
        const inputs = document.getElementsByClassName('guess');
        let lastInput = inputs[0];
        for (let i in inputs) {
          if (document.activeElement.name == inputs[i].name
            && document.activeElement.value == '') {
            e.preventDefault();
            lastInput.focus();
            break;   
          }
          lastInput = inputs[i];
        }
      }
    })

    // localstorage: find latest kelvin
    //   use that to show if user advanced or fell back
    const kenId = document.getElementById('kid').innerText;
    const lastK = +localStorage.getItem('_kenning_lastK_'+kenId);
    const currK = +document.getElementById('k').innerText;
    if (!isNaN(lastK)) {
      if (!isNaN(currK)) {
        const wentDown = lastK < currK;
        const noChange = lastK == currK && lastK != 0;

        document.getElementById('arrow').innerText = wentDown ?
          "❌" : noChange ? "" : "✅";
      }
    }
    localStorage.setItem('_kenning_lastK_'+kenId, currK);

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
  =/  max    (lent canon)
  =/  assay  ""
  =/  i=@ud  0
  :: build the tape representing our submission
  |-  
  =/  j  (crip (scow %ud i))
  :: ~&  >>  j
  ?:  (gte i max)
    [%test id=id assay=(kap:kon assay)] 
  ?.  (~(has by args) j)
    $(i +(i))
  =/  word  (trip (~(got by args) j))
  =/  next  (weld word " ")
  :: ~&  >>>  assay
  :: ~&  >>>  next
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