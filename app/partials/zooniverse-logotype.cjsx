React = require 'react'

module.exports = React.createClass
  displayName: 'ZooniverseLogoType'

  getDefaultProps: ->
    width: '395px'
    height: '121px'

  render: ->
    @titleID ?= 'logo_' + Math.random()

    useHTML = "
      <title id=#{@titleID}>Zooniverse</title>
      <use xlink:href='#zooniverse-logotype-source' x='0' y='0' width='395px' height='121px' />
    "
    <svg width='513px' height='157px'>
      <image xlinkHref="http://ec2-52-196-4-55.ap-northeast-1.compute.amazonaws.com/assets/cientopolis-grande.png" x='0' y='0' width="513px" height="157px" />
    </svg>

