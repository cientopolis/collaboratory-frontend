React = require 'react'
AutoSave = require '../../components/auto-save'
handleInputChange = require '../../lib/handle-input-change'
PromiseRenderer = require '../../components/promise-renderer'
ImageSelector = require '../../components/image-selector'
apiClient = require 'panoptes-client/lib/api-client'
putFile = require '../../lib/put-file'
counterpart = require 'counterpart'
DisplayNameSlugEditor = require '../../partials/display-name-slug-editor'
TagSearch = require '../../components/tag-search'
{MarkdownEditor} = require 'markdownz'
MarkdownHelp = require '../../partials/markdown-help'
alert = require('../../lib/alert')
Translate = require 'react-translate-component'


counterpart.registerTranslations 'en',
  project: 'project'
  headerText: 'Input the basic information about your project, and set up its home page.'
  avatar:
    overText: 'Drop an avatar image here'
    description: '''Pick a logo to represent your project. To add an image, either drag and drop or click to open your file viewer. For best results, use a square image of not more than 50 KB.'''
  background:
    label: 'Background image'
    overText: 'Drop a background image here'
    description: '''This image will be the background for all of your project pages, including your project’s front page. To add an image, either drag and drop or left click to open your file viewer. For best results, use good quality images no more than 256 KB.'''
  chooseWF:
    checkBox: 'Volunteers can choose which workflow they work on'
    description: '''If you have multiple workflows, check this to let volunteers select which workflow they want to to work on; otherwise, they’ll be served randomly.'''
  description:
    label: 'Description'
    help: '''This should be a one-line call to action for your project that displays on your landing page. Some volunteers will decide whether to try your project based on reading this, so try to write short text that will make people actively want to join your project.'''
  introduction:
    label: 'Introduction'
    help: '''Add a brief introduction to get people interested in your project. This will display on your landing page.'''
  WFDescription:
    label: 'Workflow description'
    help: '''Add text here when you have multiple workflows and want to help your volunteers decide which one they should do.'''
  banner:
    label: 'Announcement Banner'
    help: '''This text will appear as a banner at the top of all your project's pages. Only use this when you've got a big important announcement to make!'''
  tags:
    label: 'Tags'
    help: '''Enter a list of tags separated by commas to help users find your project.'''
  externals:
    label: 'External links'
    help: '''Adding an external link will make it appear as a new tab alongside the science, classify, and talk tabs.'''
    URLLabel: 'Label'
    URL: 'URL'
    addLabel: 'Add link'

counterpart.registerTranslations 'es',
  project: 'proyecto'
  headerText: 'Ingresá la información básica de tu proyecto, y configurá la página principal del mismo.'
  avatar:
    overText: 'Arrastrá y soltá una imagen de logo aquí'
    description: '''Elegí un logo que represente a tu proyecto. Para esto, arrastrá y soltá una imágen o hacé click en el recuadro. Para obtener mejores resultados, es recomendable utilizar una imagen cuadrada de no más de 50KB.'''
  background:
    label: 'Imágen de fondo'
    overText: 'Arrastrá y soltá una imagen de fondo aquí'
    description: '''Esta será la imagen de fondo en todas las páginas del proyecto, incluyendo la página principal. Arastrá y soltá una imágen o hacé click en el recuadro. Para obtener mejores resultados, es recomendable utilizar una imagen con buena calidad de no más de 256KB.'''
  chooseWF:
    checkBox: 'Los voluntarios pueden elegir el flujo de trabajo en el cual trabajar.'
    description: '''Si definiste múltiples flujos de trabajo, tildá esta opción para permitir que los voluntarios elijan el flujo de trabajo que deseen utilizar; de otro modo, serán asignados aleatoriamente.'''
  description:
    label: 'Descripción'
    help: '''Esta sería la frase bien concisa que atrape a tus potenciales voluntarios, y que se muestra en la página principal del proyecto. Así, algunos voluntarios decidirán si participar o no, basado en este texto. '''
  introduction:
    label: 'Introducción'
    help: '''Agregá una introducción breve para lograr que la gente se interese en tu proyecto. Este texto se verá en la página principal del mismo.'''
  WFDescription:
    label: 'Descripción de los flujos de trabajo'
    help: '''Agregá una porción de texto aquí cuando hayas definido múltiples flujos de trabajo, y quieras ayudar a tus voluntarios decidir en cuáles quieren trabajar.'''
  banner:
    label: 'Banner de anuncios'
    help: '''Este texto aparecerá como banner en la parte superior de todas las páginas del proyecto. Esto debe utilizarse solamente cuando tengas que hacer anuncios importantes.'''
  tags:
    label: 'Etiquetas'
    help: '''Ingresá un listado de etiquetas (tags) separadas por comas, para ayudar a los usuarios a encontrar tu proyecto.'''
  externals:
    label: 'Links externos'
    help: '''Agregar un link externo hará que aparezca como una pestaña nueva junto con las pestañas de Investigación, Clasificar y Discusión, en la página principal del proyecto. Este link puede llevar, por ejemplo, a un sitio de tu autoría que describa el proyecto real.''' 
    URLLabel: 'Etiqueta'
    URL: 'URL'
    addLabel: 'Agregar link'   


