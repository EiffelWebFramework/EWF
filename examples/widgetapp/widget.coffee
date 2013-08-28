trigger_callback = (control_name,event)->
  $.ajax
    data:
      control_name: control_name
      event:        event
    cache: no
  .done (new_states)->
    #Update all classes
    for name,state of new_states
      controls[name]?.update(state)
    states = new_states
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
    trigger_callback(@control_name, 'click')

  update: (state) ->
    @$el.text(state.text)

#map class name to effectiv class
typemap =
  "WSF_BUTTON_CONTROL":WSF_BUTTON_CONTROL

#create a js class for each control
for name,state of states
  #find control DOM element
  $el = $('[data-name='+name+']')
  #get control type
  type = $el.data('type')
  #create class
  if type? and typemap[type]?
    controls[name]=new typemap[type](name,$el)
   
