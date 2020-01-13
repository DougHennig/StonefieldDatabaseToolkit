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
   [<div class="content-body">])

Response.Write(TRANSFORM( EVALUATE([ oHelp.FormatHTML(oHelp.oTopic.Body) ]) ))

Response.Write([]+ CRLF +;
   [</div>]+ CRLF +;
   [])

 IF !EMPTY(oHelp.oTopic.Remarks) 
Response.Write([]+ CRLF +;
   [<h3 class="outdent">Remarks</h3>]+ CRLF +;
   [])

Response.Write(TRANSFORM( EVALUATE([ oHelp.FormatHTML(oHelp.oTopic.Remarks) ]) ))


 ENDIF 

 if !EMPTY(oHelp.oTopic.SeeAlso) 
Response.Write([]+ CRLF +;
   [<h3 class="outdent">See also</h3>])

Response.Write(TRANSFORM( EVALUATE([ lcSeeAlsoTopics ]) ))


  endif 
