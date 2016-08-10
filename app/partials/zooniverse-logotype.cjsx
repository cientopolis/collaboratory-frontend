React = require 'react'

module.exports = React.createClass
  displayName: 'ZooniverseLogoType'

  getDefaultProps: ->
    width: '178px'
    height: '18px'

  render: ->
    @titleID ?= 'logo_' + Math.random()

    useHTML = "
      <title id=#{@titleID}>Zooniverse</title>
      <use xlink:href='#zooniverse-logotype-source' x='0' y='0' width='178px' height='18px' />
    "
    <svg>
      <image xlinkHref="http://127.0.0.1:3735/assets/cientopolis-grande.png" x='0' y='0' width="253px" height="78px" />
    </svg>

