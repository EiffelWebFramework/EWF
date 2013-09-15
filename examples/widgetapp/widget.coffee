cache = {}
template  = tmpl = (str, data) ->
  # Simple JavaScript Templating
  # John Resig - http://ejohn.org/ - MIT Licensed
  fn = (if not /\W/.test(str) then cache[str] = cache[str] or tmpl(str) else new Function("obj", "var p=[],print=function(){p.push.apply(p,arguments);};" + "with(obj){p.push('" + str.replace(/[\r\t\n]/g, " ").split("{{").join("\t").replace(/((^|}})[^\t]*)'/g, "$1\r").replace(/\t=(.*?)}}/g, "',$1,'").split("\t").join("');").split("}}").join("p.push('").split("\r").join("\\'") + "');}return p.join('');"))
  (if data then fn(data) else fn)

Mini =
  compile:(t)->
    {
      render:template(t)
    }

trigger_callback = (control_name,event,event_parameter)->
  $.ajax
    data:
      control_name: control_name
      event: event
      event_parameter: event_parameter
      states: JSON.stringify(window.states)
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

class WSF_MIN_VALIDATOR extends WSF_VALIDATOR

  validate: ()->
    val = @parent_control.value()
    return (val.length>=@settings.min)

class WSF_MAX_VALIDATOR extends WSF_VALIDATOR

  validate: ()->
    val = @parent_control.value()
    return (val.length<=@settings.max)

validatormap =
  "WSF_REGEXP_VALIDATOR":WSF_REGEXP_VALIDATOR
  "WSF_MIN_VALIDATOR":WSF_MIN_VALIDATOR
  "WSF_MAX_VALIDATOR":WSF_MAX_VALIDATOR

class WSF_CONTROL
  constructor: (@control_name, @$el)->
    return

  attach_events: ()->
    return

  update: (state)->
    return 

  #Simple event listener

  #subscribe to an event
  on: (name, callback, context)->
    if not @_events?
      @_events = {}
    if not @_events[name]?
      @_events[name] = []
    @_events[name].push({callback:callback,context:context})
    return @

  #trigger an event
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

class WSF_TEXTAREA_CONTROL extends WSF_INPUT_CONTROL

class WSF_AUTOCOMPLETE_CONTROL extends WSF_INPUT_CONTROL
  attach_events: () ->
    self = @
    @$el.typeahead({
      name: @control_name
      template: window.states[@control_name]['template']
      engine: Mini
      remote:
        url:""
        replace: (url, uriEncodedQuery) ->
            window.states[self.control_name]['text'] = self.$el.val()
            '?' + $.param
                      control_name: self.control_name
                      event: 'autocomplete'
                      states: JSON.stringify(window.states)
        filter: (parsedResponse) ->
            parsedResponse[self.control_name]['suggestions']
    })
    @$el.on 'typeahead:closed',()->
        self.change() 
    @$el.on 'typeahead:blured',()->
        self.change() 

class WSF_CHECKBOX_CONTROL extends WSF_CONTROL
  attach_events: ()->
    self = @
    @checked_value = window.states[@control_name]['checked_value']
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
      #subscribe to change event on value_control
      @value_control.on('change',@change,@)
    @serverside_validator = false
    #Initialize validators
    @validators = []
    for validator in window.states[@control_name]['validators']
      if validatormap[validator.name]?
        @validators.push new validatormap[validator.name](@,validator)
      else
        #Use serverside validator if no js implementation
        @serverside_validator = true
    return

  #value_control changed run validators
  change: ()->
    for validator in @validators
      if not validator.validate()
        @showerror(validator.error)
        return
    @showerror("")
    #If there is validator which is not implemented in js ask server to validate
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

class WSF_HTML_CONTROL extends WSF_CONTROL

  value:()->
    return @$el.html()

  update: (state) ->
    if state.html?
      window.states[@control_name]['html'] = state.html
      @$el.html(state.html)

class WSF_CHECKBOX_LIST_CONTROL extends WSF_CONTROL

  attach_events: ()->
    self = @
    @subcontrols = []
    #Listen to events of subelements and forward them
    for name,control of controls
      if @$el.has(control.$el).length > 0
        @subcontrols.push(control)
        control.on('change',@change,@)
    return
 
  change:()->
    @trigger("change")

  value:()->
    result = []
    for subc in @subcontrols
      if subc.value()
        result.push(subc.checked_value)
    return result

class WSF_PROGRESS_CONTROL extends WSF_CONTROL

  update: (state)->
    if state.progress?
      window.states[@control_name]['progress'] = state.progress
      $('#' + @control_name).children('.progress-bar').attr('aria-valuenow', state.progress).width(state.progress + '%')

class WSF_PAGINATION_CONTROL extends WSF_CONTROL
  attach_events: ()->
    self = @
    @$el.on 'click', 'a', (e)->
      e.preventDefault()
      self.click(e)

  click: (e)->
    nr = $(e.target).data('nr')
    if nr == "next"
      trigger_callback(@control_name, "next")
    else if nr == "prev"
      trigger_callback(@control_name, "prev")
    else
      trigger_callback(@control_name, "goto", nr)

  update: (state) ->
    if state._html?
      @$el.html($(state._html).html())

class WSF_GRID_CONTROL extends WSF_CONTROL
  attach_events: ()->
    self = @

  update: (state) ->
    if state.datasource?
      window.states[@control_name]['datasource'] = state.datasource
    if state._body?
      @$el.find('tbody').html(state._body)

class WSF_REPEATER_CONTROL extends WSF_CONTROL
  attach_events: ()->
    self = @

  update: (state) ->
    if state.datasource?
      window.states[@control_name]['datasource'] = state.datasource
    if state._body?
      @$el.find('.repeater_content').html(state._body)
      console.log state._body

#map class name to effective class
typemap =
  "WSF_BUTTON_CONTROL": WSF_BUTTON_CONTROL
  "WSF_INPUT_CONTROL": WSF_INPUT_CONTROL
  "WSF_TEXTAREA_CONTROL": WSF_TEXTAREA_CONTROL
  "WSF_AUTOCOMPLETE_CONTROL": WSF_AUTOCOMPLETE_CONTROL
  "WSF_CHECKBOX_CONTROL": WSF_CHECKBOX_CONTROL
  "WSF_FORM_ELEMENT_CONTROL": WSF_FORM_ELEMENT_CONTROL
  "WSF_HTML_CONTROL": WSF_HTML_CONTROL
  "WSF_CHECKBOX_LIST_CONTROL": WSF_CHECKBOX_LIST_CONTROL
  "WSF_PROGRESS_CONTROL": WSF_PROGRESS_CONTROL
  "WSF_PAGINATION_CONTROL": WSF_PAGINATION_CONTROL
  "WSF_GRID_CONTROL": WSF_GRID_CONTROL
  "WSF_REPEATER_CONTROL":WSF_REPEATER_CONTROL

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
   
