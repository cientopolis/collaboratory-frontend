React = require 'react'
counterpart = require 'counterpart'
Translate = require 'react-translate-component'
ChangeListener = require '../../components/change-listener'
AutoSave = require '../../components/auto-save'
handleInputChange = require '../../lib/handle-input-change'
drawingTools = require '../drawing-tools'
alert = require '../../lib/alert'
DrawingTaskDetailsEditor = require './drawing-task-details-editor'
NextTaskSelector = require './next-task-selector'
{MarkdownEditor} = require 'markdownz'
MarkdownHelp = require '../../partials/markdown-help'

counterpart.registerTranslations 'en',
  content:
    mainText: 'Main text'
    describeTask: '''Describe the task, or ask the question, in a way that is clear to a non-expert. You can use markdown to format this text.'''
    helpText: 'Help text'
    taskHelp: '''Add text and images for a window that pops up when volunteers click “Need some help?” You can use markdown to format this text and add images. The help text can be as long as you need, but you should try to keep it simple and avoid jargon.'''
    choices: 'Choices'
    allowMulti: 'Allow multiple'
    multipleHelp: 'Multiple Choice: Check this box if more than one answer can be selected.'
    required: 'Required'
    requiredHelp: 'Check this box if this question has to be answered before proceeding. If a marking task is Required, the volunteer will not be able to move on until they have made at least 1 mark.'    
    subTasks:
      label: 'Sub-tasks'
      text: 'Ask users a question about what they’ve just drawn.'
    choice:
      add: 'Add choice'
      remove: 'Remove choice'
    nextTask: 'Next task'
    textBox:
      p1: '''The answers will be displayed next to each checkbox, so this text is as important as the main text and help text for guiding the volunteers. Keep your answers as minimal as possible -- any more than 5 answers can discourage new users.'''
      p2: '''The “Next task” selection describes what task you want the volunteer to perform next after they give a particular answer. You can choose from among the tasks you’ve already defined. If you want to link a task to another you haven’t built yet, you can come back and do it later (don’t forget to save your changes).'''
    tools:
      text: '''Select which marks you want for this task, and what to call each of them. The tool name will be displayed on the classification page next to each marking option. Use the simplest tool that will give you the results you need for your research.'''
      point: '''*point:* X marks the spot.'''
      line: '''*line:* a straight line at any angle.'''
      polygon: '''*polygon:* an arbitrary shape made of point-to-point lines.'''
      rectangle: '''*rectangle:* a box of any size and length-width ratio; this tool *cannot* be rotated.'''
      circle: '''*circle:* a point and a radius.'''
      ellipse: '''*ellipse:* an oval of any size and axis ratio; this tool *can* be rotated.'''
  colors:
    red: 'Red'
    yellow: 'Yellow'
    green: 'Green'
    cyan: 'Cyan'
    blue: 'Blue'
    magenta: 'Magenta'
    black: 'Black'
    white: 'White'

counterpart.registerTranslations 'es',
  content:
    mainText: 'Texto principal'
    describeTask: '''Describí la tarea, o realizá la pregunta, de manera tal que sea clara para un no experto. Podés usar markdown para darle formato a este texto.'''
    helpText: 'Texto de ayuda'
    taskHelp: '''Agregá texto y/o imágenes a una ventana que aparece cuando el voluntario hace click en "¿Necesita ayuda?". Podés usar markdown para darle formato a este texto y a las imágenes. Este texto puede ser tan extenso como sea necesario, pero lo ideal es evitar terminología específica.'''
    choices: 'Opciones'
    allowMulti: 'Permitir selección múltiple'
    multipleHelp: 'Tildá esta casilla si querés permitir que se pueda seleccionar más de una respuesta.'    
    required: 'Requerido'
    requiredHelp: 'Tildá esta casilla si esta pregunta tiene que ser respondida antes de continuar. Si una tarea de tipo dibujo/marca es requerida, el voluntario no podrá continuar hasta que hagan al menos una marca o dibujo.'
    subTasks:
      label: 'Sub-tareas'
      text: 'Realizar una pregunta a los voluntarios sobre lo que acaban de dibujar o marcar.'
    choice:
      add: 'Agregar opción'
      remove: 'Remover opción'  
    nextTask: 'Siguiente tarea'
    textBox:
      p1: '''Las respuestas serán mostradas junto a cada checkbox, así que este texto es tan importante como el texto principal y el texto de ayuda. Mantené tus respuestas tan pequeñas como sea posible -- más de 5 pueden resultar desalentadoras para los usuarios nuevos.'''
      p2: '''La sección de "Siguiente tarea" describe qué tarea querés que el voluntario haga a continuación, luego de responder la tarea actual. Podés elegir entre las tareas que ya definiste. Si querés conectar una tarea a otra que aún no creaste, es posible hacerlo más adelante (no olvides guardar los cambios).'''
    tools:
      text: '''Seleccioná qué marcas querés para esta tarea, y cómo llamar a cada una de ellas. El nombre de la herramienta será mostrado en la página de clasificaciones junto a cada opción de marcado. Intentá utilizar la herramienta más simple posible que te de los resultados que necesitás.'''
      point: '''*punto:* una X que marca un lugar.'''
      line: '''*línea:* una línea recta en cualquier ángulo.'''
      polygon: '''*polígono:* una forma arbitraria hecha de líneas punto a punto.'''
      rectangle: '''*rectángulo:* una caja de cualquier tamaño y relación alto-ancho. Esta herramienta *no puede* ser rotada.'''
      circle: '''*círculo:* un punto y un radio.'''
      ellipse: '''*elipse:* un óvalo de cualquier tamaño y relación de eje. Esta herramienta *puede* rotarse.'''
  colors:
    red: 'Rojo'
    yellow: 'Amarillo'
    green: 'Verde'
    cyan: 'Cyan'
    blue: 'Azul'
    magenta: 'Magenta'
    black: 'Negro'
    white: 'Blanco'

