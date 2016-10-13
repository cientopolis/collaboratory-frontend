React = require 'react'
counterpart = require 'counterpart'
Translate = require 'react-translate-component'
handleInputChange = require '../../lib/handle-input-change'
PromiseRenderer = require '../../components/promise-renderer'
TriggeredModalForm = require 'modal-form/triggered'
ModalFormDialog = require 'modal-form/dialog'
WorkflowTasksEditor = require '../../components/workflow-tasks-editor'
apiClient = require 'panoptes-client/lib/api-client'
ChangeListener = require '../../components/change-listener'
RetirementRulesEditor = require '../../components/retirement-rules-editor'
{History, Navigation, Link} = require 'react-router'
MultiImageSubjectOptionsEditor = require '../../components/multi-image-subject-options-editor'
tasks = require '../../classifier/tasks'
AutoSave = require '../../components/auto-save'
FileButton = require '../../components/file-button'
GoldStandardImporter = require './gold-standard-importer'

counterpart.registerTranslations 'en',
  content:
    description: '''A workflow is the sequence of tasks that you’re asking volunteers to perform. For example, you might want to ask volunteers to answer questions about your images, or to mark features in your images, or both.'''
    cannotEdit: '''You cannot edit a project’s workflows once it’s gone live.'''
    title:
      note: '''If you let your volunteers choose which workflow to attempt, this text will appear as an option on the project front page.'''
    tasks:
      label: 'Tasks'
      add: 'Add a task'
      first: 'First task'
      help: '''A task is a unit of work you are asking volunteers to do. You can ask them to answer a question or mark an image. Add a task by clicking the question or marking buttons below.'''
      question:
        label: 'Question'
        text: '''Question tasks: the volunteer chooses from among a list of answers but does not mark or draw on the image(s).'''
       drawing:
        label: 'Drawing'
        text: '''Marking tasks: the volunteer marks or draws directly on the image(s) using tools that you specify. They can also give sub-classifications for each mark.'''
       text:
        label: 'Text'
        text: '''Text tasks: the volunteer writes free-form text into a dialog box.'''  
       survey:
        label: 'Survey'
        text: '''Survey tasks: the volunteer identifies objects (usually animals) in the image(s) by filtering by their visible charactaristics, then answers questions about them.'''
       crop:
        label: 'Crop'
        text: '''Crop tasks: the volunteer draws a rectangle around an area of interest, and the view of the subject is approximately cropped to that area.'''
       dropdown:
        label: 'Dropdown'
        text: '''Dropdown tasks: the volunteer selects an option from a list. Conditional dropdowns can be created, and if a research team enables the feature, a volunteer can enter text if the answer they'd like to provide is not an option available.'''
       combo:
        label: 'Combo'
        text: '''Combo tasks: show a bunch of tasks at the same time.'''                         
    version:
      label: 'Version '
      description: '''Version indicates which version of the workflow you are on. Every time you save changes to a workflow, you create a new version. Big changes, like adding or deleting questions, will change the version by a whole number: 1.0 to 2.0, etc. Smaller changes, like modifying the help text, will change the version by a decimal, e.g. 2.0 to 2.1. The version is tracked with each classification in case you need it when analyzing your data.'''
    subjectSets:
      assoc: 'Associated subject sets'
      text: 'Choose the set of subjects you want to use for this workflow.'
      none: 'This project has no subject sets.'
      add: 'Add an example subject set'
    summaries:
      label: 'Classification summaries'
      text: '''Classification summaries show the user how they have answered/marked for each task once the classification is complete'''
      hide: 'Hide classification summaries'
    multiImages:
      label: 'Multi-image options'
      text: 'Choose how to display multiple images'
    retire:
      label: 'Subject retirement '
      text: 'How many people should classify each subject before it is “done”? Once a subject has reached the retirement limit it will no longer be shown to any volunteers.'
    gold:
      label: 'Import gold standard classifications'
      text: 'Import gold standard classifications to improve the quality of automatic aggregations and optionally provide classification feedback for volunteers.'
      format: 'Gold standard classificaitons should be in the form:'
      use: 'Use gold standard data to provide classification feedback to volunteers.'
      after: '''After they classify, they’ll be able to compare their own classification to the gold standard data to make sure they’re on the right track.'''
    test: 'Test this workflow'
    visualize: 'Visualize this workflow'
    delete:
      workflow: 'Delete this workflow'
      task: 'Delete this task'
    edit:
      task: 'Choose a task to edit'

