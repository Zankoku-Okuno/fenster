module Control.Window.List
  ( window2
  , window3
  , windowN
  , stateMachine2
  ) where

-- TODO more data types can be included (more optimally) in `Control.Window.{Array,Text,...}`

-- |Alter a list by passing a size-2 window over it.
--  This algorithm only commits an element to output once no edits have been performed on it.
--  This lets editor operate on an element multiple times, but also allows infinite loops.
window2 ::
  (a -> a -> Maybe [a]) -- ^editor function: takes two list items,
                        --  and if an edit is needed, returns `Just` a list
                        --  that replaces the two inputs
  -> [a] -- ^ input list
  -> [a] -- ^ edited list
window2 _ [] = []
window2 _ [x] = [x]
window2 edit (x:y:rest) = case edit x y of
  Nothing -> x : window2 edit (y:rest)
  Just xs' -> window2 edit (xs' ++ rest)

-- | As 'window2', but with a size-3 window.
window3 ::
  (a -> a -> a -> Maybe [a]) -- ^editor function: takes two list items,
                             --  and if an edit is needed, returns `Just` a list
                             --  that replaces the two inputs
  -> [a] -- ^ input list
  -> [a] -- ^ edited list
window3 _ [] = []
window3 _ [x] = [x]
window3 _ [x,y] = [x,y]
window3 edit (x:y:z:rest) = case edit x y z of
  Nothing -> x : window3 edit (y:z:rest)
  Just xs' -> window3 edit (xs' ++ rest)

-- |As 'window2', but any integer can be set.
--  The editor function need only take lists of the passed length.
windowN ::
     Int -- ^ number of elements in the window
  -> ([a] -> Maybe [a])
  -> [a]
  -> [a]
windowN n _ xs | n < 1 = xs
windowN n _ xs | length xs < n = xs
windowN n editor xs
  | (window, rest) <- splitAt n xs
  = case editor window of
      Nothing -> head window : windowN n editor (tail window ++ rest)
      Just xs' -> windowN n editor (xs' ++ rest)


stateMachine2 ::
     (st -> a -> a -> Maybe ([a], st))
  -> st
  -> [a]
  -> [a]
stateMachine2 edit st0 xs0 = go st0 xs0
  where
  go _ [] = []
  go _ [x] = [x]
  go st (x:y:rest) = case edit st x y of
    Nothing -> x : go st (y:rest)
    Just (xs', st') -> go st' (xs' ++ rest)
