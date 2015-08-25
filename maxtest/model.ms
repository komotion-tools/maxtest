/*
 *	Class for storing all test suites found inside a test file.
 *	Test runner uses these information for running the tests.
 *	@info: all finders must return MAXTestFile objects
 */
struct MAXTestFile
(
	public filename = undefined,

	-- <Array of MAXTestSuite>
	public testSuites = #()
)


/*
 *	Class for storing test suite information.
 *	Necessary for the runner to execute the test functions inside a struct.
 */
struct MAXTestSuite
(
	public structName = "",

	-- <Array of String>
	public testFnNames = #()
)


/*
 *	Class for storing result information of a unit test when run by the Runner.
 */
struct MAXTestResult
(
	public fileName = "",
	public structName = "",
	public testName = "",
	public state = undefined, -- -1 == error, 0 == passed, 1 == failed
	public resultStream = StringStream ""
)