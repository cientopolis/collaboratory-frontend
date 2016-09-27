counterpart = require 'counterpart'
React = require 'react'
Translate = require 'react-translate-component'
PromiseRenderer = require '../components/promise-renderer'
apiClient = require 'panoptes-client/lib/api-client'
moment = require 'moment'
Translate = require 'react-translate-component'

counterpart.registerTranslations 'en',
  csv: "CSV format."
  mostRecent: 'Most recent data available requested'
  processing: 'Processing your request.'
  never: 'Never requested.'
  received: 'We’ve received your request, check your email for a link to your data soon!'

counterpart.registerTranslations 'es',
  csv: "formato CSV."
  mostRecent: 'Datos solicitados más recientes'
  processing: 'Procesando su solicitud.'
  never: 'Nunca solicitado.'
  received: 'Recibimos su petición. Revisá tu casilla de correo pronto para obtener el link de descarga'

module.exports = React.createClass
  displayName: 'DataExportButton'

  getDefaultProps: ->
    contentType: 'text/csv'
    newFeature: false

  getInitialState: ->
    exportRequested: false
    exportError: null

  exportGet: ->
    @_exportsGet or= @props.project.get(@props.exportType).catch( -> [])

  requestDataExport: ->
    @setState exportError: null
    apiClient.post @props.project._getURL(@props.exportType), media: content_type: @props.contentType
      .then =>
        @_exportsGet = null
        @setState exportRequested: true
      .catch (error) =>
        @setState exportError: error

  recentAndReady: (exported) ->
    exported? and (exported.metadata.state is 'ready' or not exported.metadata.state?)

  pending: (exported) ->
    exported?

  render: ->
    <div>
      { if @props.newFeature
        <i className="fa fa-cog fa-lg fa-fw"></i> }
      <button type="button" disabled={@state.exportRequested} onClick={@requestDataExport}>
        <Translate content={@props.buttonKey} />
      </button> {' '}
      <small className="form-help">
        <Translate content="csv" />{' '}
        <PromiseRenderer promise={@exportGet()}>{([mostRecent]) =>
          if @recentAndReady(mostRecent)
            <span>
              <Translate content="mostRecent" />{' '}
              <a href={mostRecent.src}>{moment(mostRecent.updated_at).fromNow()}</a>.
            </span>
          else if @pending(mostRecent)
            <span>
              <Translate content="processing" />
            </span>
          else
            <span><Translate content="never" /></span>
        }</PromiseRenderer>
        <br />
      </small>

      {if @state.exportError?
         <div className="form-help error">{@state.exportError.toString()}</div>
       else if @state.exportRequested
         <div className="form-help success">
           <Translate content="received" />
         </div>}
    </div>
