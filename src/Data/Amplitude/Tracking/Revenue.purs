module Data.Amplitude.Tracking.Revenue where

import Data.Function.Uncurried (Fn2, runFn2)
import Effect (Effect)

foreign import data Revenue ∷ Type

newtype Builder
  = Builder Revenue

run ∷ Builder → Revenue
run (Builder revenue) = revenue

foreign import create ∷ Effect Builder

setEventProperties ∷ ∀ payload. payload → (Builder → Builder)
setEventProperties payload (Builder revenue)
  = Builder (runFn2 setEventPropertiesImpl payload revenue)

foreign import setEventPropertiesImpl ∷ ∀ payload. Fn2 payload Revenue Revenue

setPrice ∷ Number → (Builder → Builder)
setPrice price (Builder revenue)
  = Builder (runFn2 setPriceImpl price revenue)

foreign import setPriceImpl ∷ Fn2 Number Revenue Revenue

setProductId ∷ String → (Builder → Builder)
setProductId productId (Builder revenue)
  = Builder (runFn2 setProductIdImpl productId revenue)

foreign import setProductIdImpl ∷ Fn2 String Revenue Revenue

setQuantity ∷ Int → (Builder → Builder)
setQuantity quantity (Builder revenue)
  = Builder (runFn2 setQuantityImpl quantity revenue)

foreign import setQuantityImpl ∷ Fn2 Int Revenue Revenue

setRevenueType ∷ String → (Builder → Builder)
setRevenueType revenueType (Builder revenue)
  = Builder (runFn2 setRevenueTypeImpl revenueType revenue)

foreign import setRevenueTypeImpl ∷ Fn2 String Revenue Revenue