MAX_AVATAR_SIZE = 64000
MAX_BACKGROUND_SIZE = 256000

ExternalLinksEditor = React.createClass
  displayName: 'ExternalLinksEditor'

  getDefaultProps: ->
    project: {}

  render: ->
    <div>
      <table>
        <thead>
          <tr>
            <th><Translate content="externals.URLLabel" /></th>
            <th><Translate content="externals.URL" /></th>
          </tr>
        </thead>
        <tbody>
          {for link, i in @props.project.urls
            link._key ?= Math.random()
            <AutoSave key={link._key} tag="tr" resource={@props.project}>
              <td>
                <input type="text" name="urls.#{i}.label" value={@props.project.urls[i].label} onChange={handleInputChange.bind @props.project} />
              </td>
              <td>
                <input type="text" name="urls.#{i}.url" value={@props.project.urls[i].url} onChange={handleInputChange.bind @props.project} />
              </td>
              <td>
                <button type="button" onClick={@handleRemoveLink.bind this, link}>
                  <i className="fa fa-remove"></i>
                </button>
              </td>
            </AutoSave>}
        </tbody>
      </table>

      <AutoSave resource={@props.project}>
        <button type="button" onClick={@handleAddLink}><Translate content="externals.addLabel" /></button>
      </AutoSave>
    </div>

  handleAddLink: ->
    changes = {}
    changes["urls.#{@props.project.urls.length}"] =
      label: 'Ejemplo'
      url: 'https://ejemplo.com/'
    @props.project.update changes

  handleRemoveLink: (linkToRemove) ->
    changes =
      urls: (link for link in @props.project.urls when link isnt linkToRemove)
    @props.project.update changes

