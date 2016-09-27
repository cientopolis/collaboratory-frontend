counterpart = require 'counterpart'
React = require 'react'
Translate = require 'react-translate-component'
alert = require '../lib/alert'
LoginDialog = require './login-dialog'

counterpart.registerTranslations 'en',
  note: '''Signing in allows you to participate in discussions, allows us to give you credit for your work, and helps the science team make the best use of the data you provide.'''
  no: 'No, thanks'
  signIn: 'Sign in'
  register: 'Register'

counterpart.registerTranslations 'es',
  note: '''Ingresar te permite participar en los foros de discusión, obtener crédito por tu trabajo, y ayuda al equipo de investigación a utilizar de la mejor manera la información que les provees.'''
  no: 'No, gracias'
  signIn: 'Ingresar'
  register: 'Registrarse'

module.exports = React.createClass
  displayName: 'SignInPrompt'

  getDefaultProps: ->
    project: {}
    onChoose: Function.prototype # No-op

  render: ->
    <div className="content-container">
      {@props.children}
      <p><Translate content="note" /></p>
      <p className="columns-container spread inline">
        <span>
          <button type="button" className="minor-button" onClick={@dismiss}><Translate content="no" /></button>
        </span>
        <span>
          <button type="button" className="standard-button" autoFocus onClick={@signIn}><Translate content="signIn" /></button>{' '}
          <button type="button" className="standard-button" onClick={@register}><Translate content="register" /></button>
        </span>
      </p>
    </div>

  dismiss: ->
    @props.onChoose()

  signIn: ->
    @props.onChoose()
    alert (resolve) =>
      <LoginDialog which="sign-in" project={@props.project} onSuccess={resolve} />

  register: ->
    @props.onChoose()
    alert (resolve) =>
      <LoginDialog which="register" project={@props.project} onSuccess={resolve} />
