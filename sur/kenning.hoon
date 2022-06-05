|%
+$  action
  $%  [%add text=tape]
      [%test id=@ud assay=tape]
      [%get id=@ud]
      [%browse ~]
      [%del id=@ud]
      [%mod ken=ken]
  ==
+$  ken
  $%  [%ken id=@ud text=tape kelvin=@ud]
  ==
+$  kennings  (list ken)
--