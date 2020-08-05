Contribution Guideline
======================

* [Reporting Issues](#reporting-issues)
* [Submitting a Pull Request](#submitting-a-pull-request)

Reporting Issues
----------------

Before reporting an issue:

1. Read the [Troubleshooting](https://github.com/phpbrew/phpbrew/wiki/Troubleshooting) page. Your problem might already be documented.
2. Search [previous issues](https://github.com/phpbrew/phpbrew/issues) to avoid reporting a duplicate.
3. If you encountered some installation issue, please also attach your build log file (build.log) to improve the diagnosis process. for example:

         $ phpbrew ext install pdo_dblib
         ===> Installing pdo_dblib extension...
         Log stored at: /home/user/.phpbrew/build/php-5.4.39/ext/pdo_dblib/build.log

4. If the error message is not clear enough, you may add an extra option `--debug` after the program name in the command line, e.g.,

         $ phpbrew --debug ext install ...
         $ phpbrew --debug install ...

Submitting a Pull Request
-------------------------

1. If you modified the source code, run the test suite:

         $ make test

2. Before you send the pull request, please rebase & squash your commits. See this guide for details: https://git-scm.com/book/en/v2/Git-Tools-Rewriting-History
