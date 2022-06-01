::  webpage: simple webpage core type
::  by ~palfun-foslup https://github.com/Fang-
::
|*  [dat=mold cmd=mold]
$_  ^|
|_  [bowl:gall dat]
++  build  |~([(list [k=@t v=@t]) (unit [? @t])] *manx)  ::  get to page
++  argue  |~([header-list:http (unit octs)] *(unit cmd))::  post to cmd
--