counterpart = require 'counterpart'
React = require 'react'
Translate = require 'react-translate-component'
MediaArea = require '../../components/media-area'

counterpart.registerTranslations 'en',
  youCanAdd: 'You can add images here to use in your project’s content.'
  justCopy: '  Just copy and paste the image’s Markdown code: '
  canBeOfType: '. Images can be any of: '

counterpart.registerTranslations 'es',
  youCanAdd: 'Acá podés subir imágenes para usarlas como contenido de tu proyecto.'
  justCopy: '  Simpliemente copiá y pegá el código Markdown de la imagen: '
  canBeOfType: '. Las imágenes puede ser de los siguientes tipos: '  

VALID_SUBJECT_EXTENSIONS = ['.jpg', '.jpeg', '.png', '.gif', '.svg']

module.exports = React.createClass
  displayName: 'EditMediaPage'

  getDefaultProps: ->
    project: {}

  render: ->
    <div className="edit-media-page">
      <div className="content-container">
        <p><strong><Translate content="youCanAdd" /></strong><Translate content="justCopy" /><code>![title](url)</code><Translate content="canBeOfType" />{<span key={ext}><code>{ext}</code>{', ' if VALID_SUBJECT_EXTENSIONS[i + 1]?}</span> for ext, i in VALID_SUBJECT_EXTENSIONS}{' '} </p>
        <MediaArea resource={@props.project} />
      </div>
    </div>

  handleChange: ->
    @getMedia = null
    @forceUpdate()
