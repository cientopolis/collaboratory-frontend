counterpart = require 'counterpart'
React = require 'react'
Translate = require 'react-translate-component'
apiClient = require 'panoptes-client/lib/api-client'
testClassificationQuality = require '../lib/test-classification-quality'
ChangeListener = require '../components/change-listener'
FrameAnnotator = require './frame-annotator'
SubjectViewer = require '../components/subject-viewer'
ClassificationSummary = require './classification-summary'
{Link} = require 'react-router'
tasks = require './tasks'
{getSessionID} = require '../lib/session'
preloadSubject = require '../lib/preload-subject'
PromiseRenderer = require '../components/promise-renderer'
TriggeredModalForm = require 'modal-form/triggered'
TutorialButton = require './tutorial-button'
isAdmin = require '../lib/is-admin'
Tutorial = require '../lib/tutorial'
workflowAllowsFlipbook = require '../lib/workflow-allows-flipbook'
workflowAllowsSeparateFrames = require '../lib/workflow-allows-separate-frames'

counterpart.registerTranslations 'en',
  done: 'Done'
  talk: 'Talk'
  next: 'Next'
  tutorial: '''Show the project's tutorial'''
  demo: 
    label: 'Demo mode:'
    note: 'In demo mode, classifications' 
    note2: 'will not be saved.'
    note3: '''Use this for quick, inaccurate demos of the classification interface.'''
  noClassi: 'No classifications are being recorded.'
  disable: 'Disable'
  expert:
    available: 'Expert classification available.'
    match: 'Looks like you matched about '
    keep: 'Keep at it, all classifications are useful!'
    work: 'Keep up the good work!'
  hide: 'Hide'
  show: 'Show'
  goldMode: 
    label: 'Gold standard mode'
    description: '''A “gold standard” classification is one that is known to be completely accurate. We’ll compare other classifications against it during aggregation.'''
    pleaseSure: 'Please ensure this classification is completely accurate.'
  classi:
    expert: 'Expert classification:'
    yours: 'Your classification'

counterpart.registerTranslations 'es',
  done: 'Listo'
  talk: 'Discusión'
  next: 'Siguiente'
  tutorial: '''Ver el tutorial del proyecto'''
  demo: 
    label: 'Modo de pruebas:'
    note: 'En el modo de pruebas, las clasificaciones' 
    note2: 'no se guardarán.'
    note3: '''Usá esto para pruebas rápidas de la interfaz de clasificación.'''
  noClassi: 'No se están guardando las clasificaciones.'
  disable: 'Desactivar'
  expert:
    available: 'Clasifiación experta disponible.'
    match: 'Al parecer acertaste sobre '
    keep: '¡Seguí así, todas las clasificaciones son útiles!'
    work: '¡Continuá con el buen trabajo!'
  hide: 'Ocultar'
  show: 'Mostrar'  
  goldMode: 
    label: 'Modo estándar oro'
    description: '''Una clasificación "estándar oro" es aquella que se sabe que es completamente correcta. Vamos a comparar otras clasificaciones contra ésta durando el proceso de agregación'''
    pleaseSure: 'Por favor, asegurate de que esta clasificación es completamente correcta.'


PULSAR_HUNTERS_SLUG = 'zooniverse/pulsar-hunters'

