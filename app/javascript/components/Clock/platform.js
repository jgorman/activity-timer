/* Platform specific functions. */

import React from "react"

import { defaultState, mergeOldState, SETTINGS_KEY } from "./appstate"

export const isNative = false

export const clockRef = React.createRef()

export const bootState = () => {
  const initialState = mergeOldState(defaultState(), getOldState())
  initialState.date = new Date()
  return initialState
}

export const bootClock = () => {}

export const keepState = (state) => saveState(mergeOldState({}, state))

// Save state in browser storage.
const saveState = (state) => {
  const settings = JSON.stringify(state)
  localStorage.setItem(SETTINGS_KEY, settings)
}

// Get state from browser storage.
const getOldState = () => {
  try {
    const settings = localStorage.getItem(SETTINGS_KEY)
    if (settings) {
      return JSON.parse(settings)
    }
  } catch (err) {}
  return {} // Discard missing or corrupted old state.
}

// Viewport dimensions.
export const getViewPort = () => {
  const clock = clockRef.current
  if (clock) {
    return [clock.clientWidth, clock.clientHeight]
  }
}
