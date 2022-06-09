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
++  nospline
  |=  t=tape
  ^-  (list tape)
  (split (noline t) " ")
++  nospace
  |=  t=tape
  ^-  tape
  (zing (split t " "))
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
  .2em {
    width: 2em;
  }
  .3em {
    width: 3em;
  }
  .4em {
    width: 4em;
  }
  .5em {
    width: 5em;
  }
  .6em {
    width: 6em;
  }
  '''
--