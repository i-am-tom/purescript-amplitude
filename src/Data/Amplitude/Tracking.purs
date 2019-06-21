module Data.Amplitude.Tracking where

import Data.Amplitude.Tracking.Config (Config)
import Data.Amplitude.Tracking.Identify (Identify)
import Data.Amplitude.Tracking.Revenue (Revenue)
import Data.Maybe (Maybe)
import Data.Nullable (Nullable, toNullable)
import Data.Symbol (class IsSymbol, SProxy (..), reflectSymbol)
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Aff.Compat (EffectFnAff, fromEffectFnAff)
import Effect.Class (liftEffect)
import Effect.Uncurried as Uncurried
import Prelude
import Prim.Row (class Union)

-- We require all events in a taxonomy to be labelled, and then we use this
-- label as the event name. The functional dependency means that any two events
-- of the same name _must_ have the same payload type, so we can enforce a
-- schema more strictly. Namespaces are an orphan instance workaround.
class Taxonomy (label ∷ Type) (structure ∷ Type) | label → structure

-- When Amplitude returns a response in an event callback, it will take the
-- following shape. Mostly, we only use these to accept/reject promises.
type Status
  = { responseCode ∷ Int
    , responseBody ∷ String
    }

-- Get the current version of Amplitude's JavaScript SDK.
foreign import version ∷ String

-- Clear all of the user properties for the current user. This will wipe all of
-- the user's user properties and reset them.
--
-- _Note: Clearing user properties is irreversible! Amplitude will not be able
-- to sync the user's user property values before the wipe to any future events
-- that the user triggers as they will have been reset._
foreign import clearUserProperties ∷ Effect Unit

-- Returns the ID of the current session.
foreign import getSessionIdImpl ∷ Effect Int

