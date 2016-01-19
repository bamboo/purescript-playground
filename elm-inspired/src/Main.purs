module Main where
import Prelude
import Control.Monad.Eff
import Control.Monad.ST
import Control.Timer (Timer())

import Signal
import Signal.DOM

import Data.Nullable
import Data.Maybe

import DOM
import DOM.HTML as H
import DOM.HTML.Document as H
import DOM.HTML.Types as H
import DOM.HTML.Window as H
import DOM.Node.Node as H
import DOM.Node.Types as H

import VirtualDOM

main :: forall e h. Eff (st :: ST h, timer :: Timer, dom :: DOM | e) Unit
main = do
  mouse <- mousePos
  runUI $ render <~ mouse
  where
  render pos =
    svg {width: "100%", height: "100%"}
        [ circle {cx: pos.x, cy: pos.y, r: 20, fill: "lime"} []
        ]

data UIState
  = Unmounted
  | Mounted H.Node VNode

runUI :: forall e. Signal VNode -> (forall h. Eff (st :: ST h, timer :: Timer, dom :: DOM | e) Unit)
runUI ui = do
  uiStateRef <- newSTRef Unmounted
  animation <- animationFrame
  runSignal $ update uiStateRef <$> sampleOn animation ui
  where
  update uiStateRef current = void do
    uiState <- readSTRef uiStateRef
    node <- mountOrPatch uiState current
    writeSTRef uiStateRef (Mounted node current)
  mountOrPatch Unmounted current = do
    node <- createElement current
    appendToBody node
    return node
  mountOrPatch (Mounted node previous) current = do
    patch node (diff previous current)
    return node

appendToBody :: forall eff. H.Node -> Eff (dom :: DOM | eff) (Maybe H.Node)
appendToBody node = do
  maybeBody <- toMaybe <$> (H.window >>= H.document >>= H.body)
  case maybeBody of
    Just body -> Just <$> (H.htmlElementToNode body # H.appendChild node)
    _         -> return Nothing
