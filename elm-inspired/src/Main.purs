module Main where

import Prelude (Unit, ($), bind, return, void)

import Control.Monad.Eff (Eff)
import Control.Monad.ST (ST, newSTRef, writeSTRef, readSTRef)
import Control.Timer (Timer())

import Signal (Signal, sampleOn, (<~), runSignal)
import Signal.DOM (animationFrame, mousePos)

import DOM (DOM)
import DOM.Node.Types (Node)

import VirtualDOM (VNode, diff, patch, createElement, circle, svg)

main :: forall e h. Eff (st :: ST h, timer :: Timer, dom :: DOM | e) Unit
main = do
  mouse <- mousePos
  runUI $ render <~ mouse
  where
  render pos =
    svg { width: "100%", height: "100%" }
        [ circle {cx: pos.x, cy: pos.y, r: 20, fill: "lime"} []
        ]

data UIState
  = Unmounted
  | Mounted Node VNode

runUI :: forall e. Signal VNode -> (forall h. Eff (st :: ST h, timer :: Timer, dom :: DOM | e) Unit)
runUI ui = do
  uiStateRef <- newSTRef Unmounted
  animation <- animationFrame
  runSignal $ update uiStateRef <~ sampleOn animation ui
  where
  update uiStateRef current = void do
    uiState <- readSTRef uiStateRef
    node <- mountOrPatch uiState current
    writeSTRef uiStateRef (Mounted node current)
  mountOrPatch Unmounted current = do
    node <- createElement current
    appendToBody node
    return node
  mountOrPatch (Mounted node previous) current =
    patch node (diff previous current)

foreign import appendToBody :: forall eff. Node -> Eff (dom :: DOM | eff) Unit
