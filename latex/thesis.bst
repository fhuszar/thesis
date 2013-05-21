FUNCTION {bye}
{ "BibTeX-style: `thesis 0.1h'        <30-10-96> (wm)" top$
  "German Documentation: `mlbib.dtx'  <30-10-96> (wm)" top$
}

% BibTeX bibliography style `thesis' 
	% version 0.99a for BibTeX versions 0.99a or later, LaTeX version 2.09.
	% Copyright (C) 1991, 1993 all rights reserved.
	% Copying of this file is authorized only if either
	% (1) you make absolutely no changes to your copy, including name, or
	% (2) if you do make changes, you name it something other than
	% btxbst.doc, plain.bst, unsrt.bst, alpha.bst, abbrv.bst,
        % thesis.bst, journal.bst or paper.bst.
	% This restriction helps ensure that all standard styles are identical.

% ACKNOWLEDGEMENT
%   This document is a modified version of `apalike.bst' to which it 
%   owes much of its functionality.

% USAGE
% The file `mlbib.dtx' has the german documentation for this style.

% AUTHOR
%                              ___      
% wenzel matiaske  |           / /_/-Berlin
%                  |  mail:   Technical University Berlin
%                  |          Dept. of Economics, WW6
%                  |          Uhlandstr. 4-5, D-10623 Berlin
%                  |  phone:  +49 30 314-22574
%                  |  email:  mati1831@perform.ww.tu-berlin.de

% HISTORY
%   <0.1a> <15.12.90>      german version, german labels, uppercase titles
%   <0.1b> <03.07.91>      multilingual Version, `bib-labels', `if-titles'
%   <0.1c> <10.10.91>      `bysame'
%   <0.1d> <31.01.93>      `bbl-labels', compatible to `paper.bst', `tpbib.sty'
%   <0.1f> <20.10.94>      format.in.ed.booktitle used in function inbook
%   <0.1g> <08.11.95>      minor fixes 
%   <0.1h> <30.10.96>      updates for mlbib package

% NOTE
%   There are undoubtably bugs in this program.  Should  you make
%   improvements, bug fixes, etc., however, I ask you to send improvements
%   back to me for incorporation into the macro for the rest of us.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ENTRY
  { address
    author
    booktitle
    chapter
    edition
    editor
    howpublished
    institution
    journal
    key
    language            % special
%    month		not used
    note
    number
    organization
    pages
    publisher
    school
    series
    title
    type
    volume
    year
  }
  {}
% extra label ``samextra'' is used for repeating entries of on author.
% extra label ``yearextra'' is used for defining entries like 1991a.
  { label samextra.label yearextra.label sort.label }

INTEGERS { output.state before.all mid.sentence after.sentence after.block }

FUNCTION {init.state.consts}
{ #0 'before.all :=
  #1 'mid.sentence :=
  #2 'after.sentence :=
  #3 'after.block :=
}

STRINGS { s t }

FUNCTION {output.nonnull}
{ 's :=
  output.state mid.sentence =
    { ", " * write$ }
    { output.state after.block =
	{ add.period$ write$
	  newline$
	  "\newblock " write$
	}
	{ output.state before.all =
	    'write$
	    { add.period$ " " * write$ }
	  if$
	}
      if$
      mid.sentence 'output.state :=
    }
  if$
  s
}

FUNCTION {output}
{ duplicate$ empty$
    'pop$
    'output.nonnull
  if$
}

FUNCTION {output.check}
{ 't :=
  duplicate$ empty$
    { pop$ "empty " t * " in " * cite$ * warning$ }
    'output.nonnull
  if$
}

FUNCTION {output.year.check}
{ year empty$
    { "empty year in " cite$ * warning$ }
    { write$
      " \bbllb" year * yearextra.label * "\bblrb" *
      mid.sentence 'output.state :=
    }
  if$
}

FUNCTION {output.bibitem}
{ newline$
  "\bibitem[" write$
  label write$
  "}]{" write$
  cite$ write$
  "}" write$
  newline$
  language empty$
     'skip$
     { "{\bbl" language * write$ newline$ }
  if$
  ""
  before.all 'output.state :=
}

FUNCTION {fin.entry}
{ add.period$
  write$
  newline$
  language empty$
    'skip$
    { "}" write$ newline$ } 
  if$                                 
}

FUNCTION {new.block}
{ output.state before.all =
    'skip$
    { after.block 'output.state := }
  if$
}

FUNCTION {new.sentence}
{ output.state after.block =
    'skip$
    { output.state before.all =
	'skip$
	{ after.sentence 'output.state := }
      if$
    }
  if$
}

FUNCTION {shows}
{ duplicate$ "::::  `" swap$ * "'" * top$
}

