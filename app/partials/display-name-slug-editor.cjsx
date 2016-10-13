counterpart = require 'counterpart'
React = require 'react'
Translate = require 'react-translate-component'
AutoSave = require '../components/auto-save'
PromiseRenderer = require '../components/promise-renderer'
handleInputChange = require '../lib/handle-input-change'

counterpart.registerTranslations 'en',
  resource:
    name: 'Name'
    warn:
      changing: 'You’re changing the url of your '
      noLongerWork: '. Users with bookmarks and links in talk will no longer work. '
      undo: 'Undo'

counterpart.registerTranslations 'es',
  resource:
    name: 'Nombre'
    warn:
      changing: 'Estás cambiando la URL de tu '
      noLongerWork: '. Usuarios con marcadores y links en los foros dejarán de funcionar. '
      undo: 'Deshacer'      

module.exports = React.createClass
  displayName: "DisplayNameSlugEditor"

  getDefaultProps: ->
    disabled: false
    resource: {}

  getInitialState: ->
    currentSlug: @props.resource?.slug
    currentName: @props.resource?.display_name

  warnURLChange: ->
    @props.resource.slug isnt @state.currentSlug and @state.currentSlug.match(/untitled-project/i) is null

  resourceURL: ->
    @props.resource.get('owner')
      .then (owner) =>
        "/#{@props.resourceType}s/#{@props.resource.slug}"

  undoNameChange: ->
    @props.resource.update display_name: @state.currentName
    @props.resource.save()

  render: ->
    <p>
      <AutoSave resource={@props.resource}>
        <span className="form-label"><Translate content="resource.name" /></span>
        <br />
        <input type="text" className="standard-input full" name="display_name" value={@props.resource.display_name} onChange={handleInputChange.bind @props.resource} disabled={@props.disabled or @props.resource.live}/>
      </AutoSave>

      {if @warnURLChange()
        <small className="form-help"><Translate content="resource.warn.changing" />{@props.resourceType}<Translate content="resource.warn.noLongerWork" /><button type="button" onClick={@undoNameChange}><Translate content="resource.warn.undo" /></button></small>
      }

      <PromiseRenderer promise={@resourceURL()} pending={null}>{(url) =>
        <small className="form-help">
          {if @props.resource.live
            "No es posible cambiar el nombre de un #{@props.resourceType} en vivo."
          else
            "El nombre del #{@props.resourceType} es lo primero que los usuarios van a ver sobre el #{@props.resourceType}, y aparecerá en la URL del mismo. Lo mejor es que sea breve y conciso."}
        </small>
      }</PromiseRenderer>
    </p>
