counterpart = require 'counterpart'
React = require 'react'
Translate = require 'react-translate-component'

counterpart.registerTranslations 'en',
  stats: '. Statistics'
  vol: 'Registered volunteers'
  classi: 'Classifications'
  subs: 'Subjects'
  retired: 'Retired subjects'

counterpart.registerTranslations 'es',
  stats: '. Estadísticas'
  vol: 'Voluntarios registrados'
  classi: 'Clasificaciones'
  subs: 'Unidades de análisis'
  retired: 'Unidades de análisis retiradas'

module?.exports = React.createClass
  displayName: 'ProjectMetadata'

  propTypes:
    project: React.PropTypes.object

  render: ->
    {project} = @props

    <div className="project-metadata content-container">
      <div className="project-metadata-header">
        <span>{project.display_name}</span>{''}
        <span><Translate content="stats" /></span>
      </div>

      <div className="project-metadata-stats">
        <div className="project-metadata-stat">
          <div>{project.classifiers_count.toLocaleString()}</div>
          <div><Translate content="vol" /></div>
        </div>

        <div className="project-metadata-stat">
          <div>{project.classifications_count.toLocaleString()}</div>
          <div><Translate content="classi" /></div>
        </div>

        <div className="project-metadata-stat">
          <div>{project.subjects_count.toLocaleString()}</div>
          <div><Translate content="subs" /></div>
        </div>

        <div className="project-metadata-stat">
          <div>{project.retired_subjects_count.toLocaleString()}</div>
          <div><Translate content="retired" /></div>
        </div>
      </div>
    </div>
