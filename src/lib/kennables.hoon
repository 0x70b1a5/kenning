|%
++  split  :: Split a cord recursively
  |=  [original=(list @t) splitter=(list @t)]
  ^-  (list (list @t))
  =/  final  `(list (list @t))`~
  |-
  =/  i  (find splitter original)
  ?~  i
    (snoc final original)
  =/  initial  (scag +.i original)
  =/  sequential  (slag +(+.i) original)
  ?~  initial
    $(original sequential)
  =.  final  (snoc final initial)
  $(original sequential)
++  style
  '''
  form { 
    margin: 0; 
    display: inline-block;
  }
  * {
    box-sizing: border-box;
  }
  .inline {
    display: inline-block;
  }
  .guess {
    margin: 0.5em 1em;
    border: none;
    border-bottom: 1px solid;
  }
  '''
--