module.exports = React.createClass
  displayName: 'GenericTaskEditor'

  getDefaultProps: ->
    workflow: null
    task: null
    taskPrefix: ''

  render: ->
    handleChange = handleInputChange.bind @props.workflow

    [mainTextKey, choicesKey] = switch @props.task.type
      when 'single', 'multiple' then ['question', 'answers']
      when 'drawing' then ['instruction', 'tools']
      when 'crop' then ['instruction']
      when 'text' then ['instruction']

    isAQuestion = @props.task.type in ['single', 'multiple']
    canBeRequired = @props.task.type in ['single', 'multiple', 'text']

    <div className="workflow-task-editor #{@props.task.type}">
      <div>
        <AutoSave resource={@props.workflow}>
          <span className="form-label"><Translate content="content.mainText" /></span>
          <br />
          <textarea name="#{@props.taskPrefix}.#{mainTextKey}" value={@props.task[mainTextKey]} className="standard-input full" onChange={handleChange} />
        </AutoSave>
        <small className="form-help"><Translate content="content.describeTask" /></small><br />
      </div>
      <br />

      {unless @props.isSubtask
        <div>
          <AutoSave resource={@props.workflow}>
            <span className="form-label"><Translate content="content.helpText" /></span>
            <br />
            <MarkdownEditor name="#{@props.taskPrefix}.help" onHelp={-> alert <MarkdownHelp/>} value={@props.task.help ? ""} rows="7" className="full" onChange={handleChange} />
          </AutoSave>
          <small className="form-help"><Translate content="content.taskHelp" /></small>
        </div>}

      {if choicesKey?
        <div>
          <hr />
          <span className="form-label"><Translate content="content.choices" /></span>
        </div>}
      {' '}

      {if isAQuestion
        <span>
          <Translate component="label" className="pill-button" attributes={{title: "content.multipleHelp" }}>
            <AutoSave resource={@props.workflow}>
              <input type="checkbox" checked={@props.task.type is 'multiple'} onChange={@toggleMultipleChoice} />{' '}
              <Translate content="content.allowMulti" />
            </AutoSave>
          </Translate>
          {' '}
        </span>}

      {if canBeRequired
        <span>
          <Translate component="label" className="pill-button" attributes={{title: "content.requiredHelp" }}>
            <AutoSave resource={@props.workflow}>
              <input type="checkbox" name="#{@props.taskPrefix}.required" checked={@props.task.required} onChange={handleChange} />{' '}
              <Translate content="content.required" />
            </AutoSave>
          </Translate>
          {' '}
        </span>}
      <br />

      {if choicesKey?
        <div className="workflow-task-editor-choices">
          {if (@props.task[choicesKey]?.length ? 0) is 0 # Work around the empty-array-becomes-null bug on the back end.
            <span className="form-help">No <code>{choicesKey}</code> defined for this task.</span>}
          {for choice, index in @props.task[choicesKey] ? []
            choice._key ?= Math.random()
            <div key={choice._key} className="workflow-choice-editor">
              <AutoSave resource={@props.workflow}>
                <textarea name="#{@props.taskPrefix}.#{choicesKey}.#{index}.label" value={choice.label} onChange={handleChange} />
              </AutoSave>

              <div className="workflow-choice-settings">
                {switch @props.task.type
                  when 'single'
                    unless @props.isSubtask
                      <div className="workflow-choice-setting">
                        <AutoSave resource={@props.workflow}>
                          <Translate content="content.nextTask" />{' '}
                          <NextTaskSelector workflow={@props.workflow} name="#{@props.taskPrefix}.#{choicesKey}.#{index}.next" value={choice.next ? ''} onChange={handleChange} />
                        </AutoSave>
                      </div>

                  when 'drawing'
                    [<div key="type" className="workflow-choice-setting">
                      <AutoSave resource={@props.workflow}>
                        Type{' '}
                        <select name="#{@props.taskPrefix}.#{choicesKey}.#{index}.type" value={choice.type} onChange={handleChange}>
                          {for toolKey of drawingTools
                            <option key={toolKey} value={toolKey}>{toolKey}</option>}
                        </select>
                      </AutoSave>
                    </div>

                    <div key="color" className="workflow-choice-setting">
                      <AutoSave resource={@props.workflow}>
                        Color{' '}
                        <select name="#{@props.taskPrefix}.#{choicesKey}.#{index}.color" value={choice.color} onChange={handleChange}>
                          <option value="#ff0000"><Translate content="colors.red" /></option>
                          <option value="#ffff00"><Translate content="colors.yellow" /></option>
                          <option value="#00ff00"><Translate content="colors.green" /></option>
                          <option value="#00ffff"><Translate content="colors.cyan" /></option>
                          <option value="#0000ff"><Translate content="colors.blue" /></option>
                          <option value="#ff00ff"><Translate content="colors.magenta" /></option>
                          <option value="#000000"><Translate content="colors.black" /></option>
                          <option value="#ffffff"><Translate content="colors.white" /></option>
                        </select>
                      </AutoSave>
                    </div>

                    <div key="min-max" className="min-max-editor workflow-choice-setting">
                      <AutoSave resource={@props.workflow}>
                        Min{' '}
                        <input type="number"
                          name="#{@props.taskPrefix}.#{choicesKey}.#{index}.min"
                          value={choice.min}
                          placeholder="0"
                          style={width: '3ch'}
                          onBlur={handleChange}
                          data-json-value={true}
                         />
                      </AutoSave>
                      <AutoSave resource={@props.workflow}>
                        Max{' '}
                        <input
                          type="number"
                          name="#{@props.taskPrefix}.#{choicesKey}.#{index}.max"
                          value={choice.max}
                          placeholder="∞"
                          style={width: '3ch'}
                          onBlur={handleChange}
                          data-json-value={true}
                         />
                      </AutoSave>
                    </div>

                    <div key="details" className="workflow-choice-setting">
                      <button type="button" onClick={@editToolDetails.bind this, @props.task, index}><Translate content="content.subTasks.label" /> ({choice.details?.length ? 0})</button>{' '}
                      <small className="form-help"><Translate content="content.subTasks.text" /></small>
                    </div>]}
              </div>

              <AutoSave resource={@props.workflow}>
                <Translate component="button" type="button" className="workflow-choice-remove-button" onClick={@removeChoice.bind this, choicesKey, index} attributes={{title: "content.choice.remove" }}>&times;</Translate>
              </AutoSave>
            </div>}

          <AutoSave resource={@props.workflow}>
            <Translate component="button" type="button" className="workflow-choice-add-button" onClick={@addChoice.bind this, choicesKey} attributes={{title: "content.choice.add" }}>+</Translate>
          </AutoSave>
          <br />

          {switch choicesKey
            when 'answers'
              <div>
                <small className="form-help"><Translate content="content.textBox.p1" /></small><br />
                <small className="form-help"><Translate content="content.textBox.p2" /></small>
              </div>
            when 'tools'
              <div>
                <small className="form-help"><Translate content="content.tools.text" /></small><br />
                <small className="form-help"><Translate content="content.tools.point" /></small><br />
                <small className="form-help"><Translate content="content.tools.line" /></small><br />
                <small className="form-help"><Translate content="content.tools.polygon" /></small><br />
                <small className="form-help"><Translate content="content.tools.rectangle" /></small><br />
                <small className="form-help"><Translate content="content.tools.circle" /></small><br />
                <small className="form-help"><Translate content="content.tools.ellipse" /></small><br />
              </div>}
        </div>}

      {unless @props.task.type is 'single' or @props.isSubtask
        <div>
          <AutoSave resource={@props.workflow}>
            Next task{' '}
            <NextTaskSelector workflow={@props.workflow} name="#{@props.taskPrefix}.next" value={@props.task.next ? ''} onChange={handleChange} />
          </AutoSave>
        </div>}
    </div>

  toggleMultipleChoice: (e) ->
    newType = if e.target.checked
      'multiple'
    else
      'single'
    @props.task.type = newType
    @props.workflow.update 'tasks'

  addChoice: (type) ->
    switch type
      when 'answers' then @addAnswer()
      when 'tools' then @addTool()

  addAnswer: ->
    @props.task.answers.push
      label: 'Ingresá una respuesta'
    @props.workflow.update 'tasks'

  addTool: ->
    @props.task.tools.push
      type: 'point'
      label: 'Nombre de la herramienta'
      color: '#00ff00'
      details: []
    @props.workflow.update 'tasks'

  editToolDetails: (task, toolIndex) ->
    @props.task.tools[toolIndex].details ?= []

    alert (resolve) =>
      <ChangeListener target={@props.workflow}>{=>
        <DrawingTaskDetailsEditor
          project={@props.project}
          workflow={@props.workflow}
          task={@props.task}
          toolIndex={toolIndex}
          details={@props.task.tools[toolIndex].details}
          toolPath="#{@props.taskPrefix}.tools.#{toolIndex}"
          onClose={resolve}
        />
      }</ChangeListener>

  removeChoice: (choicesName, index) ->
    @props.task[choicesName].splice index, 1
    @props.workflow.update 'tasks'
