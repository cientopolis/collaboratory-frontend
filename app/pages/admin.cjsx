React = require 'react'
counterpart = require 'counterpart'
Translate = require 'react-translate-component'
ChangeListener = require '../components/change-listener'
{IndexLink, Link} = require 'react-router'

counterpart.registerTranslations 'en',
  userAdminPage:
    header: "Admin"
    nav:
      createAdmin: "Manage Users"
      projectStatus: "Set Project Status"
    notAdmin: "You are not an administrator"
    notSignedIn: "You're not signed in"

counterpart.registerTranslations 'es',
  userAdminPage:
    header: "Administrador"
    nav:
      createAdmin: "Administrar usuarios"
      projectStatus: "Cambiar el estado de un proyecto"      
    notAdmin: "No tenés permisos de administrador"
    notSignedIn: "No iniciaste sesión"


AdminPage = React.createClass
  displayName: 'AdminPage'

  render: ->
    <section className="admin-page-content">
      <div className="secondary-page admin-page">
        <h2><Translate content="userAdminPage.header" /></h2>
        <div className="admin-content">
          <aside className="secondary-page-side-bar admin-side-bar">
            <nav>
              <IndexLink to="/admin"
                type="button"
                className="secret-button admin-button"
                activeClassName="active">
                <Translate content="userAdminPage.nav.createAdmin" />
              </IndexLink>
              <Link to="/admin/project_status"
                type="button"
                className="secret-button admin-button"
                activeClassName="active">
                <Translate content="userAdminPage.nav.projectStatus" />
              </Link>
            </nav>
          </aside>
          <section className="admin-tab-content">
            {React.cloneElement @props.children, @props}
          </section>
        </div>
      </div>
    </section>

module.exports = React.createClass
  displayName: 'AdminPageWrapper'

  render: ->
    <div>
      <ChangeListener target={@props.user}>{ =>
        if @props.user?
          if @props.user.admin
            <AdminPage {...@props} />
          else
            <div className="content-container">
              <p><Translate content="userAdminPage.notAdmin" /></p>
            </div>
        else
          <div className="content-container">
            <p><Translate content="userAdminPage.notSignedIn" /></p>
          </div>
      }</ChangeListener>
    </div>
