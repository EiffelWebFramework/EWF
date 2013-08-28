trigger_callback = (control_name,event)->
  $.ajax
    data:
      control_name: control_name
      event: event
      states: JSON.stringify(states)
    cache: no
  .done (new_states)->
    #Update all classes
    window.states = new_states
    for name,state of new_states
      controls[name]?.update(state)
    return

class WSF_CONTROL
  constructor: (@control_name, @$el)->
    @attach_events()
    return

  attach_events: ()->
    return

  update: (state)->
    return

controls = {}

class WSF_BUTTON_CONTROL extends WSF_CONTROL
  attach_events: ()->
    self = @
    @$el.click ()->
      self.click()
  click: ()->
    if window.states[@control_name]['callback_click']
      trigger_callback(@control_name, 'click')

  update: (state) ->
    @$el.text(state.text)

class WSF_TEXT_CONTROL extends WSF_CONTROL
  attach_events: ()->
    self = @
    @$el.change ()->
      self.change()
  change: ()->
    #update local state
    window.states[@control_name]['text'] = @$el.val()
    if window.states[@control_name]['callback_change']
      trigger_callback(@control_name, 'change')

  update: (state) ->
    @$el.val(state.text)

#map class name to effectiv class
typemap =
  "WSF_BUTTON_CONTROL":WSF_BUTTON_CONTROL
  "WSF_TEXT_CONTROL":WSF_TEXT_CONTROL

#create a js class for each control
for name,state of window.states
  #find control DOM element
  $el = $('[data-name='+name+']')
  #get control type
  type = $el.data('type')
  #create class
  if type? and typemap[type]?
    controls[name]=new typemap[type](name,$el)
   