counterpart.registerTranslations 'es',
  content:
    description: '''Un flujo de trabajo representa la secuencia de tareas que los voluntarios realizan. Por ejemplo, podrías pedir a los voluntarios que respondan preguntas sobre tus imágenes, o realizar marcas en las mismas, o ambas.'''
    cannotEdit: '''No es posible editar los flujos de trabajo de un proyecto una vez que éste está en vivo.'''
    title:
      note: '''Si permitís que tus voluntarios puedan elegir en qué flujo trabajar, este texto aparecerá como una opción en la página principal del proyecto.'''
    tasks:
      label: 'Tareas'
      add: 'Agregar una tarea'
      first: 'Primer tarea'
      help: '''Una tarea es una unidad de trabajo que los voluntarios realizan. Podés solicitar que respondan una preguntao que marquen algo en una imagen. Podés agregar una tarea haciendo click en los botones de pregunta o dibujo, luego de clickear en el botón de abajo.'''
      question:
        label: 'Pregunta'
        text: '''Tareas con pregunta/s: el voluntario elige entre un listado de respuestas, pero no realiza ningún tipo de marca o dibujo en la/s imágen/es.'''
       drawing:
        label: 'Dibujo/marca'
        text: '''Tareas con dibujos/marcas: el voluntario marca o dibuja directamente en la/s imágen/es utilizando las herramientas que especifiques. También pueden dar sub-clasificaciones por cada marca.'''
       text:
        label: 'Texto'
        text: '''Tareas con texto: el voluntario escribe libremente en un campo de texto.'''  
       survey:
        label: 'Reconocimiento/estudio'
        text: '''Tareas de reconocimiento: el voluntario identifica objetos (por ejemplo animales) en la/s imágen/es, filtrando sus características visibles, y luego responde preguntas sobre ellas.'''
       crop:
        label: 'Recortar'
        text: '''Tareas con recortes: el voluntario dibuja un rectángulo alrededor de un área de interés, y la vista del elemento a analizar se recorta aproximadamente a ese área.'''
       dropdown:
        label: 'Componente desplegable'
        text: '''Tareas con componentes desplegables: el voluntario selecciona una opción de una lista. Desplegables condicionales pueden definirse, y si el equipo habilita esta característica, el voluntario puede ingresar texto si la respuesta que quieren dar no se encuentra como opción.'''
       combo:
        label: 'Combinadas'
        text: '''Tareas combinadas: mostrar un conjunto de tareas al mismo tiempo.'''   
    version:
      label: 'Versión '
      description: '''Versión indica el número de versión en el que nos encontramos. Cada vez que se guarden cambios en un flujo de trabajo, se crea una nueva versión. Cambios grandes, como agregar o borrar preguntas, cambiarán el número de versión entero: 1.0 a 2.0, etc. Cambios más pequeños, como modificar el texto de ayuda, cambarán el número de versión decimal: 2.0 a 2.1, etc. El número de versión queda registrado con cada clasificación que hagan los voluntarios, en caso de que lo necesites cuando analices los resultados.'''
    subjectSets:
      assoc: 'Conjuntos de análisis asociados'
      text: 'Elegí los conjuntos de análisis que quieras utilizar en este flujo de trabajo.'
      none: 'Este proyecto no tiene conjuntos de análisis cargados.'
      add: 'Agregar un conjunto de análisis de ejemplo'
    summaries:
      label: 'Sumarios de clasificación'
      text: '''Los sumarios de clasificación muestran al usuario cómo contestaron/marcaron cada tarea, una vez que la clasificación ha sido completada'''
      hide: 'Ocultar sumarios de clasificación'
    multiImages:
      label: 'Opciones multi-imagen'
      text: 'Elegí cómo mostrar múltiples imágenes'
    retire:
      label: 'Retirar elementos de análisis '
      text: '¿Cuántas personas deben clasificar un elemento simple (una imágen) antes de que se la considere como que ya está "lista"? Una vez que un elemento alcance el límite deseado, ya no será mostrado a los voluntarios.'
    gold:
      label: 'Importar clasificaciones de estándar oro'
      text: 'Importar clasificaciones de estándar oro para mejorar la calidad de las agregaciones automáticas, y opcionalmente proveer retroalimentación en las clasificaciones a los voluntarios.'
      format: 'Las   clasificaciones de estándar oro deben estar en el formato:'
      use: 'Utilizá clasificaciones de estándar oro para proveer retroalimentación en las clasificaciones a los voluntarios.'
      after: '''Luego de realizar una clasificación, tendrán la posibilidad de comparar sus propias clasificaciones con los datos del estándar de oro para asegurarse de que van en buen camino.'''
    test: 'Probar este flujo de trabajo'
    visualize: 'Visualizar este flujo de trabajo'
    delete:
      workflow: 'Borrar este flujo de trabajo'
      task: 'Borra esta tarea'
    edit:
      task: 'Seleccionar una tarea a editar'

