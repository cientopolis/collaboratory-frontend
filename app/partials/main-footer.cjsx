counterpart = require 'counterpart'
React = require 'react'
Translate = require 'react-translate-component'
{IndexLink, Link} = require 'react-router'
ZooniverseLogoType = require './zooniverse-logotype'
apiClient = require 'panoptes-client/lib/api-client'

counterpart.registerTranslations 'en',
  footer:
    adminMode: 'Admin mode'
    discover:
      title: 'Projects'
      projectList: 'Projects'
      collectionList: 'Collections'
      projectBuilder: 'Build a Project'
      howToGuide: 'How to Build'
      projectBuilderPolicies: 'Project Policies'
    about:
      title: 'About'
      aboutUs: 'About Us'
      ourTeam: 'Our Team'
      education: 'Education'
      publications: 'Publications'
    talk:
      title: 'Talk'
      zooTalk: 'Zooniverse Talk'
      daily: 'Daily Zooniverse'
      blog: 'Blog'
    boilerplate:
      contact: 'Contact Us'
      jobs: 'Jobs'
      privacyPolicy: 'Privacy Policy'
      status: 'System Status'
      security: 'Security'

counterpart.registerTranslations 'es',
  footer:
    adminMode: 'Admin mode'
    discover:
      title: 'Proyectos'
      projectList: 'Proyectos'
      collectionList: 'Colecciones'
      projectBuilder: 'Construya un proyecto'
      howToGuide: 'Cómo construir un proyecto'
      projectBuilderPolicies: 'Políticas de construcción'
    about:
      title: 'About'
      aboutUs: 'Sobre nosotros'
      ourTeam: 'Nuestro equipo'
      education: 'Educación'
      publications: 'Publicaciones'
    talk:
      title: 'Discusión'
      zooTalk: 'Zooniverse Talk'
      daily: 'Daily Zooniverse'
      blog: 'Blog'
    boilerplate:
      contact: 'Contáctenos'
      jobs: 'Jobs'
      privacyPolicy: 'Políticas de privacidad'
      status: 'Estado del sistema'
      security: 'Seguridad'

AdminToggle = React.createClass
  displayName: 'AdminToggle'

  getInitialState: ->
    adminFlag = localStorage.getItem('adminFlag') || undefined
    apiClient.update 'params.admin': adminFlag

    checked: if adminFlag then adminFlag else false

  componentDidMount: ->
    apiClient.listen 'change', @handleClientChange

  componentWillUnmount: ->
    apiClient.stopListening 'change', @handleClientChange

  handleClientChange: ->
    checked = apiClient.params.admin ? false

    unless @state.checked is checked
      if checked
        localStorage.setItem 'adminFlag', checked
      else
        localStorage.removeItem 'adminFlag'

      @setState {checked}

  toggleAdminMode: (e) ->
    apiClient.update 'params.admin': if e.target.checked
      true
    else
      undefined

  render: ->
    classes = 'admin-toggle ' + (if @state.checked then 'in-admin-mode' else '')
    <label className={classes}>
      <input type="checkbox" checked={@state.checked} onChange={@toggleAdminMode} />{' '}
      <Translate content="footer.adminMode" />
    </label>

module.exports = React.createClass
  displayName: 'MainFooter'

  render: ->
    <footer className="main-footer">
      <div className="centered-grid main-footer-flex">
        <div className="main-logo">
          <IndexLink to="/" className="main-logo-link">
            <ZooniverseLogoType />
          </IndexLink>
          <br />
          {if @props.user?.admin
            <AdminToggle />}
        </div>
        <nav className="site-map">
          <div className="site-map-section">
            <Translate component="h6" content="footer.discover.title" />
            <Link to="/projects"><Translate content="footer.discover.projectList" /></Link>
            <Link to="/collections"><Translate content="footer.discover.collectionList" /></Link>
            <Link to="/lab"><Translate content="footer.discover.projectBuilder" /></Link>
            <Link to="/lab-how-to"><Translate content="footer.discover.howToGuide" /></Link>
          </div>
          <div className="site-map-section social-media">
            <a href="https://www.facebook.com/cientopolis" target="_blank"><i className="fa fa-facebook"></i></a>
            <a href="https://twitter.com/cientopolis" target="_blank"><i className="fa fa-twitter"></i></a>
          </div>
        </nav>
      </div>
      <div className="footer-sole">
        <div className="centered-grid footer-sole-links">
          <Link to="/privacy"><Translate content="footer.boilerplate.privacyPolicy" /></Link>
          <i className="fa fa-ellipsis-v footer-sole-links-separator"></i>
          <a href="https://status.zooniverse.org/"><Translate content="footer.boilerplate.status" /></a>
          <i className="fa fa-ellipsis-v footer-sole-links-separator"></i>
          <Link to="/security"><Translate content="footer.boilerplate.security" /></Link>
        </div>
      </div>
    </footer>