-- Send an identify call containing user property operations to Amplitude
-- servers. See the [JavaScript SDK
-- Installation](https://amplitude.zendesk.com/hc/en-us/articles/115001361248#setting-user-properties)
-- documentation for more information.
identify ∷ Identify → Aff Status
identify
    = Uncurried.runEffectFn1 identifyImpl >>> liftEffect >=> fromEffectFnAff

foreign import identifyImpl
  ∷ Uncurried.EffectFn1 Identify (EffectFnAff Status)

-- Initializes the Amplitude JavaScript SDK with your apiKey and any optional
-- configurations. This is required before any other methods can be called.
init
  ∷ ∀ overrides. Union overrides Config Config
  ⇒ String → Maybe String → { | overrides } → Aff Unit
init key userId
  = Uncurried.runEffectFn3 initImpl key (toNullable userId)
      >>> liftEffect

foreign import initImpl
  ∷ ∀ config. Uncurried.EffectFn3 String (Nullable String) config Unit

-- Returns true if a new session was created during initialization, otherwise
-- false.
foreign import isNewSession ∷ Effect Boolean

-- If we have a valid label/payload matchg, log an event with eventType and
-- eventProperties.
logEvent
  ∷ ∀ f name payload. Taxonomy (f name) payload ⇒ IsSymbol name
  ⇒ f name → payload → Aff Status
logEvent _
  = Uncurried.runEffectFn2 logEventImpl label >>> liftEffect >=> fromEffectFnAff
  where
    label ∷ String
    label = reflectSymbol (SProxy ∷ SProxy name)

foreign import logEventImpl
  ∷ ∀ payload. Uncurried.EffectFn2 String payload (EffectFnAff Status)

-- Log an event with eventType, eventProperties, and a custom timestamp.
logEventWithTimestamp
  ∷ ∀ f name payload. Taxonomy (f name) payload ⇒ IsSymbol name
  ⇒ f name → payload → Int → Aff Status
logEventWithTimestamp _ payload
  = Uncurried.runEffectFn3 logEventWithTimestampImpl label payload
      >>> liftEffect
      >=> fromEffectFnAff
  where
    label ∷ String
    label = reflectSymbol (SProxy ∷ SProxy name)

foreign import logEventWithTimestampImpl
  ∷ ∀ payload. Uncurried.EffectFn3 String payload Int (EffectFnAff Status)

-- Log revenue with the revenue interface. The new revenue interface allows for
-- more revenue fields like 'revenueType' and event properties. See the [SDK
-- documentation](https://amplitude.zendesk.com/hc/en-us/articles/115001361248#tracking-revenue)
-- for more information on the Revenue interface and logging revenue.
logRevenueV2 ∷ Revenue → Effect Unit
logRevenueV2 = Uncurried.runEffectFn1 logRevenueV2Impl

foreign import logRevenueV2Impl ∷ Uncurried.EffectFn1 Revenue Unit

-- Regenerates a new random deviceId for the current user. _Note: This is not
-- recommended unless you know what you are doing_. This can be used in
-- conjunction with `setUserId(null)` to anonymize users after they log out.
-- The current user would appear as a brand new user in Amplitude if they have
-- a null userId and a completely new `deviceId`. This uses
-- [src/uuid.js](https://github.com/amplitude/Amplitude-Javascript/blob/master/src/uuid.js)
-- to regenerate the `deviceId`.
foreign import regenerateDeviceId ∷ Effect Unit

-- Sets a custom `deviceId` for the current user. Note: This is not recommended
-- unless you know what you are doing (e.g. you have your own system for
-- managing `deviceId`s). Make sure the `deviceId` you set is sufficiently
-- unique (we recommend something like a UUID - see
-- [src/uuid.js](https://github.com/amplitude/Amplitude-Javascript/blob/master/src/uuid.js)
-- for an example of how to generate) to prevent conflicts with other devices
-- in our system.
setDeviceId ∷ String → Effect Unit
setDeviceId = Uncurried.runEffectFn1 setDeviceIdImpl

foreign import setDeviceIdImpl
  ∷ Uncurried.EffectFn1 String Unit

-- Sets a custom domain for the Amplitude cookie. This is useful if you want to
-- support cross-subdomain tracking.
setDomain ∷ String → Effect Unit
setDomain = Uncurried.runEffectFn1 setDomainImpl

foreign import setDomainImpl ∷ Uncurried.EffectFn1 String Unit

-- Add a user to a group or groups. You will need to specify a `groupType` and
-- `groupName`(s). For example, you can group people by their organization, in
-- which case their `groupType` could be 'orgId' and their `groupName` would be
-- the actual ID(s). `groupName` can be a string or an array of strings to
-- indicate that a user is in multiple groups. You can also call `setGroup`
-- multiple times with different `groupType`s to track multiple types of groups
-- (up to five per app). _Note: This will also set 'groupType:groupName' as a
-- user property_. See the [SDK
-- installation](https://amplitude.zendesk.com/hc/en-us/articles/115001361248#setting-groups)
-- documentation for more information.
setGroup ∷ String → Array String → Effect Unit
setGroup = Uncurried.runEffectFn2 setGroupImpl

foreign import setGroupImpl ∷ Uncurried.EffectFn2 String (Array String) Unit

-- Sets whether to opt current user out of tracking.
setOptOut ∷ Boolean → Effect Unit
setOptOut = Uncurried.runEffectFn1 setOptOutImpl

foreign import setOptOutImpl
  ∷ Uncurried.EffectFn1 Boolean Unit

-- Sets an identifier for the current user.
setUserId ∷ String → Effect Unit
setUserId = Uncurried.runEffectFn1 setUserIdImpl

foreign import setUserIdImpl
  ∷ Uncurried.EffectFn1 String Unit

-- Sets user properties for the current user.
setUserProperties ∷ ∀ properties. { | properties } → Effect Unit
setUserProperties = Uncurried.runEffectFn1 setUserPropertiesImpl

foreign import setUserPropertiesImpl
  ∷ ∀ properties. Uncurried.EffectFn1 { | properties } Unit

-- Set a `versionName` for your application.
setVersionName ∷ String → Effect Unit
setVersionName = Uncurried.runEffectFn1 setVersionNameImpl

foreign import setVersionNameImpl
  ∷ Uncurried.EffectFn1 String Unit

-- Set a custom [Session
-- ID](https://amplitude.zendesk.com/hc/en-us/articles/115002323627#session-id)
-- for the current session. _Note: This is not recommended unless you know what
-- you are doing because the Session ID of a session is utilized for all
-- session metrics in Amplitude._
setSessionId ∷ Int → Effect Unit
setSessionId = Uncurried.runEffectFn1 setSessionIdImpl

foreign import setSessionIdImpl
  ∷ Uncurried.EffectFn1 Int Unit