FUNCTION {showstack}
{"STACK====================================================================="
top$
stack$
"ENDSTACK=================================================================="
top$
}

FUNCTION {not}
{   { #0 }
    { #1 }
  if$
}

FUNCTION {and}
{   'skip$
    { pop$ #0 }
  if$
}

FUNCTION {or}
{   { pop$ #1 }
    'skip$
  if$
}

FUNCTION {new.block.checkb}
{ empty$
  swap$ empty$
  and
    'skip$
    'new.block
  if$
}

FUNCTION {field.or.null}
{ duplicate$ empty$
    { pop$ "" }
    'skip$
  if$
}

FUNCTION {bbltf}
{ duplicate$ empty$
    { pop$ "" }
    { "{\bbltf " swap$ * "}" * }
  if$
}

FUNCTION {bblvf}
{ duplicate$ empty$
    { pop$ "" }
    { "{\bblvf " swap$ * "}" * }
  if$
}

FUNCTION {bblquote}
{ duplicate$ empty$
    { pop$ "" }
    { "\bbllqq" swap$ * "\bblrqq" * }
  if$
}

INTEGERS { nameptr namesleft numnames }

FUNCTION {format.names}
{ 's :=
  #1 'nameptr :=
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 > }
     { nameptr #1 =
     { s nameptr "{ll}{, ff}{~vv}{, jj}" format.name$ 't := }
     { s nameptr "{ff~}{vv~}{ll}{, jj}" format.name$ 't := }
     if$
     nameptr #1 >
	{ namesleft #1 >
	    { ", " * t * }
	    { numnames #2 >
		{ "" * }
		'skip$
	      if$
	      t "others" =
		{ "{\bblnf et~al.}" * }
		{ "{\bblnf \bbland}" * t * }
	      if$
	    }
	  if$
        }
       't
      if$
      nameptr #1 + 'nameptr :=
      namesleft #1 - 'namesleft :=
    }
  while$
}

FUNCTION {format.in.names}
{ 's :=
  #1 'nameptr :=
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 > }
    { s nameptr "{ff~}{vv~}{ll}{, jj}" format.name$ 't :=
      nameptr #1 >
	{ namesleft #1 >
	    { ", " * t * }
	    { numnames #2 >
		{ "" * }
		'skip$
	      if$
	      t "others" =
		{ "{\bblnf et~al.}" * }
		{ "{\bblnf \bbland}" * t * }
	      if$
	    }
	  if$
	}
	't
      if$
      nameptr #1 + 'nameptr :=
      namesleft #1 - 'namesleft :=
    }
  while$
}

FUNCTION {format.authors}
{ author empty$
    { "" }
    { samextra.label "\bysame" =
   	 {"\bysame"}
         { "{\bblnf " * author format.names * "}" }
	if$
    }
  if$
}

FUNCTION {format.key}
{ empty$
    { key field.or.null }
    { "" }
  if$
}

FUNCTION {format.editors}
{ editor empty$
    { "" }
    { samextra.label "\bysame" =
       {"\bysame"}
       { "{\bblnf " * editor format.names * "}" }
      if$
      editor num.names$ #1 >
        { ", \bbleds{} " * }
        { ", \bbled{} " * }
      if$
    }
  if$
}

FUNCTION {format.in.editors}
{ editor empty$
    { "" }
    { "{\bblnf " * editor format.in.names * "}"
      editor num.names$ #1 >
	{ ", \bbleds" * }
	{ ", \bbled" * }
      if$
    }
  if$
}

FUNCTION {format.title}
{ title empty$
     { "" }
     { language empty$                                      % default english 
       { "\bbllq " title "t" change.case$ * "\bblrq" * }    % language empty, then lower case
       { language "english" =                               % non empty, equal english
	  { "\bbllq " title "t" change.case$ * "\bblrq" * } % then lower case,
	  { "\bbllq " title * "\bblrq" * }                  % else title
         if$                             
         }                              
       if$
     }
   if$
}

FUNCTION {n.dashify}
{ 't :=
  ""
    { t empty$ not }
    { t #1 #1 substring$ "-" =
	{ t #1 #2 substring$ "--" = not
	    { "--" *
	      t #2 global.max$ substring$ 't :=
	    }
	    {   { t #1 #1 substring$ "-" = }
		{ "-" *
		  t #2 global.max$ substring$ 't :=
		}
	      while$
	    }
	  if$
	}
	{ t #1 #1 substring$ *
	  t #2 global.max$ substring$ 't :=
	}
      if$
    }
  while$
}

FUNCTION {format.btitle}
{ title bbltf
}

FUNCTION {tie.or.space.connect}
{ duplicate$ text.length$ #3 <
    { "~" }
    { " " }
  if$
  swap$ * *
}

FUNCTION {either.or.check}
{ empty$
    'pop$
    { "can't use both " swap$ * " fields in " * cite$ * warning$ }
  if$
}

FUNCTION {format.bvolume}
{ volume empty$
    { "" }
    { series empty$
	'skip$
	{ ", " * series bbltf * }
      if$
      "\bblvol~" volume *
      "volume and number" number either.or.check
    }
  if$
}


FUNCTION {format.number.series}
{ volume empty$
    { number empty$
	{ series field.or.null }
	{ output.state mid.sentence =
	    { "\bblno~" }
	    { "\bblNo~" }
	  if$
	  number *
	  series empty$
	    { "there's a number but no series in " cite$ * warning$ }
	    { ", in " * series * }
	  if$
	}
      if$
    }
    { "" }
  if$
}

FUNCTION {format.edition}
{ edition empty$
    { "" }
    { output.state mid.sentence =
	{ edition "l" change.case$ " \bbledit" * }
	{ edition "t" change.case$ " \bbledit" * }
      if$
    }
  if$
}

INTEGERS { multiresult }

FUNCTION {multi.page.check}
{ 't :=
  #0 'multiresult :=
    { multiresult not
      t empty$ not
      and
    }
    { t #1 #1 substring$
      duplicate$ "-" =
      swap$ duplicate$ "," =
      swap$ "+" =
      or or
	{ #1 'multiresult := }
	{ t #2 global.max$ substring$ 't := }
      if$
    }
  while$
  multiresult
}

FUNCTION {format.pages}
{ pages empty$
    { "" }
    { pages multi.page.check
	{ "\bblpp~" pages n.dashify * }
	{ "\bblp~" pages * }
      if$
    }
  if$
}

FUNCTION {format.journal.vol}
{ journal empty$
    { "empty journal name in " cite$ * warning$
      "" }
    { journal bbltf
      volume empty$
        'skip$
        { ", " * volume bblvf * }
      if$
    }
  if$
}

FUNCTION {format.number}
{ volume empty$
  { number empty$
    { "empty volume and number in " cite$ * warning$ 
     "" }
    { "\bblno~" number * }
  if$
  }
  { "" }
 if$
}

FUNCTION {format.chapter.pages}
{ chapter empty$
    'format.pages
    { type empty$
	{ "\bblchap\" }
	{ type }
      if$
      chapter tie.or.space.connect
      pages empty$
	'skip$
	{ ", " * format.pages * }
      if$
    }
  if$
}

FUNCTION {format.in.ed.booktitle}
{ booktitle empty$
    { "" }
    { editor empty$
	{ "In " booktitle bbltf * }
	{ "In " format.in.editors * ", " * booktitle bbltf * }
      if$
    }
  if$
}

FUNCTION {format.thesis.type}
{ type empty$
    'skip$
    { pop$
      type "t" change.case$
    }
  if$
}

FUNCTION {format.tr.number}
{ type empty$
    { "\bbltrep " }
    'type
  if$
  number empty$
    { "t" change.case$ }
    { ", \bblno" * number tie.or.space.connect }
  if$
}

FUNCTION {format.article.crossref}
{ "In"
  " \citeasnoun{" * crossref * "}" *
}

FUNCTION {format.book.crossref}
{ "In "
  "\citeasnoun{" * crossref * "}" *
  volume empty$ 
   { "empty volume in " cite$ * "'s crossref of " * crossref * warning$
   }
    { ", \bblvol~" * volume * 
    }
  if$
}

FUNCTION {format.incoll.inproc.crossref}
{ "In"
  " \citeasnoun{" * crossref * "}" *
}

FUNCTION {format.addr.pub}
{ publisher empty$
    { address empty$
	{ "" }
	{ address }
      if$
    }
    { address empty$
	'publisher
	{ address ": " * publisher * }
      if$
    }
  if$
}

FUNCTION {article}
{ output.bibitem
  format.authors "author" output.check
  author format.key output
  output.year.check
  new.block
  format.title "title" output.check
  new.block
  crossref missing$
    { format.journal.vol "volume and number" output.check
      format.number output
      format.pages "pages" output.check
    }
    { format.article.crossref output.nonnull
      format.pages output
    }
  if$
  new.block
  note output
  fin.entry
}

FUNCTION {book}
{ output.bibitem
  author empty$
    { format.editors "author and editor" output.check
      editor format.key output
    }
    { format.authors output.nonnull
      crossref missing$
	{ "author and editor" editor either.or.check }
	'skip$
      if$
    }
  if$
  output.year.check
  new.block
  format.btitle "title" output.check
  crossref missing$
    { format.bvolume output      
      new.block
      format.number.series output
      new.sentence
      format.edition output
      format.addr.pub "address and publisher" output.check
    }
    { new.block
      format.book.crossref output.nonnull
    }
  if$
  new.block
  note output
  fin.entry
}

FUNCTION {booklet}
{ output.bibitem
  format.authors output
  author format.key output
  output.year.check
  new.block
  format.title "title" output.check
  new.block
  howpublished output
  address "address" output.check
  new.block
  note output
  fin.entry
}

FUNCTION {inbook}
{ output.bibitem
  author empty$
    { format.editors "author and editor" output.check
      editor format.key output
    }
    { format.authors output.nonnull
      crossref missing$
	{ "author and editor" editor either.or.check }
	'skip$
      if$
    }
  if$
  output.year.check
  new.block
  format.title "title" output.check
  new.block
  crossref missing$
    { format.in.ed.booktitle output
      format.number.series output
      format.bvolume output
      format.chapter.pages output
      new.sentence
      format.edition output
      format.addr.pub "address and publisher" output.check
    }
    { new.block
      format.incoll.inproc.crossref output.nonnull
      format.bvolume output
      format.chapter.pages output
    }
  if$
  new.block
  note output
  fin.entry
}

FUNCTION {incollection}
{ output.bibitem
  format.authors "author" output.check
  author format.key output
  output.year.check
  new.block
  format.title "title" output.check
  new.block
  crossref missing$
    { format.in.ed.booktitle "booktitle" output.check
      format.bvolume output
      format.number.series output
      format.chapter.pages output
      new.sentence
      format.edition output
      format.addr.pub "address and publisher" output.check
    }
    { format.incoll.inproc.crossref output.nonnull
      format.bvolume output
      format.chapter.pages output
    }
  if$
  new.block
  note output
  fin.entry
}

FUNCTION {inproceedings}
{ output.bibitem
  format.authors "author" output.check
  author format.key output
  output.year.check
  new.block
  format.title "title" output.check
  new.block
  crossref missing$
    { format.in.ed.booktitle "booktitle" output.check
      format.bvolume output
      format.number.series output
      format.pages output
      address "address" output.check
      new.sentence
      organization output
      publisher output
    }
    { format.incoll.inproc.crossref output.nonnull
      format.pages output
    }
  if$
  new.block
  note output
  fin.entry
}

FUNCTION {conference} { inproceedings }

FUNCTION {manual}
{ output.bibitem
  format.authors output
  author format.key output
  output.year.check
  new.block
  format.btitle "title" output.check
  organization address new.block.checkb
  organization output
  format.edition output
  address output
  new.block
  note output
  fin.entry
}

FUNCTION {mastersthesis}
{ output.bibitem
  format.authors "author" output.check
  author format.key output
  output.year.check
  new.block
  format.title "title" output.check
  new.block
  "\bblmth" format.thesis.type output.nonnull
  school "school" output.check
  address output
  new.block
  note output
  fin.entry
}

FUNCTION {misc}
{ output.bibitem
  format.authors output
  author format.key output
  output.year.check
  new.block
  format.title output
  new.block
  howpublished output
  new.block
  note output
  fin.entry
}

FUNCTION {phdthesis}
{ output.bibitem
  format.authors "author" output.check
  author format.key output
  output.year.check
  new.block
  format.btitle "title" output.check
  new.block
  "\bblphd" format.thesis.type output.nonnull
  school "school" output.check
  address output
  new.block
  note output
  fin.entry
}

FUNCTION {proceedings}
{ output.bibitem
  format.editors output
  editor format.key output
  output.year.check
  new.block
  format.btitle "title" output.check
  format.bvolume output
  format.number.series output
  new.sentence
  organization output
  address output
  publisher output
  new.block
  note output
  fin.entry
}

FUNCTION {techreport}
{ output.bibitem
  format.authors "author" output.check
  author format.key output
  output.year.check
  new.block
  format.title "title" output.check
  new.block
  format.tr.number output.nonnull
  institution "institution" output.check
  address output
  new.block
  note output
  fin.entry
}

FUNCTION {unpublished}
{ output.bibitem
  format.authors "author" output.check
  author format.key output
  output.year.check
  new.block
  format.title "title" output.check
  new.block
  note "note" output.check
  fin.entry
}

FUNCTION {default.type} { misc }
MACRO {jan} {"January"}

MACRO {feb} {"February"}

MACRO {mar} {"March"}

MACRO {apr} {"April"}

MACRO {may} {"May"}

MACRO {jun} {"June"}

MACRO {jul} {"July"}

MACRO {aug} {"August"}

MACRO {sep} {"September"}

MACRO {oct} {"October"}

MACRO {nov} {"November"}

MACRO {dec} {"December"}

MACRO {acmcs} {"ACM Computing Surveys"}

MACRO {acta} {"Acta Informatica"}

MACRO {cacm} {"Communications of the ACM"}

MACRO {ibmjrd} {"IBM Journal of Research and Development"}

MACRO {ibmsj} {"IBM Systems Journal"}

MACRO {ieeese} {"IEEE Transactions on Software Engineering"}

MACRO {ieeetc} {"IEEE Transactions on Computers"}

MACRO {ieeetcad}
 {"IEEE Transactions on Computer-Aided Design of Integrated Circuits"}

MACRO {ipl} {"Information Processing Letters"}

MACRO {jacm} {"Journal of the ACM"}

MACRO {jcss} {"Journal of Computer and System Sciences"}

MACRO {scp} {"Science of Computer Programming"}

MACRO {sicomp} {"SIAM Journal on Computing"}

MACRO {tocs} {"ACM Transactions on Computer Systems"}

MACRO {tods} {"ACM Transactions on Database Systems"}

MACRO {tog} {"ACM Transactions on Graphics"}

MACRO {toms} {"ACM Transactions on Mathematical Software"}

MACRO {toois} {"ACM Transactions on Office Information Systems"}

MACRO {toplas} {"ACM Transactions on Programming Languages and Systems"}

MACRO {tcs} {"Theoretical Computer Science"}

READ

FUNCTION {sortify}
{ purify$
  "l" change.case$
}

INTEGERS { len }

FUNCTION {chop.word}
{ 's :=
  'len :=
  s #1 len substring$ =
    { s len #1 + global.max$ substring$ }
    's
  if$
}

FUNCTION {format.lab.names}
{ 's :=
  s #1 "{f.~}{vv~}{ll}{, jj}" format.name$
  s num.names$ duplicate$
  #2 >
    { pop$ " \textnormal{et~al.} " * }
    { #2 <
	'skip$
	{ s #2 "{f.~}{vv~}{ll}{, jj}" format.name$ "others" =
	    { " \textnormal{et~al.}" * }
	    { "\textnormal{\bbland}" * s #2 "{f.~}{vv~}{ll}{, jj}" format.name$ * }
	  if$
	}       % three possibilities: F. Last
      if$       %                      F. Last and F. Last
    }           %                      F. et al.
  if$
}

FUNCTION {author.key.label}
{ author empty$
    { key empty$
	{ cite$ #1 #3 substring$ }
	'key
      if$
    }
    { author format.lab.names }
  if$
}

FUNCTION {author.editor.key.label}
{ author empty$
    { editor empty$
	{ key empty$
	    { cite$ #1 #3 substring$ }
	    'key
	  if$
	}
	{ editor format.lab.names }
      if$
    }
    { author format.lab.names }
  if$
}

FUNCTION {editor.key.label}
{ editor empty$
    { key empty$
	{ cite$ #1 #3 substring$ }
	'key
      if$
    }
    { editor format.lab.names }
  if$
}

FUNCTION {calc.label}
{ type$ "book" =
  type$ "inbook" =
  or
    'author.editor.key.label
    { type$ "proceedings" =
	'editor.key.label
	'author.key.label
      if$
    }
  if$
  "\protect\citeauthoryear{" swap$ * "}{" *
  year field.or.null purify$ #-1 #4 substring$
  *
  'label :=
}

FUNCTION {sort.format.names}
{ 's :=
  #1 'nameptr :=
  ""
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 > }
    { nameptr #1 >
	{ "   " * }
	'skip$
      if$
      s nameptr "{ll{ }}{  f{ }}{  vv{ }}{  jj{ }}" format.name$ 't :=
      nameptr numnames = t "others" = and
	{ "et al" * }
	{ t sortify * }
      if$
      nameptr #1 + 'nameptr :=
      namesleft #1 - 'namesleft :=
    }
  while$
}

FUNCTION {sort.format.title}
{ 't :=
  "A " #2
    "An " #3
      "The " #4 t chop.word
    chop.word
  chop.word
  sortify
  #1 global.max$ substring$
}

FUNCTION {author.sort}
{ author empty$
    { key empty$
	{ "to sort, need author or key in " cite$ * warning$
	  ""
	}
	{ key sortify }
      if$
    }
    { author sort.format.names }
  if$
}

FUNCTION {author.editor.sort}
{ author empty$
    { editor empty$
	{ key empty$
	    { "to sort, need author, editor, or key in " cite$ * warning$
	      ""
	    }
	    { key sortify }
	  if$
	}
	{ editor sort.format.names }
      if$
    }
    { author sort.format.names }
  if$
}

FUNCTION {editor.sort}
{ editor empty$
    { key empty$
	{ "to sort, need editor or key in " cite$ * warning$
	  ""
	}
	{ key sortify }
      if$
    }
    { editor sort.format.names }
  if$
}

FUNCTION {presort}
{ calc.label
  label sortify
  "    "
  *
  type$ "book" =
  type$ "inbook" =
  or
    'author.editor.sort
    { type$ "proceedings" =
	'editor.sort
	'author.sort
      if$
    }
  if$
  #1 entry.max$ substring$
  'sort.label :=
  sort.label
  *
  "    "
  *
  title field.or.null
  sort.format.title
  *
  #1 entry.max$ substring$
  'sort.key$ :=
}

ITERATE {presort}

SORT

STRINGS { last.label next.extra prev.author prev.editor }

INTEGERS { last.extra.num }

FUNCTION {initialize.extra.label.stuff}
{ #0 int.to.chr$ 'last.label :=
  "" 'next.extra :=
  #0 'last.extra.num :=
  "abcxyz" 'prev.author :=
}

FUNCTION {forward.pass}
{ last.label label =
    { last.extra.num #1 + 'last.extra.num :=
      last.extra.num int.to.chr$ 'yearextra.label :=
    }
    { "a" chr.to.int$ 'last.extra.num :=
      "" 'yearextra.label :=
      label 'last.label :=
    }
  if$
  author empty$
    { editor empty$
      'skip$
        { editor prev.editor =
          editor prev.author =
          or
         { "\bysame" 'samextra.label := }
         { "" 'samextra.label :=
          editor 'prev.editor :=
         }
        if$
        }
     if$
     }
     { author prev.author =
       author prev.editor =
       or
       { "\bysame" 'samextra.label := }
       { "" 'samextra.label :=
         author 'prev.author :=
       }
      if$
     }
  if$
}

FUNCTION {reverse.pass}
{ next.extra "b" =
    { "a" 'yearextra.label := }
    'skip$
  if$
  label yearextra.label * 'label :=
  yearextra.label 'next.extra :=
}

EXECUTE {initialize.extra.label.stuff}

ITERATE {forward.pass}

REVERSE {reverse.pass}

FUNCTION {bib.sort.order}
{ sort.label
  "    "
  *
  year field.or.null sortify
  *
  "    "
  *
  title field.or.null
  sort.format.title
  *
  #1 entry.max$ substring$
  'sort.key$ :=
}

ITERATE {bib.sort.order}

SORT

FUNCTION {begin.bib}
{ preamble$ empty$
    'skip$
    { preamble$ write$ newline$ }
  if$
  "\begin{thebibliography}{} \bblsize" write$ newline$	
  "\ifx\undefined\bysame" write$ newline$
  "\newcommand{\bysame}{\leavevmode\hbox to3em{\hrulefill}\ }"
    write$ newline$
  "\fi" write$ newline$
}

EXECUTE {begin.bib}

EXECUTE {init.state.consts}

ITERATE {call.type$}

FUNCTION {end.bib}
{ newline$
  "\end{thebibliography}" write$ newline$
}

EXECUTE {end.bib}

EXECUTE {bye}
