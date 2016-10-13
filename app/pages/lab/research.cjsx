counterpart = require 'counterpart'
React = require 'react'
Translate = require 'react-translate-component'
ProjectPageEditor = require '../../partials/project-page-editor'

counterpart.registerTranslations 'en',
  mainText: '''This page is for you to describe your research motivations and goals to the volunteers. Feel free to add detail, but try to avoid jargon. This page renders markdown, so you can format it and add images via the Media Library and links. The site will show your team members and their roles to the side of the text.'''

counterpart.registerTranslations 'es',
  mainText: '''Esta página es para describir a los voluntarios las motivaciones y los objetivos de la investigación. Se puede agregar detalles, pero lo ideal es evitar terminología específica. Esta página utiliza Markdown, así que es posible darle formato, agregar links, y agregar imágenes (las subidas previamente en la sección Subir Imágenes). El sitio va a mostrar los miembros de tu equipo y sus roles, al costado del texto.'''  

module.exports = React.createClass
  displayName: 'EditProjectResearch'

  render: ->
    <div>
      <p className="form-help"><Translate content="mainText" /></p>
      <ProjectPageEditor project={@props.project} page="science_case" pageTitle="Research" />
    </div>
