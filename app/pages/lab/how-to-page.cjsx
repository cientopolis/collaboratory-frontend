React = require 'react'
counterpart = require 'counterpart'
Translate = require 'react-translate-component'
{Markdown} = require 'markdownz'

counterpart.registerTranslations 'en',
  howToPage:
    content: '''
      # How to Build a Project

      **So you want to build a project using the Zooniverse Project Builder?**
      This tutorial will help walk you through the process, using Kitteh Zoo as an example.
      You can [explore the actual project](https://www.zooniverse.org/projects/vrooje/kitteh-zoo).

      [![Kitteh Zoo screenshot](./assets/how-to-lab/how-to-1.jpg)](./assets/how-to-lab/how-to-1.jpg)

      ### Getting Started

      To get started building, go to [the Project Builder home page](/lab) and log in to your Zooniverse account, then click the "Build a Project" button in the top right. Here you can see all of the projects you own and collaborate on. Click on "Create a project" to start building.

      [![Project Builder screenshot](./assets/how-to-lab/how-to-2.jpg)](./assets/how-to-lab/how-to-2.jpg)

      **Start building:** Now you're in the Project Builder itself. This is where the magic happens. On the left-hand side, you've got your main menus: Project, Workflow, and Subjects. These are terms you'll see a lot, and they have specific meanings in the Zooniverse.  Project is pretty self-explanatory; Galaxy Zoo, Penguin Watch, and of course, Kitteh Zoo, are all examples of Zooniverse projects that you could build using the project builder. A workflow is the sequence of tasks that you ask volunteers to do, and subjects are the things (usually images) that volunteers do those tasks on.

      [![Project details editor screenshot](./assets/how-to-lab/how-to-3.jpg)](./assets/how-to-lab/how-to-3.jpg)

      ### Define your project.

      The first thing you'll want to do is fill in some basic information about your project on the Project Details page. Just click and type in the relevant boxes. We've added a short description that will be formatted using the markdown language. The avatar and background image for Kitteh Zoo are in this folder. Download these images to your computer. Now add these images by dragging and dropping or by clicking on the relevant boxes (like in the image above). You can come back and add more details at any time while building your project.

      ### Building a workflow

      This is where you build the tasks that volunteers actually do. When you first get to this page, you'll see there is a sample task (specifically a question) already in place.

      [![Project workflow editor screenshot](./assets/how-to-lab/how-to-4.jpg)](./assets/how-to-lab/how-to-4.jpg)

      We want to create this:

      [![Project workflow example](./assets/how-to-lab/how-to-5.jpg)](./assets/how-to-lab/how-to-5.jpg)

      We'll start by replacing the sample text with our question, which asks people how many cats are in the image. We add more answers using the "+" button under the "Yes" answer. Use the screenshot below to fill in the workflow details (you may need to zoom in!)

      [![Project workflow editing screenshot](./assets/how-to-lab/how-to-6.jpg)](./assets/how-to-lab/how-to-6.jpg)

      We added both text and images into the _Help Text_ box using the markdown language ([learn more about markdown](http://markdownlivepreview.com)).

      Here is the markdown for the help text:

          Tell us **how many cats** you see. You should include:

            - Actual cats (not drawn or simulated)
            - Cats of any species

          We will ask many people the same question about this image, so don't worry if you aren't absolutely sure. *Just give us your best guess.*

          Here are some examples of cats:

          ![Sink Cats Relax](http://zooniverse-resources.s3.amazonaws.com/bigblogfiles/cat_demo/cat_bloonet.jpg)
          ![Only 1 of these cats counts.](http://zooniverse-resources.s3.amazonaws.com/bigblogfiles/cat_demo/cat_valentina_a.jpg)
          ![Wet kitteh iz not amused](http://zooniverse-resources.s3.amazonaws.com/bigblogfiles/cat_demo/cat_joeltelling.jpg)

          And here are some examples of not-cats (you can ignore these):

          ![A sample of things that are not cats.](http://zooniverse-resources.s3.amazonaws.com/bigblogfiles/cat_demo/notcats.png)

      We can set subsequent tasks to depend on the answer to this question. Right now we haven't made any other tasks, so the only option is "End of Classification." Once we create more tasks, we'll go back through and link them. Note that this question is _required_ (people can't move on until they've answered it) and only one answer is allowed.

      Now we want to draw circles around the cat's faces and mark a point on their tails. Why? Because we can. (For your own project you'd obviously want to think carefully about the reasons for adding tasks to a workflow, and what you want to get from the answers/marks.)

      [![Project workflow task editing screenshot](./assets/how-to-lab/how-to-7.jpg)](./assets/how-to-lab/how-to-7.jpg)

      So under the _Task_ list, we'll click on **drawing**. We're asking folks to draw (with ellipses) around the cats' faces, as well as mark their tail tips with a point. We've changed the color on the Cattail points so they stand out more too. As usual, the main text gives people basic instructions on what we want, and the help text provides some more explanation on how to do the task.

      In addition to marking all the cat faces, we want to know just how cute they are. So every time someone marks a cat-face, we've added a pop-up question to ask just that. Add this question by clicking on the _sub-tasks_ button below the _Type_ and _Color_ task specifications.

      [![Project workflow task details editing screenshot](./assets/how-to-lab/how-to-8.jpg)](./assets/how-to-lab/how-to-8.jpg)

      When building your own project, you can combine any number of tasks in any order. You can start with a drawing task instead of a question. You can add sub-tasks for any drawing tool you make.

      In general, keep in mind that people are more likely to complete more classifications if the workflow is short and simple. Try to keep the workflow as simple as possible to achieve your research goals, and definitely try to only request tasks that cannot be accurately accomplished by automated methods.

      ### Linking the workflow together

      Now that all the tasks have been created, we've got to string them together by specifying what happens _next_. Right now, this means you kind of need to work backwards. The drawing task is the last task in this workflow, so we'll leave the "Next Task" button as the default "end of classification." But we'll have to go back to our first question.

      The first question, "How many cats are in this image?" only allows one answer, so you can specify the next task depending on the answer.  If folks say "None" for the number of cats, the classification ends. But if they say there's at least one cat, then they go on to the next question.

      [![Project workflow task editing screenshot](./assets/how-to-lab/how-to-9.jpg)](./assets/how-to-lab/how-to-9.jpg)

      ### Upload subjects

      To really get started building a project, you need images to work with. Normally you would add your own images by clicking on the "New Subject Set" button on the left hand side of the screen. This is one of the trickier steps in project creation -- for the purposes of this tutorial you can simply copy the Kitteh Zoo subject set, but check out the next section "Uploading subjects -- the nitty gritty" if you want to practice the full approach. To do this go to the workflow you created and under the _associated subject_ set section click on _add an example subject set_. You should now see the 'kittehs' subject set selected.

      [![Project workflow task editing screenshot](./assets/how-to-lab/how-to-10.jpg)](./assets/how-to-lab/how-to-10.jpg)

      **CONGRATULATIONS!**

      You should have successfully created Kitteh Zoo! To view it, got back to the _Build a Project_ page (by clicking the button in the top right of the page) and then click on the view button next to the new project you have just made.

      [![Project list screenshot](./assets/how-to-lab/how-to-11.jpg)](./assets/how-to-lab/how-to-11.jpg)

      ### Uploading subjects - the Nitty Gritty

      When you actually build your own project, there won't be an example set of images already loaded for you. Get started uploading a set of subjects for your project by clicking on the "New Subject Set" button on the left hand side of the screen. That will bring you to the _Subject Uploader_.

      It's easiest if you have all of your images in a single folder along with a manifest file, and you will upload both at the same time. The manifest file lists all the images we want to upload and links each  image to additional information, also called metadata, such as date, time, and photographer. There is more information about the manifest in the "Details" section below, but for now you can see an example manifest file in the ["Kitteh" zip file](https://data.zooniverse.org/tutorial/kitteh_zoo.zip).

      Click on the "Upload Subjects" box and navigate to the "Kitteh" folder you downloaded. The easiest thing to do is simply hit _cmd + a_ (on Mac, or _ctrl + a_ on Windows) to select everything in that folder. Note that the subject uploader ignores the excel file and the other folders. Click "open" to select those images and the manifest file for upload. The project uploader now indicates that the "Cat project manifest.csv" has 29 subjects for upload.

      Click "Upload" to start the process. It might take a little while, but when everything is uploaded, you'll see a list of all of the subjects. The numbers to the left are unique identifiers for each subject, and the icons to the right let you preview or delete each subject.

      Subject sets can be pretty powerful, and sometimes complex. You can have a single subject set that you add to over time, or have multiple subject sets, say, from different years or places. You can have different subject sets for different workflows, but you don't have to. You can even have multiple images in a given subject. For more details and advice on creating and structuring subject sets and associated manifests, check out the details section below.

      ### PROJECT BUILDER'S MANUAL – THE DETAILS

      - **Project**: This holds all your project level details. The project name, the people involved, and all the extra content (e.g. text and pictures) you want to share, are all here.
        - **Project Details**: This is your project's "behind the scenes" home page. Start off by naming and describing your project, add a logo and background image.
        - **Research Case, FAQ, Results, and Education**: You can add a lot of information in these pages to help volunteers better understand the motivation for your project, the best approaches for classifying, and the outcomes of your project.
        - **Collaborators**: Add people to your team and specify what their roles are so that they have the right access to the tools they need (including access to the project before it's public).
        - **Workflows**: A workflow is the sequence of tasks that you're asking volunteers to perform. For example, you might want to ask volunteers to answer questions about your images, or to mark features in your data, or both. The workflow is where you define those tasks and set out the order in which the volunteers will do them. Your project might have multiple workflows (if you want to set different tasks for different image sets).
      - **Subjects**: A subject is a unit of data to be analyzed. A subject can include one or more images that will be analyzed at the same time by volunteers. A subject set consists of a list of subjects (the "manifest") defining their properties, and the images themselves. Feel free to group subjects into sets in the way that is most useful for your research. Many projects will find it's best to just have all their subjects in 1 set, but not all.

      ### DETAILS - Workflows

      Note that a workflow with fewer tasks will be easier for volunteers to complete. We know from surveys of our volunteers that many people classify in their limited spare time, and sometimes they only have a few minutes. Longer, more complex workflows mean each classification takes longer, so if your workflow is very long you may lose volunteers.

      _Workflow Name_: Give your workflow a short, but descriptive name. If you have multiple workflows and give volunteers the option of choosing which they want to work on, this name will appear on a button instead of "Get started!"

      _Version_: Version indicates which version of the workflow you are on. Every time you save changes to a workflow, you create a new version. Big changes, like adding or deleting questions, will change the version by a whole number: 1.0 to 2.0, etc. Smaller changes, like modifying the help text, will change the version by a decimal, e.g. 2.0 to 2.1. The version is tracked with each classification in case you need it when analyzing your data.

      _Tasks_: There are two main types of tasks: questions and drawing. For question tasks, the volunteer chooses from a list of answers but does not mark or draw on the image. In drawing tasks, the volunteer marks or draws directly on the image using tools that you specify. They can also give sub-classifications for each mark. Note that you can set the first task from the drop-down menu.

      _Main Text_: Describe the task, or ask the question, in a way that is clear to a non-expert.

      The wording here is very important, because you will in general get what you ask for. Solicit opinions from team members and testers before you make the project public: it often takes a few tries to reach the combination of simplicity and clarity that will guide your volunteers to give you the inputs you need.

      You can use markdown in the main text.

      _Help Text_: Add text and images for a pop-up help window. This is shown next to the main text of the task in the main classification interface, when the volunteer clicks a button asking for help. You can use markdown in this text, and link to other images to help illustrate your description. The help text can be as long as you need, but you should try to keep it simple and avoid jargon. One thing that is useful in the help text is a concise description of why you are asking for this particular information.

      ### DETAILS - Project Details:

      _Name_: The project name is the first thing people will see and it will show up in the project URL. Try to keep it short and sweet.

      _Avatar_: Pick an avatar image for your project. This will represent your project on the Zooniverse home page. It can also be used as your project's brand. It's best if it's recognizable even as a small icon. To add an image, either drag and drop or click to open your file viewer. For best results, use a square image of not more than 50KB, but at minimum 100x100 pixels.

      _Background_: This image will be the background for all of your project pages, including your project's front page, which newcomers will see first. It should be relatively high resolution and you should be able to read text written across it. To add an image, either drag and drop or click to open your file viewer. For best results, use images of at least 1 megapixel, no larger than 256 KB. Most people's screens are not much bigger than 1300 pixels across and 750 pixels high, so if your image is a lot bigger than this you may find it doesn't look the way you expect. Feel free to experiment with different sizes on a "typical" desktop, laptop or mobile screen.

      _Description_: This should be a one-line call to action for your project. This will display on your landing page and, if approved, on the Zooniverse home page. Some volunteers will decide whether to try your project based on reading this, so try to write short text that will make people actively want to join your project.

      _Introduction_: Add a brief introduction to get people interested in your project. This will display on your project's front page. Note this field (renders markdown)[http://markdownlivepreview.com/], so you can format the text. You can make this longer than the Description, but it's still probably best to save much longer text for areas like the Research Case or FAQ tabs.

      _Checkbox: Volunteers choose workflow_: A workflow is a set of tasks a volunteer completes to create a classification. Your project might have multiple workflows (if you want to set different tasks for different image sets). Check this to let volunteers select which workflow they want to work on; otherwise, they'll be served workflow-subject pairs randomly.

      _Checkbox: Private project_:
      On "private" projects, only users with specified project roles can see or classify on the project. We strongly recommend you keep your project private while you're still working out its details. Share it with your team to get feedback by adding them in the Collaborators area (linked at the left). Team members you add can see your project even if it's private. Once your project is public, anyone with the link can view and classify on it.

      ### DETAILS - Additional Content

      _Research Case, FAQ, Results, and Education_: These pages are where you really get to share all the cool things about your project. All of these pages use Markdown (see link above) to format text and display images.

      [![Project additional content editor screenshot](./assets/how-to-lab/how-to-12.jpg)](./assets/how-to-lab/how-to-12.jpg)

      _Research case_: Explain your research to your audience here in as much detail as you'd like. This page displays no matter what, since explaining your motivation to volunteers is critical for the success of your project!

      _Results_: Once your project has hit its stride, share the results of your project with your volunteers here. This page will only display if you add content to it.

      _FAQ_: Add details here about your research, how to classify, and what you plan to do with the classifications. This page can evolve as your project does so that your active community members have a resource to point new users to. This page will only display if you add content to it.

      _Education_: If you are a researcher open to collaborating with educators you can state that here, include educational content, and describe how you'd like to help educators use your project. Also, if your project is primarily for educational purposes you can describe that here. This page will only display if you add content to it.

      ### DETAILS - Media

      You can upload your own media to your project (such as example images for your help pages) so  you can link to it without an external host. To start uploading, drop an image into the box (or click it to bring up your file browser and select a file).

      Once the image has uploaded, it will appear above the "Add an image" box. You can then copy the markdown text beneath the image into your project, or add another image.

      ### DETAILS - Visibility

      This page is where you decide whether your project is public and whether it's ready to go live. For more information on the different project stages, see our [project builder policies](/lab-policies).

      ### DETAILS - Collaborators

      Add people to your team and specify what their roles are so that they have the right access to the tools they need (including access to the project before it's public).

      [![Project collaborator editor screenshot](./assets/how-to-lab/how-to-13.jpg)](./assets/how-to-lab/how-to-13.jpg)

      _Owner_: The owner is the original project creator. There can be only one.

      _Collaborator_: Collaborators have full access to edit workflows and project content, including deleting some or all of the project.

      _Expert_: Experts can enter “gold mode” to make authoritative gold standard classifications that will be used to validate data quality.

      _Researcher_: Members of the research team will be marked as researchers on “Talk"

      _Moderator_: Moderators have extra privileges in the community discussion area to moderate discussions. They will also be marked as moderators on “Talk".

      _Tester_: Testers can view and classify on your project to give feedback while it’s still private. They cannot access the project builder.

      _Translator_: Translators will have access to the project builder as well as the translation site, so they can translate all of your project text into a different language.

      ### DETAILS - Subject sets and manifest details, a.k.a. "What is a manifest?"

      *The condensed answer:*

      A manifest is a file that tells our software how to combine the images you have into units of data (subjects) to be classified. The manifest also allows you to link your classifications back to the rest of your data. A manifest is formatted as a CSV file with 1 line per subject, with a unique identifier and the names of images to be associated with a subject on each row (with additional information often included in other fields as well). There is an example in the ["Kitteh" zip file](https://data.zooniverse.org/tutorial/kitteh_zoo.zip).

      *The full answer:*

      What we call a "manifest" is really just a plain text file with a specific format to each line.

      To understand the format, let's start with the first few lines from the Kitteh Zoo manifest:

          subject_id,image_name_1,origin,link,attribution,license,#secret_description
          1,6672150457_420d61007d_b.jpg,Flickr,https://www.flickr.com/photos/aigle_dore/6672150457,Moyan Brenn,Creative Commons - share adapt attribute,sleepy striped kitteh is unsuspecting of paparazzi
          2,8300920648_d4a21bba59_z,Flickr,https://www.flickr.com/photos/aigle_dore/8300920648,Moyan Brenn,Creative Commons - share adapt attribute,grandfather kitteh has ear hair. a lot of it
          3,6713782851_82fc8c73e5_z.jpg,Flickr,https://www.flickr.com/photos/hellie55/6713782851,hehaden,Creative Commons - share adapt attribute,juvenile kittehs practice break-in at the catnip factory

      The first line of the file is a header line that specifies the name of each of the manifest fields. In this case, our manifest has 7 fields (or columns), called "subject\_id", "image\_name", "origin", "link", "attribution", "license" and “#secret\_description”. They are separated by commas: this is what's known as a "comma separated values" file, or CSV file.

      After the first line, each row of the file contains information about 1 subject. The first field, corresponding with the "subject\_id" header, is a unique number that identifies the subject. The second field, which aligns with the "image\_name" header, contains the name of the image that's associated with that subject. These 2 fields are critically important: the image name is obviously important, and a unique identifier is important for matching your classifications to the rest of your data.

      All the other fields are optional, but in general having more information in the manifest is better. Most projects include additional information in the manifest that helps them match the classifications and subjects to the other data they need for their research. The additional information in the manifest can also be made available to volunteers as they classify (some very keen volunteers find this extremely useful). Any fields with names that begin with “#” or “//” will *not* be shown to volunteers, such as the “#secret\_description” field in Kitteh Zoo. These hidden fields will still be returned to you in the classification file, so you can use these to include information helpful to your research without worrying about whether it might affect the classifications themselves. Information in fields that *don’t* begin with either “#” or “//” will be accessible to volunteers.

      For now, let’s assume you’re just including the bare minimum of information, like:

          id,image
          1,kitteh_in_box.jpg
          2,kitteh_stalking.jpg
          3,kitteh_losing_balance.jpg

      Note the field names have changed from the previous example. That's because, aside from marking whether a field is hidden or not, it doesn't actually matter to the Zooniverse what the fields are called (or what order they’re in), so you can name and order them according to whatever works best for your project.

      Using a manifest CSV file also makes it very easy to create subjects with multiple images:

          id,image1,image2
          1,kitteh_in_box.jpg,kitteh_eating_box.jpg
          2,kitteh_stalking.jpg,kitteh_pounced.jpg
          3,kitteh_losing_balance.jpg,kitteh_falling_off_sofa.jpg

      If you upload this manifest plus the 6 images named in it, the Zooniverse software will create 3 subjects with 2 images each. When these subjects come up in the classification interface, volunteers will be able to flash between the images or switch between them manually.

      You can create a manifest file in a simple text editor (such as TextEdit or Notepad), although this method is prone to errors like missed or extra commas. People often find it easiest to create manifest files using spreadsheet software such as Google Sheets, iWork Numbers or Microsoft Excel. Creating and maintaining a manifest using a spreadsheet makes the manifest easy to read, and you can export it to CSV format when you're ready to upload your subjects. You can also open existing CSV files in spreadsheet software.

      *Note:* if you have a large subject set it may be cumbersome to manually create a manifest. We suggest using a command-line or other tool to copy-paste a directory list of files into a spreadsheet to help you get started.
    '''




















