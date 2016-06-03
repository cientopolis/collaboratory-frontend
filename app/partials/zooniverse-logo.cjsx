React = require 'react'

module.exports = React.createClass
  displayName: 'ZooniverseLogo'

  getDefaultProps: ->
    width: '1em'
    height: '1em'

  render: ->
    useHTML = '''
      <use xlink:href="#zooniverse-logo-source" x="0" y="0" width="100" height="100" />
    '''
    <svg>
      <image xlinkHref="http://staging-cientopolis.lifia.info.unlp.edu.ar/assets/cientopolis-chico.png" x="0" y="0" height="100" width="100" />
    </svg>
