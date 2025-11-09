

<!-- README.md is generated from README.qmd. Please edit that file -->

# Shifu Quarto templates

> Shīfù (師傅): Chinese; n. [expert
> instructor](https://en.wikipedia.org/wiki/Shifu) or
> [father/teacher](https://en.wikipedia.org/wiki/Shifu)

------------------------------------------------------------------------

For a while, I’ve been using [Andrew
Heiss’](https://www.andrewheiss.com/) excellent custom LaTeX templates,
[hikmah](https://github.com/andrewheiss/hikmah-academic-quarto/tree/main),
which themselves build on [Kieran Healy’s
template](https://github.com/kjhealy/latex-custom-kjh). While I’ve
really enjoyed working with those, I wanted to create my own version -
one that reflects my personal style and takes advantage of new tools.

Recently, I’ve been learning [Typst](https://typst.app/docs/), and this
project represents a reimplementation of the Hikmah-style academic
template using Typst. I owe particular thanks to [Christopher
Kenny](https://github.com/christopherkenny) and his excellent
[ctk-article](https://github.com/christopherkenny/ctk-article) template,
which helped me understand Typst’s file structure and how to pull
metadata from YAML into Typst dynamically.

The result is **Shifu**, a modern Typst-based academic manuscript
template that blends aspects of Andrew Heiss’ *hikmah* and
*hikmah-manuscript* variants, with additional refinements and
customizations planned for future releases.

------------------------------------------------------------------------

## Layout Options

Shifu currently supports two layout modes for author formatting:

- **Default (block-author = true)** Authors are displayed in a grid
  layout (up to 3 columns).
  - Similar to the original *hikmah* template.
  - *Use this for manuscripts with a small number of authors.*
- **Inline (block-author = false)** Authors are listed on a single line,
  followed by their affiliations below
  - More typical of journal-style layouts.
  - *Recommended when you have 4 or more authors.*

------------------------------------------------------------------------

## Installation

To install the templates in your Quarto project, run:

``` bash
quarto add C-Monaghan/shifu-academic-quarto
```

After installation, you can reference the template in your YAML header:

``` yaml
format:
  shifu-typst: default
```

or

``` yaml
format:
  shifu-typst:
    block-author: false
```

## Shifu Typst (default)

![](https://github.com/C-Monaghan/shifu-academic-quarto/blob/main/pdf-examples/thumbnails/shifu-default-pdf.png)

## Shifu Tyspt (block-author = false)

![](https://github.com/C-Monaghan/shifu-academic-quarto/blob/main/pdf-examples/thumbnails/shifu-custom-pdf.png)

## Acknowledgements

This project draws inspiration from the following excellent works:

- [Andrew Heiss](https://www.andrewheiss.com/)
- [Christopher Kenny](https://github.com/christopherkenny)
