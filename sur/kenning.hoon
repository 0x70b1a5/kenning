|%
+$  action
  $%  [%add text=tape]
      [%test id=@ud assay=kext]
      [%get id=@ud]
      [%browse ~]
      [%del id=@ud]
      [%mod ken=ken]
  ==
+$  khar  $@(@t $%([%ace ~] [%gap ~] [%hep ~]))
+$  kext  (list khar)
+$  ken
  $%  [%ken id=@ud text=kext kelvin=@ud]
  ==
+$  kennings  (list ken)
--