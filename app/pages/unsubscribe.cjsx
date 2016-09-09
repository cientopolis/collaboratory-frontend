counterpart = require 'counterpart'
React = require 'react'
Translate = require 'react-translate-component'
auth = require 'panoptes-client/lib/auth'
alert = require '../lib/alert'
LoginDialog = require '../partials/login-dialog'

counterpart.registerTranslations 'en',
  processed:
    success: "Your unsubscribe request was successfully processed."
    changeOfMind:
      ifYou: "If you change your mind, just visit your "
      accountSettings: "account settings"
      toUpdate: " page to update your email preferences."
  unsuscribe:
    unsuscribe: "Unsubscribe from all Zooniverse emails."
    weGetIt: "We get it - no one likes to keep receiving email they don't want."
    enterEmail: "Just enter your email address here and we'll unsubscribe you from ALL our email lists."
  unsuscribed: "You've been unsubscribed!"
  error: "There was an error unsubscribing your email."


counterpart.registerTranslations 'es',
  processed:
    success: "Tu petición para darte de baja ha sido procesada con éxito."
    changeOfMind:
      ifYou: "Si cambiás de parecer, visitá tus "
      accountSettings: "opciones de perfil"
      toUpdate: " para actualizar tu preferencias de correos."
  unsuscribe:
    unsuscribe: "Darse de baja de todos los correos de Cientópolis."
    weGetIt: "Es entendible - a nadie le gusta recibir demasiados emails."
    enterEmail: "Simplemente ingresá tu dirección de correo electrónico y te daremos de baja de TODAS nuestras listas de correo"
  unsuscribed: "¡Te has dado de baja!"
  error: "Hubo un error."


module.exports = React.createClass
  displayName: 'UnsubscribeFromEmailsPage'

  getDefaultProps: ->
    location: query: {}

  getInitialState: ->
    inProgress: false
    resetSuccess: false
    resetError: null
    emailSuccess: false
    emailError: false
    emailIsValid: false

  componentDidMount: ->
    @handleEmailChange()

  handleEmailChange: ->
    @setState { emailIsValid: @refs.email.checkValidity() }

  handleEmailSubmit: (e) ->
    e.preventDefault()

    @setState
      inProgress: true
      emailSuccess: false
      emailError: false

    email = @refs.email.value

    auth.unsubscribeEmail {email}
      .then =>
        @setState emailSuccess: true
      .catch =>
        @setState emailError: true
      .then =>
        @setState inProgress: false

  render: ->
    <div className="centered-grid">
      {if @props.location.query?.processed
        <div>
          <p><strong><Translate content="processed.success" /></strong></p>
          <p><Translate content="processed.changeOfMind.ifYou" /><a href="#{document.baseURI.slice(0, -1)}/settings"><Translate content="processed.changeOfMind.accountSettings" /></a><Translate content="processed.changeOfMind.toUpdate" /></p>
        </div>
      else
        <form onSubmit={@handleEmailSubmit}>
          <p><strong><Translate content="unsuscribe.unsuscribe" /></strong></p>
          <p><Translate content="unsuscribe.weGetIt" /></p>
          <p><Translate content="unsuscribe.enterEmail" /></p>
          <p>
            <input ref="email" type="email" required onChange={@handleEmailChange} className="standard-input" defaultValue={@props.location.query?.email} size="50" />
          </p>
          <p>
            <button type="submit" className="standard-button" disabled={!@state.emailIsValid || @state.emailSuccess}>Submit</button>

            {' '}

            {if @state.inProgress
              <i className="fa fa-spinner fa-spin form-help"></i>
            else if @state.emailSuccess
              <i className="fa fa-check-circle form-help success"></i>}
          </p>

          {if @state.emailSuccess
            <p><Translate content="unsuscribed" /></p>
          else if @state.emailError
            <small className="form-help error"><Translate content="error" /></small>}
        </form>}
    </div>
