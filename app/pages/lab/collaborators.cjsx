counterpart = require 'counterpart'
React = require 'react'
Translate = require 'react-translate-component'
ReactDOM = require 'react-dom'
PromiseRenderer = require '../../components/promise-renderer'
UserSearch = require '../../components/user-search'
apiClient = require 'panoptes-client/lib/api-client'
talkClient = require 'panoptes-client/lib/talk-client'
projectSection = require '../../talk/lib/project-section'

counterpart.registerTranslations 'en',
  projectOwner:
    label: 'Project Owner'
    self: 'You are the project owner'
    another: ' is the project owner'
  collaborators:
    none: 'None yet'
  error: 'Your account status on this project is still being setup. Please try again later.'
  addUserRole:
    label: 'Add another'
    button: 'Add user role'
  roles:
    collab:
      label: 'Collaborator'
      description: 'Collaborators have full access to edit workflows and project content, including deleting some or all of the project.'
    expert:
      label: 'Expert'
      description: 'Experts can enter "gold mode" to make authoritative gold standard classifications that will be used to validate data quality.'
    scientist:
      label: 'Researcher'
      description: 'Members of the research team will be marked as researchers on "Talk"'
    moderator:
      label: 'Moderator'
      description: 'Moderators have extra privileges in the community discussion area to moderate discussions. They will also be marked as moderators on "Talk".'
    tester:
      label: 'Tester'
      description: 'Testers can view and classify on your project to give feedback while it’s still private. They cannot access the project builder.'
    translator:
      label: 'Translator'
      description: 'Translators will have access to the translation site.'

counterpart.registerTranslations 'es',
  projectOwner:
    label: 'Dueño del proyecto'
    self: 'Sos el dueño del proyecto'
    another: ' es el dueño del proyecto'
  collaborators:
    none: 'Ninguno aún'
  error: 'El estado de tu cuenta en este proyecto todavía está siendo definido. Por favor, intentá de nuevo más tarde.'
  addUserRole:
    label: 'Agregar otro'
    button: 'Agregar rol'
  roles:
    collab:
      label: 'Colaborador'
      description: 'Los colaboradores tienen acceso total para editar los flujos de trabajo y el contenido del proyecto, incluyendo poder borrar algunas cosas o el proyecto en sí.'
    expert:
      label: 'Experto'
      description: 'Los expertos pueden entrar en el modo "estándar oro", en el cual pueden realizar clasificaciones autoritativas que sirven para validar la calidad de los datos ingresados por los voluntarios.'
    scientist:
      label: 'Investigador'
      description: 'Los miembros del grupo de investigación serán marcados como tal en los foros de discusión'
    moderator:
      label: 'Moderador'
      description: 'Los moderadores tienen privilegios extra en los foros de discusión de la comunidad, y son los que moderan estas discusiones. Serán marcados como tal en los foros de discusión.'
    tester:
      label: 'Tester'
      description: 'Un tester puede ver y realizar clasificaciones en el proyecto para brindar retroalimentación cuando el proyecto todavía es privado. Un tester no puede acceder a la sección de creación del proyecto'
    translator:
      label: 'Traductor'
      description: 'Los traductores tienen acceso al sitio de traducción.'

ID_PREFIX = 'LAB_COLLABORATORS_PAGE_'

POSSIBLE_ROLES = {
  collaborator: 'admin',
  expert: 'team',
  scientist: 'scientist',
  moderator: 'moderator',
  tester: 'team'
}

ROLES_INFO =
  collaborator:
    label: <Translate content="roles.collab.label" />
    description: <Translate content="roles.collab.description" />
  expert:
    label: <Translate content="roles.expert.label" />
    description: <Translate content="roles.expert.description" />
  scientist:
    label: <Translate content="roles.scientist.label" />
    description: <Translate content="roles.scientist.description" />
  moderator:
    label: <Translate content="roles.moderator.label" />
    description: <Translate content="roles.moderator.description" />
  tester:
    label: <Translate content="roles.tester.label" />
    description: <Translate content="roles.tester.description" />
  translator:
    label: <Translate content="roles.translator.label" />
    description: <Translate content="roles.translator.description" />

CollaboratorCreator = React.createClass
  displayName: 'CollaboratorCreator'

  getDefaultProps: ->
    project: null

  getInitialState: ->
    error: null
    creating: false

  render: ->
    style = if @state.creating
      opacity: 0.5
      pointerEvents: 'none'

    <div>
      {if @state.error?
        <p className="form-help error">{@state.error.toString()}</p>}
      <form style={style}>
        <div>
          <UserSearch />
        </div>

        <table className="standard-table">
          <tbody>
            {for role, label of POSSIBLE_ROLES
              <tr key={role + '-' + label}>
                <td><input id={ID_PREFIX + role} type="checkbox" name="role" value={role} disabled={role is 'owner'}/></td>
                <td><strong><label htmlFor={ID_PREFIX + role}>{ROLES_INFO[role].label}</label></strong></td>
                <td>{ROLES_INFO[role].description}</td>
              </tr>}
          </tbody>
        </table>

        <p>
          <button type="submit" className="major-button" onClick={@handleSubmit}><Translate content="addUserRole.button" /></button>
        </p>
      </form>
    </div>

  handleSubmit: (e) ->
    e.preventDefault()
    node = ReactDOM.findDOMNode(@)
    checkboxes = node.querySelectorAll '[name="role"]'
    userids = node.querySelector('[name="userids"]')
    users = userids.value.split(',').map (id) -> parseInt(id)
    roles = for checkbox in checkboxes when checkbox.checked
      checkbox.value

    talkRoles = for role, talkRole of POSSIBLE_ROLES when role in roles
      talkRole

    talkRoles = talkRoles.reduce(((memo, role) ->
      memo.push(role) unless role in memo
      memo
    ), [])

    @setState
      error: null
      creating: true

    newRoles = users.reduce(((memo, id) =>
      newRoleSet = apiClient.type('project_roles').create
        roles: roles
        links:
          project: @props.project.id
          user: id

      newTalkRoleSets = for role in talkRoles
        talkClient.type('roles').create
          name: role
          section: projectSection(@props.project)
          user_id: id

      memo.concat([newRoleSet]).concat(newTalkRoleSets)
    ), [])

    Promise.all(roleSet.save() for roleSet in newRoles)
      .then =>
        userids.value = ''
        for checkbox in checkboxes
          checkbox.checked = false
        @props.onAdd? arguments...

      .catch (error) =>
        if error.message.match /not allowed to create this role/i
          error.message = <Translate content="error" />

        @setState {error}

      .then =>
        @setState creating: false

