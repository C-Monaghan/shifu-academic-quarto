// What to pull from the YAML file
#show: doc => article(
$if(title)$
  title: [$title$],
$endif$
$if(subtitle)$
  subtitle: [$subtitle$],
$endif$
$if(by-author)$
  authors: (
$for(by-author)$
$if(it.name.literal)$
    ( name: [$it.name.literal$],
      last: [$it.name.family$],
    $for(it.affiliations/first)$
    department: $if(it.name)$[$it.name$]$else$none$endif$,
    $endfor$
    $if(it.email)$
      email: [$it.email$],
    $endif$
    $if(it.orcid)$
      orcid: "$it.orcid$",
    $endif$
    $if(it.attributes.corresponding)$
    corresponding: $it.attributes.corresponding$,
    $endif$
      ),
$endif$
$endfor$
    ),
$endif$
$if(date)$
  date: [$date$],
$endif$
$if(abstract)$
  abstract: [$abstract$],
$endif$
$if(correspondence-prefix)$
  correspondence: [$correspondence-prefix$],
$endif$
$if(keywords)$
  keywords: ($for(keywords)$"$keywords$",$endfor$),
$endif$
$if(published)$
  published: [$published$],
$endif$
$if(code-repo)$
  code: [$code-repo$],
$endif$
$if(margin)$
  margin: ($for(margin/pairs)$$margin.key$: $margin.value$,$endfor$),
$endif$
$if(papersize)$
  paper: "$papersize$",
$endif$
$if(mainfont)$
  font: ($for(mainfont)$"$mainfont$",$endfor$),
$endif$
$if(fontsize)$
  fontsize: $fontsize$,
$endif$
$if(mathfont)$
  mathfont: ($for(mathfont)$"$mathfont$",$endfor$),
$endif$
$if(codefont)$
  codefont: ($for(codefont)$"$codefont$",$endfor$),
$endif$
  sectionnumbering: $if(section-numbering)$"$section-numbering$"$else$none$endif$,
$if(toc)$
  toc: $toc$,
$endif$
$if(toc-title)$
  toc_title: [$toc-title$],
$endif$
$if(toc-indent)$
  toc_indent: $toc-indent$,
$endif$
  toc_depth: $toc-depth$,
  cols: $if(columns)$$columns$$else$1$endif$,
$if(linestretch)$
  linestretch: $linestretch$,
$endif$
$if(linkcolor)$
  linkcolor: "$linkcolor$",
$endif$
$if(title-page)$
  title-page: $title-page$,
$endif$
$if(blind)$
  blind: $blind$,
$endif$
$if(author-note)$
  author-note: "$author-note$",
$endif$
  doc,
)
