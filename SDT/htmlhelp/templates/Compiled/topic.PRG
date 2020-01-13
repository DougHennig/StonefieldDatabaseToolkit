LOCAL CRLF
CRLF = CHR(13) + CHR(10)

 IF (!wwScriptIsLayout)
    wwScriptIsLayout = .T.
    wwScript.RenderAspScript("~/templates/_Layout.wcs")
    RETURN
ENDIF 
Response.Write([]+ CRLF +;
   []+ CRLF +;
   []+ CRLF +;
   [<h1 class="content-title">]+ CRLF +;
   [	 <img src="bmp/])

Response.Write(TRANSFORM( EVALUATE([ TRIM(LOWER(oHelp.oTopic.Type))]) ))

Response.Write([.png">]+ CRLF +;
   [])

Response.Write(TRANSFORM( EVALUATE([ iif(oHelp.oTopic.Static,[<img src="bmp/static.png" />] + ']' + [,[] + ']' + [) ]) ))


Response.Write(TRANSFORM( EVALUATE([ EncodeHtml(TRIM(oHelp.oTopic.Topic)) ]) ))

Response.Write([]+ CRLF +;
   [</h1>]+ CRLF +;
   []+ CRLF +;
   [<div id="TimeToRead"></div>]+ CRLF +;
   []+ CRLF +;
   [<div class="content-body" id="body">])

Response.Write(TRANSFORM( EVALUATE([ oHelp.FormatHTML(oHelp.oTopic.Body) ]) ))

Response.Write([]+ CRLF +;
   [</div>]+ CRLF +;
   [])

 IF !EMPTY(oHelp.oTopic.Remarks) 
Response.Write([]+ CRLF +;
   [<h3 class="outdent" id="remarks">Remarks</h3>]+ CRLF +;
   [<blockquote>		  ])

Response.Write(TRANSFORM( EVALUATE([ oHelp.FormatHTML(oHelp.oTopic.Remarks) ]) ))

Response.Write([]+ CRLF +;
   [</blockquote>])

 ENDIF 

 IF !EMPTY(oHelp.oTopic.Example) 
Response.Write([]+ CRLF +;
   [<h3 class="outdent" id="example">Example</h3>])

Response.Write(TRANSFORM( EVALUATE([ oHelp.FormatExample(oHelp.oTopic.Example)]) ))


 ENDIF 

 if !EMPTY(oHelp.oTopic.SeeAlso) 
Response.Write([]+ CRLF +;
   [<h3 class="outdent" id="seealso">See also</h3>])

Response.Write(TRANSFORM( EVALUATE([ lcSeeAlsoTopics ]) ))


  endif 
