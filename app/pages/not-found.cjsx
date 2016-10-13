counterpart = require 'counterpart'
React = require 'react'
Translate = require 'react-translate-component'

counterpart.registerTranslations 'en',
  notfound: "Not found"

counterpart.registerTranslations 'es',
  notfound: "No encontrado"


module.exports = React.createClass
  displayName: 'NotFoundPage'

  componentDidMount: ->
    # Here's a workaround until the router supports optional trailing slashes.
    if location?.hash.charAt(location.hash.length - 1) is '/'
      location.hash = location.hash[...-1]

  render: ->
    <div className="content-container">
      <i className="fa fa-frown-o"></i> <Translate content="notFound" />
    </div>
