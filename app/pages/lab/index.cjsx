React = require 'react'
counterpart = require 'counterpart'
Translate = require 'react-translate-component'
{Link} = require 'react-router'
apiClient = require 'panoptes-client/lib/api-client'
ModalFormDialog = require 'modal-form/dialog'
projectActions = require './actions/project'
LandingPage = require './landing-page'

counterpart.registerTranslations 'en',
  main:
    project:
      loading: "Loading..."
      noProjects: "No projects"
      button:
        create: "Create a new project"
        howTo: "How-to"
        policies: "Policies"
        bestPractices: "Best practices"
        builderTalk: "Project builder talk"
        edit: "Edit"
        view: "View"
      creation:
        name: "Project name"
        description: "Short description"
        intro: "Introduction"
        cancel: "Cancel"
        create: "Create project"

counterpart.registerTranslations 'es',
  main:
    project:
      loading: "Cargando..."
      noProjects: "No existen proyectos"
      button:
        create: "Crear un proyecto"
        howTo: "Cómo crear"
        policies: "Políticas"
        bestPractices: "Mejores prácticas"
        builderTalk: "Discusión"
        edit: "Editar"
        view: "Ver"      
      creation:
        name: "Nombre del proyecto"
        description: "Descripción breve"
        intro: "Introducción"
        cancel: "Cancelar"
        create: "Crear"

ProjectLink = React.createClass
  getDefaultProps: ->
    project: {}
    avatar: null
    owner: null

  render: ->
    <div className="lab-index-project-row">
      {if @props.avatar?
        <img className="lab-index-project-row-avatar" src={@props.avatar.src} />}
      <div className="lab-index-project-row-description">
        <strong className="lab-index-project-row-name">{@props.project.display_name}</strong>{' '}
        {if @props.owner?
          <small>by {@props.owner.display_name}</small>}
      </div>
      <Link to="/lab/#{@props.project.id}" className="lab-index-project-row-icon-button">
        <i className="fa fa-pencil fa-fw"></i>{' '}
        <small><Translate content="main.project.button.edit" /></small>
      </Link>
      <Link to="/projects/#{@props.project.slug}" className="lab-index-project-row-icon-button">
        <i className="fa fa-hand-o-right fa-fw"></i>{' '}
        <small><Translate content="main.project.button.view" /></small>
      </Link>
    </div>

ProjectList = React.createClass
  getDefaultProps: ->
    title: ''
    page: 1
    roles: []
    withAvatars: false
    withOwners: false
    onChangePage: ->

  getInitialState: ->
    loading: false
    pages: 0
    projects: []
    avatars: {}
    owners: {}
    error: null

  componentDidMount: ->
    @loadData @props.roles, @props.page, @props.withAvatars, @props.withOwners

  componentWillReceiveProps: (nextProps) ->
    # TODO: This is hacky. Find a nice deep comparison.
    anyChanged = Object.keys(nextProps).some (key) =>
      JSON.stringify(nextProps[key]) isnt JSON.stringify(@props[key])
    if anyChanged
      @loadData nextProps.roles, nextProps.page, nextProps.withAvatars, nextProps.withOwners

  loadData: (roles, page, withAvatars, withOwners) ->
    @setState
      avatars: {}
      owners: {}
      error: null
      loading: true

    include = []
    if @props.withAvatars
      include.push 'avatar'
    if @props.withOwners
      include.push 'owners'

    query =
      current_user_roles: roles
      page: page
      include: include
      sort: 'display_name'

    awaitProjects = apiClient.type('projects').get query
      .then (projects) =>
        @setState {projects}
      .catch (error) =>
        @setState {error}
      .then =>
        @setState loading: false
      .then =>
        @state.projects.forEach (project) =>
          if @props.withAvatars
            project.get 'avatar'
              .catch =>
                {}
              .then (avatar) =>
                @state.avatars[project.id] = avatar
                @forceUpdate()
          if @props.withOwners
            project.get 'owner'
              .catch =>
                null
              .then (owner) =>
                @state.owners[project.id] = owner
                @forceUpdate()

  handlePageChange: (e) ->
    @props.onChangePage parseFloat e.target.value

  render: ->
    pages = Math.max @state.projects[0]?.getMeta()?.page_count ? 1, @props.page

    <div className="content-container">
      <header>
        <p>
          <strong className="form-label">{@props.title}</strong>{' '}
          {unless @state.error? or pages is 1
            <small className="form-help">
              Page{' '}
              <select value={@props.page} disabled={@state.loading} onChange={@handlePageChange}>
                {[1..pages].map (page) =>
                  <option key={page} value={page}>{page}</option>}
              </select>
            </small>}
        </p>
      </header>

      {if @state.loading
        <small className="form-help"><Translate content="main.project.loading" /></small>
      else if @state.error?
        <p className="form-help error">{@state.error.toString()}</p>
      else if @state.projects.length is 0
        <p className="form-help"><Translate content="main.project.noProjects" /></p>
      else
        <ul className="lab-index-project-list">
          {@state.projects.map (project) =>
            <li key={project.id}>
              <ProjectLink
                project={project}
                avatar={@state.avatars[project.id]}
                owner={@state.owners[project.id]}
              />
            </li>}
        </ul>}
    </div>

