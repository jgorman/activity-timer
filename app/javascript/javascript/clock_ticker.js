/*
 * Run the global timer clock ticker.
 */

/*
 * TODO: recover from missed returns or server down every 60 seconds.
 * TODO: action cable?
 * TODO: react clock?
 */

import Rails from '@rails/ujs'
import { sprintf } from 'sprintf-js'

const tick_interval = 1000
const ticks_per_get = 5

let start_time = undefined
let current_timer = undefined
let getting_timer = false
let get_id = 0
let last_page_timer_id = undefined

// Run the global ticker forever.
$(() => {
  global_ticker()
  setInterval(global_ticker, tick_interval)
})

const global_ticker = () => {
  show_time()
  call_home()
}

// GET the current timer.
const call_home = () => {
  get_id++
  const getting_id = get_id

  // If the clock has not changed, don't query the server every time.
  const page_timer_id = $('#timer_id').html()
  if (last_page_timer_id === page_timer_id) {
    if (getting_id % ticks_per_get !== 0) {
      // console.log(`xxxxx global_ticker ${getting_id} skipping get`)
      return
    }
  } else {
    // console.log(`yyyyy global_ticker ${getting_id} NOT skipping get`)
  }
  last_page_timer_id = page_timer_id

  // Serialize overlapping requests when things get slow.
  if (getting_timer) {
    console.log(`<<<<< global_ticker ${getting_id} COLLISION AVOIDANCE`)
    return
  }
  getting_timer = true

  console.log(`<<<<< global_ticker ${getting_id}`)
  Rails.ajax({
    url: '/timer.json',
    type: 'GET',

    success: timer => {
      // console.log(`>>>>> global_ticker ${getting_id}`, timer)
      new_timer(timer)
    },

    complete: () => {
      // console.log(`>>>>> global_ticker ${getting_id} complete.`)
      getting_timer = false
    },
  })
}

const new_timer = timer => {
  start_time = timer ? Date.parse(timer.start) : undefined

  if (current_timer && timer) {
    // Has the timer changed?
    if (current_timer.id !== timer.id) {
      console.log('===== id', { current_timer, timer })
      // New timer. Probably saved an activity. Replace page.
      replace_page()
    } else if (
      current_timer.name !== timer.name ||
      current_timer.project_id !== timer.project_id
    ) {
      console.log('===== name', { current_timer, timer })
      // The name or project changed. Replace clock.
      replace_clock()
    } else {
      // console.log('===== unchanged', { current_timer, timer })
    }
  } else if (current_timer && !timer) {
    console.log('===== disappeared', { current_timer, timer })
    // The timer disappeared. Probably saved an activity. Replace page.
    replace_page()
    erase_time()
  } else if (!current_timer && timer) {
    console.log('===== appeared', { current_timer, timer })
    // A new timer appeared. Replace clock.
    replace_clock()
    show_time()
  } else if (!current_timer && !timer) {
    // console.log('===== nothn', { current_timer, timer })
    // No timer. Nothing to do.
  }

  current_timer = timer
}

const show_time = () => {
  if (!start_time) return
  // console.log('~~~~~ show_time')
  const elapsed = Date.now() - start_time
  const elapsed_s = format_ms(elapsed)
  document.title = elapsed_s
  $('#nav-timer-link').html(elapsed_s)
  $('#ticker').html(elapsed_s)
}

const erase_time = () => {
  console.log('~~~~~ erase_time')
  document.title = 'Timer'
  $('#nav-timer-link').html('Timer')
  $('#ticker').html('')
}

const replace_clock = () => {
  console.log('^^^^^ replace_clock')
  Rails.ajax({
    url: '/timer/replace_clock.js',
    type: 'GET',
    success: data => {
      // console.log('CCCCC ajax.replace_clock', data)
    },
  })
}

const replace_page = () => {
  console.log('^^^^^ replace_page')
  Rails.ajax({
    url: '/timer/replace_page.js',
    type: 'GET',
    success: data => {
      // console.log('CCCCC ajax.replace_page', data)
    },
  })
}

const format_ms = ms => {
  const seconds = ms / 1000
  const hh = seconds / (60 * 60)
  const mm = (seconds / 60) % 60
  const ss = seconds % 60
  return sprintf('%d:%02d:%02d', hh, mm, ss)
}