module.exports = React.createClass
  displayName: 'EditProjectCollaborators'

  getDefaultProps: ->
    project: null

  getInitialState: ->
    error: null
    saving: []

  fetchAllRoles: ->
    Promise.all([@props.project.get('project_roles'), talkClient.type('roles').get(section: @talkSection(), page_size: 100)])
      .then ([panoptesRoles, talkRoles]) ->
        for roleSet in panoptesRoles when roleSet.links.owner.type == 'users'
          roleSet['talk_roles'] = talkRoles.filter((role) -> role.links.user == roleSet.links.owner.id)
          roleSet

  render: ->
    <div>
      <div className="form-label"><Translate content="projectOwner.label" /></div>
      <PromiseRenderer promise={@props.project.get('owner')} then={(projectOwner) =>
        projectOwnerMessage = if @props.user.id is projectOwner.id
          <Translate content="projectOwner.self" />
        else
          projectOwner.display_name + <Translate content="projectOwner.another" />

        <p>
          {projectOwnerMessage}
        </p>
      } />

      <br />

      <div className="form-label">Collaborators</div>

      <hr />

      {if @state.error?
        <p className="form-help error">{@state.error.toString()}</p>}

      <PromiseRenderer promise={@fetchAllRoles()} then={(projectRoleSets) =>
        <div>
          {if projectRoleSets.length > 1
            for projectRoleSet in projectRoleSets when 'owner' not in projectRoleSet.roles
              <PromiseRenderer key={projectRoleSet.id} promise={projectRoleSet.get 'owner'} then={@renderUserRow.bind this, projectRoleSet} />
          else
            <em className="form-help"><Translate content="collaborators.none" /></em>}
        </div>
      } />

      <hr />

      <div className="form-label"><Translate content="addUserRole.label" /></div>
      <CollaboratorCreator project={@props.project} onAdd={@handleCollaboratorAddition} />
    </div>

  renderUserRow: (projectRoleSet, user) ->
    <p>
      <strong>{user.display_name}</strong>{' '}
      <button type="button" className="secret-button" onClick={@removeRoleSet.bind this, projectRoleSet}>&times;</button>
      <br />

      <span className="columns-container inline">
        {for role, _ of POSSIBLE_ROLES
          toggleThisRole = @toggleRole.bind this, projectRoleSet, role
          # TODO: Translate this.
          <label key={role}>
            <input type="checkbox" name={role} checked={role in projectRoleSet.roles} disabled={role is 'owner' or projectRoleSet.id in @state.saving} onChange={toggleThisRole} />{' '}
            {ROLES_INFO[role].label}
          </label>}
      </span>
    </p>

  toggleRole: (projectRoleSet, role) ->
    index = projectRoleSet.roles.indexOf role

    @state.saving.push projectRoleSet.id

    @setState
      error: null
      saving: @state.saving

    talkRoleAction = if index is -1
      projectRoleSet.roles.push role
      talkClient.type('roles').create(
        user_id: parseInt(projectRoleSet.links.owner.id)
        section: @talkSection()
        name: POSSIBLE_ROLES[role]
      ).save()
    else
      projectRoleSet.roles.splice index, 1
      filteredRoles = projectRoleSet.talk_roles.filter (talkRole) ->
        talkRole.name is POSSIBLE_ROLES[role]
      filteredRoles[0]?.delete()

    Promise.all([projectRoleSet.update('roles').save(), talkRoleAction])
      .catch (error) =>
        @setState {error}
      .then =>
        savingIndex = @state.saving.indexOf projectRoleSet.id
        @state.saving.splice savingIndex, 1
        @setState saving: @state.saving

  removeRoleSet: (projectRoleSet) ->
    @state.saving.push projectRoleSet.id

    @setState
      error: null
      saving: @state.saving

    Promise.all([projectRoleSet.delete(), talkRole.delete() for talkRole in projectRoleSet.talk_roles])
      .catch (error) =>
        @setState {error}

      .then =>
        @props.project.uncacheLink 'project_roles'

        savingIndex = @state.saving.indexOf projectRoleSet.id
        @state.saving.splice savingIndex, 1
        @setState saving: @state.saving

  talkSection: ->
    projectSection(@props.project)

  handleCollaboratorAddition: ->
    @props.project.uncacheLink 'project_roles'
    @forceUpdate()