DEMO_SUBJECT_SET_ID = if process.env.NODE_ENV is 'production'
  '6' # Cats
else
  '1166' # Ghosts

EXAMPLE_GOLD_STANDARD_DATA = '''
  [{
    "links": {
      "subjects": ["123"]
    },
    "annotations": [{
      task: "T1",
      value: 3
    }, {
      task: "T2",
      value: "The value"
    }, ...]
  }, ...]
'''

EditWorkflowPage = React.createClass
  displayName: 'EditWorkflowPage'

  mixins: [History]

  getDefaultProps: ->
    workflow: null

  getInitialState: ->
    selectedTaskKey: @props.workflow.first_task
    goldStandardFilesToImport: null
    forceReloader: 0
    deletionInProgress: false
    deletionError: null

  workflowLink: ->
    [owner, name] = @props.project.slug.split('/')
    viewQuery = workflow: @props.workflow.id, reload: @state.forceReloader
    @history.createHref("/projects/#{owner}/#{name}/classify", viewQuery)

  canUseTask: (project, task)->
    task in project.experimental_tools

  handleTaskChange: (taskKey, taskDescription) ->
    changes = {}
    changes["tasks.#{taskKey}"] = taskDescription
    @props.workflow.update(changes).save()

  render: ->
    window.editingWorkflow = @props.workflow

    disabledStyle =
      opacity: 0.4
      pointerEvents: 'none'

    <div className="edit-workflow-page">
      <h3>{@props.workflow.display_name} #{@props.workflow.id}</h3>
      <p className="form-help"><Translate content="content.description" /></p>
      {if @props.project.live
        <p className="form-help warning"><strong><Translate content="content.cannotEdit" /></strong></p>}
      <div className="columns-container" style={disabledStyle if @props.project.live}>
        <div className="column">
          <div>
            <AutoSave tag="label" resource={@props.workflow}>
              <span className="form-label">Workflow title</span>
              <br />
              <input type="text" name="display_name" value={@props.workflow.display_name} className="standard-input full" onChange={handleInputChange.bind @props.workflow} />
            </AutoSave>
            <small className="form-help"><Translate content="content.title.note" /></small>

            <br />

            <div>
              <div className="nav-list standalone">
                <span className="nav-list-header"><Translate content="content.tasks.label" /></span>
                <br />
                {for key, definition of @props.workflow.tasks
                  classNames = ['secret-button', 'nav-list-item']
                  if key is @state.selectedTaskKey
                    classNames.push 'active'
                  <div key={key}>
                    <button type="button" className={classNames.join ' '} onClick={@setState.bind this, selectedTaskKey: key, null}>
                      {switch definition.type
                        when 'single' then <i className="fa fa-dot-circle-o fa-fw"></i>
                        when 'multiple' then <i className="fa fa-check-square-o fa-fw"></i>
                        when 'drawing' then <i className="fa fa-pencil fa-fw"></i>
                        when 'survey' then <i className="fa fa-binoculars fa-fw"></i>
                        when 'flexibleSurvey' then <i className="fa fa-binoculars fa-fw"></i>
                        when 'crop' then <i className="fa fa-crop fa-fw"></i>
                        when 'text' then <i className="fa fa-file-text-o fa-fw"></i>
                        when 'dropdown' then <i className="fa fa-list fa-fw"></i>
                        when 'combo' then <i className="fa fa-cubes fa-fw"></i>}
                      {' '}
                      {tasks[definition.type].getTaskText definition}
                      {if key is @props.workflow.first_task
                        <small> <em>(first)</em></small>}
                    </button>
                  </div>}
              </div>

              <p>
                <TriggeredModalForm trigger={
                  <span className="standard-button">
                    <i className="fa fa-plus-circle"></i>{' '}
                    <Translate content="content.tasks.add" />
                  </span>
                }>
                  <AutoSave resource={@props.workflow}>
                    <Translate component="button" type="submit" className="minor-button" onClick={@addNewTask.bind this, 'single'} attributes={{title: "content.tasks.question.text" }} required>
                        <i className="fa fa-question-circle fa-2x"></i>
                        <br />
                        <small><strong><Translate content="content.tasks.question.label" /></strong></small>
                    </Translate>
                  </AutoSave>{' '}
                  <AutoSave resource={@props.workflow}>
                    <Translate component="button" type="submit" className="minor-button" onClick={@addNewTask.bind this, 'drawing'} attributes={{title: "content.tasks.drawing.text" }} required>
                        <i className="fa fa-pencil fa-2x"></i>
                        <br />
                        <small><strong><Translate content="content.tasks.drawing.label" /></strong></small>
                    </Translate>
                  </AutoSave>{' '}
                  {if @canUseTask(@props.project, "text")
                    <AutoSave resource={@props.workflow}>
                     <Translate component="button" type="submit" className="minor-button" onClick={@addNewTask.bind this, 'text'} attributes={{title: "content.tasks.text.text" }} required>
                          <i className="fa fa-file-text-o fa-2x"></i>
                          <br />
                          <small><strong><Translate content="content.tasks.text.label" /></strong></small>
                    </Translate>
                    </AutoSave>}{' '}
                  {if @canUseTask(@props.project, "survey")
                    <AutoSave resource={@props.workflow}>
                      <Translate component="button" type="submit" className="minor-button" onClick={@addNewTask.bind this, 'survey'} attributes={{title: "content.tasks.survey.text" }} required>
                          <i className="fa fa-binoculars fa-2x"></i>
                          <br />
                          <small><strong><Translate content="content.tasks.survey.label" /></strong></small>
                      </Translate>
                    </AutoSave>}{' '}
                  {if @canUseTask(@props.project, "crop")
                    <AutoSave resource={@props.workflow}>
                      <Translate component="button" type="submit" className="minor-button" onClick={@addNewTask.bind this, 'crop'} attributes={{title: "content.tasks.crop.text" }} required>
                          <i className="fa fa-crop fa-2x"></i>
                          <br />
                          <small><strong><Translate content="content.tasks.crop.label" /></strong></small>
                      </Translate>
                    </AutoSave>}{' '}
                  {if @canUseTask(@props.project, "dropdown")
                      <AutoSave resource={@props.workflow}>
                        <Translate component="button" type="submit" className="minor-button" onClick={@addNewTask.bind this, 'dropdown'} attributes={{title: "content.tasks.dropdown.text" }} required>
                            <i className="fa fa-list fa-2x"></i>
                            <br />
                            <small><strong><Translate content="content.tasks.dropdown.label" /></strong></small>
                        </Translate>
                      </AutoSave>}{' '}
                  {if @canUseTask(@props.project, "combo")
                    <AutoSave resource={@props.workflow}>
                      <Translate component="button" type="submit" className="minor-button" onClick={@addNewTask.bind this, 'combo'} attributes={{title: "content.tasks.combo.text" }} required>
                          <i className="fa fa-cubes fa-2x"></i>
                          <br />
                          <small><strong><Translate content="content.tasks.combo.label" /></strong></small>
                        </Translate>
                    </AutoSave>}
                </TriggeredModalForm>
              </p>

              <AutoSave tag="div" resource={@props.workflow}>
                <small><Translate content="content.tasks.first" /></small>{' '}
                <select name="first_task" value={@props.workflow.first_task} onChange={handleInputChange.bind @props.workflow}>
                  {for taskKey, definition of @props.workflow.tasks
                    <option key={taskKey} value={taskKey}>{tasks[definition.type].getTaskText definition}</option>}
                </select>
              </AutoSave>
            </div>

            <p className="form-help"><small><Translate content="content.tasks.help" /></small></p>

            <hr />

            <p>
              <small className="form-help"><Translate content="content.version.label" />{@props.workflow.version}</small>
            </p>
            <p className="form-help"><small><Translate content="content.version.description" /></small></p>
          </div>

          <hr />

          <div>
            <span className="form-label"><Translate content="content.subjectSets.assoc" /></span><br />
            <small className="form-help"><Translate content="content.subjectSets.text" /></small>
            {@renderSubjectSets()}
          </div>

          <hr />

          {if 'hide classification summaries' in @props.project.experimental_tools
            <div>
              <div>
                <AutoSave resource={@props.workflow}>
                  <span className="form-label"><Translate content="content.summaries.label" /></span><br />
                  <small className="form-help"><Translate content="content.summaries.text" /></small>
                  <br />
                  <input type="checkbox" id="hide_classification_summaries" onChange={@handleSetHideClassificationSummaries} defaultChecked={@props.workflow.configuration?.hide_classification_summaries} />
                  <label htmlFor="hide_classification_summaries"><Translate content="content.summaries.hide" /></label>
                </AutoSave>
              </div>

              <hr />
            </div>}

          <AutoSave tag="div" resource={@props.workflow}>
            <span className="form-label"><Translate content="content.multiImages.label" /></span><br />
            <small className="form-help"><Translate content="content.multiImages.text" /></small>
            <MultiImageSubjectOptionsEditor workflow={@props.workflow} />
          </AutoSave>

          <hr />

          <p>
            <AutoSave resource={@props.workflow}>
              <Translate content="content.retire.label" /><RetirementRulesEditor workflow={@props.workflow} />
            </AutoSave>
            <br />
            <small className="form-help"><Translate content="content.retire.text" /></small>
          </p>

          <hr />

          <p>
            <FileButton className="standard-button" accept="application/json" multiple onSelect={@handleGoldStandardDataImport}><Translate content="content.gold.label" /></FileButton>
            <br />
            <small className="form-help"><Translate content="content.gold.text" /></small>{' '}
            <TriggeredModalForm trigger={<i className="fa fa-question-circle"></i>}>
              <p><Translate content="content.gold.format" /></p>
              <pre>{EXAMPLE_GOLD_STANDARD_DATA}</pre>
            </TriggeredModalForm>
          </p>

          <p>
            <AutoSave tag="label" resource={@props.workflow}>
              <input type="checkbox" name="public_gold_standard" checked={@props.workflow.public_gold_standard} onChange={handleInputChange.bind @props.workflow} />{' '}
              <Translate content="content.gold.use" />
            </AutoSave>
            <br />
            <small className="form-help"><Translate content="content.gold.after" /></small>
          </p>

          <hr />

          <div style={pointerEvents: 'all'}>
            <a href={@workflowLink()} className="standard-button" target="from-lab" onClick={@handleViewClick}><Translate content="content.test" /></a>
          </div>

          <hr />

          <div style={pointerEvents: 'all'}>
            <Link to="/lab/#{@props.project.id}/workflow/#{@props.workflow.id}/visualize" className="standard-button" params={workflowID: @props.workflow.id, projectID: @props.project.id} title="A workflow is the sequence of tasks that you’re asking volunteers to perform."><Translate content="content.visualize" /></Link>
          </div>

          <hr />

          <div>
            <small>
              <button type="button" className="minor-button" disabled={@state.deletionInProgress} data-busy={@state.deletionInProgress || null} onClick={@handleDelete}>
                <Translate content="content.delete.workflow" />
              </button>
            </small>{' '}
            {if @state.deletionError?
              <span className="form-help error">{@state.deletionError.message}</span>}
          </div>
        </div>

        <div className="column">
          {if @state.selectedTaskKey? and @props.workflow.tasks[@state.selectedTaskKey]?
            TaskEditorComponent = tasks[@props.workflow.tasks[@state.selectedTaskKey].type].Editor
            <div>
              <TaskEditorComponent
                workflow={@props.workflow}
                task={@props.workflow.tasks[@state.selectedTaskKey]}
                taskPrefix="tasks.#{@state.selectedTaskKey}"
                project={@props.project}
                onChange={@handleTaskChange.bind this, @state.selectedTaskKey}
              />
              <hr />
              <br />
              <AutoSave resource={@props.workflow}>
                <small>
                  <button type="button" onClick={@handleTaskDelete.bind this, @state.selectedTaskKey}><Translate content="content.delete.task" /></button>
                </small>
              </AutoSave>
            </div>
          else
            <p><Translate content="content.edit.task" /></p>}
        </div>
      </div>

      {if @state.goldStandardFilesToImport?
        <ModalFormDialog required>
          <GoldStandardImporter
            project={@props.project}
            workflow={@props.workflow}
            files={@state.goldStandardFilesToImport}
            onClose={@handleGoldStandardImportClose}
          />
        </ModalFormDialog>}
    </div>

  renderSubjectSets: ->
    projectAndWorkflowSubjectSets = Promise.all [
      @props.project.get 'subject_sets', sort: 'display_name', page_size: 100
      @props.workflow.get 'subject_sets', sort: 'display_name', page_size: 100
    ]

    <PromiseRenderer promise={projectAndWorkflowSubjectSets}>{([projectSubjectSets, workflowSubjectSets]) =>
      <div>
        <table>
          <tbody>
            {for subjectSet in projectSubjectSets
              assigned = subjectSet in workflowSubjectSets
              toggle = @handleSubjectSetToggle.bind this, subjectSet
              <tr key={subjectSet.id}>
                <td><input type="checkbox" checked={assigned} onChange={toggle} /></td>
                <td>{subjectSet.display_name} (#{subjectSet.id})</td>
              </tr>}
          </tbody>
        </table>
        {if projectSubjectSets.length is 0
          <p>
            <Translate content="content.subjectSets.none" />{' '}
            <button type="button" onClick={@addDemoSubjectSet}><Translate content="content.subjectSets.add" /></button>
          </p>}
      </div>
    }</PromiseRenderer>

  addNewTask: (type) ->
    taskCount = Object.keys(@props.workflow.tasks).length

    # Task IDs aren't displayed anywhere.
    # This could be random, but we might as well make it sorta meaningful.
    taskIDNumber = -1
    until nextTaskID? and nextTaskID not of @props.workflow.tasks
      taskIDNumber += 1
      nextTaskID = "T#{taskCount + taskIDNumber}"

    changes = {}
    changes["tasks.#{nextTaskID}"] = tasks[type].getDefaultTask()
    unless @props.workflow.first_task
      changes.first_task = nextTaskID

    @props.workflow.update changes
    @setState selectedTaskKey: nextTaskID

  handleSetHideClassificationSummaries: (e) ->
    @props.workflow.update
      'configuration.hide_classification_summaries': e.target.checked

  handleSubjectSetToggle: (subjectSet, e) ->
    shouldAdd = e.target.checked

    ensureSaved = if @props.workflow.hasUnsavedChanges()
      @props.workflow.save()
    else
      Promise.resolve()

    ensureSaved.then =>
      if shouldAdd
        @props.workflow.addLink 'subject_sets', [subjectSet.id]
      else
        @props.workflow.removeLink 'subject_sets', subjectSet.id

  addDemoSubjectSet: ->
    @props.project.uncacheLink 'subject_sets'
    @props.workflow.addLink 'subject_sets', [DEMO_SUBJECT_SET_ID]

  handleDelete: ->
    @setState deletionError: null

    confirmed = confirm '¿Está seguro de que desea borrar este flujo de trabajo con todas sus tareas?'

    if confirmed
      @setState deletionInProgress: true

      @props.workflow.delete().then =>
        @props.project.uncacheLink 'workflows'
        @history.pushState(null, "/lab/#{@props.project.id}")
      .catch (error) =>
        @setState deletionError: error
      .then =>
        if @isMounted()
          @setState deletionInProgress: false

  handleGoldStandardDataImport: (e) ->
    @setState goldStandardFilesToImport: e.target.files

  handleGoldStandardImportClose: ->
    @setState goldStandardFilesToImport: null

  handleViewClick: ->
    setTimeout =>
      @setState forceReloader: @state.forceReloader + 1

  handleTaskDelete: (taskKey, e) ->
    if e.shiftKey or confirm 'Really delete this task?'
      changes = {}
      changes["tasks.#{taskKey}"] = undefined
      @props.workflow.update changes

      if @props.workflow.first_task not of @props.workflow.tasks
        @props.workflow.update first_task: Object.keys(@props.workflow.tasks)[0] ? ''

module.exports = React.createClass
  displayName: 'EditWorkflowPageWrapper'

  getDefaultProps: ->
    params:
      workflowID: ''

  render: ->
    <PromiseRenderer promise={apiClient.type('workflows').get @props.params.workflowID}>{(workflow) =>
      <ChangeListener target={workflow}>{=>
        <EditWorkflowPage {...@props} workflow={workflow} />
      }</ChangeListener>
    }</PromiseRenderer>
