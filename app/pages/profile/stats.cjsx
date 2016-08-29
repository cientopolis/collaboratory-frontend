React = require 'react'
counterpart = require 'counterpart'
Translate = require 'react-translate-component'
ClassificationsRibbon = require '../../components/classifications-ribbon'
PromiseRenderer = require '../../components/promise-renderer'
ProjectIcon = require '../../components/project-icon'

counterpart.registerTranslations 'en',
  body:
    contributionStats: "Your contribution stats"
    info: "Users can only view their own stats."

counterpart.registerTranslations 'es',
  body:
    contributionStats: "Sus estadísticas en contribuciones" 
    info: "Usuarios sólo podrán ver sus propias estadísticas" 

module.exports = React.createClass
  getDefaultProps: ->
    user: null

  render: ->
    <div className="content-container">
      <h3><Translate content="body.contributionStats" /></h3>
      <p className="form-help"><Translate content="body.info" /></p>
      {if @props.profileUser is @props.user
        # TODO: Braces after "style" here confuse coffee-reactify. That's really annoying.
        centered = textAlign: 'center'
        <div style=centered>
          <p><ClassificationsRibbon user={@props.profileUser} /></p>
          <PromiseRenderer promise={ClassificationsRibbon::getAllProjectPreferences @props.profileUser} then={(projectPreferences) =>
            <div>
              {projectPreferences.map (projectPreference) =>
                <PromiseRenderer key={projectPreference.id} promise={projectPreference.get 'project'} catch={null} then={(project) =>
                  if project?
                    <span>
                      <ProjectIcon project={project} badge={projectPreference.activity_count} />
                      &ensp;
                    </span>
                  else
                    null
                } />}
            </div>
          } />
        </div>
      else
        <p>Sorry, we can’t show you stats for {@props.profileUser.display_name}.</p>}
    </div>
