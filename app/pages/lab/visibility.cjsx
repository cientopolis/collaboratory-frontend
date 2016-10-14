React = require 'react'
counterpart = require 'counterpart'
Translate = require 'react-translate-component'
SetToggle = require '../../lib/set-toggle'

counterpart.registerTranslations 'en',
  visibility:
    header: 'Project state and visibility'
    private: 'Private'
    public: 'Public'
    note:
      only: 'Only the assigned '
      collaborators: 'collaborators'
      can: ' can view a private project. Anyone with the URL can access a public project.'
    development: 'Development'
    live: 'Live'
    stateNote: 'Workflows can be edited during development, and subjects will never retire. In a live project, workflows are locked and can no longer be edited, and classifications count toward subject retirement.'
    review:
      apply: 'Apply for review'
      onlyPublic:
        only: 'Only '
        public: 'public projects'
        can: ' can apply for review.'
      onlyLive:
        only: 'Only '
        public: 'live projects'
        can: ' can apply for review.'  
      appliedFor: 'Review status has been applied for. '
      cancel: 'Cancel application'
      pending: 'Pending approval, expose this project to users who have opted in to help test new projects.'
    beta:
      status: 'Beta Approval Status: '
      approved:
        label: 'Approved'
        note:
          review: 'Review status for this project has been approved. To end the review and make changes, switch back to '
          development: 'development'
          mode: ' mode.'
      ready: 'If you’re ready to launch this project, see the next section.'
      pending: 'Pending'
    fullLaunch:
      label: 'Apply for full launch'
      note:
        only: 'Only '
        review: 'projects in review'
        can: ' can apply for a full launch.'
      status: 'Launch approval status: '
      approved: 'Approved'
      available: 'This project is available to the whole Zooniverse!'
      pending: 
        label: 'Pending'
        awaiting: 'Launch is awaiting Zooniverse approval. '
        cancel: 'Cancel'
        note: 'Pending approval, expose this project to the entire Zooniverse through the main projects listing.'

counterpart.registerTranslations 'es',
  visibility:
    header: 'Estado del proyecto y visibilidad'
    private: 'Privado'
    public: 'Público'
    note:
      only: 'Sólo los '
      collaborators: 'colaboradores'
      can: ' asignados pueden ver un proyecto privado. Cualquiera con la URL puede acceder un proyecto público.'
    development: 'Desarrollo'
    live: 'En vivo'
    stateNote: 'Los flujos de trabajo pueden editarse durante el estado de desarrollo, y los elementos de análisis nunca serán retirados. En un proyecto en vivo, los flujos de trabajo se bloquean y no pueden ser editados, y las clasificaciones cuentan en relación al retirado de elementos.'
    review:
      apply: 'Solicitar revisión'
      onlyPublic:
        only: 'Sólo '
        public: 'proyectos públicos'
        can: ' pueden solicitar revisión.'
      onlyLive:
        only: 'Sólo '
        public: 'lproyectos en vivo'
        can: ' pueden solicitar revisión.'  
      appliedFor: 'Se ha enviado la solicitud de revisión. '
      cancel: 'Cancelar solicitud'
      pending: 'Aprobación pendiente. Exponé el proyecto a usuarios que indicaron que desean ayudar a probar proyectos nuevos.'
    beta:
      status: 'Estado de aprobación para la beta: '
      approved:
        label: 'Aprobado'
        note:
          review: 'El estado de revisión del proyecto ha sido aprobado. Para finalizar la revisión y poder realizar cambios, volvé al modo de '
          development: 'desarrollo'
          mode: ''
      ready: 'Si estás listo para hacer el lanzamiento de este proyecto, mirá la siguiente sección.'
      pending: 'Pendiente'
    fullLaunch:
      label: 'Solicitar lanzamiento'
      note:
        only: 'Sólo '
        review: 'proyectos en revisión'
        can: ' pueden solicitar su lanzamiento.'
      status: 'Estado de aprobación del lanzamiento: '
      approved: 'Aprobado'
      available: '¡Este proyecto está disponible para todos!'
      pending: 
        label: 'Pendiente'
        awaiting: 'El lanzamiento está esperando por su aprobación. '
        cancel: 'Cancelar'
        note: 'Aprobación pendiente. Exponé el proyecto a todos los usuarios de la plataforma mediante el listado principal de proyectos.'

