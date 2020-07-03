import React from "react"
import Clock from "./Clock"

const ClockFace = (props) => {
  let style

  if ($.isEmptyObject(props)) {
    style = { width: "600px", height: "200px" }
  } else {
    style = { ...props }
  }
  style.position = "relative"

  return (
    <div style={style}>
      <Clock />
    </div>
  )
}

export default ClockFace