ProjectCreationForm = React.createClass
  getDefaultProps: ->
    onCancel: ->
    onSubmit: ->
    onSuccess: ->

  getInitialState: ->
    busy: false
    error: null

  handleSubmit: (e) ->
    e.preventDefault()

    @setState
      busy: true
      error: null

    awaitSubmission = @props.onSubmit
      display_name: @refs.displayNameInput.value
      description: @refs.descriptionInput.value
      introduction: @refs.introductionInput.value

    Promise.resolve(awaitSubmission)
      .then (result) =>
        @props.onSuccess result
      .catch (error) =>
        @setState {error}
      .then =>
        @setState busy: false

  render: ->
    <form onSubmit={@handleSubmit} style={maxWidth: '90vw', width: '60ch'}>
      <p>
        <label>
          <span className="form-label"><Translate content="main.project.creation.name" /></span><br />
          <input type="text" ref="displayNameInput" className="standard-input full" defaultValue="Proyecto sin título (#{new Date().toLocaleString()})" required disabled={@state.busy} />
        </label>
      </p>
      <p>
        <label>
          <span className="form-label"><Translate content="main.project.creation.description" /></span><br />
          <input type="text" ref="descriptionInput" className="standard-input full" defaultValue="Descripción breve del proyecto" required disabled={@state.busy} />
        </label>
      </p>
      <p>
        <label>
          <span className="form-label"><Translate content="main.project.creation.intro" /></span><br />
          <textarea type="text" ref="introductionInput" className="standard-input full" defaultValue=Introducción en profundidad sobre tu investigación" rows="5" required disabled={@state.busy} />
        </label>
      </p>
      {if @state.error?
        <p className="form-help error">{@state.error.toString()}</p>}
      <p style={textAlign: 'center'}>
        <button type="button" className="minor-button" disabled={@state.busy} onClick={@props.onCancel}><Translate content="main.project.creation.cancel" /></button>{' '}
        <button type="submit" className="major-button" disabled={@state.busy}><Translate content="main.project.creation.create" /></button>
      </p>
    </form>

module.exports = React.createClass
  getDefaultProps: ->
    user: null
    loaction:
      query:
        'owned-page': 1
        'collaborations-page': 1
    actions: projectActions

  getInitialState: ->
    creationInProgress: false

  handlePageChange: (which, page) ->
    queryUpdate = {}
    queryUpdate[which] = page
    newQuery = Object.assign {}, @props.location.query, queryUpdate
    newLocation = Object.assign {}, @props.location, query: newQuery
    @props.history.replace newLocation

  showProjectCreator: ->
    @setState creationInProgress: true

  hideProjectCreator: ->
    @setState creationInProgress: false

  handleProjectCreation: (project) ->
    @hideProjectCreator()
    newLocation = Object.assign {}, @props.location, pathname: "/lab/#{project.id}"
    @props.history.push newLocation

  render: ->
    if @props.user?
      <div>
        <ProjectList
          title="Crear un proyecto"
          page={@props.location.query['owned-page']}
          roles={['owner', 'workaround']}
          withAvatars
          onChangePage={@handlePageChange.bind this, 'owned-page'}
        />
        <div className="content-container">
          <p style={textAlign: 'center'}>
            <button type="button" className="major-button" onClick={@showProjectCreator}><Translate content="main.project.button.create" /></button>{' '}
            <Link to="/lab-how-to" className="standard-button"><Translate content="main.project.button.howTo" /></Link>{' '}
            <Link to="/lab-policies" className="standard-button"><Translate content="main.project.button.policies" /></Link>{' '}
            <Link to="/lab-best-practices/introduction" className="standard-button"><Translate content="main.project.button.bestPractices" /></Link>{' '}
            <Link to="/talk/18" className="standard-button"><Translate content="main.project.button.builderTalk" /></Link>
          </p>
        </div>
        {if @state.creationInProgress
          <ModalFormDialog tag="div">
            <ProjectCreationForm onSubmit={@props.actions.createProject} onCancel={@hideProjectCreator} onSuccess={@handleProjectCreation} />
          </ModalFormDialog>}
        <hr />
        <ProjectList
          title="Colaboraciones"
          page={@props.location.query['collabarations-page']}
          roles={['collaborator']}
          withOwners
          style={fontSize: '0.8em'}
          onChangePage={@handlePageChange.bind this, 'collabarations-page'}
        />
      </div>

    else
      <LandingPage />
