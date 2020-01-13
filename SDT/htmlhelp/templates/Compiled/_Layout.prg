LOCAL CRLF
CRLF = CHR(13) + CHR(10)
Response.Write([<!DOCTYPE html>]+ CRLF +;
   [<!-- saved from url=(0016)http://localhost -->]+ CRLF +;
   [<html>]+ CRLF +;
   [<head> ]+ CRLF +;
   [		<meta charset="utf-8" /> ]+ CRLF +;
   [	 	<meta http-equiv="X-UA-Compatible" content="IE=edge" />]+ CRLF +;
   [	 	<title>])

Response.Write(TRANSFORM( EVALUATE([ TRIM(oHelp.oTopic.Topic) ]) ))

Response.Write([ - ])

Response.Write(TRANSFORM( EVALUATE([ oHelp.cProjectName ]) ))

Response.Write([</title>	 ]+ CRLF +;
   [		<meta name="viewport" content="width=device-width, initial-scale=1,maximum-scale=1" />]+ CRLF +;
   [		<!-- <script type="text/javascript" src="https://getfirebug.com/firebug-lite.js#startOpened,overrideConsole"></script> -->]+ CRLF +;
   [	<link rel="stylesheet" type="text/css" href="templates/scripts/bootstrap/dist/css/bootstrap.min.css" />	]+ CRLF +;
   [	<link rel="stylesheet" type="text/css" href="templates/scripts/fontawesome/css/font-awesome.min.css" />]+ CRLF +;
   [		<link rel="stylesheet" type="text/css" href="templates/wwhelp.css" />]+ CRLF +;
   []+ CRLF +;
   [	 	<script src="templates/scripts/jquery/jquery.min.js"></script>	]+ CRLF +;
   []+ CRLF +;
   [		<script src="templates/scripts/highlightjs/highlight.pack.js"></script>] + CRLF )
Response.Write([	<script src="templates/scripts/highlightjs-badge.min.js"></script> ]+ CRLF +;
   [	<link href="templates/scripts/highlightjs/styles/vs2015.css" rel="stylesheet" />]+ CRLF +;
   []+ CRLF +;
   [  	<script src="templates/scripts/ww.jquery.min.js"></script>]+ CRLF +;
   []+ CRLF +;
   [	 <script src="templates/scripts/wwhelp.js"></script>]+ CRLF +;
   []+ CRLF +;
   [	<topictype value="])

Response.Write(TRANSFORM( EVALUATE([ TRIM(oHelp.oTopic.Type) ]) ))

Response.Write([" />]+ CRLF +;
   [	<script>		  ]+ CRLF +;
   [	$(document).ready( function() {]+ CRLF +;
   [		helpBuilder.initializeLayout();]+ CRLF +;
   [		// expand all top level topics]+ CRLF +;
   [		setTimeout( helpBuilder.tocExpandTop, 2);]+ CRLF +;
   [	});]+ CRLF +;
   [	</script>]+ CRLF +;
   [</head>]+ CRLF +;
   [<body>] + CRLF )
Response.Write([])

 lcSeeAlsoTopics = oHelp.InsertSeeAlsoTopics() 
Response.Write([]+ CRLF +;
   [	 <div class="flex-master">]+ CRLF +;
   [		  <div class="banner">]+ CRLF +;
   []+ CRLF +;
   [				<div class="pull-right sidebar-toggle">]+ CRLF +;
   [					 <i class="fa fa-bars"]+ CRLF +;
   [						 title="Show or hide the topics list"></i>]+ CRLF +;
   [				</div>]+ CRLF +;
   [				<div class="projectname">])

Response.Write(TRANSFORM( EVALUATE([ oHelp.cProjectname ]) ))

Response.Write([</div>]+ CRLF +;
   [		  </div>]+ CRLF +;
   []+ CRLF +;
   [		  <div class="page-content">]+ CRLF +;
   [				<div id="toc" class="sidebar-left toc-content">					 ]+ CRLF +;
   [					 <nav class="visually-hidden">]+ CRLF +;
   [						  <a href="tableofcontents.htm">Table of Contents</a>]+ CRLF +;
   [					 </nav>]+ CRLF +;
   [				</div>]+ CRLF +;
   [] + CRLF )
Response.Write([				<div class="splitter">					 ]+ CRLF +;
   [				</div>]+ CRLF +;
   []+ CRLF +;
   [				<nav class="topic-outline">]+ CRLF +;
   [					 <div class="topic-outline-header">On this page:</div>]+ CRLF +;
   [					 <div class="topic-outline-content"></div>]+ CRLF +;
   [				</nav>]+ CRLF +;
   []+ CRLF +;
   [				<div class="main-content">]+ CRLF +;
   [] + CRLF )
Response.Write([					 <!-- Rendered Content -->]+ CRLF +;
   [					 <article class="content-pane">		  ]+ CRLF +;
   [])

 wwScript.RenderAspScript(wwScriptContentPage)
Response.Write([]+ CRLF +;
   [					 </article>]+ CRLF +;
   [					 <br class="clearfix" />]+ CRLF +;
   [					 <br />]+ CRLF +;
   [					 <!-- End Rendered Content -->]+ CRLF +;
   [				</div>]+ CRLF +;
   []+ CRLF +;
   []+ CRLF +;
   [		  </div>		  ]+ CRLF +;
   [	 </div>] + CRLF )
Response.Write([]+ CRLF +;
   []+ CRLF +;
   [</body>]+ CRLF +;
   [</html>]+ CRLF +;
   [])
