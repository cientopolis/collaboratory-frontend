counterpart = require 'counterpart'
React = require 'react'
Translate = require 'react-translate-component'
AutoSave = require '../../components/auto-save'
handleInputChange = require '../../lib/handle-input-change'
PromiseRenderer = require '../../components/promise-renderer'
apiClient = require 'panoptes-client/lib/api-client'
ChangeListener = require '../../components/change-listener'
Papa = require 'papaparse'
{History} = require 'react-router'
alert = require '../../lib/alert'
SubjectViewer = require '../../components/subject-viewer'
SubjectUploader = require '../../partials/subject-uploader'
UploadDropTarget = require '../../components/upload-drop-target'
ManifestView = require '../../components/manifest-view'
isAdmin = require '../../lib/is-admin'

counterpart.registerTranslations 'en',
  help:
    p1: '''A subject is a unit of data to be analyzed. A subject can include one or more images that will be analyzed at the same time by volunteers. A subject set consists of a list of subjects (the “manifest”) defining their properties, and the images themselves.'''
    p2: '''Feel free to group subjects into sets in the way that is most useful for your research. Many projects will find it’s best to just have all their subjects in 1 set, but not all.'''
    p3: '''We strongly recommend uploading subjects in batches of 500 - 1,000 at a time.'''
  limitMessage:
    l1: 'The project has '
    l2: ' uploaded subjects. '
    l3: 'You have uploaded '
    l4: ' subjects from an allowance of '
    l5: '. Your uploaded subject count is the tally of all subjects (including those deleted) that your account has uploaded through the project builder or Zooniverse api.'
  ss:
    name: 'Name'
    note: 'A subject set’s name is only seen by the research team.'
    contains:
      l1: 'This set contains '
      l2: ' subjects: '
  pagination:
    page: 'Página '
    of: ' de '
  uploadZone:
    drag: 'Drag-and-drop or click to upload manifests and subject images here.'
    note: 
      p1: '''Manifests must be '''
      or: ' or '
      p2: '''. The first row should define metadata headers. All other rows should include at least one reference to an image filename in the same directory as the manifest.'''
      p3: '''Headers that begin with "#" or "//" denote private fields that will not be visible to classifiers in the main classification interface or in the Talk discussion tool.'''
      p4: '''Subject images can be up to '''
      p5: '''KB and any of: '''
      p6: '''and may not contain '''
  upload:
    button:
      p1: 'Upload '
      p2: ' new subjects'
    success:
      p1: ' subjects created (with '
      p2: ' files uploaded).'
    error: 'Errors creating subjects:'
  delete:
    p1: 'Delete this subject set and its '
    p2: ' subjects'
   

counterpart.registerTranslations 'es',
  help:
    p1: '''En el contexto del proyecto, llamamos "elemento de análisis" a la unidad de datos que se quiere analizar. Este puede incluir una o más imágenes, y será analizado por varios voluntarios al mismo tiempo. Un conjunto de análisis consiste de un listado de estos elementos (el "manifiesto"), definiendo sus propiedades, y las imágenes en sí.'''
    p2: '''Tenés la libertad de agrupar a los elementos en los conjuntos que quieras, de la forma que sea más significativa y útil para tu proyecto. Muchos proyectos usualmente encuentran que es mejor agrupar todos los elementos en sólo un conjunto, pero ese no necesariamente es tu caso.'''
    p3: '''Es recomendable realizar la subida de elementos en tandas de 500 - 1.000.'''
  limitMessage:
    l1: 'El proyecto tiene '
    l2: ' elementos subidos. '
    l3: 'Has subido '
    l4: ' elementos, de un máximo permitido de '
    l5: '. El contador de elementos subidos es la suma de todos los elementos (incluyendo aquellos borrados) que subiste desde tu cuenta.'
  ss:
    name: 'Nombre'
    note: 'El nombre del conjunto de análisis sólo puede ser visto por el equipo del proyecto.'
    contains:
      l1: 'Este conjunto contiene '
      l2: ' elementos: '
  pagination:
    page: 'Página '
    of: ' de '
  uploadZone:
    drag: 'Arrastrá y soltá, o bien hacé click en este recuadro para subir manifiestos e imágenes.'
    note: 
      p1: '''Los manifiestos deben ser '''
      or: ' o '
      p2: '''. La primer fila debe definir encabezados de metadatos. El resto de las filas debe incluir al menos una referencia al nombre de archivo de una imagen en el mismo directorio que el manifiesto.'''
      p3: '''Los encabezados que empiecen con "#" o "//" denotan campos privados que no pueden ser vistos por los colaboradores, ni en la página de clasificación, ni en los foros de discusión.'''
      p4: '''Las imágenes de los elementos pueden ser de hasta '''
      p5: '''KB y de los tipos: '''
      p6: '''y no pueden contener '''
  upload:
    button:
      p1: 'Subir '
      p2: ' nuevos elementos'
    success:
      p1: ' elementos creados (con '
      p2: ' archivos subidos).'
    error: 'Errores creando los elementos:'
  delete:
    p1: 'Borrar este conjunto de análisis y sus '
    p2: ' elementos'    

