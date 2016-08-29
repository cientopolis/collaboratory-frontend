counterpart = require 'counterpart'
React = require 'react'
Translate = require 'react-translate-component'
TitleMixin = require '../lib/title-mixin'
apiClient = require 'panoptes-client/lib/api-client'
OwnedCardList = require '../components/owned-card-list'

counterpart.registerTranslations 'en',
  projectsPage:
    title: 'All Projects'
    countMessage: 'Showing %(pageStart)s-%(pageEnd)s of %(count)s found'
    button: 'Get Started'
    notFoundMessage: 'Sorry, no projects found'

counterpart.registerTranslations 'es',
  projectsPage:
    title: 'Todos los proyectos'
    countMessage: 'Mostrando %(pageStart)s-%(pageEnd)s de %(count)s encontrados'
    button: 'Unirse'
    notFoundMessage: 'No se encontraron proyectos'


module.exports = React.createClass
  displayName: 'ProjectsPage'

  mixins: [TitleMixin]

  title: 'Projects'

  listProjects: ->
    query = {include: 'avatar'}
    query.cards = true

    if !apiClient.params.admin
      query.launch_approved = true

    apiClient.type('projects').get Object.assign {}, query, @props.location.query

  imagePromise: (project) ->
    src = if project.avatar_src
      "#{ project.avatar_src }"
    else
      './assets/simple-avatar.jpg'
    Promise.resolve src

  cardLink: (project) ->
    link = if !!project.redirect
      project.redirect
    else
      [owner, name] = project.slug.split('/')
      "/projects/#{owner}/#{name}"

    return link

  render: ->
    <OwnedCardList
      {...@props}
      translationObjectName="projectsPage"
      listPromise={@listProjects()}
      linkTo="projects"
      cardLink={@cardLink}
      heroClass="projects-hero"
      imagePromise={@imagePromise}
      skipOwner={true} />
