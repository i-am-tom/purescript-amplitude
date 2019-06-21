module Test.Main where

import Test.Taxonomy as Taxonomy
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)
import Effect.Exception (throw)
import Data.Maybe (Maybe (..))
import Effect (Effect)
import Prelude
import Data.Amplitude.Tracking as Amplitude
import Web.HTML (window) as DOM
import Web.HTML.Location (href) as DOM
import Web.HTML.Window (location, prompt) as DOM

main :: Effect Unit
main = do
  key <- DOM.window >>= DOM.prompt "Amplitude testing API key:" >>= case _ of
    Just key -> pure key
    Nothing  -> throw "You must enter an Amplitude key!"

  launchAff_ do
    Amplitude.init key (Just "Testing User") {}

    url <- liftEffect $ DOM.window >>= DOM.location >>= DOM.href
    Amplitude.logEvent Taxonomy.viewedAPage { url }
