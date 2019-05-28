module Data.Amplitude.Tracking where

import Data.Symbol (class IsSymbol, SProxy, reflectSymbol)
import Data.Maybe (Maybe)
import Data.Nullable (Nullable, toNullable)
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Aff.Compat (EffectFnAff, fromEffectFnAff)
import Effect.Class (liftEffect)
import Effect.Uncurried (EffectFn1, runEffectFn1, EffectFn2, runEffectFn2, EffectFn3, runEffectFn3, EffectFn4, runEffectFn4)
import Prelude

-- When dealing with Amplitude, we like our events to follow a given schema.
-- Data in Amplitude is, effectively, immutable, and having a common schema
-- among events of the same name means we'll be able to write more structured
-- queries. With this class, we can define the event "name" along with the
-- properties that it should have, and use this to assist type inference.
--
-- Note that, strictly speaking, you can include /any/ types in an Amplitude
-- event, but only the primitive types survive the trip. Note also that
-- Amplitude cares only about the JavaScript representation, so it is probably
-- best to stick to records of Int/String/Bool/Float. Note that nested records
-- are also flattened: `{ a: { b: 2 } }` becomes `{ "a.b": 2 }`, and so on.
--
-- ```
-- instance addUserEvent ∷ Topology "Play Song or Video"
--   { Content_ID   ∷ Int
--   , Content_Type ∷ String
--   , Duration     ∷ Int
--   , Genre_Type   ∷ String
--   , Source       ∷ Source
--   }
-- ```
class Topology (name ∷ Symbol) (structure ∷ # Type) | name → structure

newtype UserProperties = UserProperties {}
newtype Revenue = Revenue {}
newtype Config = Config {}
newtype Key = Key String
newtype UserId = UserId String
newtype Identify = Identify {}

type Status = { responseCode ∷ Int, responseBody ∷ String }

foreign import data AmplitudeClient ∷ Type

-- Get the current version of Amplitude's JavaScript SDK.
foreign import version ∷ String

-- Clear all of the user properties for the current user. This will wipe all of
-- the user's user properties and reset them.
--
-- _Note: Clearing user properties is irreversible! Amplitude will not be able
-- to sync the user's user property values before the wipe to any future events
-- that the user triggers as they will have been reset._
clearUserProperties ∷ AmplitudeClient → Effect Unit
clearUserProperties = runEffectFn1 clearUserPropertiesImpl

foreign import clearUserPropertiesImpl ∷ EffectFn1 AmplitudeClient Unit

-- Returns the ID of the current session.
getSessionId ∷ AmplitudeClient → Effect Int
getSessionId = runEffectFn1 getSessionIdImpl

foreign import getSessionIdImpl ∷ EffectFn1 AmplitudeClient Int

-- Send an identify call containing user property operations to Amplitude
-- servers. See the [JavaScript SDK
-- Installation](https://amplitude.zendesk.com/hc/en-us/articles/115001361248#setting-user-properties)
-- documentation for more information.
identify ∷ AmplitudeClient → Identify → Aff Status
identify client object
  = liftEffect (runEffectFn2 identifyImpl client object)
      >>= fromEffectFnAff

foreign import identifyImpl ∷ EffectFn2 AmplitudeClient Identify (EffectFnAff Status)

-- Initializes the Amplitude JavaScript SDK with your apiKey and any optional
-- configurations. This is required before any other methods can be called.
init ∷ Key → Maybe UserId → Maybe Config → Aff AmplitudeClient
init key userId config
  = liftEffect (runEffectFn3 initImpl key (toNullable userId) (toNullable config))
      >>= fromEffectFnAff

foreign import initImpl ∷ EffectFn3 Key (Nullable UserId) (Nullable Config) (EffectFnAff AmplitudeClient)

-- Returns true if a new session was created during initialization, otherwise
-- false.
isNewSession ∷ AmplitudeClient → Effect Boolean
isNewSession = runEffectFn1 isNewSessionImpl

foreign import isNewSessionImpl ∷ EffectFn1 AmplitudeClient Boolean

-- Log an event with a given topology. Consistency is ensured through types!
--
-- Somewhere in your code, you must define `Topology` instances for your
-- events:
--
-- ```
-- instance Topology "page_viewed" { url ∷ String, other_property ∷ Int }
-- ```
--
-- You can then define a function for logging this event:
--
-- ```
-- pageViewed ∷ { url ∷ String, other_property ∷ Int } → Aff Status
-- pageViewed = logEvent (SProxy ∷ SProxy "page_viewed")
-- ```
--
-- The `SProxy` enforces the type of the payload, making sure that our logging
-- for any given event is consistent throughout!
logEvent
  ∷ ∀ name payload. Topology name payload ⇒ IsSymbol name
  ⇒ AmplitudeClient → SProxy name → { | payload } → Aff Status
logEvent client label payload
  = liftEffect (runEffectFn3 logEventImpl client (reflectSymbol label) payload)
      >>= fromEffectFnAff

foreign import logEventImpl ∷ ∀ payload. EffectFn3 AmplitudeClient String payload (EffectFnAff Status)

-- Log an event with eventType, eventProperties, and a custom timestamp.
logEventWithTimestamp
  ∷ ∀ name payload. Topology name payload ⇒ IsSymbol name
  ⇒ AmplitudeClient → SProxy name → { | payload } → Int → Aff Status
logEventWithTimestamp client label payload timestamp
  = liftEffect (runEffectFn4 logEventWithTimestampImpl client (reflectSymbol label) payload timestamp)
      >>= fromEffectFnAff

foreign import logEventWithTimestampImpl ∷ ∀ payload. EffectFn4 AmplitudeClient String payload Int (EffectFnAff Status)

-- Log revenue with the revenue interface. The new revenue interface allows for
-- more revenue fields like 'revenueType' and event properties. See the [SDK
-- documentation](https://amplitude.zendesk.com/hc/en-us/articles/115001361248#tracking-revenue)
-- for more information on the Revenue interface and logging revenue.
logRevenueV2 ∷ AmplitudeClient → Revenue → Effect Unit
logRevenueV2 = runEffectFn2 logRevenueV2Impl

foreign import logRevenueV2Impl ∷ EffectFn2 AmplitudeClient Revenue Unit

-- Regenerates a new random deviceId for the current user. _Note: This is not
-- recommended unless you know what you are doing_. This can be used in
-- conjunction with `setUserId(null)` to anonymize users after they log out.
-- The current user would appear as a brand new user in Amplitude if they have
-- a null userId and a completely new `deviceId`. This uses
-- [src/uuid.js](https://github.com/amplitude/Amplitude-Javascript/blob/master/src/uuid.js)
-- to regenerate the `deviceId`.
regenerateDeviceId ∷ AmplitudeClient → Effect Unit
regenerateDeviceId = runEffectFn1 regenerateDeviceIdImpl

foreign import regenerateDeviceIdImpl ∷ EffectFn1 AmplitudeClient Unit

-- Sets a custom `deviceId` for the current user. Note: This is not recommended
-- unless you know what you are doing (e.g. you have your own system for
-- managing `deviceId`s). Make sure the `deviceId` you set is sufficiently
-- unique (we recommend something like a UUID - see
-- [src/uuid.js](https://github.com/amplitude/Amplitude-Javascript/blob/master/src/uuid.js)
-- for an example of how to generate) to prevent conflicts with other devices
-- in our system.
setDeviceId ∷ AmplitudeClient → String → Effect Unit
setDeviceId = runEffectFn2 setDeviceIdImpl

foreign import setDeviceIdImpl ∷ EffectFn2 AmplitudeClient String Unit

-- Sets a custom domain for the Amplitude cookie. This is useful if you want to
-- support cross-subdomain tracking.
setDomain ∷ AmplitudeClient → String → Effect Unit
setDomain = runEffectFn2 setDomainImpl

foreign import setDomainImpl ∷ EffectFn2 AmplitudeClient String Unit

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
setGroup ∷ AmplitudeClient → String → Array String → Effect Unit
setGroup = runEffectFn3 setGroupImpl

foreign import setGroupImpl ∷ EffectFn3 AmplitudeClient String (Array String) Unit

-- Sets whether to opt current user out of tracking.
setOptOut ∷ AmplitudeClient → Boolean → Effect Unit
setOptOut = runEffectFn2 setOptOutImpl

foreign import setOptOutImpl ∷ EffectFn2 AmplitudeClient Boolean Unit

-- Sets an identifier for the current user.
setUserId ∷ AmplitudeClient → String → Effect Unit
setUserId = runEffectFn2 setUserIdImpl

foreign import setUserIdImpl ∷ EffectFn2 AmplitudeClient String Unit

-- Sets user properties for the current user.
setUserProperties ∷ AmplitudeClient → UserProperties → Effect Unit
setUserProperties = runEffectFn2 setUserPropertiesImpl

foreign import setUserPropertiesImpl ∷ EffectFn2 AmplitudeClient UserProperties Unit

-- Set a `versionName` for your application.
setVersionName ∷ AmplitudeClient → String → Effect Unit
setVersionName = runEffectFn2 setVersionNameImpl

foreign import setVersionNameImpl ∷ EffectFn2 AmplitudeClient String Unit

-- Set a custom [Session
-- ID](https://amplitude.zendesk.com/hc/en-us/articles/115002323627#session-id)
-- for the current session. _Note: This is not recommended unless you know what
-- you are doing because the Session ID of a session is utilized for all
-- session metrics in Amplitude._
setSessionId ∷ AmplitudeClient → Int → Effect Unit
setSessionId = runEffectFn2 setSessionIdImpl

foreign import setSessionIdImpl ∷ EffectFn2 AmplitudeClient Int Unit
