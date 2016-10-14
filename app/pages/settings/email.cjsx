React = require 'react'
counterpart = require 'counterpart'
Translate = require 'react-translate-component'
talkClient = require 'panoptes-client/lib/talk-client'
AutoSave = require '../../components/auto-save'
PromiseRenderer = require '../../components/promise-renderer'
ChangeListener = require '../../components/change-listener'
handleInputChange = require '../../lib/handle-input-change'

counterpart.registerTranslations 'en',
  address:
    label: 'Email address'
  preferences:
    label: 'Zooniverse email preferences'
    general: 'Get general Zooniverse email updates'
    projects: 'Get email updates from the Projects you classify on'
    beta: 'Get beta project email updates'
  discussion:
    label: 'Talk email preferences'  
    table:
      sendMe: 'Send me an email'
      now: 'Immediately'
      daily: 'Daily'
      weekly: 'Weekly'
      never: 'Never'
  project:
    label: 'Project email preferences'
    project: 'Project'
    page: 'Page'

counterpart.registerTranslations 'es',
  address:
    label: 'Dirección de correo electrónico'
  preferences:
    label: 'Preferencias de email de Zooniverse'
    general: 'Recibir mails en general sobre actualizaciones en Zooniverse'
    projects: 'Recibir mails sobre actualizaciones en proyectos en los que participes'
    beta: 'Recibir mails sobre actualizaciones en proyectos en estado beta'
  discussion:
    label: 'Preferencias de email para los foros de discusión'
    table:
      sendMe: 'Enviarme un email'
      now: 'Inmediatamente'
      daily: 'Diariamente'
      weekly: 'Semanalmente'
      never: 'Nunca'
  proj:
    label: 'Project email preferences'
    project: 'Project'
    page: 'Page '    

module.exports = React.createClass
  displayName: 'EmailSettingsPage'

  getDefaultProps: ->
    user: null

  getInitialState: ->
    page: 1

  nameOfPreference: (preference) ->
    switch preference.category
      when 'participating_discussions' then "When discussions I'm participating in are updated"
      when 'followed_discussions' then "When discussions I'm following are updated"
      when 'mentions' then "When I'm mentioned"
      when 'group_mentions' then "When I'm mentioned by group (@admins, @team, etc)"
      when 'messages' then 'When I receive a private message'
      when 'started_discussions' then "When a discussion is started in a board I'm following"

  sortPreferences: (preferences) ->
    order = ['participating_discussions', 'followed_discussions', 'started_discussions', 'mentions', 'group_mentions', 'messages']
    preferences.sort (a, b) ->
      order.indexOf(a.category) > order.indexOf(b.category)

  handlePreferenceChange: (preference, event) ->
    preference.update(email_digest: event.target.value).save()

  talkPreferenceOption: (preference, digest) ->
    <td className="option">
      <input type="radio"
        name={preference.category}
        value={digest}
        checked={preference.email_digest is digest}
        onChange={@handlePreferenceChange.bind this, preference}
      />
    </td>

  render: ->
    <div className="content-container">
      <p>
        <AutoSave resource={@props.user}>
          <span className="form-label"><Translate content="address.label" /></span>
          <br />
          <input type="text" className="standard-input full" name="email" value={@props.user.email} onChange={handleInputChange.bind @props.user} />
        </AutoSave>
      </p>
      <p><strong><Translate content="preferences.label" /></strong></p>
      <p>
        <AutoSave resource={@props.user}>
          <label>
            <input type="checkbox" name="global_email_communication" checked={@props.user.global_email_communication} onChange={handleInputChange.bind @props.user} />{' '}
            <Translate content="preferences.general" />
          </label>
        </AutoSave>
        <br />
        <AutoSave resource={@props.user}>
          <label>
            <input type="checkbox" name="project_email_communication" checked={@props.user.project_email_communication} onChange={handleInputChange.bind @props.user} />{' '}
            <Translate content="preferences.projects" />
          </label>
        </AutoSave>
        <br />
        <AutoSave resource={@props.user}>
          <label>
            <input type="checkbox" name="beta_email_communication" checked={@props.user.beta_email_communication} onChange={handleInputChange.bind @props.user} />{' '}
            <Translate content="preferences.beta" />
          </label>
        </AutoSave>
      </p>

      <p><strong><Translate content="discussion.label" /></strong></p>
      <table className="talk-email-preferences">
        <thead>
          <tr>
            <th><Translate content="discussion.table.sendMe" /></th>
            <th><Translate content="discussion.table.now" /></th>
            <th><Translate content="discussion.table.daily" /></th>
            <th><Translate content="discussion.table.weekly" /></th>
            <th><Translate content="discussion.table.never" /></th>
          </tr>
        </thead>
        <PromiseRenderer promise={talkClient.type('subscription_preferences').get()} pending={-> <tbody></tbody>} then={(preferences) =>
          <tbody>
            {for preference in @sortPreferences(preferences) when preference.category isnt 'system' and preference.category isnt 'moderation_reports' then do (preference) =>
              <ChangeListener key={preference.id} target={preference} handler={=>
                <tr>
                  <td>{@nameOfPreference(preference)}</td>
                  {@talkPreferenceOption preference, 'immediate'}
                  {@talkPreferenceOption preference, 'daily'}
                  {@talkPreferenceOption preference, 'weekly'}
                  {@talkPreferenceOption preference, 'never'}
                </tr>
              } />
            }
          </tbody>
        } />
      </table>

      <p><strong><Translate content="proj.label" /></strong></p>
      <table>
        <thead>
          <tr>
            <th><i className="fa fa-envelope-o fa-fw"></i></th>
            <th><Translate content="proj.project" /></th>
          </tr>
        </thead>
        <PromiseRenderer promise={@props.user.get 'project_preferences', page: @state.page} pending={=> <tbody></tbody>} then={(projectPreferences) =>
          meta = projectPreferences[0].getMeta()
          <tbody>
            {for projectPreference in projectPreferences then do (projectPreference) =>
              <PromiseRenderer key={projectPreference.id} promise={projectPreference.get 'project'} then={(project) =>
                <ChangeListener target={projectPreference} handler={=>
                  <tr>
                    <td><input type="checkbox" name="email_communication" checked={projectPreference.email_communication} onChange={@handleProjectEmailChange.bind this, projectPreference} /></td>
                    <td>{project.display_name}</td>
                  </tr>
                } />
              } />}
            <tr>
              <td colSpan="2">
                {if meta?
                  <nav className="pagination">
                    <Translate content="proj.page" /><select value={@state.page} disabled={meta.page_count < 2} onChange={(e) => @setState page: e.target.value}>
                      {for p in [1..meta.page_count]
                        <option key={p} value={p}>{p}</option>}
                    </select> of {meta.page_count || '?'}
                  </nav>}
              </td>
            </tr>
          </tbody>
        } />
      </table>
    </div>

  handleProjectEmailChange: (projectPreference, args...) ->
    handleInputChange.apply projectPreference, args
    projectPreference.save()
