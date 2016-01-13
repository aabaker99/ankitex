# Anki

[Anki](http://ankisrs.net/) is a flashcard software that uses [spaced repetition](https://en.wikipedia.org/wiki/Spaced_repetition).
I like Anki because it supports LaTeX, which makes it easy to make flashcards with math formulas, definitions, and theorems that you want to remember.
Anki also has a nice Android application that lets me study on the go!
This repository contains some simple functions and scripts for transforming specifically-structured LaTeX files into flashcards that can be imported into Anki.

While you could just type LaTeX into the Anki GUI, I've found that in doing so I lose some valuable parts of my usual LaTeX workflow such as working in my favorite text editor, visually verifying the LaTeX markup by producing pdf files, and retaining an alternative reference point for quick lookups of a theorem I'm thinking about (the TeX file that is the input to this program).

## Usage

The *ankitex* command displays the following help text:

```
NAME
        ankitex - transform LaTeX documents into Anki flashcards.

SYNOPSIS
        ankitex [-o <output_file>] <latex_files...>

OPTIONS
        --help, -h      Display this help
        --output, -o    File to write Anki flashcards to; defaults to flashcards.anki.txt
```

The output file may be imported to Anki via the *File -> Import* menu. The output is semicolon delimited: be sure to mark it as such in the input dialog.

## Note about TeX files

Coming soon.
