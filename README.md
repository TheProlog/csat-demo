# Content Selection Automated Testing Demo

If you're a battle-scarred veteran developer, you *should* be accustomed to behaviour-driven development (BDD) by now. (If you're the latest [FNG](http://www.urbandictionary.com/define.php?term=F.N.G.) to join our community, *welcome!* It's never too early to start good development habits.) In most languages, in most situations, there's at least one obvious way to specify, implement and verify whatever detail of whatever feature you're working on. [Almost always](http://answers.yahoo.com/question/index?qid=20071204175638AAz56c9).

But how do you properly BDD a UI feature that depends on the user selecting displayed content with the mouse? As far as I could tell in several research attempts, [Selenium](http://www.seleniumhq.org/) gives no help. Neither does [Capybara](http://jnicklas.github.io/capybara/) nor its browser-that-isn't, [`capybara-webkit`](https://github.com/thoughtbot/capybara-webkit/). It's enough to make an otherwise reasonably competent developer stop productive outside-in BDDing and resort to unit-testing his way up from bare metal, hoping against hope that he'll get to a point where hooking the "handler" code into the real app is a matter of "just a half-dozen lines of [jQuery](http://jquery.com/)."

(Days, then weeks, then months pass. Colourful language, then incredulity, then devout prayer to any `$DEITY` imaginable, then funereal silence are heard from the hapless developer's cubicle. Joe from Accounting walks by: "Beam me up, Scotty; there's no intelligent life apparent here." Continued silence, with a wad of crumpled paper hitting the back of Joe's head as he wanders down the aisle.)

There's got to be a better way. And it turns out that *there is*. Well, at least, a *workaround*.

## What Is a "Selection"?

You could find an answer by looking at [documentation](https://developer.mozilla.org/en-US/docs/Web/API/Selection), or you could think a bit. Broadly, a selection is what's between one endpoint (where the user clicks and starts dragging the mouse) and another endpoint (where she stops dragging and releases the mouse button). The relevant W3C doc is actually tucked away in their specification of [Ranges](http://www.w3.org/TR/DOM-Level-2-Traversal-Range/ranges.html); you can "invest" an arbitrary amount of time following the hunt from Ranges to Selections.

All right, you think. "I understand this so far." But then you realise you have A Problem. And it's deceptively ginormous.

The W3C, browser vendors like Mozilla, and Script libraries like [jQuery++](http://jquerypp.com/#selection) point out, if you pay attention, that a selection (or a range) is with regards to the selected *text*, not the selected *markup*. "[Hey, Abbott](http://www.jokebuddha.com/joke/Costello_Hey_Abbott)...I need the markup!" "OK, Lou; just call *this* and call *that* and...errr...let's see. Well, it looks like you can't have it after all." Well, [ve haff *vays*](http://achillesheelart.deviantart.com/art/Ve-Haff-Vays-363019502) — but they're unreliable hacks with all the elegance and efficiency of [a Rube Goldberg machine](https://en.wikipedia.org/wiki/Rube_Goldberg_machine) after several hurricanes hit it. Not what we want.

## The Light Bulb Moment (That's Not (Yet) Cracked)

A selection can be thought of as "connecting" two separate points in the DOM. How can we define, or express those points? Any element in the DOM has a unique **selector**, as used in [jQuery](http://api.jquery.com/category/selectors/) and CSS 2 and 3. This can be either an "absolute" selector, such as `html > body > div#outer > div#sluggo > #div#content > p:nth-child(4) em:nth-child(2)` or, if all the selectors you need to worry about are relative to a known point, say, that `#content` `div`, then all you care about from that example would be `p:nth-child(4) > em:nth-child(2)`, or "get me the fourth paragraph block, and then the second 'emphasis' inline element within that paragraph block."

Every element has one or more *text nodes* within it. If a given element has child elements (elements contained entirely within the first element), then that parent element will have (at least) two text nodes; one before and one after the child element. In the DOM, these are numbered (as are most things) from zero. And the DOM Range object (and thus the DOM Selection object) are also defined in terms of the text offset within that text node. So, continuing the example, if you wanted an endpoint to be located between the second and third characters enclosed within that `em` element, you'd specify the selector we gave earlier, a node index of zero, and a text offset of 3. Specify a start point and an end point, and you have (a representation of) a selection *that "knows" about HTML and the DOM.*

All this is pretty pointless for your *application* code that responds to selections made by the user, but *it's the key breakthrough that allows you to automate testing.* When your specs are setting up fixtures, they can specify a selection in terms of its endpoints and fire an event or directly call your code, and your code says "hey! there's a selection! I know what to do with *this*" and you're off to the races.

## The Proof is In the Coding

### First Iteration

Which brings us to the point of this demo app. This app will present a view that displays a (noneditable) content area filled with enough sample markup to be useful for our purpose here. That view will also include a simple Ajaxified form that allows the user to enter (or choose) values for the endpoint specifications for a selection, and a `Select` button. The first iteration will be complete when entering valid endpoint details and clicking the button causes the specified text to be visibly selected.

### Second Iteration

A second iteration will create a Rails initialiser that controls whether or not the enter-selection-values form is displayed. *The form **should not** be displayed unless the initialiser exists **and** specifies otherwise.* It should lock the value to `false` in a `production` environment.

### Third(?) Iteration

A (possible) third iteration would replace the simple text fields of the selector endpoint criteria with drop-down listboxes. A use scenario might be as follows:

1. User clicks on start endpoint "Selector" drop-down. It contains a list of all valid selectors in the content area. User makes a selection.
2. User clicks on start endpoint "Node Index" drop-down. It has *only* the values (0-*n*) for the element identified by the selector. User makes a selection.
3. User clicks on start endpoint "Text Offset" drop-down. It has *only* the values (0-*n*) for the individual text node identified by the earlier two specifiers.
4. User clicks on *end* endpoint "Selector" index. Drop-down contains *only* the start endpoint's selector and all succeeding selectors in the content area. User makes a selection.
5. User makes end-endpoint "Node Index" and "Text Offset" selections as described in earlier steps.

This would render the form proof against most idiots, eliminating (or at least sharply reducing) the requirement for validation of the text-area inputs.

# Changelog

All releases after the first will include a `CHANGELOG` file.

# Bugs and Feedback

If you discover a possible problem, please describe it (including your Ruby version, rvm/rbenv setup, OS and version) in the issues tracker. Searching the issues tracker may allow you to take advantage of others' previous experience with similar problems to your own. Direct any questions to the maintainer to jeff.dickey@theprolog.com or jdickey@seven-sigma.com.

Patch requests submitted along with or following up on issue reports are greatly appreciated and will be responded to more quickly.

# License (New BSD)

Copyright (c) 2013 Jeff Dickey and Prolog Systems Pte Ltd.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.