module.exports = React.createClass
  displayName: 'EditProjectVisibility'

  getDefaultProps: ->
    project: null

  getInitialState: ->
    error: null
    setting:
      private: false
      beta_requested: false
      launch_requested: false

  mixins: [SetToggle]

  setterProperty: 'project'

  render: ->
    looksDisabled =
      opacity: 0.7
      pointerEvents: 'none'

    <div>
      <p className="form-label">Project state and visibility</p>

      {if @state.error
        <p className="form-help error">{@state.error.toString()}</p>}

      <p>
        <label style={whiteSpace: 'nowrap'}>
          <input type="radio" name="private" value={true} data-json-value={true} checked={@props.project.private} disabled={@state.setting.private} onChange={@set.bind this, 'private', true} />
          <Translate content="visibility.private" />
        </label>
        &emsp;
        <label style={whiteSpace: 'nowrap'}>
          <input type="radio" name="private" value={false} data-json-value={true} checked={not @props.project.private} disabled={@state.setting.private} onChange={@set.bind this, 'private', false} />
          <Translate content="visibility.public" />
        </label>
      </p>

      <p className="form-help"><Translate content="visibility.note.only" /><strong><Translate content="visibility.note.collaborators" /></strong><Translate content="visibility.note.can" /></p>

      <hr/>

      <label style={whiteSpace: 'nowrap'}>
        <input type="radio" name="live" value={true} data-json-value={true} checked={not @props.project.live} disabled={@state.setting.live} onChange={@set.bind this, 'live', false} />
        <Translate content="visibility.development" />
      </label>
      &emsp;
      <label style={whiteSpace: 'nowrap'}>
        <input type="radio" name="live" value={false} data-json-value={true} checked={@props.project.live} disabled={@state.setting.live} onChange={@set.bind this, 'live', true} />
        <Translate content="visibility.live" />
      </label>

      <p className="form-help"><Translate content="visibility.stateNote" /></p>

      <div style={looksDisabled if @props.project.private or not @props.project.live}>
        <hr />

        <p>
          <button type="button" className="standard-button" disabled={@props.project.private or not @props.project.live or @state.setting.beta_requested or @props.project.beta_requested or @props.project.beta_approved} onClick={@set.bind this, 'beta_requested', true}><Translate content="visibility.review.apply" /></button>{' '}
          {if @props.project.private
            <span><Translate content="visibility.review.onlyPublic.only" /><strong><Translate content="visibility.review.onlyPublic.public" /></strong><Translate content="visibility.review.onlyPublic.can" /></span>
          else if not @props.project.live
            <span><Translate content="visibility.review.onlyLive.only" /><strong><Translate content="visibility.review.onlyLive.public" /></strong><Translate content="visibility.review.onlyLive.can" /></span>
          else if @props.project.beta_requested
            <span><Translate content="visibility.review.appliedFor" /><button type="button" disabled={@state.setting.beta_requested} onClick={@set.bind this, 'beta_requested', false}><Translate content="visibility.review.cancel" /></button></span>}
        </p>

        {unless @props.project.beta_approved
          <p className="form-help"><Translate content="visibility.review.pending" /></p>}

        {if @props.project.beta_approved
          <span>
            <div className="approval-status">
              <span><Translate content="visibility.beta.status" /></span>
              <span className="color-label green"><Translate content="visibility.beta.approved.label" /></span>
            </div>
            <p>
              <Translate content="visibility.beta.approved.note.review" /><em><Translate content="visibility.beta.approved.note.development" /></em><Translate content="visibility.beta.approved.note.mode" />
              {unless @props.project.launch_requested or @props.project.launch_approved
                <span><Translate content="visibility.beta.ready" /></span>}
            </p>
          </span>
        else if @props.project.beta_requested
          <div className="approval-status">
            <span><Translate content="visibility.beta.status" /></span>
            <span className="color-label orange"><Translate content="visibility.beta.pending" /></span>
          </div>}

        <div style={looksDisabled unless @props.project.beta_approved}>
          <hr />

          <p>
            <button type="button" className="standard-button" disabled={not @props.project.beta_approved or @state.setting.launch_requested or @props.project.launch_requested} onClick={@set.bind this, 'launch_requested', true}><Translate content="visibility.fullLaunch.label" /></button>{' '}

            {unless @props.project.beta_approved
              <span><Translate content="visibility.fullLaunch.note.only" /><strong><Translate content="visibility.fullLaunch.note.review" /></strong><Translate content="visibility.fullLaunch.note.can" /></span>}

            {if @props.project.launch_approved
              <span>
              <div className="approval-status">
                <span><Translate content="visibility.fullLaunch.status" /></span>
                <span className="color-label green"><Translate content="visibility.fullLaunch.approved" /></span>
              </div>
                <Translate content="visibility.fullLaunch.available" />
              </span>
            else if @props.project.launch_requested
              <span>
                <div className="approval-status">
                  <span><Translate content="visibility.fullLaunch.status" /></span>
                  <span className="color-label orange"><Translate content="visibility.fullLaunch.pending.label" /></span>
                </div>
                <Translate content="visibility.fullLaunch.pending.awaiting" /><button type="button" disabled={@state.setting.launch_requested} onClick={@set.bind this, 'launch_requested', false}><Translate content="visibility.fullLaunch.pending.cancel" /></button>
              </span>}
          </p>

          {unless @props.project.launch_approved
            <p className="form-help"><Translate content="visibility.fullLaunch.pending.note" /></p>}

        </div>
      </div>
    </div>
