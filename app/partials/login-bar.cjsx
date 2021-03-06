counterpart = require 'counterpart'
React = require 'react'
Translate = require 'react-translate-component'
alert = require '../lib/alert'
LoginDialog = require '../partials/login-dialog'

counterpart.registerTranslations 'en',
  loginBar:
    signIn: 'Sign in'
    register: 'Register'

counterpart.registerTranslations 'es',
  loginBar:
    signIn: 'Ingresar'
    register: 'Registrarse'


module.exports = React.createClass
  displayName: 'LoginBar'

  render: ->
    <div className="login-bar">
      <button type="button" className="secret-button" onClick={@showLoginDialog.bind this, 'sign-in'}>
        <Translate content="loginBar.signIn" />
      </button>
      <button type="button" className="secret-button" onClick={@showLoginDialog.bind this, 'register'}>
        <Translate content="loginBar.register" />
      </button>
    </div>

  showLoginDialog: (which) ->
    alert (resolve) ->
      <LoginDialog which={which} onSuccess={resolve} />
