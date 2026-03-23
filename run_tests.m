clc;

import matlab.unittest.TestSuite;
import matlab.unittest.TestRunner;
import matlab.unittest.Verbosity;

suite = TestSuite.fromPackage('tests', 'IncludingSubpackages', true);

runner = TestRunner.withTextOutput('Verbosity', Verbosity.Detailed);
results = runner.run(suite);

disp(table(results));

failedCount = nnz(~[results.Passed]);
if failedCount > 0
    error('run_tests:failures', '%d test(s) failed.', failedCount);
end