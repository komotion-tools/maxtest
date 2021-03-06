# General Introduction
Lets start with a summary explaining the idea and purpose of maxtest. If you are familiar with unit testing you can skip this section.

Maxtest is a unit testing framework like cppunit for C++ or unittest for Python. It allows for testing MAXScript code. The developer writes tests as MAXScript functions for validating the behavior of certain code. The framework finds these tests, runs them and returns the result back to the developer. The result of a test can be one of three states: pass, fail or error. The framework can tell the state by comparing the result the code generated with an expected result value.

The framework aims at extensibility and robustness. It tries to achieve the former by using a class design allowing new structs to extend core functionality when adhering to an interface. This will be explained in coming sections. The later means to run thousands of tests smoothly without crashing. Time will tell, where limits and problems will arise.

# Design
The previous section explained the purpose of maxtest. In this part, we will explain the class design driving the framework.

![maxtest UML](http://yuml.me/b662d7a2)
[Edit UML](http://yuml.me/edit/57ed7245)

Four base classes form the core of maxtest: Assert2, Finder, Runner, Presenter

The Assert2 allows for writing asserts, which when fail throw exception messages, containing information like filepath and line number. The Exception format is interpretable by the Runner. Runner depends on Assert2, not physically but the exception it throws.

The Finder purpose is to find tests, meaning to collect the filepath, struct and function name of a test.

The Runner knows how to validate a test. It uses the results generated by the Finder and executes the tests. Whether the assert fails, passes or any other unexpected exception arises, will be recorded and returned.

The Presenter takes the Runner results and displays them back to the user.

Currently one Finder exists, the so called DirCrawler. Also one Presenter exists, the ListenerPresenter and one Runner equally named.

# Extension
The aim of the above chosen design, should allow other developer to extend the framework.

New finders can be created. Finders which don't crawl a directory structure, but look up test locations in a database or XML file.

Also new presenters are possible. As an example results could be displayed in a GUI or simply just stored in a file at a certain place.

What ever your pipeline is comfortable with.

# Test Design
The former part explained to you how the interaction between the different framework components allow for testing. This section will show you how an actual test must be designed to be validated by the framework.

A test function without content would make the test pass. A test always passes if no exception got raised. You have to use an assert provided by Assert2 to make a meaning full evaluation. The Assert2 struct is explained in the next section.

An example for each state a test can evaluate to::
```
-- test_example.ms
struct TestExample
(
        function test_pass =
        (
                Assert2.equals true true
        ),


        function test_passesToo =
        (
                -- empty
        ),


        function test_fail =
        (
                Assert2.equals true false
        ),


        function test_error =
        (
                throw ""
        )
)
```
# Assert2
The Assert2 is a struct with static functions. The Assert2 doesn't need to be instanced. It can be viewed as a struct holding utility functions, important ones though. As the name suggests its purpose it to do an assert, e.g 1 equals 1.

Currently six asserts are supported:

**equals**

    Assert2.equals 1 1

**notEquals**

    Assert2.notEquals 1 0

**raises**

    Assert2.raises “*” testobj.testfunc args:#(1)

**notRaises**

    Assert2.notRaises testobj.testfunc args:#(1)

**assertTrue**

    Assert2.assertTrue (isKindOf (Sphere()) Sphere)

**assertFalse**

    Assert2.assertFalse (1 != 0)

# Advanced
## setUp and tearDown
WIP

## DirCrawler struct
This section explains the DirCrawler struct, which is used to find tests. It implements the Finder interface.

By recursively crawling from a certain directory down the hierarchy, it gathers tests matching certain criteria.

Three properties decide if it will be picked up:

1. The filename the test lives in
2. The name of the struct the test lives in
3. The name of the function the test lives in

Example implementation for a fictional struct called Splitter.

    fileIn @"finder.ms"
    (
            local searchDir = "c:\\projects\\splitter\\"

            /* e.g.
               file: test_splitter.ms
               struct: struct TestSplitter ()
               function: function test_doSplit = ()
            */
            local finderStandard = DirCrawler searchDir

            /* e.g.
               file: slowtest_splitter.ms
               struct: struct TestSplitter ()
               function: function test_heavyComputationSplit = ()
            */
            local finderFilePattern = DirCrawler searchDir "*slowtest_*.ms"

            /* e.g.
               file: integrationtest_splitter.ms
               struct: struct IntegrationtestSplitter ()
               function: function test_canBeSplit = ()
            */
            local finderStructPrefix = DirCrawler searchDir "*integrationtest_*.ms" "Integrationtest"

            /* e.g.
               file: test_splitter.ms
               struct: struct TestSplitter ()
               function: function tmptest_canBeSplit = ()
            */
            local finderFunctionPrefix = DirCrawler searchDir "*test_*.ms" "Test" "tmptest_"
    )

## ListenerPresenter struct
WIP

# Problems
## Assert2.raises in “on create do”
If you raise an exception inside the constructor (on create do) of a struct, a popup opens, stopping further execution until “OK” is pressed. This is an odd behavior as it differs from the throw() behavior outside of the constructor. Autodesk should be notified about this and asked to remove the popup and make exceptions in constructors not create popups.

Meanwhile a workaround can be used. Use a tool like “Click Off” to automatically close the popup. (add further instructions)

## Assert2.equals #() #()
Comparing two MAXScript arrays with each other doesn't work. The compare only tests the address of both arrays not their content. You have to manually assert the arrays content with each other.

## Commenting out Suite/Test
Commenting out a test or a whole suite doesn't exclude the it from being run. The finder still finds the suite/test, because currently it doesn't consider comments. Cause the finder finds the suite/test, the runner then still tries to execute it, which results in an exception, because on execution the commented out code is not interpreted and missing.

## DirCrawler
Keyword structPattern doesn't take any wildcards, so Pattern is a bad name.

# Roadmap
== Try Catch for the DirCrawler, to return a more meaningful error msg or to continue getting an instance of the other tests
## PreAndPost Events after running a test and entire suite
- in post event containing the test results

## assert message being added to the MaxTestResult
## DirCrawler
**file, struct and function patterns to find tests must be case insensitive **
## Implement profiling for tests
Allow for logging run time of a check. Allow for logging memory consumption of a check.
## Continuous Integration
## Add Array Asserts


