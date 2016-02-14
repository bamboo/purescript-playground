module VirtualDOM where

import Prelude

import Control.Monad.Eff

import DOM
import DOM.Node.Types

foreign import data VNode :: *

foreign import data Patch :: *

foreign import vnode :: forall attrs. String -> {|attrs} -> Array VNode -> VNode

foreign import vtext :: String -> VNode

foreign import diff :: VNode -> VNode -> Patch

foreign import patch :: forall eff. Node -> Patch -> Eff (dom :: DOM | eff) Node

foreign import createElement :: forall eff. VNode -> Eff (dom :: DOM | eff) Node

-- | Smart constructor for SVG nodes.
foreign import snode :: forall attrs. String -> {|attrs} -> Array VNode -> VNode

type SvgConstructor = forall attrs. {|attrs} -> Array VNode -> VNode

svg :: SvgConstructor
svg = snode "svg"

circle :: SvgConstructor
circle = snode "circle"

rect :: SvgConstructor
rect = snode "rect"
