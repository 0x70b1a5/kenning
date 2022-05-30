|%
+$  action
  $%  [%add text=(list @t)]
      [%test id=@ud assay=(list @t)]
      [%get id=@ud]
      [%browse ~]
      [%del id=@ud]
  ==
+$  ken
  $%  [%ken id=@ud text=(list @t) kelvin=@u]
  ==
+$  kennings  (list ken)
--