React = require 'react'
counterpart = require 'counterpart'
Translate = require 'react-translate-component'
PromiseRenderer = require '../../components/promise-renderer'
ImageSelector = require '../../components/image-selector'
apiClient = require 'panoptes-client/lib/api-client'
putFile = require '../../lib/put-file'

counterpart.registerTranslations 'en',
  avatar:
    change: 'Change avatar'
    note: 'Drop an image here (square, less than '
    clickArea: 'Drop an image here (or click to select).'
    clear: 'Clear avatar'
  header:
    change: 'Change profile header'
    note: 'Drop an image here (any dimensions, less than '
    clickArea: 'Drop an image here (or click to select).'    
    clear: 'Clear header'

counterpart.registerTranslations 'es',
  avatar:
    change: 'Cambiar avatar'
    note: 'Arrastrá y soltá una imagen aquí (cuadrada, menor que '
    clickArea: 'Arrastrá y soltá una imagen aquí (o hacé click para seleccionar una).'
    clear: 'Remover avatar'
  header:
    change: 'Cambiar foto de encabezado'
    note: 'Arrastrá y soltá una imagen aquí (cualquier dimensión, menor que '
    clickArea: 'Arrastrá y soltá una imagen aquí (o hacé click para seleccionar una).'    
    clear: 'Remover encabezado'    


MAX_AVATAR_SIZE = 65536
MAX_HEADER_SIZE = 256000

module.exports = React.createClass
  displayName: 'CustomizeProfilePage'

  getDefaultProps: ->
    user: null

  getInitialState: ->
    avatarError: null
    headerError: null

  render: ->
    @avatarGet ?= @props.user.get 'avatar', {}
      .then ([avatar]) ->
        avatar
      .catch ->
        null
    @profile_headerGet ?= @props.user.get 'profile_header', {}
      .then ([header]) ->
        header
      .catch ->
        null

    <div>
      <div className="content-container">
        <h3><Translate content="avatar.change" /></h3>
        <PromiseRenderer promise={@avatarGet}>{(avatar) =>
          placeholder = <p className="content-container"><Translate content="avatar.clickArea" /></p>
          <div>
            <p className="form-help"><Translate content="avatar.note" />{Math.floor MAX_AVATAR_SIZE / 1000} KB)</p>
            <div style={width: '20vw'}>
              <ImageSelector maxSize={MAX_AVATAR_SIZE} ratio={1} src={avatar?.src} placeholder={placeholder} onChange={@handleMediaChange.bind(this, 'avatar')} />
            </div>
            <div>
              <button type="button" disabled={avatar is null} onClick={@handleMediaClear.bind(this, 'avatar')}><Translate content="avatar.clear" /></button>
            </div>
          </div>
        }</PromiseRenderer>
        {if @state.avatarError
          <div className="form-help error">{@state.avatarError.toString()}</div>}
      </div>
      <hr />
      <div className="content-container">
        <h3><Translate content="header.change" /></h3>
        <PromiseRenderer promise={@profile_headerGet}>{(header) =>
          placeholder = <p className="content-container"><Translate content="header.clickArea" /></p>
          <div>
            <p className="form-help"><Translate content="header.note" />{Math.floor MAX_HEADER_SIZE / 1000} KB)</p>
            <div style={width: '40vw'}>
              <ImageSelector maxSize={MAX_HEADER_SIZE} src={header?.src} placeholder={placeholder} onChange={@handleMediaChange.bind(this, 'profile_header')} />
            </div>
            <div>
              <button type="button" disabled={header is null} onClick={@handleMediaClear.bind(this, 'profile_header')}><Translate content="header.clear" /></button>
            </div>
          </div>
        }</PromiseRenderer>
        {if @state.headerError
          <div className="form-help error">{@state.headerError.toString()}</div>}
      </div>
    </div>

  handleMediaChange: (type, file) ->
    errorProp = "#{type}Error"

    newState = {}
    newState[errorProp] = null
    @setState newState

    apiClient.post @props.user._getURL(type), media: content_type: file.type
      .then ([resource]) =>
        putFile resource.src, file, {'Content-Type': file.type}
      .then =>
        @["#{type}Get"] = null # Uncache the local request so that rerendering makes it again.
        @forceUpdate()
      .catch (error) =>
        newState = {}
        newState[errorProp] = error
        @setState newState

  handleMediaClear: (type) ->
    errorProp = "#{type}Error"

    newState = {}
    newState[errorProp] = null
    @setState newState

    @["#{type}Get"]
      .then (resource) =>
        resource?.delete()
      .then =>
        @["#{type}Get"] = null
        @forceUpdate()
      .catch (error) =>
        newState = {}
        newState[errorProp] = error
        @setState newState
