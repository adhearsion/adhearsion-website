# Contributing

[TOC]

Adhearsion is a project of noteable size, complexity and stability. As such, we ask that prospective contributors adhere to these guidelines to help speed the acceptance of code or pull requests.  These guidelines apply to all projects maintained by the Adhearsion team, including the main project and all official plugins.

## Copyright assignment

All copyright in the Adhearsion source code, its documentation, logo and promotional materials lies with the [Adhearsion Foundation Inc](http://adhearsion.com/foundation), a non-profit corporation setup to serve the Adhearsion community. We ask that all contributors to the Adhearsion project assign copyright of the contributions to the non-profit organization.  This can be done easily by executing the [Contributor Agreement](https://docs.google.com/document/d/1TKA7_LKUzTFZyyiZ4gNJKh7RIgk7NJtU7oKF-u-8cgQ/edit). Doing so is simple; when you submit your first contribution, make sure you include your full name and an email address to send the document to for online signature. When you receive it, simply follow the instructions to sign. We'll do the rest.

## Source control

Adhearsion lives in a Git repository [hosted on Github](http://github.com/adhearsion/adhearsion).  The repository is managed using a workflow based on [git-flow](http://nvie.com/posts/a-successful-git-branching-model/) with the following additional clarifications:

### Individual commits

* Rule of Single Purpose: Should make one type of change at a time. Whitespace fixes should not be bundled in with a bug fix. If you are using "and" or a list in your commit message, you are probably breaking this rule and should split the commit into logical chunks.
* Rule of Clarity: Should have a logically structured commit message: http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html
  Additionally, the subject line of commit messages should be preceded by a categorization of the commit contents from the following options:
  * [FEATURE] - New functionality that did not previously exist
  * [BUGFIX] - Changes that address a bug with the intention of resolving it
  * [UPDATE] - Used wherever external dependency versions are updated, or internal code which consumes those dependencies is updated to match new APIs.
  * [DOC] - changes which update existing documentation or add new documentation. These may be either ad-hoc or related to code changes.
  * [CS] - "Coding Standards" This covers whitespace, syntax and style changes
* In addition to categorisation, the following tags should be added where appropriate and should immediately follow the categorisation, separated by spaces:
  * [BCBREAK] - to be used if any backward incompatability is introduced by this commit. **This should be noted for external APIs only.** Internal API changes should have the consumer code updated to match in the same commit.
* Whenever possible, provide references to more information in commit messages to:
  * Tickets - github issues, use "[closes]#271" where 'closes' is optional and '#271' references the issue number
  * Mailing list discussions - provide a URL for the appropriate Google Groups page

## Patch submissions

* Always prepare patch submissions on an appropriately named branch, following the git-flow conventions.
* Ensure that patch submissions address only one issue, or one closely related set of issues. This ensures that unrelated patches are not unnecessarily delayed by being grouped together with a patch that cannot be merged right away.
* Choose an appropriate merge target. If the patch is a feature or otherwise applies to the current line of development (highest version number), specify 'develop'. If the patch applies to a maintained release of Adhearsion (for example the 1.x.x series), specify the relevant 'support/*' branch.
* All patches should follow the [style guide](https://github.com/adhearsion/adhearsion/wiki/Code-style-guide).
* All patches should have an appropriate CHANGELOG entry:
  * "A good changelog doesn’t just disassemble version control logs. It presents an executive summary of a whole slew of changes, in terms that make it clear why I, the end user, should be giving a damn." - http://blog.natulte.net/posts/2009-12-21-how-to-write-a-good-changelog.html
  * Changelog entries should be added to the section of the changelog which applies to the target branch, and not to any specific version.
  * Changelog entries should be marked with with the commit tags as listed above.
  * Changelog entries should be sorted by significance, and grouped by tag in the same order as presented above.

### Testing

* New features must have sufficient test coverage.  Without test coverage, we cannot ensure that future changes will not break this feature.
* Bug fixes should come with a test to demonstrate the issue. This should be committed first, such that it can be shown to fail, with the resolution committed separately in order to make the test pass.

<div class='docs-progress-nav'>
  <span class='back'>
    Back to <a href="/docs/dealing-with-bugs">Dealing with bugs</a>
  </span>
  <span class='forward'>
    Continue to <a href="/api">API Docs</a>
  </span>
</div>