module.exports = React.createClass
  displayName: 'EditProjectDetails'

  getDefaultProps: ->
    project: {}

  getInitialState: ->
    avatarError: null
    backgroundError: null

  render: ->
    # Failures on media GETs are acceptable here,
    # but the JSON-API lib doesn't cache failed requests,
    # so do it manually:

    @avatarGet ?= @props.project.get 'avatar'
      .catch ->
        null

    @backgroundGet ?= @props.project.get 'background'
      .catch ->
        null

    <div>
      <p className="form-help"><Translate content="headerText" /></p>
      <div className="columns-container">
        <div>
          Avatar<br />
          <PromiseRenderer promise={@avatarGet} then={(avatar) =>
            placeholder = <div className="form-help content-container"><Translate content="avatar.overText" /></div>
            <ImageSelector maxSize={MAX_AVATAR_SIZE} ratio={1} src={avatar?.src} placeholder={placeholder} onChange={@handleMediaChange.bind this, 'avatar'} />
          } />
          {if @state.avatarError
            <div className="form-help error">{@state.avatarError.toString()}</div>}

          <p><small className="form-help"><Translate content="avatar.description" /></small></p>

          <hr />

          <Translate content="background.label" /><br />
          <PromiseRenderer promise={@backgroundGet} then={(background) =>
            placeholder = <div className="form-help content-container"><Translate content="background.overText" /></div>
            <ImageSelector maxSize={MAX_BACKGROUND_SIZE} src={background?.src} placeholder={placeholder} onChange={@handleMediaChange.bind this, 'background'} />
          } />
          {if @state.backgroundError
            <div className="form-help error">{@state.backgroundError.toString()}</div>}

          <p><small className="form-help"><Translate content="background.description" /></small></p>

          <hr />

          <p>
            <AutoSave tag="label" resource={@props.project}>
              {checked = @props.project.configuration?.user_chooses_workflow}
              <input type="checkbox" name="configuration.user_chooses_workflow" defaultChecked={checked} defaultValue={checked} onChange={handleInputChange.bind @props.project} />{' '}
              <Translate content="chooseWF.checkBox" />
            </AutoSave>
            <br />
            <small className="form-help"><Translate content="chooseWF.description" /></small>
          </p>
        </div>

        <div className="column">
          <DisplayNameSlugEditor resource={@props.project} resourceType="proyecto" />

          <p>
            <AutoSave resource={@props.project}>
              <span className="form-label"><Translate content="description.label" /></span>
              <br />
              <input className="standard-input full" name="description" value={@props.project.description} onChange={handleInputChange.bind @props.project} />
            </AutoSave>
            <small className="form-help"><Translate content="description.help" /></small>
          </p>

          <div>
            <AutoSave resource={@props.project}>
              <span className="form-label"><Translate content="introduction.label" /></span>
              <br />
              <MarkdownEditor className="full" name="introduction" rows="10" value={@props.project.introduction} project={@props.project} onChange={handleInputChange.bind @props.project} onHelp={-> alert <MarkdownHelp/>}/>
            </AutoSave>
            <small className="form-help"><Translate content="introduction.help" /></small>
          </div>

          <p>
            <AutoSave resource={@props.project}>
              <span className="form-label"><Translate content="WFDescription.label" /></span>
              <br />
              <textarea className="standard-input full" name="workflow_description" value={@props.project.workflow_description} onChange={handleInputChange.bind @props.project} />
            </AutoSave>
            <small className="form-help"><Translate content="WFDescription.help" /></small>
          </p>

          <p>
            <AutoSave resource={@props.project}>
              <span className="form-label"><Translate content="banner.label" /></span>
              <br />
              <textarea className="standard-input full" name="configuration.announcement" value={@props.project.configuration?.announcement} onChange={handleInputChange.bind @props.project} />
            </AutoSave>
            <small className="form-help"><Translate content="banner.help" /></small>
          </p>

          <div>
            <AutoSave resource={@props.project}>
              <span className="form-label"><Translate content="tags.label" /></span>
              <br />
              <TagSearch name="tags" multi={true} value={@props.project.tags} onChange={@handleTagChange} />
            </AutoSave>
            <small className="form-help"><Translate content="tags.help" /></small>
          </div>

          <div>
            <Translate content="externals.label" /><br />
            <small className="form-help"><Translate content="externals.help" /></small>
            <ExternalLinksEditor project={@props.project} />
          </div>
        </div>
      </div>
    </div>

  handleTagChange: (value) ->
    event =
      target:
        value: if value is '' then [] else value.split(',')
        name: 'tags'
        dataset: {}
    handleInputChange.call @props.project, event

  handleMediaChange: (type, file) ->
    errorProp = "#{type}Error"

    newState = {}
    newState[errorProp] = null
    @setState newState

    apiClient.post @props.project._getURL(type), media: content_type: file.type
      .then ([resource]) =>
        putFile resource.src, file, {'Content-Type': file.type}
      .then =>
        @props.project.uncacheLink type
        @["#{type}Get"] = null # Uncache the local request so that rerendering makes it again.
        @props.project.refresh() # Update the resource's links.
      .then =>
        @props.project.emit 'change' # Re-render
      .catch (error) =>
        newState = {}
        newState[errorProp] = error
        @setState newState
