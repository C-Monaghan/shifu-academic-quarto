// ============================================================================
// CUSTOM TYPST TEMPLATE
// Author: Cormac Monaghan
// Description: General-purpose Typst template for academic manuscripts
// Supports: multiple authors, optional ORCID, affiliations, correspondence, etc.
// ============================================================================

// Credit to Christopher Kenny's ctk-article
// https://github.com/christopherkenny/ctk-article/blob/main/_extensions/ctk-article/typst-template.typ
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

// Instead of linking to an external ORCID image, we inline the SVG directly.
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

// -----------------------------------------------------------------------------
// Core Function: `shifu-article(...)`
// -----------------------------------------------------------------------------
#let shifu-article(
    // --- Metadata and layout parameters ---
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
  // ---------------------------------------------------------------------------
  // PAGE AND TYPOGRAPHY SETTINGS
  // ---------------------------------------------------------------------------
  // Set up margins, paper size, and page numbering scheme.
  set page(
    paper: paper,
    margin: margin,
    numbering: "1",
  )
  // Paragraph defaults — fully justified text with standard indent.
  set par(
    justify: true,
    first-line-indent: 1em
    )

  // Define global text style: language, font, size, etc.
  set text(
    lang: lang,
    region: region,
    font: font,
    size: fontsize)

  // Special fonts for math and code blocks
  show math.equation: set text(font: mathfont)
  show raw: set text(font: codefont)

  // ---------------------------------------------------------------------------
  // FIGURE CAPTION FORMAT
  // ---------------------------------------------------------------------------
  // Defines how figure/table captions should be displayed.
  // Adds bold numbering and aligns captions to the left margin.
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

  // ---------------------------------------------------------------------------
  // LINK AND REFERENCE COLORS
  // ---------------------------------------------------------------------------
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

  // ---------------------------------------------------------------------------
  // FRONT MATTER: DATE, PREPRINT INFO, CODE REPOSITORY
  // ---------------------------------------------------------------------------
  // Displays date, publication status, and repository link (if provided).
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

  // ---------------------------------------------------------------------------
  // TITLE AND SUBTITLE BLOCKS
  // ---------------------------------------------------------------------------
  if title != none {
    v(2cm)
    align(center)[#block(inset: (bottom: 1em))[
        #text(weight: "bold", size: 1.4em)[#title]
    ]]
  }

  if subtitle != none{
    align(center)[#block(inset: (bottom: 1em))[
        #text(weight: "bold", size: 1.4em)[#subtitle]
    ]]
  }

  // ---------------------------------------------------------------------------
  // AUTHOR BLOCKS
  // ---------------------------------------------------------------------------
  // Two main modes:
  //   (1) `block-author` enabled  → authors printed in a grid (name, dept, email)
  //   (2) `block-author` disabled → inline (common for journal manuscripts)
  if authors != none and block-author != none {
    let count = authors.len()
    let ncols = calc.min(count, 3)
    grid(
      columns: (1fr,) * ncols,
      row-gutter: 1.5em,
      inset: (bottom: 1em),
      ..authors.map(author => align(center, {
        text(weight: "bold", author.name)
        // Corresponding author footnote
        if "corresponding" in author {
            if correspondence != none {
                footnote(correspondence, numbering: "*")
                counter(footnote).update(n => n - 1)
            }
        }
        // Optional ORCID link
        if "orcid" in author [
            #link("https://orcid.org/" + author.orcid)[
                #box(height: 9pt, image(bytes(orcid_svg)))
                ]
        ]
        // Department and email in smaller text
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
      // --- Inline author layout ---
      // Personally I find this useful when there are 4+ authors as the grid
      // system above gets messy
  } else if authors != none {
     // First line: Author names with subscripts + ORCID
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
    // Second line: unique affiliations
    align(center, {
      authors
      .map(author => (author.subscript, author.department))
      .dedup()
      .map(pair => {
        super(pair.at(0))
        h(1pt)
        pair.at(1)
      }).join("\n")
    })
  }

  // ---------------------------------------------------------------------------
  // ABSTRACT AND KEYWORDS
  // ---------------------------------------------------------------------------
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

  // ---------------------------------------------------------------------------
  // TABLE OF CONTENTS (optional)
  // ---------------------------------------------------------------------------
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

  // ---------------------------------------------------------------------------
  // MAIN BODY CONTENT
  // ---------------------------------------------------------------------------
  // Display document body either as a single column or multiple columns.
  if cols == 1 {
    doc
  } else {
    columns(cols, doc)
  }
}

// -----------------------------------------------------------------------------
// GLOBAL TABLE STYLE OVERRIDE
// -----------------------------------------------------------------------------
// Applies to all `table` blocks within the document by default.
// Removes outer borders and adds consistent padding.
#set table(
  inset: 6pt,
  stroke: none
)
