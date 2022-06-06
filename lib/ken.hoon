|%
++  split  :: Split a cord recursively
  |=  [original=tape splitter=tape]
  ^-  (list tape)
  =/  final  `(list tape)`~
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
++  noline  :: remove newlines
  |=  t=tape
  t
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
  .test {
  }
  textarea {
    margin: 0 1em;
    padding: 0; 
    outline: none;
    border: none;
    border-bottom: 1px solid;
  }
  th {
    text-align: left;
  }
  .hidden {
    visibility:hidden;
  }
  '''
--