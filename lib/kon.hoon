/-  kenning
|%
++  split  :: Split a cord recursively
  |=  [original=tape splitter=tape]
  ^-  (list tape)
  =/  final  `(list tape)`~
  |-
  =/  i  (find splitter original)
  ?~  i
    (snoc final original)
  =/  initial  (scag (tail i) original)
  =/  sequential  (slag (add (tail i) (lent splitter)) original)
  ?~  initial
    $(original sequential)
  =.  final  (snoc final initial)
  $(original sequential)
++  noline  :: replace newlines with ace
  |=  t=tape
  ^-  tape
  |-
  =/  gaps  (find "\0d\0a" t)
  ?~  gaps
    t
  %=  $
    :: remove one, swap one.
    :: first oust, then snap (so we can use same index for both)
    t  (snap (oust [(tail gaps) 1] t) (tail gaps) ' ')
  ==
++  nopun
  |=  t=tape
  ^-  tape
  %+  skip  t
  |=  u=@ta
  =(~ (find (trip u) alphanum))
++  alphanum
  "abcdefghijklmnopqrstuvwxyz0123456789"
++  nospline
  |=  t=tape
  ^-  (list tape)
  (split (noline t) " ")
++  nospace
  |=  t=tape
  ^-  tape
  (zing (split t " "))
++  tap
  |=  t=kext:kenning
  ^-  tape
  (turn t taper)
++  taper
  |=  c=khar:kenning
  ^-  @t
  ?@  c
    c
  ?-  -.c
      %ace
    ' '
      %gap
    '\0d\0a'
      %hep
    '-'
  ==
++  kap
  |=  t=tape
  ^-  kext:kenning
  =/  turnt  (turn t kaper)
  =/  kaxt  `kext:kenning`~
  =/  i  0
  =/  store  ""
  |-
  :: ~&  >  i
  :: ~&  >  (lent turnt)
  :: ~&  >>  ith
  :: ~&  >>>  store
  ?:  (gte i (lent turnt))
    kaxt
  =/  ith  (snag i turnt)
  ?@  ith
    $(store (weld store (trip ith)), i +(i))
  %=  $
    kaxt   (weld kaxt ~[`khar:kenning`(crip store) `khar:kenning`ith])
    i      +(i)
    store  ""
  ==
++  kaper
  |=  c=@t
  ^-  khar:kenning
  ?:  =(c ' ')
    ace+~
  ?:  !=(~ (find ~[c] "\0d\0a"))
    gap+~
  ?:  =(c '-')
    hep+~
  c
++  style
  ^~
  %-  trip
  '''
  * {
    box-sizing: border-box;
    font-family: monospace;
  }
  .red { 
    font-weight: bold;
    color: #dd2222; 
  }
  .green { 
    font-weight: bold; 
    color: #229922; 
  }
  form { 
    margin: 0; 
    padding: 0;
    display: inline-block;
  }
  .inline {
    display: inline-block;
  }
  .guess {
    margin: 0.5em 1em;
    border: none;
    border-bottom: 1px solid;
    width: 10em;
  }
  .linq {
    margin: 0.5em;
    border: none;
    background: transparent;
    text-decoration: underline;
    color: blue;
    cursor: pointer;
  }
  textarea {
    margin: 0 1em;
    padding: 0; 
    outline: none;
    border: none;
    border-bottom: 1px solid;
  }
  table {
    border-spacing: 0px;
  }
  th, td {
    text-align: left;
    padding: 2px;
  }
  .hidden {
    visibility:hidden;
  }
  .w1 {
    width: 1em;
  }
  .w2 {
    width: 2em;
  }
  .w3 {
    width: 3em;
  }
  .w4 {
    width: 4em;
  }
  .w5 {
    width: 5em;
  }
  .w6 {
    width: 6em;
  }
  #arrow { 
    font-size: 0.7em;
  }
  .red { 
    outline: 2px solid red;
    border-radius: 3px;
  }
  #test {
    margin-left: 2em;
    max-width: 800px;
  }
  '''
--