NOOP = Function.prototype

VALID_SUBJECT_EXTENSIONS = ['.jpg', '.jpeg', '.png', '.gif', '.svg']
INVALID_FILENAME_CHARS = ['/', '\\', ':', ',']
MAX_FILE_SIZE = 600 * 1024

announceSetChange = ->
  apiClient.type('subject_sets').emit 'add-or-remove'

SubjectSetListingRow = React.createClass
  displayName: 'SubjectSetListingRow'

  getDefaultProps: ->
    subject: {}
    onPreview: Function.prototype # No-op
    onRemove: Function.prototype

  getInitialState: ->
    beingDeleted: false

  render: ->
    <tr key={@props.subject.id}>
      <td>
        <small className="form-help">{@props.subject.id}{"- #{@props.subject.metadata.Filename}" if @props.subject.metadata.Filename?}</small>
      </td>
      <td>
        <button type="button" disabled={@state.beingDeleted} onClick={@props.onPreview.bind null, @props.subject}><i className="fa fa-eye fa-fw"></i></button>
        <button type="button" disabled={@state.beingDeleted} onClick={@handleRemove}><i className="fa fa-trash-o fa-fw"></i></button>
      </td>
    </tr>

  handleRemove: ->
    @setState beingDeleted: true
    @props.onRemove @props.subject

SubjectSetListingTable = React.createClass
  displayName: 'SubjectSetListing'

  getDefaultProps: ->
    subjects: []
    onPreview: Function.prototype
    onRemove: Function.prototype

  render: ->
    <table>
      <tbody>
        {for subject in @props.subjects
          <SubjectSetListingRow key={subject.id} subject={subject} onPreview={@props.onPreview} onRemove={@props.onRemove} />}
      </tbody>
    </table>

SubjectSetListing = React.createClass
  displayName: 'SubjectSetListing'

  getDefaultProps: ->
    subjectSet: {}

  getInitialState: ->
    page: 1
    pageCount: NaN

  render: ->
    gettingSetMemberSubjects = apiClient.type('set_member_subjects').get
      subject_set_id: @props.subjectSet.id
      page: @state.page

    gettingSetMemberSubjects.then ([setMemberSubject]) =>
      newPageCount = setMemberSubject?.getMeta().page_count
      unless newPageCount is @state.pageCount
        @setState pageCount: newPageCount

    gettingSubjects = gettingSetMemberSubjects.get 'subject'

    <div>
      <PromiseRenderer promise={gettingSubjects} then={(subjects) =>
        <SubjectSetListingTable subjects={subjects} onPreview={@previewSubject} onRemove={@removeSubject} />
      } />
      <nav className="pagination">
        <Translate content="pagination.page" /><select value={@state.page} disabled={@state.pageCount < 2 or isNaN @state.pageCount} onChange={(e) => @setState page: e.target.value}>
          {if isNaN @state.pageCount
            <option>?</option>
          else
            for p in [1..@state.pageCount]
              <option key={p} value={p}>{p}</option>}
        </select><Translate content="pagination.of" />{@state.pageCount || '?'}
      </nav>
    </div>

  previewSubject: (subject) ->
    alert <div className="content-container subject-preview">
      <SubjectViewer subject={subject} />
    </div>

  removeSubject: (subject) ->
    @props.subjectSet.removeLink('subjects', subject.id).then =>
      announceSetChange()

