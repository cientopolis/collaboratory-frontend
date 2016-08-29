counterpart = require 'counterpart'
React = require 'react'
Translate = require 'react-translate-component'
auth = require 'panoptes-client/lib/auth'
alert = require '../lib/alert'
LoginDialog = require '../partials/login-dialog'

counterpart.registerTranslations 'en',
  forgotten:
    header: 'So, you’ve forgotten your password'
    text: 'It happens to the best of us. Just enter your email address here and we’ll send you a link you can follow to reset it.'
    submit: 'Submit'
    emailSent: 'We’ve just sent you an email with a link to reset your password.'
    error: 'There was an error reseting your password.'
  reset:
    success: 'You have successfully reset your password, please login to get started.'
    new: 'Go ahead and enter a new password, then you can get back to doing some research.'
    pass: 'New password:'
    again: 'Again, to confirm:'
    submit: 'Submit'
    error: 'Something went wrong, please try and reset your password via email again.'


counterpart.registerTranslations 'es',
  forgotten:
    header: 'Así que olvidaste tu contraseña'
    text: 'Nos pasa a todos. Simplemente ingrese su dirección de correo electrónico y le enviaremos un link para resetear su contraseña.'
    submit: 'Enviar'
    emailSent: 'El correo con el link para resetear la contraseña fue enviado.'
    error: 'Hubo un error al resetear su contraseña.'
  reset:
    success: 'Ha reseteado su contraseña con éxito. Por favor, vuelva a ingresar.'
    new: 'Ingrese una nueva contraseña y vuelva a hacer algo de investigación.'
    pass: 'Nueva contraseña:'
    again: 'Otra vez, para confirmar:'
    submit: 'Enviar'
    error: 'Algo salió mal. Por favor, intente resetear su contraseña otra vez.'

module.exports = React.createClass
  displayName: 'ResetPasswordPage'

  getDefaultProps: ->
    query: {}

  getInitialState: ->
    inProgress: false
    resetSuccess: false
    resetError: null
    emailSuccess: false
    emailError: false
    emailIsValid: false

  componentDidMount: ->
    @handleEmailChange()

  handleResetSubmit: (e) ->
    e.preventDefault()

    @setState
      inProgress: true
      resetSuccess: false
      resetError: null

    token = @props.location.query.reset_password_token
    password = @refs.password.value
    confirmation = @refs.confirmation.value

    auth.resetPassword {password, confirmation, token}
      .then =>
        @setState resetSuccess: true
        alert (resolve) ->
          <LoginDialog onSuccess={=>
            location.hash = '/' # Sorta hacky.
            resolve()
          } />
        return
      .catch (error) =>
        @setState resetError: error
      .then =>
        @setState inProgress: false

  handleEmailChange: ->
    @setState { emailIsValid: @refs.email?.checkValidity() }

  handleEmailSubmit: (e) ->
    e.preventDefault()

    @setState
      inProgress: true
      emailSuccess: false
      emailError: false

    email = @refs.email.value

    auth.requestPasswordReset {email}
      .then =>
        @setState emailSuccess: true
      .catch =>
        @setState emailError: true
      .then =>
        @setState inProgress: false

  render: ->
    <div className="centered-grid">
      {if @props.location.query?.reset_password_token?
        if @state.resetSuccess
          <p><Translate content="reset.success" /></p>
        else
          <form method="POST" onSubmit={@handleResetSubmit}>
            <p><Translate content="reset.new" /></p>

            <p>
              <Translate content="reset.pass" /><br />
              <input ref="password" type="password" className="standard-input" size="20" />
            </p>

            <p>
              <Translate content="reset.again" /><br />
              <input ref="confirmation" type="password" className="standard-input" size="20" />
            </p>

            <p>
              <button type="submit" className="standard-button" disabled={@state.resetError || @state.resetSuccess}><Translate content="reset.submit" /></button>{' '}
              {if @state.inProgress
                <i className="fa fa-spinner fa-spin form-help"></i>
              else if @state.resetSuccess
                <i className="fa fa-check-circle form-help success"></i>
              else if @state.resetError?
                <small className="form-help error"><Translate content="reset.error" /> {@state.resetError.toString()}</small>}
            </p>
          </form>

      else
        <form onSubmit={@handleEmailSubmit}>
          <p><strong><Translate content="forgotten.header" /></strong></p>
          <p><Translate content="forgotten.text" /></p>
          <p>
            <input ref="email" type="email" required onChange={@handleEmailChange} className="standard-input" defaultValue={@props.location.query?.email} size="50" />
          </p>
          <p>
            <button type="submit" className="standard-button" disabled={!@state.emailIsValid}><Translate content="forgotten.submit" /></button>

            {' '}

            {if @state.inProgress
              <i className="fa fa-spinner fa-spin form-help"></i>
            else if @state.emailSuccess
              <i className="fa fa-check-circle form-help success"></i>}
          </p>

          {if @state.emailSuccess
            <p><Translate content="forgotten.emailSent" /></p>
          else if @state.emailError
            <small className="form-help error"><Translate content="forgotten.error" /></small>}
        </form>}
    </div>
