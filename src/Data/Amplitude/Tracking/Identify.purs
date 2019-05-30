module Data.Amplitude.Tracking.Identify where

import Data.Function.Uncurried (Fn2, runFn2, Fn3, runFn3)
import Effect (Effect)

foreign import data Identify ∷ Type

newtype Builder
  = Builder Identify

-- Very ad-hoc ST interface for MVP.

run ∷ Builder → Identify
run (Builder identify) = identify -- TODO copy before "thawing"

foreign import create ∷ Effect Builder

add ∷ String → Int → (Builder → Builder)
add property value (Builder identify)
  = Builder (runFn3 addImpl property value identify)

foreign import addImpl ∷ Fn3 String Int Identify Identify

append ∷ ∀ item. String → item → (Builder → Builder)
append property value (Builder identify)
  = Builder (runFn3 appendImpl property value identify)

foreign import appendImpl ∷ ∀ item. Fn3 String item Identify Identify

prepend ∷ ∀ item. String → item → (Builder → Builder)
prepend property value (Builder identify)
  = Builder (runFn3 prependImpl property value identify)

foreign import prependImpl ∷ ∀ item. Fn3 String item Identify Identify

set ∷ ∀ item. String → item → (Builder → Builder)
set property value (Builder identify)
  = Builder (runFn3 setImpl property value identify)

foreign import setImpl ∷ ∀ item. Fn3 String item Identify Identify

setOnce ∷ ∀ item. String → item → (Builder → Builder)
setOnce property value (Builder identify)
  = Builder (runFn3 setOnceImpl property value identify)

foreign import setOnceImpl ∷ ∀ item. Fn3 String item Identify Identify

unset ∷ String → (Builder → Builder)
unset property (Builder identify)
  = Builder (runFn2 unsetImpl property identify)

foreign import unsetImpl ∷ Fn2 String Identify Identify
