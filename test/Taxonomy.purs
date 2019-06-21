module Test.Taxonomy where

import Data.Amplitude.Tracking (class Taxonomy)

-- In order to avoid orphan instance troubles, we need a categorising type for
-- our events created in the same module as our taxonomy. You can, of course,
-- have multiple categories, but no two categories can contain the same event
-- name. These are not _namespaces_, as Amplitude has no such concept - these
-- are just a way to organise your code and avoid orphans.

data Acme (title :: Symbol)
  = Acme

-- Now, we can use this category to define our events without orphan instance
-- problems. We state the event name (which `purescript-amplitude` will use
-- directly) and the schema to which that event should be related.

instance acmePageView :: Taxonomy (Acme "PureScript Amplitude: Viewed a page")
  { url :: String
  }

instance acmeFoobar :: Taxonomy (Acme "PureScript Amplitude: Fooed a Bar")
  { baz  :: Number
  , quux :: Int
  }

-- Now, when we pass an appropriate event, the type-checker will make sure that
-- we're including the right properties in the event. We can make this a bit
-- neater by defining these values here:

viewedAPage :: Acme "PureScript Amplitude: Viewed a page"
viewedAPage = Acme

foobar :: Acme "Fooed a bar"
foobar = Acme
