LOCAL CRLF
CRLF = CHR(13) + CHR(10)

 IF (!wwScriptIsLayout)
    wwScriptIsLayout = .T.
    wwScriptContentPage = "templates\errorpage.wcs"
    wwScript.RenderAspScript("~/templates/_Layout.wcs")
    RETURN
ENDIF 
Response.Write([]+ CRLF +;
   []+ CRLF +;
   []+ CRLF +;
   [<style>]+ CRLF +;
   [	 header.error-message {]+ CRLF +;
   [		  font-size: 1.1em;]+ CRLF +;
   [		  font-weight: bold;]+ CRLF +;
   [		  margin: 10px 0 25px;]+ CRLF +;
   [		  color:saddlebrown;]+ CRLF +;
   [	 }] + CRLF )
Response.Write([	 .error-detail-table td:first-child {]+ CRLF +;
   [		  font-weight: bold;]+ CRLF +;
   [	 }]+ CRLF +;
   [</style>]+ CRLF +;
   [<header class="content-title">]+ CRLF +;
   [	 <i class="fa fa-warning" style="color: saddlebrown"></i> An Error has occurred processing the Template]+ CRLF +;
   [</header>]+ CRLF +;
   []+ CRLF +;
   [<div class="container">]+ CRLF +;
   [] + CRLF )
Response.Write([	 <header class="error-message">])

Response.Write(TRANSFORM( EVALUATE([ poException.Message ]) ))

Response.Write([</header>]+ CRLF +;
   []+ CRLF +;
   [	 <table class="table table-bordered table-striped error-detail-table">]+ CRLF +;
   [		  <tr>]+ CRLF +;
   [				<td>Template</td>]+ CRLF +;
   [				<td>])

Response.Write(TRANSFORM( EVALUATE([ FORCEEXT(poException.procedure,"wcs") ]) ))

Response.Write([</td>]+ CRLF +;
   [		  </tr>]+ CRLF +;
   [		  <tr>]+ CRLF +;
   [				<td>Code</td>]+ CRLF +;
   [				<td>])

Response.Write(TRANSFORM( EVALUATE([ STRTRAN(STRTRAN(poException.LineContents,"Response.Write(TRANSFORM( EVALUATE([","&lt;%=")," ] + ']' + [) ))"," %&gt;") ]) ))

Response.Write([</td>]+ CRLF +;
   [		  </tr>]+ CRLF +;
   [		  <tr>]+ CRLF +;
   [				<td>Line</td>]+ CRLF +;
   [				<td>])

Response.Write(TRANSFORM( EVALUATE([ poException.LineNo ]) ))

Response.Write([</td>]+ CRLF +;
   [		  </tr>]+ CRLF +;
   [	 </table>]+ CRLF +;
   []+ CRLF +;
   []+ CRLF +;
   [	 <p style="margin-top: 30px;">]+ CRLF +;
   [		  <b>To edit and fix the template:</b>]+ CRLF +;
   [		  <ul>]+ CRLF +;
   [				<li>Select the current topic in the topic list</li>]+ CRLF +;
   [				<li>Right click and select <i>Edit Topic Templates</i></li>] + CRLF )
Response.Write([				<li>Select <i>Edit Topic Template</i></li>]+ CRLF +;
   []+ CRLF +;
   [		  </ul>]+ CRLF +;
   [	 </p>]+ CRLF +;
   []+ CRLF +;
   [	 <blockquote>]+ CRLF +;
   [		  <b><i class="fa fa-info-circle"></i> Note</b> <br />]+ CRLF +;
   [		  The code displayed is the compiled template code and the line number]+ CRLF +;
   [		  is only an approximate location in the template. The line number reflects]+ CRLF +;
   [		  the location in the actual compiled template source code, which can be found] + CRLF )
Response.Write([		  in the the project's]+ CRLF +;
   [		  <code>.\templates\compiled\])

Response.Write(TRANSFORM( EVALUATE([ FORCEEXT(poException.procedure,"prg") ]) ))

Response.Write([</code>]+ CRLF +;
   [		  file.]+ CRLF +;
   [	 </blockquote>]+ CRLF +;
   [</div>])
