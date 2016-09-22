counterpart = require 'counterpart'
React = require 'react'
Translate = require 'react-translate-component'
PromiseRenderer = require '../../components/promise-renderer'
apiClient = require 'panoptes-client/lib/api-client'
Paginator = require '../../talk/lib/paginator'
ProjectIcon = require '../../components/project-icon'
{History, Link} = require 'react-router'

counterpart.registerTranslations 'en',
  projectStatus:
    all: 'All'
    launchApproved: 'Launch Approved'
    launchRequested: 'Launch Requested'
    betaApproved: 'Beta Approved'
    betaRequested: 'Beta Requested'
  notFound: 'No projects found for this filter'

counterpart.registerTranslations 'es',
  projectStatus:
    all: 'Todos'
    launchApproved: 'Lanzamiento aprobado'
    launchRequested: 'Lanzamiento solicitado'
    betaApproved: 'Beta aprobada'
    betaRequested: 'Beta solicitada'
  notFound: 'No se encontraron proyectos con este filtro'  

module.exports = React.createClass
  displayName: "ProjectStatusPage"

  mixins: [History]

  getProjects: ->
    query =
      page_size: 24
      sort: '-updated_at'
      include: 'avatar'

    Object.assign query, @props.location.query

    delete query.filterBy

    query[@props.location.query.filterBy] = true unless query.slug?

    apiClient.type('projects').get(query)

  render: ->
    <div className="project-status-page">
      <nav className="project-status-filters">
        <Link to="/admin/project_status"><Translate content="projectStatus.all" /></Link>
        <Link to="/admin/project_status?filterBy=launch_approved"><Translate content="projectStatus.launchApproved" /></Link>
        <Link to="/admin/project_status?filterBy=launch_requested"><Translate content="projectStatus.launchRequested" /></Link>
        <Link to="/admin/project_status?filterBy=beta_approved"><Translate content="projectStatus.betaApproved" /></Link>
        <Link to="/admin/project_status?filterBy=beta_requested"><Translate content="projectStatus.betaRequested" /></Link>
      </nav>

      <PromiseRenderer promise={@getProjects()}>{(projects) =>
        projectsMeta = projects[0]?.getMeta()
        if projects.length is 0
          <div className="project-status-list"><Translate content="notFound" /></div>
         else
           <div>
             <div className="project-status-list">
               {projects.map (project) =>
                 [owner, name] = project.slug.split('/')
                 <div key={project.id}>
                   <Link to={"/admin/project_status/#{owner}/#{name}"}>
                     <ProjectIcon linkTo={false} project={project} />
                   </Link>
                 </div>}
             </div>
             <Paginator
               page={projectsMeta?.page}
               pageCount={projectsMeta?.page_count} />
            </div>

      }</PromiseRenderer>
    </div>
