React = require 'react'
counterpart = require 'counterpart'
Translate = require 'react-translate-component'
AutoSave = require '../../components/auto-save'
handleInputChange = require '../../lib/handle-input-change'
auth = require 'panoptes-client/lib/auth'

counterpart.registerTranslations 'en',
  pass:
    changeLabel: 'Change your password'
    current: 'Current password'
    new: 'New password'
    confirm: 'Confirm new password'
    changeButton: 'Change'
    tooShort: 'That\'s too short'
    dontMatch: 'These don\'t match'
  name:
    display: 
      label: 'Display name'
      note: 'How your name will appear to other users in Talk and on your Profile Page'
    credited:
      label: 'Credited name'
      note: 'Public; we’ll use this to give acknowledgement in papers, on posters, etc.'


counterpart.registerTranslations 'es',
  pass: 
    changeLabel: 'Cambiar contraseña'
    current: 'Contraseña actual'
    new: 'Nueva contraseña'
    confirm: 'Confirmar contraseña nueva'
    changeButton: 'Cambiar'
    tooShort: 'Es muy corta'
    dontMatch: 'No coinciden'
  name:
    display:
      label: 'Nombre a mostrar'
      note: 'El nombre que aparecerá en los foros y en tu perfil'
    credited:
      label: 'Nombre real a acreditar'
      note: 'Público; se utilizará para darte crédito en papers, posters, etc'


MIN_PASSWORD_LENGTH = 8

ChangePasswordForm = React.createClass
  displayName: 'ChangePasswordForm'

  getDefaultProps: ->
    user: {}

  getInitialState: ->
    old: ''
    new: ''
    confirmation: ''
    inProgress: false
    success: false
    error: null

  render: ->
    <form ref="form" method="POST" onSubmit={@handleSubmit}>
      <p>
        <strong><Translate content="pass.changeLabel" /></strong>
      </p>

      <table className="standard-table">
        <tbody>
          <tr>
            <td><Translate content="pass.current" /></td>
            <td><input type="password" className="standard-input" size="20" onChange={(e) => @setState old: e.target.value} /></td>
          </tr>
          <tr>
            <td><Translate content="pass.new" /></td>
            <td>
              <input type="password" className="standard-input" size="20" onChange={(e) => @setState new: e.target.value} />
              {if @state.new.length isnt 0 and @tooShort()
                <small className="form-help error"><Translate content="pass.tooShort" /></small>}
            </td>
          </tr>
          <tr>
            <td><Translate content="pass.confirm" /></td>
            <td>
              <input type="password" className="standard-input" size="20" onChange={(e) => @setState confirmation: e.target.value} />
              {if @state.confirmation.length >= @state.new.length - 1 and @doesntMatch()
                <small className="form-help error"><Translate content="pass.dontMatch" /></small>}
            </td>
          </tr>
        </tbody>
      </table>

      <p>
        <button type="submit" className="standard-button" disabled={not @state.old or not @state.new or @tooShort() or @doesntMatch() or @state.inProgress}><Translate content="pass.changeButton" /></button>{' '}

        {if @state.inProgress
          <i className="fa fa-spinner fa-spin form-help"></i>
        else if @state.success
          <i className="fa fa-check-circle form-help success"></i>
        else if @state.error
          <small className="form-help error">{@state.error.toString()}</small>}
      </p>
    </form>

  tooShort: ->
    @state.new.length < MIN_PASSWORD_LENGTH

  doesntMatch: ->
    @state.new isnt @state.confirmation

  handleSubmit: (e) ->
    e.preventDefault()

    current = @state.old
    replacement = @state.new

    @setState
      inProgress: true
      success: false
      error: null

    auth.changePassword {current, replacement}
      .then =>
        @setState success: true
        @refs.form.reset()
      .catch (error) =>
        @setState {error}
      .then =>
        @setState inProgress: false

module.exports = React.createClass
  displayName: "AccountInformationPage"

  render: ->
    <div className="account-information-tab">
      <div className="columns-container">
        <div className="content-container column">
          <p>
            <AutoSave resource={@props.user}>
              <span className="form-label"><Translate content="name.display.label" /></span>
              <br />
              <input type="text" className="standard-input full" name="display_name" value={@props.user.display_name} onChange={handleInputChange.bind @props.user} />
            </AutoSave>
            <span className="form-help"><Translate content="name.display.note" /></span>
            <br />

            <AutoSave resource={@props.user}>
              <span className="form-label"><Translate content="name.credited.label" /></span>
              <br />
              <input type="text" className="standard-input full" name="credited_name" value={@props.user.credited_name} onChange={handleInputChange.bind @props.user} />
            </AutoSave>
            <span className="form-help"><Translate content="name.credited.note" /></span>
          </p>
        </div>
      </div>

      <hr />

      <div className="content-container">
        <ChangePasswordForm {...@props} />
      </div>
    </div>