Classifier = React.createClass
  displayName: 'Classifier'

  getDefaultProps: ->
    user: null
    workflow: null
    subject: null
    classification: null
    goodClassificationCutoff: 0.5
    onLoad: Function.prototype

  getInitialState: ->
    subjectLoading: false
    expertClassification: null
    classificationQuality: NaN
    showingExpertClassification: false
    selectedExpertAnnotation: -1

  componentDidMount: ->
    @loadSubject @props.subject
    @prepareToClassify @props.classification
    Tutorial.startIfNecessary @props.user, @props.project

  componentWillReceiveProps: (nextProps) ->
    if nextProps.project isnt @props.project or nextProps.user isnt @props.user
      Tutorial.startIfNecessary nextProps.user, nextProps.project
    if nextProps.subject isnt @props.subject
      @loadSubject subject
    if nextProps.classification isnt @props.classification
      @prepareToClassify nextProps.classification

  loadSubject: (subject) ->
    @setState
      subjectLoading: true
      expertClassification: null
      classificationQuality: NaN
      showingExpertClassification: false
      selectedExpertAnnotation: -1

    @getExpertClassification @props.workflow, @props.subject

    preloadSubject subject
      .then =>
        if @props.subject is subject # The subject could have changed while we were loading.
          @setState subjectLoading: false
          @props.onLoad?()

  getExpertClassification: (workflow, subject) ->
    awaitExpertClassification = Promise.resolve do =>
      apiClient.get('/classifications/gold_standard', {
        workflow_id: workflow.id,
        subject_ids: [subject.id]
      })
        .catch ->
          []
        .then ([expertClassification]) ->
          expertClassification

    awaitExpertClassification.then (expertClassification) =>
      expertClassification ?= subject.expert_classification_data?[workflow.id]
      if @props.workflow is workflow and @props.subject is subject
        window.expertClassification = expertClassification
        @setState {expertClassification}

  prepareToClassify: (classification) ->
    classification.annotations ?= []
    if classification.annotations.length is 0
      @addAnnotationForTask classification, @props.workflow.first_task

  render: ->
    <ChangeListener target={@props.classification}>{=>
      if @state.showingExpertClassification
        currentClassification = @state.expertClassification
      else
        currentClassification = @props.classification
        unless @props.classification.completed
          currentAnnotation = currentClassification.annotations[currentClassification.annotations.length - 1]
          currentTask = @props.workflow.tasks[currentAnnotation?.task]

      # This is just easy access for debugging.
      window.classification = currentClassification

      <div className="classifier">
        <SubjectViewer
          user={@props.user}
          project={@props.project}
          subject={@props.subject}
          workflow={@props.workflow}
          classification={currentClassification}
          annotation={currentAnnotation}
          onLoad={@handleSubjectImageLoad}
          frameWrapper={FrameAnnotator}
          allowFlipbook={workflowAllowsFlipbook @props.workflow}
          allowSeparateFrames={workflowAllowsSeparateFrames @props.workflow}
          onChange={@handleAnnotationChange.bind this, currentClassification}
        />

        <div className="task-area">
          {if currentTask?
            @renderTask currentClassification, currentAnnotation, currentTask
          else if not @props.workflow.configuration?.hide_classification_summaries # Classification is complete; show summary if enabled
            @renderSummary currentClassification}
        </div>
      </div>
    }</ChangeListener>

  renderTask: (classification, annotation, task) ->
    TaskComponent = tasks[task.type]
    # Should we disabled the "Back" button?
    onFirstAnnotation = classification.annotations.indexOf(annotation) is 0

    # Should we disable the "Next" or "Done" buttons?
    if TaskComponent.isAnnotationComplete?
      waitingForAnswer = not TaskComponent.isAnnotationComplete task, annotation, @props.workflow

    # Each answer of a single-answer task can have its own `next` key to override the task's.
    if TaskComponent is tasks.single
      currentAnswer = task.answers?[annotation.value]
      nextTaskKey = currentAnswer?.next
    else
      nextTaskKey = task.next

    unless @props.workflow.tasks[nextTaskKey]?
      nextTaskKey = ''

    # TODO: Actually disable things that should be.
    # For now we'll just make them non-mousable.
    disabledStyle =
      opacity: 0.5
      pointerEvents: 'none'

    <div className="task-container" style={disabledStyle if @state.subjectLoading}>
      <TaskComponent taskTypes={tasks} workflow={@props.workflow} task={task} annotation={annotation} onChange={@handleAnnotationChange.bind this, classification} />
      <hr />

      <nav className="task-nav">
        {if Object.keys(@props.workflow.tasks).length > 1
          <button type="button" className="back minor-button" disabled={onFirstAnnotation} onClick={@destroyCurrentAnnotation}>Back</button>}
        {if not nextTaskKey and @props.workflow.configuration?.hide_classification_summaries and @props.owner? and @props.project?
          [ownerName, name] = @props.project.slug.split('/')
          <Link onClick={@completeClassification} to="/projects/#{ownerName}/#{name}/talk/subjects/#{@props.subject.id}" className="talk standard-button" style={if waitingForAnswer then disabledStyle}><Translate content="done" /> &amp; <Translate content="talk" /></Link>}
        {if nextTaskKey
          <button type="button" className="continue major-button" disabled={waitingForAnswer} onClick={@addAnnotationForTask.bind this, classification, nextTaskKey}>Next</button>
        else
          <button type="button" className="continue major-button" disabled={waitingForAnswer} onClick={@completeClassification}>
            {if @props.demoMode
              <i className="fa fa-trash fa-fw"></i>
            else if @props.classification.gold_standard
              <i className="fa fa-star fa-fw"></i>}
            {' '}<Translate content="done" />
          </button>}
        {@renderExpertOptions()}
      </nav>
      
      <p>
        <small>
          <strong>
            <TutorialButton className="minor-button" user={@props.user} project={@props.project} title="Project tutorial" aria-label="Show the project's tutorial" style={marginTop: '2em'}>
              <Translate content="tutorial" />
            </TutorialButton>
          </strong>
        </small>
      </p>

      {if @props.demoMode
        <p style={textAlign: 'center'}>
          <i className="fa fa-trash"></i>{' '}
          <small>
            <strong><Translate content="demo.label" /></strong>
            <br />
            <Translate content="noClassi" />{' '}
            <button type="button" className="secret-button" onClick={@props.onChangeDemoMode.bind null, false}>
              <u>Disable</u>
            </button>
          </small>
        </p>
      else if @props.classification.gold_standard
        <p style={textAlign: 'center'}>
          <i className="fa fa-star"></i>{' '}
          <small>
            <strong><Translate content="goldMode.label" />:</strong>
            <br />
            <Translate content="goldMode.pleaseSure" />{' '}
            <button type="button" className="secret-button" onClick={@props.classification.update.bind @props.classification, gold_standard: undefined}>
              <u><Translate content="disable" /></u>
            </button>
          </small>
        </p>}
    </div>

  renderSummary: (classification) ->
    <div>
      ¡Gracias!

      {if @props.project?.slug is PULSAR_HUNTERS_SLUG or location.href.indexOf('fake-pulsar-feedback') isnt -1
        subjectClass = @props.subject.metadata['#Class']?.toUpperCase()
        if subjectClass?
          userFoundPulsar = @props.classification.annotations[0]?.value is 0

          HelpButton = (props) =>
            <button type="button" onClick={=>
              {alert} = require 'modal-form/dialog'
              {Markdown} = require 'markdownz'
              console.log {Markdown}
              alert <Markdown>{@props.workflow.tasks[@props.workflow.first_task].help}</Markdown>
            }>
              {props.children}
            </button>

          <div className="pulsar-hunters-feedback" data-is-correct={subjectClass? and userFoundPulsar || null}>
            {if subjectClass in ['KNOWN', 'DISC']
              if userFoundPulsar
                <p>Congratulations! You’ve successfully spotted a known pulsar. Keep going to find one we don’t already know about.</p>
              else
                <p>This was actually a known pulsar. <HelpButton>Click here</HelpButton> to see some examples of known pulsars.</p>
            else if subjectClass in ['FAKE']
              if userFoundPulsar
                <p>Congratulations! You’ve successfully spotted a simulated pulsar. Keep going to find a real, undiscovered pulsar.</p>
              else
                <p>This was a simulated pulsar. <HelpButton>Click here</HelpButton> to see some examples of known pulsars.</p>}
          </div>

      else if @state.expertClassification?
        <div className="has-expert-classification">
          <Translate content="expert.available" />{' '}
          {if @state.showingExpertClassification
            <button type="button" onClick={@toggleExpertClassification.bind this, false}><Translate content="hide" /></button>
          else
            <button type="button" onClick={@toggleExpertClassification.bind this, true}><Translate content="show" /></button>}

          {unless true or isNaN @state.classificationQuality
            qualityString = (@state.classificationQuality * 100).toString().split('.')[0] + '%'
            <div><Translate content="expert.match" /> <strong>{qualityString}</strong>.</div>}
          {if @state.classificationQuality < @props.goodClassificationCutoff
            <div><Translate content="expert.keep" /></div>}
          {if @state.classificationQuality > @props.goodClassificationCutoff
            <div><Translate content="expert.work" /></div>}
        </div>}

      <div>
        <strong>
          {if @state.showingExpertClassification
            'Clasificación experta:'
          else
            'Tu clasificación'}
        </strong>
        <ClassificationSummary workflow={@props.workflow} classification={classification} />
      </div>

      <hr />

      <nav className="task-nav">
        {if @props.owner? and @props.project?
          [ownerName, name] = @props.project.slug.split('/')
          <Link onClick={@props.onClickNext} to="/projects/#{ownerName}/#{name}/talk/subjects/#{@props.subject.id}" className="talk standard-button">Discusión</Link>}
        <button type="button" className="continue major-button" onClick={@props.onClickNext}><Translate content="next" /></button>
        {@renderExpertOptions()}
      </nav>
    </div>

  renderExpertOptions: ->
    return unless @props.expertClassifier
    <TriggeredModalForm trigger={
      <i className="fa fa-cog fa-fw"></i>
    }>
      {if 'owner' in @props.userRoles or 'expert' in @props.userRoles
        <p>
          <label>
            <input type="checkbox" checked={@props.classification.gold_standard} onChange={@handleGoldStandardChange} />{' '}
            <Translate content="goldMode.label" />
          </label>{' '}
          <TriggeredModalForm trigger={
            <i className="fa fa-question-circle"></i>
          }>
            <p><Translate content="goldMode.description" /></p>
          </TriggeredModalForm>
        </p>}

        {if isAdmin() or 'owner' in @props.userRoles or 'collaborator' in @props.userRoles
          <p>
            <label>
              <input type="checkbox" checked={@props.demoMode} onChange={@handleDemoModeChange} />{' '}
              <Translate content="demo.label" />
            </label>{' '}
            <TriggeredModalForm trigger={
              <i className="fa fa-question-circle"></i>
            }>
              <p><Translate content="demo.note" /> <strong><Translate content="demo.note2" /></strong> <Translate content="demo.note3" />
              </p>
            </TriggeredModalForm>
          </p>}
    </TriggeredModalForm>

  # Whenever a subject image is loaded in the annotator, record its size at that time.
  handleSubjectImageLoad: (e, frameIndex) ->
    {naturalWidth, naturalHeight, clientWidth, clientHeight} = e.target
    changes = {}
    changes["metadata.subject_dimensions.#{frameIndex}"] = {naturalWidth, naturalHeight, clientWidth, clientHeight}
    @props.classification.update changes

  handleAnnotationChange: (classification, newAnnotation) ->
    classification.annotations[classification.annotations.length - 1] = newAnnotation
    classification.update 'annotations'

  # Next (or start):
  addAnnotationForTask: (classification, taskKey) ->
    taskDescription = @props.workflow.tasks[taskKey]
    annotation = tasks[taskDescription.type].getDefaultAnnotation taskDescription, @props.workflow, tasks
    annotation.task = taskKey
    classification.annotations.push annotation
    classification.update 'annotations'

  # Back up:
  destroyCurrentAnnotation: ->
    @props.classification.annotations.pop()
    @props.classification.update 'annotations'

  completeClassification: ->
    @props.classification.update
      completed: true
      'metadata.session': getSessionID()
      'metadata.finished_at': (new Date).toISOString()
      'metadata.viewport':
        width: innerWidth
        height: innerHeight

    if @state.expertClassification?
      classificationQuality = testClassificationQuality @props.classification, @state.expertClassification, @props.workflow
      console.log 'Classification quality', classificationQuality
      @setState {classificationQuality}

    @props.onComplete?()

  handleGoldStandardChange: (e) ->
    @props.classification.update gold_standard: e.target.checked || undefined # Delete the whole key.

  handleDemoModeChange: (e) ->
    @props.onChangeDemoMode e.target.checked

  toggleExpertClassification: (value) ->
    @setState showingExpertClassification: value