counterpart.registerTranslations 'es',
  howToPage:
    content: '''
      # Cómo crear un proyecto

      Este tutorial te ayudará durante el proceso de creación, utilizando el proyecto "Recorriendo La Plata"
      como ejemplo.
      Podés explorar el [proyecto real](http://ec2-52-196-4-55.ap-northeast-1.compute.amazonaws.com/projects/investigador/recorriendo-la-plata).

      [![Kitteh Zoo screenshot](./assets/how-to-lab/howTo1Es.png)](./assets/how-to-lab/howTo1Es.png)

      ### Empezando

      Lo primero que hay que hacer es ir a la [página de creación de proyectos](/lab) e ingresar con tu cuenta
      en Cientópolis. Aquí también se pueden ver todos los proyectos que vayas a crear, como así también los
      proyectos en los que colabores. Para crear un proyecto, clickear en el botón "Crear un proyecto".

      [![Project Builder screenshot](./assets/how-to-lab/howTo2Es.png)](./assets/how-to-lab/howTo2Es.png)


      **Empezar con la creación:** Ahora ya estás en la página de creación misma. Sobre el sector izquierdo
      están los menúes principales: **Proyecto**, **Flujos de Trabajo** y **Conjuntos de análisis**.
      Esta es terminología que vas a ver a menudo, y tienen significados específicos en el contexto de esta plataforma. **Proyecto** es bastante claro; Recorriendo La Plata sería un proyecto, y representa al proyecto de investigación del mundo real con el cual estás colaborando. Un **flujo de trabajo** representa el conjunto de tareas que los voluntarios del proyecto tiene que realizar, usualmente en forma de preguntas. Un **conjunto de análisis** es un conjunto de cosas (usualmente son imágenes) sobre las que los voluntarios realizan las tareas mencionadas anteriormente.

      [![Project details editor screenshot](./assets/how-to-lab/howTo3Es.png)](./assets/how-to-lab/howTo3Es.png)


      ### Definiendo tu proyecto

      Lo primero que vas a necesitar hacer es completar información básica sobre tu proyecto en la pestaña de **Detalles del proyecto**. Algunas de ellas son el nombre del proyecto, una descripción, una introducción, e imágenes para el logo y fondo.

      ### Creando un flujo de trabajo

      Aquí es donde se definen las tareas que van a realizar los voluntarios. La primera vez que visites esta página, verás que ya hay una pregunta de ejemplo ya configurada.

      [![Project workflow editor screenshot](./assets/how-to-lab/howTo4Es.png)](./assets/how-to-lab/howTo4Es.png)

      Queremos crear lo siguiente:

      [![Project workflow example](./assets/how-to-lab/howTo5Es.png)](./assets/how-to-lab/howTo5Es.png)

      Empezamos reemplazando el texto de ejemplo con nuestra pregunta, que en nuestro caso pregunta a los voluntarios si pueden identificar un edificio representativo de La Plata. Podemos agregar más preguntas con el botón "+" debajo de la respuesta "Sí" que viene por defecto. Utilizá la captura de pantalla de abajo a modo de guía.

      [![Project workflow editing screenshot](./assets/how-to-lab/howTo6Es.png)](./assets/how-to-lab/howTo6Es.png)

      Agregamos tanto texto como imágenes en el recuadro de _Texto de Ayuda_ utilizando el lenguaje _Markdown_ ([más información sobre markdown](http://markdownlivepreview.com))

      Esta es la representación del texto de ayuda con markdown:

          Decinos solamente si ves un edificio representativo de La Plata. Esta pregunta puede resultar subjetiva en algunos casos (un edificio será representativo para algunos, y otros quizás nunca lo hayan visto), pero no te preocupes, ya que muchas personas verán las mismas imágenes.

          Algunos ejemplos que pueden resultar obvios serían la Catedral, el Teatro Argentino, la Municipalidad. 

          ![Catedral]()
          ![Teatro Argentino]()
          ![Municipalidad]()


          Tené en cuenta que la pregunta **NO** es si reconocés ese sector particular de La Plata (por ejemplo: "Sí, eso es a dos cuadras de mi casa, al lado del supermercado"), sino si el edificio te parece que es _representativo_


      Se pueden agregar tareas subsecuentes dependiendo de la respuesta a la pregunta. Por ejemplo, si responde que sí, entonces podemos agregar un recuadro donde el voluntario pueda escribir el edificio que reconoce; y si elije que no, entonces termina la tarea (opción "Fin de la clasificación"). Una vez que creemos todas las tareas, las podemos vincular creando un flujo dependiendo de las respuestas que se vayan dando. También, en la sección de "Elección", se puede configurar si se permite selección múltiple (seleccionar más de una opción, aunque en este caso de ejemplo no tendría sentido), y si la pregunta es requerida (no se puede pasar a analizar otra imagen, o a la siguiente pregunta, si no se responde algo)


      Ahora queremos dibujar un recuadro alrededor del edificio que encontramos. ¿Por qué? Porque sí, porque podemos. (En realidad, es a modo de ejemplo. En un proyecto real hay que pensar cuidadosamente las tareas que pedimos a los voluntarios)

      [![Project workflow task editing screenshot](./assets/how-to-lab/howTo7Es.png)](./assets/how-to-lab/howTo7Es.png)

      Entonces, debajo de la lista _Tareas_, clickeamos en "Agregar tarea", y luego en "Dibujo". Vamos a pedir a los voluntarios que dibujen (con rectángulos) la parte principal del edificio que vean. Como en las tareas del otro tipo, el texto principal provee instrucciones básicas en lo que queremos que el voluntario haga, y luego extendemos un poco en la sección de "Texto de ayuda".

      En adición al rectángulo marcado, queremos que el voluntario nos diga qué tanto les gusta el edificio en términos de arquitectura (otra vez, esta pregunta carece de sentido en un contexto de proyecto real; esto es solamente como ejemplo). Así, cada vez que un voluntario marque el edificio con un rectángulo, a continuación agregamos una pregunta estilo pop-up que pregunte lo mencionado. Para agregar esta pregunta, hacer click en el botón _sub-tareas_ debajo de las especificaciones de _Tipo_ y _Color_.


      [![Project workflow task details editing screenshot](./assets/how-to-lab/howTo8Es.png)](./assets/how-to-lab/howTo8Es.png)

      Al crear tu propio proyecto, podés combinar cualquier cantidad de tareas en cualquier orden. Podés empezar con una tarea de dibujo en lugar de una pregunta. También podés agregar sub-tareas para cualquiera de las tareas de dibujo que agregues.

      Tené en cuenta que en general es más probable que los voluntarios completen más clasificaciones si el flujo de trabajo es corto y simple. Idealmente deberías intentar que éste sea lo más simple posible, para poder alcanzar más fácilmente los objetivos de la investigación, y definitivamente que las tareas que solicites no puedan ser logradas de manera precisa por métodos automatizados (por ejemplo, un algoritmo de reconocimiento facial)


      ### Uniendo las tareas entre sí

      Ahora que se han creado todas las tareas, tenemos que unirlas mediante la especificación de lo que pasa _siguiente_. Esto significa que hay que trabajar un poco hacia atrás. La tarea de marcado es la última en este flujo de trabajo, así que vamos a dejar el botón de "Siguiente tarea" con el valor "fin de clasificación" que viene por defecto. Pero vamos a tener que volver a nuestra primera pregunta.

      La primera pregunta, "¿Ves un edificio representativo de la ciudad de La Plata?", permite tres tipos de respuestas: 'Sí', 'No', y 'No estoy seguro'. Si el usuario elige cualquiera de las dos últimas, entonces se termina la clasificación de esta imagen. En cambio, si elige 'Sí', entonces tenemos que pasar a la tarea de dibujo/marcado.

      [![Project workflow task editing screenshot](./assets/how-to-lab/howTo9Es.png)](./assets/how-to-lab/howTo9Es.png)

      ### Subir elementos de análisis

      Para realmente armar un proyecto, necesitamos imágenes sobre las cuales trabajar. Para esto, hacemos click en el botón de "Nuevo conjunto de análisis" en el panel de la izquierda.

      Es más fácil si tenés todas tus imágenes en una misma carpeta, junto con un manifiesto, para así subirlos al mismo tiempo. El manifiesto lista todas las imágenes que queremos subir, y relaciona cada imágen con información adicional (también llamada metadata), tal como fecha, hora, y el nombre de quien tomó la fotografía. Hay más información sobre el manifiesto en la sección de "Detalles" más abajo, pero por ahora podés ver un manifiesto de ejemplo aquí["Kitteh" zip file](https://data.zooniverse.org/tutorial/kitteh_zoo.zip).

      Hacé click en el recuadro con líneas punteadas y dirigite a la carpeta con tus imágenes. La forma más simple de realizarlo es presionar Ctrl + A para seleccionar todo (imágenes + manifiesto), y luego hacer click en "Abrir". Tendría que indicarse ahora que el manifiesto tiene X elementos a subir, donde X es la cantidad de imágenes listadas.

      Hacé click en "Subir" para empezar el proceso. Puede llevar un tiempo, pero cuando termine, podrás ver un listado con todos los elementos. Los números a la izquierda representan un identificador único de la imágen, mientras que los botones de la derecha te permiten ver y/o borrar el elemento, respectivamente.

      Los conjuntos de análisis pueden ser robustos, y a veces complejos. Podés tener un solo conjunto al que vas agregando imágenes a lo largo del tiempo; o tener múltiples conjuntos, por ejemplo para diferentes años o lugares. También es posible tener un conjunto de análisis diferente para cada flujo de trabajo, aunque esto no es necesario. También es posible incluso tener múltiples imágenes en un mismo elemento. Para más detalles y consejos sobre la creación y estructuración de conjuntos de análisis, consultá la sección de "Detalles" más abajo.


      **Felicidades!!**

      ¡Creaste satisfactoriamente el proyecto! Para verlo, podés volver a la página de "Construya un proyecto" en el panel de navegación de arriba, y luego clickear en el botón "Ver" junto al proyecto que creaste recién.

      [![Project list screenshot](./assets/how-to-lab/howTo11Es.png)](./assets/how-to-lab/howTo11Es.png)


      ### Manual de creación de proyectos – DETALLES

      - **Proyecto**: es lo que contiene los detalles a nivel proyecto: el nombre del mismo, las personas involucradas, y todo el contenido extra (como texto e imágenes) que quieras compartir.
        - **Detalles del proyecto**: esto corresponde al "detrás de las cámaras" del proyecto. Empezá nombrando y describiendo tu proyecto, y agregando un logo y una imágen de fondo.
        - **Investigación, resultados, preguntas frecuentes y educación**: podés agregar mucha información en estas secciones, para ayudar a los voluntarios a entender mejor la motivación de tu proyecto, los mejores enfoques para clasificar, y los resultados de tu proyecto.
        - **Colaboradores**: sumá gente a tu equipo y especificá cuáles son sus roles para que así tengan acceso a las herramientas que necesitan (incluyendo acceso al proyecto antes de que esté listo).
        - **Flujos de trabajo**: un flujo de trabajo representa la secuencia de tareas que querés que los voluntarios realicen. Por ejemplo, podrías pedir a los voluntarios que respondan preguntas sobre tus imágenes, o realizar marcas en las mismas, o ambas. El flujo de trabajo es donde definís esas tareas y el orden en el que los voluntarios tendrán que realizarlas. Tu proyecto puede tener múltiples flujos de trabajo (si querés configurar diferentes tareas para diferentes conjuntos de análisis).
      - **Elemento de análisis**: se trata de la unidad de datos que se desee analizar, y está contenida dentro de un conjunto de análisis. Un elemento puede estar compuesto de una o más imágenes que serán analizadas al mismo tiempo por diferentes voluntarios. Un conjunto de análisis consiste de una lista de elementos (referido anteriormente como "manifiesto") donde se definen sus propiedades, y las imágenes en sí. Tenés la libertad de agrupar los elementos en diferentes conjuntos de la manera que sea más útil y significativa para tu investigación.


      ### DETALLES - Flujos de trabajo

      Es importante notar que un flujo de trabajo con pocas tareas será más fácil de completar por los voluntarios. Es sabido que mucha gente colabora en este tipo de proyectos en su tiempo libre, y usualmente disponen de poco tiempo. Flujos de trabajo más largos y complejos equivale a más tiempo para realizar una sola clasificación, que al mismo tiempo puede significar la pérdida de tus voluntarios.


      ### DETAILS - Workflows

      Note that a workflow with fewer tasks will be easier for volunteers to complete. We know from surveys of our volunteers that many people classify in their limited spare time, and sometimes they only have a few minutes. Longer, more complex workflows mean each classification takes longer, so if your workflow is very long you may lose volunteers.

      _Nombre_: nombrá a tu flujo de trabajo de manera concisa y descriptiva. Si tenés múltiples flujos de trabajo y activás la opción para que los voluntarios elijan en cuál de ellos quieren trabajar, este nombre es el que aparecerá en un botón en lugar de "¡Sé parte ahora!"

      _Version_: Versión indica el número de versión en el que nos encontramos. Cada vez que se guarden cambios en un flujo de trabajo, se crea una nueva versión. Cambios grandes, como agregar o borrar preguntas, cambiarán el número de versión entero: 1.0 a 2.0, etc. Cambios más pequeños, como modificar el texto de ayuda, cambarán el número de versión decimal: 2.0 a 2.1, etc. El número de versión queda registrado con cada clasificación que hagan los voluntarios, en caso de que lo necesites cuando analices los resultados.

      _Tareas_: hay dos tipos principales de tareas: preguntas y dibujo/marcado. Para las tareas con preguntas, el voluntario selecciona una respuesta en un listado, pero no hace marcas o dibujos en la imágen. En cambio, en las tareas de dibujo/marcado, el voluntario hace marcas o dibuja directamente sobre la imágen utilizando herramientas que especifiques. También pueden proporcionar subclasificaciones para cada marca que hacen.

      _Texto principal_: Describí la tarea, o realizá la pregunta, de manera tal que sea clara para un no experto.

      La elección de palabras es muy importante, porque en general vas a obtener exactamente lo que preguntás. Solicitá opiniones al resto del equipo antes de hacer público el proyecto. Usualmente son necesarios algunos intentos para alcanzar la combinación adecuada de simplicidad y claridad para que tus voluntarios proporcionen la información que necesitás.

      Podés usar markdown para darle formato a este texto.

      _Texto de ayuda_: Agregá texto y/o imágenes a una ventana que aparece cuando el voluntario hace click en "¿Necesita ayuda?". Podés usar markdown para darle formato a este texto y a las imágenes. Este texto puede ser tan extenso como sea necesario, pero lo ideal es evitar terminología específica. Algo que suele ser útil es aclarar por qué estás realizando la pregunta, o por qué solicitás cierta información.


      ### DETALLES - Detalles del proyecto

      _Nombre_: El nombre del proyecto es lo primero que los usuarios van a ver sobre el proyecto, y aparecerá en la URL del mismo. Lo mejor es que sea breve y conciso.

      _Avatar_: Elegí un logo para tu proyecto. Esto va a representar al mismo en la página principal del sitio. También puede ser usado como la marca de tu proyecto. Lo ideal es que sea reconocible incluso como un ícono pequeño. Para obtener mejores resultados, es recomendable utilizar una imagen cuadrada de no más de 50KB, y un mínimo de 100 pixels.

      _Imagen de fondo_: Esta será la imagen de fondo en todas las páginas del proyecto, incluyendo la página principal, que es la que verán los recién llegados. Tendría que ser de una resolución relativamente alta, y que sea posible leer texto sobre la misma. Para obtener mejores resultados, es recomendable utilizar una imagen con buena calidad (1 megapixel) de no más de 256KB.

      _Descripción_: Esta sería la frase bien concisa que atrape a tus potenciales voluntarios, y que se muestra en la página principal del proyecto. Así, algunos voluntarios decidirán si participar o no, basado en este texto.

      _Introducción_: Agregá una introducción breve para lograr que la gente se interese en tu proyecto. Este texto se verá en la página principal del mismo. Este campo [soporta markdown](http://markdownlivepreview.com/), así que es posible darle formato al texto. El contenido de este campo puede ser más largo que la descripción, pero sin embargo sería mejor dejar texto más largo para las seccciones de Investigación o Preguntas frecuentes.

      _Checkbox: Los voluntarios pueden elegir el flujo de trabajo en el cual trabajar_: Como tu proyecto puede tener múltiples flujos de trabajo (por si es necesario configurar diferentes tareas para diferentes conjuntos de imágenes), es posible permitir a los voluntarios elegir en cuál de los flujos trabajar. De otro modo, se les asignará un par flujo de trabajo-conjunto de análisis de manera aleatoria.

      _Checkbox: Proyecto privado_: En proyectos privados, solamente usuarios con roles específicos pueden verlo o incluso realizar clasificaciones en el mismo. Es recomendable dejar el proyecto en modo privado mientras configures los detalles. Compartilo con tu equipo para obtener opiniones, agregándolos al proyecto en el área de Colaboradores sobre el panel de la izquierda. Los usuarios que hayas agregados pueden ver el proyecto incluso estando en modo privado. Una vez que el proyecto pase a ser público, cualquiera con el link al mismo podrá verlo y realizar clasificaciones.


      ### DETALLES - Contenido adicional

      _Investigación, resultados, preguntas frecuentes y educación_: Estas son las secciones donde podés compartir todos los detalles en profundidad sobre tu proyecto. Todas permiten el uso de Markdown para dar formato al texto y para mostrar imágenes.

      [![Project additional content editor screenshot](./assets/how-to-lab/howTo12Es.png)](./assets/how-to-lab/howTo12Es.png)

      _Investigación_: Explicá los detalles de tu proyecto de investigación con todo el lujo de detalle que desees. Explicar la motivación del proyecto y los objetivos del mismo a los voluntarios, puede ser crítico para el éxito del proyecto.

      _Resultados_: Una vez que el proyecto esté estable y maduro, compartí los resultados de la investigación con tus voluntarios en esta página. Esta página sólo va a mostrarse si agregás contenido.

      _Preguntas frecuentes_: Agregá otros detalles de la investigación, cómo clasificar, y lo que tengas pensado hacer con las clasificaciones. El contenido en esta sección puede ir evolucionando a la par del proyecto, de manera que tu comunidad de colaboradores activos tenga una herramienta con la cual guiar a nuevos usuarios. Esta página sólo va a mostrarse si agregás contenido.

      _Educación_: Si sos un investigador dispuesto a colaborar con educadores, podés aclararlo en esta sección. Incluir contenido educacional, y describir cómo te gustaría ayudar a los educadores a usar tu proyecto. Si tu proyecto es principalmente de índole educacional, también podés aclararlo aquí. Esta página sólo va a mostrarse si agregás contenido.


      ### DETALLES - Subir imágenes

      Es posible subir imágenes vinculadas a tu proyecto, que no corresponden a las imágenes de los conjuntos de análisis. Estas imágenes podrían usarse para las páginas de ayuda, sin la necesidad de subirlas a un servidor de imágenes externo.

      Una vez que la imagen se haya subido, aparecerá en el mismo recuadro para subirla, junto con el texto en Markdown que luego podés utilizar para mostrarla en otras secciones del proyecto.


      ### DETALLES - Visibilidad

      En esta sección es donde decidís si tu proyecto pasa a ser público, y si está listo para ponerse operacional (o también dicho como "en vivo"). Para más información sobre las diferentes etapas de un proyecto, visitá nuestras [políticas de creación de proyectos](/lab-policies).

      ### DETALLES - Colaboradores

      Sumá gente a tu equipo y especificá cuáles son sus roles para que así tengan acceso a las herramientas que necesitan (incluyendo acceso al proyecto antes de que esté listo).

      [![Project collaborator editor screenshot](./assets/how-to-lab/howTo13Es.png)](./assets/how-to-lab/howTo13Es.png)


      _Dueño_: Es el creador original del proyecto, por lo que sólo uno puede existir.

      _Colaborador_: Los colaboradores tienen acceso total para editar los flujos de trabajo y el contenido del proyecto, incluyendo poder borrar algunas cosas o el proyecto en sí.

      _Experto_: Los expertos pueden entrar en el modo "estándar oro", en el cual pueden realizar clasificaciones autoritativas que sirven para validar la calidad de los datos ingresados por los voluntarios.

      _Investigador_: Los miembros del grupo de investigación serán marcados como tal en los foros de discusión.

      _Moderador_: Los moderadores tienen privilegios extra en los foros de discusión de la comunidad, y son los que moderan estas discusiones. Serán marcados como tal en los foros de discusión.

      _Tester_: Un tester puede ver y realizar clasificaciones en el proyecto para brindar retroalimentación cuando el proyecto todavía es privado. Un tester no puede acceder a la sección de creación del proyecto.

      _Traductor_: Los traductores tienen acceso al sitio de traducción.


      ### DETALLES - Conjuntos de análisis y detalles del manifiesto; en otras palabras, ¿qué es un manifiesto?

      *Respuesta breve:*

      Un manifiesto es un archivo que le dice a nuestra aplicación cómo combinar tus imágenes en unidades de datos (elementos) a ser clasificados. El manifiesto también permite relacionar tus clasificaciones con el resto de los datos. El formato de un manifiesto es en CSV (Coma Separated Values; o Valores Separados por Comas), con una línea por elemento, con un identificador único y los nombres de las imágenes que se asocian a un elemento en cada fila (con información adicional usualmente incluída en otros campo).

      *La respuesta completa:*

      Lo que llamamos "manifiesto" es en realidad un archivo de texto un un formato específico para cada línea.
      Para entender el formato, veamos unas líneas de ejemplo:

          subject_id,image_name_1,origin,link,attribution,license,#secret_description
          1,6672150457_420d61007d_b.jpg,Flickr,https://www.flickr.com/photos/aigle_dore/6672150457,Moyan Brenn,Creative Commons - share adapt attribute,sleepy striped kitteh is unsuspecting of paparazzi
          2,8300920648_d4a21bba59_z,Flickr,https://www.flickr.com/photos/aigle_dore/8300920648,Moyan Brenn,Creative Commons - share adapt attribute,grandfather kitteh has ear hair. a lot of it
          3,6713782851_82fc8c73e5_z.jpg,Flickr,https://www.flickr.com/photos/hellie55/6713782851,hehaden,Creative Commons - share adapt attribute,juvenile kittehs practice break-in at the catnip factory

      La primer línea del archivo es una línea tipo encabezado que especifica el nombre de cada uno de los campos del manifiesto. En el ejemplo de arriba, el manifiesto tiene 7 campos (o columnas): subject_id, image_name_1, origin, etc. También se observa que, como el nombre del formato lo indica, están separados por comas.

      En las líneas siguientes, cada línea contiene información sobre un elemento de análisis. El primer campo, correspondiente al encabezado de "subject_id", es un número único que identifica al elemento. El segundo campo correspondiente al encabezado de "image_name", contiene el nombre de la imagen que está asociada al elemento. Estos dos campos son críticos: el nombre de la imagen es obviamente importante, y un identificador único es importante para poder relacionar las clasificaciones con el resto de los datos.

      El resto de los campos son opcionales, pero en general, más información en el manifiesto, mejor. Estos datos adicionales que agregues pueden ser mostrados a los voluntarios mientras clasifican (algunos voluntarios incluso encontrarán estos datos extra como muy útiles). Cualquier campo que empiece con "#" o "//" *no* será mostrado a los voluntarios, como el campo "#secret_description" de más arriba. Estos campos ocultos seguirán siendo visibles en tus archivos de clasificaciones, así que los podés utilizar para agregar información útil para la investigación, sin preocuparte de que puedan influenciar las clasificaciones por parte de los voluntarios. El resto de los campos sí podrá ser visible a los voluntarios.

      Por ahora, vamos a asumir que incluímos los campos mínimos, como

        identificador,imagen
        1,foto_catedral.jpg
        2,foto_edificio_generico.jpg
        3,foto_teatro.jpg


      Notar que los nombres de los campos cambiaron con respecto al ejemplo anterior. Esto es porque, aparte de marcar un campo como oculto o no, realmente no importa el nombre de los campos (o el orden de los mismos), así que podés nombrarlos y ordenarlos de acuerdo a lo que te resulte mejor.

      Utilizar un manifiesto también hace más fácil crear elementos de clasificación que tengan múltiples imágenes:

        identificador,imagen,imagen2
        1,foto_catedral.jpg,foto_edificio_generico2.jpg
        2,foto_edificio_generico.jpg,foto_campo.jpg
        3,foto_teatro.jpg,foto_teatro2.jpg


      Si subís un manifiesto como este, junto con las 6 imágenes, se crearán 3 elementos de análisis con 2 imágenes cada uno. Cuando cada uno de estos elementos aparezca en la sección de clasificación que ven los voluntarios, se podrá pasar entre las imágenes para verlas.

      Podés crear un manifiesto en un editor de texto simple (como Notepad), aunque esta forma es propensa a errores como olvidar comas. Lo mejor es utilizar programas de hojas de cálculo como Microsoft Excel o Google Sheets. Crear y mantener un manifiesto usando alguno de estos programas hace que sea fácil de leer, y permiten exportarlos al formato CSV. También es posible abrir archivos CSV con estos programas.

      *Nota:* si tenés un conjunto de análisis muy grande, puede resultar tedioso crear un manifiesto manualmente. Se sugiere utilizar un método automatizado.
    '''    

module.exports = React.createClass
  displayName: 'HowToPage'

  render: ->
    <div className="secondary-page centered-grid">
      <Markdown>{counterpart "howToPage.content"}</Markdown>
    </div>
