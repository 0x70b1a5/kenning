|%
+$  action
  $%  [%add text=tape title=tape]
      [%test id=@ud assay=kext]
      [%get id=@ud]
      [%browse ~]
      [%del id=@ud]
      [%mod ken=ken]
  ==
+$  khar  $@(@t $%([%ace ~] [%gap ~] [%hep ~]))
+$  kext  (list khar)
+$  ken
  $%  [%ken id=@ud title=tape text=kext kelvin=@ud errors=(list @ud)]
  ==
+$  ken-1
  $%  [%ken id=@ud text=kext kelvin=@ud errors=(list @ud)]
  ==
+$  ken-0
  $%  [%ken id=@ud text=kext kelvin=@ud]
  ==
+$  kennings  (list ken)
--