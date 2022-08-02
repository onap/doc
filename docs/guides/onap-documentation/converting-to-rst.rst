.. This work is licensed under a Creative Commons Attribution 4.0
.. International License. http://creativecommons.org/licenses/by/4.0
.. Copyright 2017 AT&T Intellectual Property.  All rights reserved.

.. _converting-to-rst:

Converting to RST
=================

RST format is used for documentation. Other file formats can be converted to
RST with pandoc.

.. caution::

  Always check the output text after conversion. For the most common errors,
  see section Fixing the converted document.

Installing pandoc
-----------------

Pandoc is a powerful document-transformation utility. We'll use it to
do simple conversions, but it is capable of much more. Visit
the `pandoc website <http://pandoc.org/installing.html>`_ for
installation instructions for your platform.

Converting
----------

Using a terminal, navigate to the directory containing the documents
you wish to convert. Next, issue the following command for each file
you'd like to convert:

:code:`pandoc -s --toc -f <from format> -t rst myfile.<from format>`

:code:`-s` tells pandoc to produce a standalone document

:code:`--toc` tells pandoc to produce a table of contents (optional)

:code:`-t` tells pandoc to produce reStructuredText output

:code:`-f` tells pandoc the input format. It should be one of the following:

+--------------------+----------------------------------------------------+
| Format             | Description                                        |
+====================+====================================================+
|commonmark          | Markdown variant                                   |
+--------------------+----------------------------------------------------+
|docbook             | XML-based markup                                   |
+--------------------+----------------------------------------------------+
|docx                | Microsoft Word                                     |
+--------------------+----------------------------------------------------+
|epub                | Ebook format                                       |
+--------------------+----------------------------------------------------+
|haddock             | Doc format produced by tool used on Haskell code   |
+--------------------+----------------------------------------------------+
|html                | HTML                                               |
+--------------------+----------------------------------------------------+
|json                | JSON pandoc AST                                    |
+--------------------+----------------------------------------------------+
|latex               | Older typesetting syntax                           |
+--------------------+----------------------------------------------------+
|markdown            | Simple formatting syntax meant to produce HTML     |
+--------------------+----------------------------------------------------+
|markdown_github     | Github flavored markdown                           |
+--------------------+----------------------------------------------------+
|markdown_mmd        | Multi-markdown flavored markdown                   |
+--------------------+----------------------------------------------------+
|markdown_phpextra   | PHP flavored markdown                              |
+--------------------+----------------------------------------------------+
|markdown_strict     | Markdown with no added pandoc features             |
+--------------------+----------------------------------------------------+
|mediawiki           | Popular wiki language                              |
+--------------------+----------------------------------------------------+
|native              | Pandoc native Haskell                              |
+--------------------+----------------------------------------------------+
|odt                 | Open document text (used by LibreOffice)           |
+--------------------+----------------------------------------------------+
|opml                | Outline processor markup language                  |
+--------------------+----------------------------------------------------+
|org                 | Org mode for Emacs                                 |
+--------------------+----------------------------------------------------+
|rst                 | reStructuredText                                   |
+--------------------+----------------------------------------------------+
|t2t                 | Wiki-like formatting syntax                        |
+--------------------+----------------------------------------------------+
|textile             | A formatting syntax similar to RST and markdown    |
+--------------------+----------------------------------------------------+
|twiki               | Popular wiki formatting syntax                     |
+--------------------+----------------------------------------------------+

Fixing the converted document
-----------------------------

How much you'll need to fix the converted document depends on which file
format you're converting from. Here are a couple of things to watch out
for:

1. Multi-line titles need to be converted to single line
2. Standalone "**" characters
3. :code:`***bolded***` should be :code:`**bolded**`
4. Mangled tables

Previewing edits
----------------

Web-based
~~~~~~~~~

`Online Sphinx editor <https://livesphinx.herokuapp.com/>`_ is a RST previewing
tool.
