module Test.Main where

import Control.Monad.Error.Class (catchError)
import Data.Amplitude.Tracking as Amplitude
import Data.Amplitude.Tracking.Identify as Identify
import Data.Maybe (Maybe (..))
import Effect (Effect)
import Effect.Aff (forkAff, launchAff_)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Prelude
import Test.Taxonomy as Taxonomy
import Web.HTML (window) as DOM
import Web.HTML.Location (href) as DOM
import Web.HTML.Window (location, prompt) as DOM

main :: Effect Unit
main = do
  key <- DOM.window >>= DOM.prompt "Amplitude testing API key:" >>= case _ of
    Just key -> pure key
    Nothing  -> pure ""

  launchAff_ do
    let attempt = Amplitude.init (Amplitude.ApiKey key) (Just "Testing User") {}
    catchError attempt \_ -> liftEffect (log "Failed to initialise...")

    url <- liftEffect $ DOM.window >>= DOM.location >>= DOM.href
    _ <- forkAff $ Amplitude.logEvent Taxonomy.viewedAPage { url }
    _ <- forkAff $ Amplitude.identify (Identify.set "Test property" 2)

    liftEffect (log "\"Test suite\" passed!")
