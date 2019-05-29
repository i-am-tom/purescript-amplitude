module Test.Main where

import Data.Amplitude.Tracking as Amplitude
import Data.Maybe (Maybe (..), maybe)
import Data.Symbol (SProxy (..))
import Effect (Effect)
import Effect.Aff (Aff, launchAff_)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Effect.Exception (error, throwException)
import Prelude
import Web.HTML (window) as DOM
import Web.HTML.Window (prompt) as DOM

newtype Category (name ∷ Symbol)
  = Category (SProxy name)

instance topologyTestEvent
  ∷ Amplitude.Taxonomy (Category "Test Event")
      { first_property  ∷ String
      , second_property ∷ Int
      }

logTestEvent
  ∷ ∀ contents. Amplitude.Taxonomy (Category "Test Event") contents
  ⇒ Amplitude.AmplitudeClient → contents → Aff Amplitude.Status
logTestEvent
  = Amplitude.logEvent (Category (SProxy ∷ SProxy "Test Event"))

---------------------------------------------------------------------

main :: Effect Unit
main = launchAff_ do
  window <- liftEffect DOM.window

  key <- liftEffect $ DOM.prompt "Please enter an Amplitude API Key" window
           >>= maybe (throwException (error "No API key given")) pure

  liftEffect $ log $ "Testing with Amplitude v" <> Amplitude.version
  client <- Amplitude.init (Amplitude.Key key) Nothing {}

  pass ("Registered with session #" <> show (getSessionId client))

  Amplitude.isNewSession client >>= case _ of
    True  → pass "Client was registered as a new session"
    False → fail "Client was not registered as a new session"
  pure unit

-- clearUserProperties ∷ AmplitudeClient → Effect Unit
-- identify ∷ AmplitudeClient → Identify → Aff Status
-- isNewSession ∷ AmplitudeClient → Effect Boolean
-- logEvent ∷ ∀ name payload. Taxonomy name payload ⇒ IsSymbol name ⇒ AmplitudeClient → SProxy name → { | payload } → Aff Status
-- logEventWithTimestamp ∷ ∀ name payload. Taxonomy name payload ⇒ IsSymbol name ⇒ AmplitudeClient → SProxy name → { | payload } → Int → Aff Status
-- logRevenueV2 ∷ AmplitudeClient → Revenue → Effect Unit
-- regenerateDeviceId ∷ AmplitudeClient → Effect Unit
-- setDeviceId ∷ AmplitudeClient → String → Effect Unit
-- setDomain ∷ AmplitudeClient → String → Effect Unit
-- setGroup ∷ AmplitudeClient → String → Array String → Effect Unit
-- setOptOut ∷ AmplitudeClient → Boolean → Effect Unit
-- setUserId ∷ AmplitudeClient → String → Effect Unit
-- setUserProperties ∷ ∀ properties. AmplitudeClient → { | properties } → Effect Unit
-- setVersionName ∷ AmplitudeClient → String → Effect Unit
-- setSessionId ∷ AmplitudeClient → Int → Effect Unit
