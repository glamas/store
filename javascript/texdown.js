/*
The MIT License (MIT)

Copyright (c) 2018-2020 Susam Pal

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/



(function () {
  'use strict'

  var version = '0.0.1';
  var markdown;
  var tex;

  var texdown = {}
  var options = {}

  var styles = {
    /** Plain white background */
    plain: [
      'body {',
      '  color: #333;',
      '}',
      'main {',
      '  max-width: 40em;',
      '  margin-left: auto;',
      '  margin-right: auto;',
      '}',
      'h1, h2, h3, h4, h5, h6, h7 {',
      '  margin-top: 1.2em;',
      '  margin-bottom: 0.5em;',
      '}',
      'a:link, a:visited {',
      '  color: #03c;',
      '  text-decoration: none;',
      '}',
      'a:hover, a:active {',
      '  color: #03f;',
      '  text-decoration: underline;',
      '}',
      'img {',
      '  max-width: 100%;',
      '}',
      'pre, code, samp, kbd {',
      '  font-family: monospace,monospace;',
      '  font-size: 0.9em;',
      '  color: #009;',
      '}',
      'pre code, pre samp, pre kbd {',
      '  font-size: 1em;',
      '}',
      'pre {',
      '  padding: 0.5em;',
      '  overflow: auto;',
      '  background: #eee;',
      '}',
      'blockquote {',
      '  border-left: medium solid #ccc;',
      '  margin-left: 0;',
      '  margin-right: 0;',
      '  padding: 0.5em;',
      '  background: #eee;',
      '}',
      'blockquote *:first-child {',
      '  margin-top: 0;',
      '}',
      'blockquote *:last-child {',
      '  margin-bottom: 0;',
      '}',
      'table {',
      '  border-collapse: collapse;',
      '}',
      'th, td {',
      '  border: thin solid #999;',
      '  padding: 0.3em 0.4em;',
      '  text-align: left;',
      '}'
    ].join('\n'),

    /** White pane on gray background */
    viewer: [
      '@media screen and (min-width: 40em) {',
      '  body {',
      '    background: #444;',
      '  }',
      '  main {',
      '    background: #fff;',
      '    padding: 5em 6em;',
      '    margin: 1em auto;',
      '    box-shadow: 0.4em 0.4em 0.4em #222;',
      '  }',
      '}'
    ].join('\n'),

    /** No style whatsoever (browser defaults) */
    none: ''
  }
  styles.viewer = styles.plain + styles.viewer

  var setWindowOptions = function () {
    var key
    for (key in options) {
      if (typeof window !== 'undefined' &&
          typeof window.texdown !== 'undefined' &&
          typeof window.texdown[key] !== 'undefined') {
        options[key] = window.texdown[key]
      }
    }
  }

  var loadjs = function (url, callback) {
    var script = window.document.createElement('script')
    script.src = url
    script.onload = callback
    window.document.head.appendChild(script)
  }

  texdown.setDefaultOptions = function () {
    options.renderOnLoad = true
    options.useMathJax = true
    options.protectMath = true
    options.markdownOnly = false
    options.style = 'viewer'

    options.katex = {
      delimiters: [
					{left: '$$', right: '$$', display: true},
					//{left: '$', right: '$', display: false},
					{left: '\\(', right: '\\)', display: false},
					{left: '\\[', right: '\\]', display: true}
				],
				macros: {},
				throwOnError: false
    }
    options.marked = {}

    // Update "Configuration Options" section of README.md if any of the
    // following URLs is updated.
    options.markdownURL =
      'https://cdn.jsdelivr.net/npm/marked/marked.min.js'
    //options.MathJaxURL =
    //  'https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js'
    options.katexURL =
      'https://cdn.jsdelivr.net/npm/katex/dist/katex.min.js'
  }

  texdown.setOption = function (key, val) {
    options[key] = val
  }

  texdown.tokenType = {
    /** Markdown token */
    MARK: 0,

    /** Math token or mask-literal token */
    MASK: 1
  }

  texdown.tokenLiteral = {

    /**
     * Mask literal used to mask math content. All mathematical
     * snippets detected in the content are replaced with this mask
     * literal before performing Markdown rendering on it. This
     * prevents from the Markdown renderer from seeing and
     * processing any math content.
     */
    MASK: '::MASK::'
  }

  var amsRegex = /^\\begin{/;

  var escapeRegex = function escapeRegex(string) {
    return string.replace(/[-/\\^$*+?.()|[\]{}]/g, "\\$&");
  };

  var findEndOfMath = function findEndOfMath(delimiter, text, startIndex) {
    // Adapted from
    // https://github.com/Khan/perseus/blob/master/src/perseus-markdown.jsx
    var index = startIndex;
    var braceLevel = 0;
    var delimLength = delimiter.length;

    while (index < text.length) {
      var character = text[index];

      if (braceLevel <= 0 && text.slice(index, index + delimLength) === delimiter) {
        return index;
      } else if (character === "\\") {
        index++;
      } else if (character === "{") {
        braceLevel++;
      } else if (character === "}") {
        braceLevel--;
      }

      index++;
    }

    return -1;
  };

  /**
   * @returns [ [<mark>, <text>], ...
   *            [<mask>, [<text>, display]], ... ]
   */
  texdown.tokenize = function (text) {
    var delimiters = options.katex.delimiters
    var dollar_escape = delimiters.findIndex(function (delim) {
      return delim.left == "$"
    })
    // ``` ... ``` stay plain text
    // check in 2 situation:
    //    1. start text to first delim.left
    //    2. backquote_plain = 1 and the math part
    var backquote_plain = 0;
    //var regexBackquote = new RegExp("^`{3,}\\s*(\\w*\\b)?\\s*$", "gm")
    var regexBackquote = new RegExp("[^\\\\]`", "g")
    var index
    var data = []
    var regexLeft = new RegExp("(" + delimiters.map(function (x) {
      return escapeRegex(x.left)
    }).join("|") + ")")

    while (true) {
      index = text.search(regexLeft);

      if (index === -1) {
        break;
      }

      if (index > 0) {
        if (dollar_escape !== -1) {
          backquote_plain = (backquote_plain + (text.slice(0, index).match(regexBackquote)||[]).length) % 2;
          if (text[index - 1] === "\\" && text[index] === "$") {
            data.push([texdown.tokenType.MARK, text.slice(0, index - 1) + text[index]])
            text = text.slice(index + 1);
            continue;
          }
        }
        data.push([texdown.tokenType.MARK, dollar_escape !== -1 ? text.slice(0, index) : text.slice(0, index).replace(/\\\$/g, "$")])
        text = text.slice(index);
      }

      var i = delimiters.findIndex(function (delim) {
        return text.startsWith(delim.left);
      });
      index = findEndOfMath(delimiters[i].right, text, delimiters[i].left.length);

      if (index === -1) {
        break;
      }

      var rawData = text.slice(0, index + delimiters[i].right.length);
      if (backquote_plain) {
        backquote_plain = (backquote_plain + (text.slice(0, index).match(regexBackquote)||[]).length) % 2;
        data.push([texdown.tokenType.MARK, dollar_escape !== -1 ? text.slice(0, index) : text.slice(0, index).replace(/\\\$/g, "$")])
        text = text.slice(index);
        continue;
      }
      var math = amsRegex.test(rawData) ? rawData : text.slice(delimiters[i].left.length, index);
      data.push([texdown.tokenType.MASK, [math, delimiters[i].display]])
      text = text.slice(index + delimiters[i].right.length);
    }

    if (text !== "") {
      data.push([texdown.tokenType.MARK, dollar_escape !== -1 ? text : text.replace(/\\\$/g, "$")])
    }

    return data;
  }
  /**
   * @param [ [<mark>, <text>], ...
   *            [<mask>, [<text>, display]], ... ]
   * @returns { text: string, tokenValues: [ [<mask>, [<text>, display]], ...]}
   */
  texdown.mask = function (tokens) {
    var maskedText = []
    var maskedTokenValues = []
    var tokenType
    var tokenValue
    var i

    for (i = 0; i < tokens.length; i++) {
      tokenType = tokens[i][0]
      tokenValue = tokens[i][1]

      if (tokenType === texdown.tokenType.MARK) {
        maskedText.push(tokenValue)
      } else { // if (tokenType === texdown.tokenType.MASK)
        maskedText.push(texdown.tokenLiteral.MASK)
        maskedTokenValues.push(tokenValue)
      }
    }

    return {
      text: maskedText.join(''),
      tokenValues: maskedTokenValues
    }
  }

  /**
   * @param s - A string containing mask-literals.
   * @param { text: string, tokenValues: [ [<mask>, [<text>, display]], ...]}
   * @returns string
   */

  texdown.unmask = function (s, tokens) {
    var re = new RegExp(texdown.tokenLiteral.MASK, 'g')
    var i = 0
    return s.replace(re, function () {
      var math = tokens[i][0]
      var display = tokens[i][1]
      i = i + 1
      var copyOptions = options.katex
      copyOptions.displayMode = display
      return tex.renderToString(math, copyOptions)
    })
  }

  texdown.renderMarkdown = function (s) {
    return markdown(s, options.marked)
  }

  /**
   * @param {string} s - Markdown + LaTeX content.
   * @returns {string} Rendered HTML.
   */
  texdown.renderMarkdownAndKatex = function (s) {
    var tokens = texdown.tokenize(s)
    var masked = texdown.mask(tokens)
    var rendered = texdown.renderMarkdown(masked.text)
    var unmasked = texdown.unmask(rendered, masked.tokenValues)
    return unmasked
  }

  /**
   * Render Markdown and/or LaTeX content into HTML.
   *
   * If the configuration option `protectMath` is `true` (the default),
   * then LaTeX content is protected from Markdown renderer. Otherwise,
   * the entire content is rendered as Markdown.
   */
  texdown.render = function (s) {
    if (options.protectMath) {
      return texdown.protectMathAndRenderMarkdown(s)
    } else {
      return texdown.renderMarkdown(s)
    }
  }

  texdown.renderToString = function(inputText, opt) {
    opt = opt || {}
    var title
    // Set title if it is not specified explicitly.
    if (typeof window.document.title === 'undefined' ||
        window.document.title === '') {
      title = inputText.split('\n', 1)[0].replace(/^\s*#*\s*|\s*#*\s*$/g, '')
      window.document.title = title
    }

    if ("marked" in opt) {
      for (var key in opt["marked"]) {
        options.marked[key] = opt["marked"][key]
      }
    }
    if ("katex" in opt) {
      for (var key in opt["katex"]) {
        options.katex[key] = opt["katex"][key]
      }
    }

    if (("markdownOnly" in opt && opt.markdownOnly) || options.markdownOnly) {
      return texdown.renderMarkdown(inputText)
    } else {
      return texdown.renderMarkdownAndKatex(inputText)
    }
  }

  /**
   * Set up dependencies and set page.
   */
  texdown.main = function () {
    texdown.setDefaultOptions()

    if (typeof window !== 'undefined') {
      setWindowOptions()

      if (window.marked == undefined){
        loadjs(options.markdownURL, function () {
          markdown = window.marked
        })
      } else {
        markdown = window.marked
      }

      if (window.katex == undefined){
        loadjs(options.katexURL, function () {
          tex = window.katex
        })
      } else {
        tex = window.katex
      }

      window.texdown = texdown
    } else {
      markdown = require('marked')
      tex = require("katex")
      module.exports = texdown
    }
  }

  texdown.main()
})()
