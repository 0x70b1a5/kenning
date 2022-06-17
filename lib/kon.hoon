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
  :: ~&  >  t
  ?~  gaps
    t
  %=  $
    :: remove one, swap one.
    :: first oust, then snap (so we can use same index for both)
    t  (snap (oust [(tail gaps) 1] t) (tail gaps) ' ')
  ==
++  nopun
  |=  c=khar:kenning
  ^-  @t
  ?^  c  ''
  %-  crip
  %-  cass
  %+  skip  (trip c)
  |=  u=@t
  =(~ (find (cass (trip u)) alphanum))
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
++  word-count
  |=  t=tape
  ^-  @
  (word-kount (kap t))
++  word-kount
  |=  k=kext:kenning
  ^-  @
  (lent (kwords k))
++  kwords
  |=  k=kext:kenning
  %+  skim  k
  |=  car=khar:kenning
  ?@  car  
    !=(car ~)
  |
++  remove-sigs
  |=  t=tape
  %+  skim  t
  |=  c=@t
  .=  ~  c
++  tap
  |=  k=kext:kenning
  ^-  tape
  =/  store  ""
  =/  i  0
  |-
  ?:  (gte i (lent k))
    :: ~&  >  store
    store
  =/  c  (snag i k)
  ?~  c
    $(i +(i))
  ?@  c  
    $(store (weld store (trip c)), i +(i))
  ?-  -.c
      %ace
    $(store (weld store " "), i +(i))
      %gap
    $(store (weld store "\0d\0a"), i +(i))
      %hep
    $(store (weld store "-"), i +(i))
  ==
++  kap
  |=  t=tape
  ^-  kext:kenning
  =/  kaxt  `kext:kenning`~
  =/  i  0
  =/  store  ""
  |-
  ?:  (gte i (lent t))
    (weld kaxt ~[`khar:kenning`(crip store)])
  =/  ith  (snag i t)
  ?:  =(ith ' ')
    $(kaxt (weld kaxt ~[`khar:kenning`(crip store) ace+~]), i +(i), store "")
  ?:  =(ith '-')
    $(kaxt (weld kaxt ~[`khar:kenning`(crip store) hep+~]), i +(i), store "")
  ?:  |(=(ith '\0d') =(ith '\0a')) :: '\0a' always follows - skip it
    $(kaxt (weld kaxt ~[`khar:kenning`(crip store) gap+~]), i +(+(i)), store "")
  $(store (weld store (trip ith)), i +(i))
++  newk
  |=  [id=@ud text=kext:kenning kelvin=@ud errors=(list @ud)]
  ^-  ken:kenning
  [%ken id=id text=text kelvin=kelvin errors=errors]
++  zero-to-one
  |=  zero=[@tas id=@ud text=kext:kenning kelvin=@ud]
  (newk id.zero text.zero kelvin.zero `(list @ud)`~)  
++  style
  ^~
  %-  trip
  '''
  * {
    box-sizing: border-box;
    font-family: monospace;
  }
  body {
    max-width: 1000px;
  }
  .red { 
    font-weight: bold;
    color: #dd2222; 
  }
  .green { 
    font-weight: bold; 
    color: #229922; 
  }
  .gold {
    font-weight: bold;
    color: goldenrod;
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
    margin-right: 0.7em;
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
    table-layout: fixed;
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
  .w7 {
    width: 7em;
  }
  .w8 {
    width: 8em;
  }
  .w9 {
    width: 9em;
  }
  .w10 {
    width: 10em;
  }
  #arrow { 
    font-size: 0.7em;
  }
  input.red { 
    outline: 2px solid red;
    border-radius: 3px;
  }
  #test {
    margin: 1em 2em;
    max-width: 800px;
  }
  #submit {
    margin-top: 1em;
  }
  label {
    margin-right: 2em;
  }
  .hep {
    margin-left: -0.7em;
  }
  input.gold {
    outline: 2px solid #ffdd00;
    border-radius: 3px;
  }
  .my-3 {
    margin-top: 3px;
    margin-bottom: 3px;
  }
  .mx-0 {
    margin-left: 0;
    margin-right: 0;
  }
  '''
--