module Data.Amplitude.Tracking.Identify where

import Data.Function.Uncurried (Fn2, runFn2, Fn3, runFn3)
import Prelude

foreign import data Identify ∷ Type

newtype Builder
  = Builder (Identify → Identify)
  -- deriving (Semigroup, Monoid) via (Endo Identify)

instance semigroupBuilder ∷ Semigroup Builder where
  append (Builder f) (Builder g) = Builder (f <<< g)

instance monoidBuilder ∷ Monoid Builder where
  mempty = Builder identity

---

add ∷ String → Int → Builder
add property value = Builder (runFn3 addImpl property value)

foreign import addImpl ∷ Fn3 String Int Identify Identify

append ∷ ∀ item. String → item → Builder
append property value = Builder (runFn3 appendImpl property value)

foreign import appendImpl ∷ ∀ item. Fn3 String item Identify Identify

prepend ∷ ∀ item. String → item → Builder
prepend property value = Builder (runFn3 prependImpl property value)

foreign import prependImpl ∷ ∀ item. Fn3 String item Identify Identify

set ∷ ∀ item. String → item → Builder
set property value = Builder (runFn3 setImpl property value)

foreign import setImpl ∷ ∀ item. Fn3 String item Identify Identify

setOnce ∷ ∀ item. String → item → Builder
setOnce property value = Builder (runFn3 setOnceImpl property value)

foreign import setOnceImpl ∷ ∀ item. Fn3 String item Identify Identify

unset ∷ String → Builder
unset property = Builder (runFn2 unsetImpl property)

foreign import unsetImpl ∷ Fn2 String Identify Identify
