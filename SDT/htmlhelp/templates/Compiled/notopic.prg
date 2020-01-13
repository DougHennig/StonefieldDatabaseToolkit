LOCAL CRLF
CRLF = CHR(13) + CHR(10)
Response.Write([<!DOCTYPE html>]+ CRLF +;
   [<html>]+ CRLF +;
   [<head>]+ CRLF +;
   [	 <meta charset="utf-8" /> ]+ CRLF +;
   [	 <meta http-equiv="X-UA-Compatible" content="IE=edge" />		]+ CRLF +;
   [	 <base href="file:///])

Response.Write(TRANSFORM( EVALUATE([ SYS(5) + CURDIR() ]) ))

Response.Write([" />]+ CRLF +;
   [	 <topictype value="topic" />]+ CRLF +;
   [	 <title>Welcome to West Wind Html Help Builder</title>]+ CRLF +;
   [	 <link rel="stylesheet" type="text/css" href="templates/scripts/bootstrap/dist/css/bootstrap.min.css" /> ]+ CRLF +;
   [	 <link rel="stylesheet" type="text/css" href="templates/scripts/fontawesome/css/font-awesome.min.css" />]+ CRLF +;
   [	 <link rel="stylesheet" type="text/css" href="templates/wwhelp.css" />	  ]+ CRLF +;
   [	 <style>]+ CRLF +;
   [	 h5 { margin-bottom: 5px; margin-top: 15px;}  ]+ CRLF +;
   [	 body {]+ CRLF +;
   [		  background-image: url(bmp/images/background.jpg);] + CRLF )
Response.Write([		  background-position-y: 75px;]+ CRLF +;
   [		  background-size: cover;]+ CRLF +;
   [	 }]+ CRLF +;
   [	 </style> ]+ CRLF +;
   [</head>]+ CRLF +;
   [<body >]+ CRLF +;
   [	 <img src="bmp/images/wwhelpLogo.gif" style="position: absolute; left: 2px; top: 120px; width: 150px">]+ CRLF +;
   []+ CRLF +;
   [	 <div class="banner">]+ CRLF +;
   [] + CRLF )
Response.Write([		  <div class="pull-right sidebar-toggle">]+ CRLF +;
   [				<i class="fa fa-bars"]+ CRLF +;
   [					title="Show or hide the topics list"></i>]+ CRLF +;
   [		  </div>]+ CRLF +;
   [		  <img src="bmp/images/logo.png" class="banner-logo" />]+ CRLF +;
   []+ CRLF +;
   [		  <div class="projectname">West Wind Html Help Builder</div>]+ CRLF +;
   [		  <div class="byline">]+ CRLF +;
   [				<img src="bmp/topic.png" />]+ CRLF +;
   [				Building Documentation the easy way] + CRLF )
Response.Write([		  </div>]+ CRLF +;
   [	 </div>]+ CRLF +;
   []+ CRLF +;
   [	 <div class="content" style="margin: 35px 10px 35px 165px; max-width: 500px; min-width: 300px;">]+ CRLF +;
   [		  <h2>Welcome to Help Builder</h2>]+ CRLF +;
   []+ CRLF +;
   [		 Currently there is <i>No Open Project</i> in Help Builder's IDE. Your next step is to create]+ CRLF +;
   [a new project or open an existing one.]+ CRLF +;
   [<hr/>]+ CRLF +;
   [] + CRLF )
Response.Write([				<h5><i class="fa fa-plus-circle"></i>  <a href="vfps://NOOPENPROJECT/CREATEPROJECT/">Create a new Project</a></h5>]+ CRLF +;
   [				<p>		 ]+ CRLF +;
   [					 Creates a new project that consists of a project file and all related ]+ CRLF +;
   [					 templates, stylesheets and scripts required to render your topics.	]+ CRLF +;
   [				</p>]+ CRLF +;
   []+ CRLF +;
   [					 <form action="vfps://NOOPENPROJECT/OPENFILE/" method="POST" style="margin-top: 0; padding-top: 5px">]+ CRLF +;
   []+ CRLF +;
   [						  <h5><i class="fa fa-file-text"></i> <a href="vfps://NOOPENPROJECT/OPENPROJECT">Open an existing Project</a></h5>]+ CRLF +;
   [						  <p>] + CRLF )
Response.Write([						  Open an previously created Help Builder Project. ]+ CRLF +;
   [])


	PUBLIC ARRAY laRecent[1]
	lnRecent = goHelp.oConfig.GetRecentList(@laRecent)
	if lnRecent > 0
	   lcOutput= ;
	   [<form action="vfps://NOOPENPROJECT/OPENFILE/" method="POST" style="margin-top:0;">] +;
	   [<select name="txtProject" onchange="form.submit();" style="padding:3px;max-width: 97%;border:1px solid silver;">] +;
	   [<option>---   Recent Projects   ---</option>] + CHR(13) + CHR(10) 
	
	   FOR __x = 1 to lnRecent    
	      lcTItemText = laRecent[__x]
	      IF !EMPTY(lcTItemText)
	         lcOutput = lcOutput + [<option>] + lcTItemText + [</option>] + CHR(13) + CHR(10)
	      ENDIF
	   ENDFOR
	   lcoutput = lcOutput + "</select></form>"
	   Response.Write(lcOutput)
	endif
	RELEASE laRecent
	
Response.Write([]+ CRLF +;
   [					 </p>]+ CRLF +;
   []+ CRLF +;
   []+ CRLF +;
   []+ CRLF +;
   [								<h5 style="margin-top: 20px;"><i class="fa fa-sign-in"></i> <a href="vfps://NOOPENPROJECT/IMPORTCHM">Import from Html Help file or Html Help Workshop Project</a></h5>]+ CRLF +;
   [						  <p>]+ CRLF +;
   [								If you have an existing CHM file or HHC project, you can import these files into Help Builder with some limitations.]+ CRLF +;
   [						  </p>]+ CRLF +;
   [] + CRLF )
Response.Write([]+ CRLF +;
   [				<h5><i class="fa fa-book"></i> <a href="vfps://NOOPENPROJECT/SHOWHELP">View Help Builder Documentation</a></h5>]+ CRLF +;
   [				<p>	 ]+ CRLF +;
   [				Browse the Help Builder documentation and check out what features are available for application and component documentation.]+ CRLF +;
   [				<p>]+ CRLF +;
   []+ CRLF +;
   [				<h5><i class="fa fa-briefcase"></i> <a href="vfps://NOOPENPROJECT/SHOWSTEPBYSTEP">Take a Step by Step Tour</a></h5>]+ CRLF +;
   [				<p>]+ CRLF +;
   [				Take a few minutes and run through the Step By Step guides that shows you how to setup]+ CRLF +;
   [				a new project, add topics, link to other topics, capture and embed images and build your] + CRLF )
Response.Write([				help file.]+ CRLF +;
   [				</p>]+ CRLF +;
   []+ CRLF +;
   []+ CRLF +;
   [				<h5><i class="fa fa-info-circle"></i> <a href="http://www.west-wind.com/wwthreads/default.asp?forum=Html+Help+Builder" target="_wwSupport">Online Support</a></h5>]+ CRLF +;
   [				<p>]+ CRLF +;
   [				Go to our online Message Board and ask a question, submit a bug report, make a suggestion or otherwise]+ CRLF +;
   [				discuss any issues or ideas you have about Help Builder. ]+ CRLF +;
   [				</p>]+ CRLF +;
   [] + CRLF )
Response.Write([	 </div>]+ CRLF +;
   [</body>]+ CRLF +;
   [</html>])
