// CUSTOM TYPST TEMPLATE -------------------------------------------------------

// better way to avoid escape characters, rather than doing a regex for \\@
#let to-string(content) = {
  if content.has("text") {
    content.text
  } else if content.has("children") {
    content.children.map(to-string).join("")
  } else if content.has("body") {
    to-string(content.body)
  } else if content == [ ] {
    " "
  }
}

// Orcid Logo
#let orcid_svg = str(
  "<?xml version=\"1.0\" encoding=\"utf-8\"?>
  <!-- Generator: Adobe Illustrator 19.1.0, SVG Export Plug-In . SVG Version: 6.00 Build 0)  -->
  <svg version=\"1.1\" id=\"Layer_1\" xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" x=\"0px\" y=\"0px\"
    viewBox=\"0 0 256 256\" style=\"enable-background:new 0 0 256 256;\" xml:space=\"preserve\">
  <style type=\"text/css\">
    .st0{fill:#A6CE39;}
    .st1{fill:#FFFFFF;}
  </style>
  <path class=\"st0\" d=\"M256,128c0,70.7-57.3,128-128,128C57.3,256,0,198.7,0,128C0,57.3,57.3,0,128,0C198.7,0,256,57.3,256,128z\"/>
  <g>
    <path class=\"st1\" d=\"M86.3,186.2H70.9V79.1h15.4v48.4V186.2z\"/>
    <path class=\"st1\" d=\"M108.9,79.1h41.6c39.6,0,57,28.3,57,53.6c0,27.5-21.5,53.6-56.8,53.6h-41.8V79.1z M124.3,172.4h24.5
      c34.9,0,42.9-26.5,42.9-39.7c0-21.5-13.7-39.7-43.7-39.7h-23.7V172.4z\"/>
    <path class=\"st1\" d=\"M88.7,56.8c0,5.5-4.5,10.1-10.1,10.1c-5.6,0-10.1-4.6-10.1-10.1c0-5.6,4.5-10.1,10.1-10.1
      C84.2,46.7,88.7,51.3,88.7,56.8z\"/>
  </g>
  </svg>"
)

// Default parameters
#let shifu-article(
  title: none,
  subtitle: none,
  authors: none,
  date: none,
  abstract: none,
  abstract-title: none,
  keywords: none,
  correspondence: none,
  published: none,
  code: none,
  cols: 1,
  margin: (x: 1in, y: 1in),
  paper: "us-letter",
  lang: "en",
  region: none,
  font: (),
  fontsize: 11pt,
  mathfont: "New Computer Modern Math",
  codefont: "DejaVu Sans Mono",
  sectionnumbering: none,
  toc: false,
  block-author: none,
  toc_title: none,
  toc_depth: none,
  toc_indent: 1.5em,
  linestretch: 1,
  linkcolor: "#800000",
  title-page: false,
  author-note: none,
  doc,
) = {
  // Modify the page
  set page(
    paper: paper,
    margin: margin,
    numbering: "1",
  )
  // Modify the paragraphs
  set par(
    justify: true,
    first-line-indent: 1em
    )

  // Modify the text font, equation font, and code font
  set text(
    lang: lang,
    region: region,
    font: font,
    size: fontsize)

  show math.equation: set text(font: mathfont)
  show raw: set text(font: codefont)

 // Modify the figure captions
  show figure.caption: it => [
    #v(-1em)
    #align(left)[
      #block(inset: 1em)[
        #text(weight: "bold")[
          #it.supplement
          #context it.counter.display(it.numbering)#it.separator
        ]
        #it.body
      ]
    ]
  ]

  set heading(numbering: sectionnumbering)

  // Rules for links
  show link: this => {
    if type(this.dest) != label {
        text(this, fill: rgb(linkcolor.replace("\\#", "#")))
    } else {
        text(this, fill: rgb("#0000CC"))
    }
  }

  show ref: this => {
    text(this, fill: rgb("#640872"))
  }

  show cite.where(form: "prose"): this => {
    text(this, fill: rgb("#640872"))
  }

  // Beginning of article
  // Date + Preprint + Code Repsoitory
  if date != none and published != none and code != none {
    align(left)[#block(inset: (bottom: 1em))[
      #text(weight: "bold", size: 0.8em)[#date]
      #h(1em) // Small gap between date and preprint statement
      #text(size: 0.8em)[#published]
      #linebreak()
      #text(size: 0.8em)[#code]
    ]]
  } else if date != none and published != none {
    align(left)[#block(inset: (bottom: 1em))[
      #text(weight: "bold", size: 0.8em)[#date]
      #h(1em) // Small gap between date and preprint statement
      #text(size: 0.8em)[#published]
    ]]
  } else if date != none {
    align(left)[#block(inset: (bottom: 1em))[
      #text(weight: "bold", size: 0.8em)[#date]
    ]]
  }

  // Title
  if title != none {
    v(2cm)
    align(center)[#block(inset: (bottom: 1em))[
        #text(weight: "bold", size: 1.4em)[#title]
    ]]
  }

  // Subtitle
  if subtitle != none{
    align(center)[#block(inset: (bottom: 1em))[
        #text(weight: "bold", size: 1.4em)[#subtitle]
    ]]
  }

  // Author blocks
  if authors != none and block-author != none {
    let count = authors.len()
    let ncols = calc.min(count, 3)
    grid(
      columns: (1fr,) * ncols,
      row-gutter: 1.5em,
      inset: (bottom: 1em),
      ..authors.map(author => align(center, {
        text(weight: "bold", author.name)
        if "corresponding" in author {
            if correspondence != none {
                footnote(correspondence, numbering: "*")
                counter(footnote).update(n => n - 1)
            }
        }
        if "orcid" in author [
            #link("https://orcid.org/" + author.orcid)[
                #box(height: 9pt, image(bytes(orcid_svg)))
                ]
        ]
        set text(size: 0.8em)
        if author.department != none [
            #show ",": linebreak()
            \ #author.department
        ]
        if "email" in author [
            \ #link("mailto:" + to-string(author.email))
        ]
      }))
      )

      // v(20pt, weak: true)
  } else if authors != none {
    align(center, {
      authors.map(author => {
        author.name
        h(1pt)
        super(author.subscript)
        if "corresponding" in author {
            if correspondence != none {
                footnote(correspondence, numbering: "*")
                counter(footnote).update(n => n - 1)
            }
        }
        if "orcid" in author [
            #link("https://orcid.org/" + author.orcid)[
                #box(height: 9pt, image(bytes(orcid_svg)))
                ]
        ]
      }).join(", ", last: " and ")
    })
    align(center, {
      authors.map(author => {
        super(author.subscript)
        h(1pt)
        author.department
      }).join(" \n ")
    })
  }

  // Abstract + Keywords
  if abstract != none {
    block(inset: 2em)[
    #text(weight: "semibold")[Abstract] #h(1em) #abstract
    ]
  }

  if keywords != none {
    v(-3.5em) // Brining the keywords closer to the abstract
    align(left)[#block(inset: 2em)[
      *Keywords*: #keywords.join(" • ")
    ]]
  }

  if toc {
    let title = if toc_title == none {
      auto
    } else {
      toc_title
    }
    block(above: 0em, below: 2em)[
    #outline(
      title: toc_title,
      depth: toc_depth
    );
    ]
  }

  if cols == 1 {
    doc
  } else {
    columns(cols, doc)
  }
}

#set table(
  inset: 6pt,
  stroke: none
)
