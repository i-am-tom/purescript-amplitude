# Amplitude Wrappers for PureScript

We write PureScript. We use [Amplitude](https://amplitude.com). Seemed sensible
to stick them together.

## API

The API (with the exception of logging) maps one-to-one with the [JavaScript
API](https://amplitude.zendesk.com/hc/en-us/articles/115002889587-JavaScript-SDK-Reference),
so you're probably best off checking there for up-to-date documentation.
However, when it comes to logging...

## Defining a Taxonomy

This library relies on *functional dependencies* to prevent some of the common
Amplitude pitfalls. In particular, we guarantee *no naming collisions* within
an event category.

To do this, whip up a new file for your taxonomy:

```purescript
module Acme.Taxonomy where

import Data.Amplitude.Tracking (class Taxonomy)

data Acme (title :: Symbol) = Acme
```

Your company, `Acme Corp`, wants to use Amplitude to track some of its
client-side events using PureScript code. To do so, you're going to need to
define some events and their structures. Because doing so would result in
orphan instances, we need to wrap the labels in some sort of proxy, which we'll
refer to as the _category_ (defined here as `Acme`). It's really just anything
that looks like an `SProxy` - don't worry too much about it.

Now, we need to specify some events. We do this by defining instances of the
`Taxonomy` class that state both the name of the event and the properties that
it should have. As an example, here are two events:

```purescript
instance acmePageView
  :: Taxonomy (Acme "viewed_page")
   -- Our event name ^

       { url :: String
       }
   -- Our event properties ^
```

Our `Taxonomy` class has a functional dependency from its first argument to its
second, meaning that any subsequent instance with the same label will be
disallowed by the compiler. However, we're free to define other events with
_different_ names:

```purescript
instance acmeFoobar :: Taxonomy (Acme "foobar")
  { baz  :: Number
  , quux :: Int
  }
```

To make things a little easier for our taxonomy users, I'd recommend making
some convenient values that they can use without having to worry about type
annotations:

```purescript
viewedAPage :: Acme "viewed_page"
viewedAPage = Acme

foobar :: Acme "foobar"
foobar = Acme
```

## Logging an Event

Now we have the taxonomy in place, logging an event is pretty straightforward.
As with the JavaScript API, we first need to `init` the Amplitude object before
doing anything. After that, we can call, for example, `logEvent foobar` and
PureScript will let us know what properties we need to apply.

Here's an abridged example from the `test` directory:

```purescript
main :: Effect Unit
main = launchAff_ do
  -- API key, custom user identifier, and configuration options.
  Amplitude.init "my-super-secret-amplitude-key" Nothing {}

  url <- liftEffect $ DOM.window >>= DOM.location >>= DOM.href
  Amplitude.logEvent Taxonomy.viewedAPage { url }
```
