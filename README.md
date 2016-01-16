# Ankitex

[Anki](http://ankisrs.net/) is a flashcard software that uses [spaced repetition](https://en.wikipedia.org/wiki/Spaced_repetition).
I like Anki because it supports [LaTeX](http://www.latex-project.org/), which makes it easy to make flashcards with math formulas, definitions, and theorems that you want to remember.
Anki also has a nice Android application that lets me study on the go!
This repository contains some simple functions and scripts for transforming specifically-structured LaTeX files into flashcards that can be imported into Anki.

While you could just type LaTeX into the Anki GUI, I've found that in doing so I lose some valuable parts of my usual LaTeX workflow such as 
working in my favorite text editor, 
visually verifying the LaTeX markup by producing pdf files, and 
retaining an alternative reference point for quick lookups of a theorem I'm thinking about (the TeX file that is the input to this program).

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

Unforunately, LaTeX is too flexible to easily infer which content should be used for the front of a flashcard. 
In fact, that content may not even be present in the file. 
For instance, if you are using the popular *\\theorem* environment provided with the *amsmath* package, the theorem will be automatically numbered when the document is created, but perhaps you would have liked that theorem number as the front of a flashcard.
Use of the *amsmath* *\\theorem* environment also does not require you to provide a title for theorems, but such titles are almost required for the front of a flashcard!
So, the code in this repository assumes some imposed structure on your LaTeX files to be able to parse flashcards.
In particular, the default parser that I have provided assumes that LaTeX content is organized like this:

```
\theorem{theorem-title}{
  theorem-text
  ...
}
```

such as in the example:


```
\theorem{Definition 1.2.1 Sigma Algebra}{
A collection of subsets of $S$ is called a \emph{sigma algebra} (or \emph{Borel field}) denoted by $\mathcal{B}$, if it satisifes the following three properties:
\begin{enumerate}
\item $\emptyset \in \mathcal{B}$
\item If $A \in \mathcal{B}$, then $A^c \in \mathcal{B}$
\item If $A_1, A_2 \ldots \in \mathcal{B}$, then $\cup_{i=1}^{\infty} \in \mathcal{B}$
\end{enumerate}
}
```

because this is how I organize my notes.
Other parsers may be provided by overriding Ankitex::Parser.
