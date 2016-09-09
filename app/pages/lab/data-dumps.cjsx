React = require 'react'
handleInputChange = require '../../lib/handle-input-change'
PromiseRenderer = require '../../components/promise-renderer'
apiClient = require 'panoptes-client/lib/api-client'
counterpart = require 'counterpart'
Translate = require 'react-translate-component'
DataExportButton = require '../../partials/data-export-button'
TalkDataExportButton = require '../../talk/data-export-button'
isAdmin = require '../../lib/is-admin'

counterpart.registerTranslations 'en',
  projectDetails:
    classificationExport: "Request new classification export"
    aggregationExport: "Experimental - Request new aggregation export"
    subjectExport: "Request new subject export"
    workflowExport: "Request new workflow export"
    workflowContentsExport: "Request new workflow contents export"
  export:
    label: 'Project data exports'
    note: 'Please note that we will process at most 1 of each export within a 24 hour period and some exports may take a long time to process. We will email you when they are ready.'
  projectLabel: 'Project data'
  talk:
    label: 'Talk data'
    comments: 'Request new Talk comments export'
    tags: 'Request new Talk tags export'

counterpart.registerTranslations 'es',
  projectDetails:
    classificationExport: "Solicitar exportar clasificaciones"
    aggregationExport: "Experimental - Solicitar exportar agregaciones"
    subjectExport: "Solicitar exportar conjuntos de análisis"
    workflowExport: "Solicitar exportar flujos de trabajo"
    workflowContentsExport: "Solicitar exportar contenido de los flujos de trabajo"
  export:
    label: 'Exportar contenido del proyecto'
    note: 'Tenga en cuenta que se procesará como mucho uno de cada tipo de exportación en un período de 24hs, y algunos de estas exportaciones pueden tomar un tiempo en completarse. Le enviaremos un correo electrónico cuando estén listos.'
  projectLabel: 'Datos del proyecto'
  talk:
    label: 'Contenido de los foros de discusión'
    comments: 'Solicitar exportar comentarios'
    tags: 'Solicitar exportar etiquetas (tags)'


module.exports = React.createClass
  displayName: 'GetDataExports'

  getDefaultProps: ->
    project: {}

  getInitialState: ->
    avatarError: null
    backgroundError: null

  render: ->
    <div className="data-exports">
      <p className="form-label"><Translate content="export.label" /></p>
      <p className="form-help"><Translate content="export.note" /></p>
      <div className="columns-container">
        <div>
          <Translate content="projectLabel" /><br />
          <div className="row">
            <DataExportButton
              project={@props.project}
              buttonKey="projectDetails.classificationExport"
              exportType="classifications_export"  />
          </div>
          <div className="row">
            <DataExportButton
              project={@props.project}
              buttonKey="projectDetails.subjectExport"
              exportType="subjects_export"  />
          </div>
          <div className="row">
            <DataExportButton
              project={@props.project}
              buttonKey="projectDetails.workflowExport"
              exportType="workflows_export"  />
          </div>
          <div className="row">
            <DataExportButton
              project={@props.project}
              buttonKey="projectDetails.workflowContentsExport"
              exportType="workflow_contents_export"  />
          </div>
           <div className="row">
            <DataExportButton
              project={@props.project}
              buttonKey="projectDetails.aggregationExport"
              contentType="application/x-gzip"
              exportType="aggregations_export"
              newFeature=true />
          </div>
          <hr />

          <Translate content="talk.label" /><br />
          <div className="row">
            <TalkDataExportButton
              project={@props.project}
              exportType="comments"
              label="Solicitar exportar comentarios" />
          </div>
          <div className="row">
            <TalkDataExportButton
              project={@props.project}
              exportType="tags"
              label="Solicitar exportar etiquetas (tags)" />
          </div>
        </div>
      </div>
    </div>