EditSubjectSetPage = React.createClass
  displayName: 'EditSubjectSetPage'

  mixins: [History]

  getDefaultProps: ->
    subjectSet: null

  getInitialState: ->
    manifests: {}
    tooBigFiles: {}
    files: {}
    deletionError: null
    deletionInProgress: false
    successfulCreates: []
    successfulUploads: []
    creationErrors: []

  subjectLimitMessage: (project_subject_count, user) ->
    "The project has " + project_subject_count + " uploaded subjects. " +
    "You have uploaded " + user.uploaded_subjects_count + " subjects from an " +
    "allowance of " + user.max_subjects + ". Your uploaded subject count is the tally of all subjects (including those deleted) that your account has uploaded through the project builder or Zooniverse api."

  render: ->
    <div>
      <h3>{@props.subjectSet.display_name} #{@props.subjectSet.id}</h3>
      <p className="form-help"><Translate content="help.p1" /></p>
      <p className="form-help"><Translate content="help.p2" />.</p>
      <p className="form-help">
      <Translate content="limitMessage.l1" /> {@props.project.subjects_count} <Translate content="limitMessage.l2" /><Translate content="limitMessage.l3" /> {@props.user.uploaded_subjects_count} <Translate content="limitMessage.l4"/>{@props.user.max_subjects}<Translate content="limitMessage.l5" />
      </p>
      <p className="form-help"><strong><Translate content="help.p3" /></strong></p>

      <form onSubmit={@handleSubmit}>
        <p>
          <AutoSave resource={@props.subjectSet}>
            <span className="form-label"><Translate content="ss.name" /></span>
            <br />
            <input type="text" name="display_name" placeholder="Nombre del conjunto" value={@props.subjectSet.display_name} className="standard-input full" onChange={handleInputChange.bind @props.subjectSet} />
          </AutoSave>
          <small className="form-help"><Translate content="ss.note" /></small>
        </p>
      </form>

      <hr />

      <Translate content="ss.contains.l1" /> {@props.subjectSet.set_member_subjects_count} <Translate content="ss.contains.l2" /><br />
      <SubjectSetListing subjectSet={@props.subjectSet} />

      <hr />

      <p>
        <UploadDropTarget accept={"text/csv, text/tab-separated-values, image/*#{if isAdmin() then ', video/*' else ''}"} multiple onSelect={@handleFileSelection}>
          <strong><Translate content="uploadZone.drag" /></strong><br />
          <Translate content="uploadZone.note.p1" /><code>.csv</code><Translate content="uploadZone.note.or" /><code>.tsv</code><Translate content="uploadZone.note.p2" /><br />
          <Translate content="uploadZone.note.p3" /><br />
         <Translate content="uploadZone.note.p4" />{MAX_FILE_SIZE / 1024}<Translate content="uploadZone.note.p5" />{<span key={ext}><code>{ext}</code>{', ' if VALID_SUBJECT_EXTENSIONS[i + 1]?}</span> for ext, i in VALID_SUBJECT_EXTENSIONS}{' '}
          <Translate content="uploadZone.note.p6" />{<span key={char}><kbd>{char}</kbd>{', ' if INVALID_FILENAME_CHARS[i + 1]?}</span> for char, i in INVALID_FILENAME_CHARS}<br />
        </UploadDropTarget>
      </p>

      <div className="manifests-and-subjects">
        <ul>
          {subjectsToCreate = 0
          for name, {errors, subjects} of @state.manifests
            {ready} = ManifestView.separateSubjects subjects, @state.files, @state.tooBigFiles
            subjectsToCreate += ready.length
            <li key={name}>
              <ManifestView name={name} errors={errors} tooBigFiles={@state.tooBigFiles} subjects={subjects} files={@state.files} onRemove={@handleRemoveManifest.bind this, name} />
            </li>}
        </ul>

        <button type="button" className="major-button" disabled={subjectsToCreate is 0} onClick={@createSubjects}><Translate content="upload.button.p1" />{subjectsToCreate}<Translate content="upload.button.p2" /></button>

        {unless @state.successfulCreates.length is 0
          <div>{@state.successfulCreates.length}<Translate content="upload.success.p1" />{@state.successfulUploads.length}<Translate content="upload.success.p2" /></div>}

        {unless @state.creationErrors.length is 0
          <div>
            <Translate content="upload.error" />
            <ul>
              {for error in @state.creationErrors
                <li className="form-help error">{error.message}</li>}
            </ul>
          </div>}
      </div>

      <hr />

      <p>
        <small>
          <button type="button" className="minor-button" disabled={@state.deletionInProgress} onClick={@deleteSubjectSet}>
            <Translate content="delete.p1" />{@props.subjectSet.set_member_subjects_count}<Translate content="delete.p2" />
          </button>
        </small>{' '}
        {if @state.deletionError?
          <span className="form-help error">{@state.deletionError.message}</span>}
      </p>  
    </div>

  handleSubmit: (e) ->
    e.preventDefault()
    @saveResource()

  handleFileSelection: (files) ->
    @setState
      successfulCreates: []
      successfulUploads: []
      creationErrors: []

    for file in files when file.size isnt 0
      if file.type in ['text/csv', 'text/tab-separated-values']
        @_addManifest file
        gotManifest = true
      else if file.type.indexOf('image/') is 0 or (isAdmin() and file.type.indexOf('video/') is 0)
        if file.size < MAX_FILE_SIZE or isAdmin()
          @state.files[file.name] = file
          gotFile = true
        else
          @state.tooBigFiles[file.name] = file
          gotFile = true
      else if file.type? # When Windows fails to detect MIME type and returns an empty string for file.type
        allowedFileExts = ['csv', 'tsv']
        ext = file.name.split('.').pop()
        if allowedFileExts.indexOf(ext) > -1
          @_addManifest file
          gotManifest = true

    unless gotManifest
      autoManifest = []
      for name, _ of @state.files
        autoManifest.push { Filename: name }
      for name, _ of @state.tooBigFiles
        autoManifest.push { Filename: name }

      @subjectsFromManifest(autoManifest, [], "AutoGeneratedManifest")

  _addManifest: (file) ->
    reader = new FileReader
    reader.onload = (e) =>
      # TODO: Look into PapaParse features.
      # Maybe wan we parse the file object directly in a worker.
      {data, errors} = Papa?.parse e.target.result.trim(), header: true
      @subjectsFromManifest(data, errors, file.name)
    reader.readAsText file

  subjectsFromManifest: (data, errors, fileName) ->
    metadatas = for rawData in data
      cleanData = {}
      for key, value of rawData
        cleanData[key.trim()] = value?.trim?() ? value
      cleanData

    subjects = []
    for metadata in metadatas
      locations = @_findFilesInMetadata metadata
      unless locations.length is 0
        subjects.push {locations, metadata}

    @state.manifests[fileName] = {errors, subjects}
    console.log(@state.manifests)
    @forceUpdate()

  _findFilesInMetadata: (metadata) ->
    filesInMetadata = []
    for key, value of metadata
      extensions = if isAdmin() then '\\.\\D\\w{2,4}' else "(?:#{VALID_SUBJECT_EXTENSIONS.join '|'})"
      filesInValue = value.match? ///([^#{INVALID_FILENAME_CHARS.join ''}]+#{extensions})///gi
      if filesInValue?
        filesInMetadata.push filesInValue...
    filesInMetadata

  handleRemoveManifest: (name) ->
    delete @state.manifests[name]
    @forceUpdate();

  createSubjects: ->
    allSubjects = []
    for name, {subjects} of @state.manifests
      {ready} = ManifestView.separateSubjects subjects, @state.files, @state.tooBigFiles
      allSubjects.push ready...

    uploadAlert = (resolve) =>
      <div className="content-container">
        <SubjectUploader subjects={allSubjects} files={@state.files} project={@props.project} subjectSet={@props.subjectSet} autoStart onComplete={resolve} />
      </div>

    startUploading = alert uploadAlert
      .then ({creates, uploads, errors}) =>
        @setState
          successfulCreates: creates
          successfulUploads: uploads
          creationErrors: errors
          manifests: {}
          files: {}
        announceSetChange()

  deleteSubjectSet: ->
    @setState deletionError: null

    confirmed = confirm 'Really delete this subject set and all its subjects?'

    if confirmed
      @setState deletionInProgress: true

      this.props.subjectSet.delete()
        .then =>
          announceSetChange()
          @props.project.uncacheLink 'subject_sets'
          @history.pushState(null, "/lab/#{@props.project.id}")
        .catch (error) =>
          @setState deletionError: error
        .then =>
          if @isMounted()
            @setState deletionInProgress: false

module.exports = React.createClass
  displayName: 'EditSubjectSetPageWrapper'

  getDefaultProps: ->
    params: null

  render: ->
    <PromiseRenderer promise={apiClient.type('subject_sets').get @props.params.subjectSetID}>{(subjectSet) =>
      <ChangeListener target={subjectSet}>{=>
        <EditSubjectSetPage {...@props} subjectSet={subjectSet} />
      }</ChangeListener>
    }</PromiseRenderer>
