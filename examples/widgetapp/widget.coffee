trigger_callback = (control_name,event)->
  $.ajax
    data:
      control_name: control_name
      event: event
      states: JSON.stringify(states)
    cache: no
  .done (new_states)->
    #Update all classes
    for name,state of new_states
      controls[name]?.update(state)
    return
class WSF_VALIDATOR
  constructor: (@parent_control, @settings)->
    @error = @settings.error
    return

  validate: ()->
    return true

class WSF_REGEXP_VALIDATOR extends WSF_VALIDATOR
  constructor: ()->
    super
    @pattern = new RegExp(@settings.expression,'g')

  validate: ()->
    val = @parent_control.value()
    res = val.match(@pattern)
    return (res!=null)

validatormap =
  "WSF_REGEXP_VALIDATOR":WSF_REGEXP_VALIDATOR

class WSF_CONTROL
  constructor: (@control_name, @$el)->
    return

  attach_events: ()->
    return

  update: (state)->
    return 

  #Simple event listener
  on: (name, callback, context)->
    if not @_events?
      @_events = {}
    if not @_events[name]?
      @_events[name] = []
    @_events[name].push({callback:callback,context:context})
    return @

  trigger: (name)->
    if not @_events?[name]?
      return @
    for ev in @_events[name]
      ev.callback.call(ev.context)
    return @


controls = {}

class WSF_BUTTON_CONTROL extends WSF_CONTROL
  attach_events: ()->
    self = @
    @$el.click (e)->
      e.preventDefault()
      self.click()
  click: ()->
    if window.states[@control_name]['callback_click']
      trigger_callback(@control_name, 'click')

  update: (state) ->
    if state.text?
      window.states[@control_name]['text'] = state.text
      @$el.text(state.text)

class WSF_INPUT_CONTROL extends WSF_CONTROL
  attach_events: ()->
    self = @
    @$el.change ()->
      self.change()

  change: ()->
    #update local state
    window.states[@control_name]['text'] = @$el.val()
    if window.states[@control_name]['callback_change']
      trigger_callback(@control_name, 'change')
    @trigger('change')

  value:()->
    return @$el.val()

  update: (state) ->
    if state.text?
      window.states[@control_name]['text'] = state.text
      @$el.val(state.text)

class WSF_TEXTAREA_CONTROL extends WSF_CONTROL
  attach_events: () ->
    self = @
    @$el.change () ->
      self.change()

  change: () ->
    window.states[@control_name]['text'] = @$el.val()
    if window.states[@control_name]['callback_change']
      trigger_callback(@control_name, 'change')
    @trigger('change')

  value:()->
    return @$el.val()

  update: (state) ->
    if state.text?
      window.states[@control_name]['text'] = state.text
      @$el.val(state.text)

class WSF_CHECKBOX_CONTROL extends WSF_CONTROL
  attach_events: ()->
    self = @
    @$el.change ()->
      self.change()

  change: ()->
    #update local state
    window.states[@control_name]['checked'] = @$el.is(':checked')
    if window.states[@control_name]['callback_change']
      trigger_callback(@control_name, 'change')
    @trigger('change')

  value:()->
    return @$el.is(':checked')

  update: (state) ->
    if state.text?
      window.states[@control_name]['checked'] = state.checked
      @$el.prop('checked',state.checked)

class WSF_FORM_ELEMENT_CONTROL extends WSF_CONTROL
  attach_events: ()->
    self = @
    @value_control = controls[window.states[@control_name]['value_control']]
    if @value_control?
      @value_control.on('change',@change,@)
    @serverside_validator = false
    @validators = []
    for validator in window.states[@control_name]['validators']
      if validatormap[validator.name]?
        @validators.push new validatormap[validator.name](@,validator)
      else
        #Use serverside validator if no js implementation
        @serverside_validator = true
    return

  change: ()->
    for validator in @validators
      if not validator.validate()
        @showerror(validator.error)
        return
    @showerror("")
    if @serverside_validator
      trigger_callback(@control_name, 'validate')
    return

  showerror: (message)->
    @$el.removeClass("has-error")
    @$el.find(".validation").remove()
    if message.length>0
      @$el.addClass("has-error")
      errordiv = $("<div />").addClass('help-block').addClass('validation').text(message)
      @$el.find(".col-lg-10").append(errordiv)

  update: (state) ->
    if state.error?
      @showerror(state.error)

  value: ()->
    @value_control.value()

#map class name to effective class
typemap =
  "WSF_BUTTON_CONTROL":WSF_BUTTON_CONTROL
  "WSF_INPUT_CONTROL":WSF_INPUT_CONTROL
  "WSF_TEXTAREA_CONTROL":WSF_TEXTAREA_CONTROL
  "WSF_CHECKBOX_CONTROL":WSF_CHECKBOX_CONTROL
  "WSF_FORM_ELEMENT_CONTROL": WSF_FORM_ELEMENT_CONTROL

#create a js class for each control
for name,state of window.states
  #find control DOM element
  $el = $('[data-name='+name+']')
  #get control type
  type = $el.data('type')
  #create class
  if type? and typemap[type]?
    controls[name]=new typemap[type](name,$el)
for name,state of window.states
  controls[name]?.attach_events()
   