module.exports = React.createClass
  displayName: 'ClassifierWrapper'

  getDefaultProps: ->
    user: null
    classification: {}
    onLoad: Function.prototype
    onComplete: Function.prototype
    onClickNext: Function.prototype

  getInitialState: ->
    workflow: null
    subject: null
    expertClassifier: null
    userRoles: []

  componentDidMount: ->
    @checkExpertClassifier()
    @loadClassification @props.classification

  componentWillReceiveProps: (nextProps) ->
    if @props.user isnt nextProps.user
      @setState expertClassifier: null
      @checkExpertClassifier nextProps

    unless nextProps.classification is @props.classification
      @loadClassification nextProps.classification

  loadClassification: (classification) ->
    @setState
      workflow: null
      subject: null

    # TODO: These underscored references are temporary stopgaps.

    Promise.resolve(classification._workflow ? classification.get 'workflow').then (workflow) =>
      @setState {workflow}

    Promise.resolve(classification._subjects ? classification.get 'subjects').then ([subject]) =>
      # We'll only handle one subject per classification right now.
      # TODO: Support multi-subject classifications in the future.
      @setState {subject}

  checkExpertClassifier: (props = @props) ->
    if props.project and props.user and @state.expertClassifier is null
      getUserRoles = props.project.get('project_roles', user_id: props.user.id)
        .then (projectRoles) =>
          getProjectRoleHavers = Promise.all projectRoles.map (projectRole) =>
            projectRole.get 'owner'
          getProjectRoleHavers
            .then (projectRoleHavers) =>
              (projectRoles[i].roles for user, i in projectRoleHavers when user is props.user)
            .then (setsOfUserRoles) =>
              [[], setsOfUserRoles...].reduce (set, next) =>
                set.concat next

      getUserRoles.then (userRoles) =>
        expertClassifier = isAdmin() or 'owner' in userRoles or 'collaborator' in userRoles or 'expert' in userRoles
        @setState {expertClassifier, userRoles}

  render: ->
    if @state.workflow? and @state.subject?
      <Classifier {...@props}
        workflow={@state.workflow}
        subject={@state.subject}
        expertClassifier={@state.expertClassifier}
        userRoles={@state.userRoles} />
    else
      <span>Loading classifier...</span>
